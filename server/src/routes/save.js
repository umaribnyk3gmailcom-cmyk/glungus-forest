import { Router } from 'express';
import { pool } from '../db.js';
import { requireAuth } from '../auth.js';

export const saveRouter = Router();

// GET /save  ->  the logged-in player's save, or null
saveRouter.get('/', requireAuth, async (req, res, next) => {
  try {
    const { rows } = await pool.query(
      'SELECT level, world, currency, data, updated_at FROM saves WHERE player_id = $1',
      [req.playerId],
    );
    res.json(rows[0] ?? null);
  } catch (err) {
    next(err);
  }
});

// PUT /save  ->  overwrite the player's save (call this at each checkpoint)
// body: { level, world, currency, data }
saveRouter.put('/', requireAuth, async (req, res, next) => {
  try {
    const body = req.body ?? {};
    const level = Math.max(1, Number(body.level) || 1);
    const world = Math.max(1, Number(body.world) || 1);
    const currency = Math.max(0, Number(body.currency) || 0);
    const data = body.data && typeof body.data === 'object' ? body.data : {};

    const { rows } = await pool.query(
      `UPDATE saves
          SET level = $2, world = $3, currency = $4, data = $5, updated_at = now()
        WHERE player_id = $1
      RETURNING level, world, currency, data, updated_at`,
      [req.playerId, level, world, currency, data],
    );

    if (!rows[0]) return res.status(404).json({ error: 'No save for this player' });

    // Keep the leaderboard's "best ever" numbers in sync.
    await pool.query(
      `UPDATE leaderboard
          SET highest_level  = GREATEST(highest_level, $2),
              highest_world  = GREATEST(highest_world, $3),
              total_currency = GREATEST(total_currency, $4),
              updated_at     = now()
        WHERE player_id = $1`,
      [req.playerId, level, world, currency],
    );

    res.json(rows[0]);
  } catch (err) {
    next(err);
  }
});

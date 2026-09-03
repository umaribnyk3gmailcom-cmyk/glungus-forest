import { Router } from 'express';
import { pool } from '../db.js';
import { requireAuth } from '../auth.js';

export const leaderboardRouter = Router();

// Which "sort" query values are allowed, and the real column each maps to.
// Whitelisting like this is what makes it safe to drop the value into the SQL.
const SORT_COLUMNS = {
  level: 'highest_level',
  world: 'highest_world',
  currency: 'total_currency',
  bosses: 'bosses_defeated',
};

// GET /leaderboard?sort=level&limit=25   (public - no login needed)
leaderboardRouter.get('/', async (req, res, next) => {
  try {
    const column = SORT_COLUMNS[req.query.sort] || 'highest_level';
    const limit = Math.min(Math.max(Number(req.query.limit) || 25, 1), 100);

    const { rows } = await pool.query(
      `SELECT p.username,
              l.highest_level,
              l.highest_world,
              l.total_currency,
              l.bosses_defeated
         FROM leaderboard l
         JOIN players p ON p.id = l.player_id
        ORDER BY l.${column} DESC, l.updated_at ASC
        LIMIT $1`,
      [limit],
    );

    res.json(rows.map((row, i) => ({ rank: i + 1, ...row })));
  } catch (err) {
    next(err);
  }
});

// POST /leaderboard/boss   (login required) - call after the player beats a boss
leaderboardRouter.post('/boss', requireAuth, async (req, res, next) => {
  try {
    const { rows } = await pool.query(
      `UPDATE leaderboard
          SET bosses_defeated = bosses_defeated + 1, updated_at = now()
        WHERE player_id = $1
      RETURNING bosses_defeated`,
      [req.playerId],
    );
    res.json(rows[0]);
  } catch (err) {
    next(err);
  }
});

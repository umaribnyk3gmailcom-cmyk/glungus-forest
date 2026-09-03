import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { pool } from './db.js';

const JWT_SECRET = process.env.JWT_SECRET || 'dev-secret-change-me';
const TOKEN_TTL = '7d';

export function httpError(status, message) {
  const err = new Error(message);
  err.status = status;
  return err;
}

function signToken(player) {
  return jwt.sign(
    { sub: player.id, username: player.username },
    JWT_SECRET,
    { expiresIn: TOKEN_TTL },
  );
}

export async function registerPlayer(username, password) {
  if (!username || username.length < 3) {
    throw httpError(400, 'Username must be at least 3 characters');
  }
  if (!password || password.length < 6) {
    throw httpError(400, 'Password must be at least 6 characters');
  }

  const passwordHash = await bcrypt.hash(password, 10);

  let player;
  try {
    const { rows } = await pool.query(
      'INSERT INTO players (username, password_hash) VALUES ($1, $2) RETURNING id, username',
      [username, passwordHash],
    );
    player = rows[0];
  } catch (err) {
    if (err.code === '23505') throw httpError(409, 'That username is taken');
    throw err;
  }

  // Give the new player an empty save and a leaderboard row.
  await pool.query('INSERT INTO saves (player_id) VALUES ($1)', [player.id]);
  await pool.query('INSERT INTO leaderboard (player_id) VALUES ($1)', [player.id]);

  return { token: signToken(player), player };
}

export async function loginPlayer(username, password) {
  const { rows } = await pool.query(
    'SELECT id, username, password_hash FROM players WHERE username = $1',
    [username],
  );
  const player = rows[0];

  // Same error whether the username or the password is wrong, so nobody can
  // fish for which usernames exist.
  if (!player) throw httpError(401, 'Wrong username or password');

  const ok = await bcrypt.compare(password, player.password_hash);
  if (!ok) throw httpError(401, 'Wrong username or password');

  return {
    token: signToken(player),
    player: { id: player.id, username: player.username },
  };
}

/** Express middleware: requires a valid "Authorization: Bearer <token>" header. */
export function requireAuth(req, res, next) {
  const header = req.headers.authorization || '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;
  if (!token) return res.status(401).json({ error: 'Missing token' });

  try {
    const payload = jwt.verify(token, JWT_SECRET);
    req.playerId = payload.sub;
    req.username = payload.username;
    next();
  } catch {
    res.status(401).json({ error: 'Invalid or expired token' });
  }
}

import pg from 'pg';
import 'dotenv/config';

const { Pool } = pg;

const isLocal =
  !process.env.DATABASE_URL ||
  process.env.DATABASE_URL.includes('localhost') ||
  process.env.DATABASE_URL.includes('127.0.0.1');

export const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  // Railway's Postgres needs SSL; a local one does not.
  ssl: isLocal ? false : { rejectUnauthorized: false },
});

/**
 * Create the tables if they don't exist yet. Called once on startup.
 * This is a simple approach - for a bigger project you'd use real migrations.
 */
export async function initDb() {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS players (
      id            SERIAL PRIMARY KEY,
      username      TEXT UNIQUE NOT NULL,
      password_hash TEXT NOT NULL,
      created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
    );
  `);

  await pool.query(`
    CREATE TABLE IF NOT EXISTS saves (
      player_id  INTEGER PRIMARY KEY REFERENCES players(id) ON DELETE CASCADE,
      level      INTEGER NOT NULL DEFAULT 1,
      world      INTEGER NOT NULL DEFAULT 1,
      currency   BIGINT  NOT NULL DEFAULT 0,
      data       JSONB   NOT NULL DEFAULT '{}'::jsonb,
      updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
    );
  `);

  await pool.query(`
    CREATE TABLE IF NOT EXISTS leaderboard (
      player_id       INTEGER PRIMARY KEY REFERENCES players(id) ON DELETE CASCADE,
      highest_level   INTEGER NOT NULL DEFAULT 1,
      highest_world   INTEGER NOT NULL DEFAULT 1,
      total_currency  BIGINT  NOT NULL DEFAULT 0,
      bosses_defeated INTEGER NOT NULL DEFAULT 0,
      updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
    );
  `);
}

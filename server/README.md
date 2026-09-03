# Glungus's Forest - Server

The backend. Handles sign-in, per-player save data, and the leaderboard.

Node.js + Express + PostgreSQL. Built to deploy on Railway.

## Endpoints

| Method | Path | Auth | What it does |
|---|---|---|---|
| GET  | `/health` | - | Returns `{ ok: true }` |
| POST | `/auth/register` | - | Body `{ username, password }`. Creates a player, returns `{ token, player }` |
| POST | `/auth/login` | - | Body `{ username, password }`. Returns `{ token, player }` |
| GET  | `/save` | Bearer token | The player's save |
| PUT  | `/save` | Bearer token | Body `{ level, world, currency, data }`. Overwrites the save. Call at checkpoints |
| GET  | `/leaderboard?sort=level\|world\|currency\|bosses&limit=25` | - | Ranked list |
| POST | `/leaderboard/boss` | Bearer token | +1 to the player's boss-kill count |

Send the token from register/login as a header: `Authorization: Bearer <token>`.

## Tables (created automatically on first start)

- **players** - id, username, password_hash, created_at
- **saves** - player_id, level, world, currency, data (JSON), updated_at
- **leaderboard** - player_id, highest_level, highest_world, total_currency, bosses_defeated

## Local setup

See the [root README](../README.md#running-the-server-locally).

## Notes / next steps

- Currency is currently trusted from the client. Later, move currency-earning
  logic here so it can't be cheated (see design doc section 8).
- Real-time multiplayer is not here yet - that needs WebSockets or a dedicated
  game-server process, separate from this HTTP API.
- Swap the auto-create-tables approach for real migration files once the schema
  starts changing.

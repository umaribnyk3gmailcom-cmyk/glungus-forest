# Glungus's Forest

A 3rd-person action RPG. Full design in [docs/GAME_DESIGN.md](docs/GAME_DESIGN.md).

Repo: <https://github.com/umaribnyk3gmailcom-cmyk/glungus-forest>

## Repo layout

```
glungus-forest/
  client/   the game itself - Godot 4 project (sign-in wired up, rest to build)
  server/   the backend: sign-in, save data, leaderboard  (deploys to Railway)
  shared/   data both sides use: world list, item list
  docs/     design document
```

## Running the server locally

You need [Node.js](https://nodejs.org/) 20+ and a Postgres database.

1. Install Postgres, or run one with Docker:
   ```bash
   docker run --name glungus-db -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=glungus -p 5432:5432 -d postgres
   ```
2. Set up the server:
   ```bash
   cd server
   npm install
   cp .env.example .env
   ```
3. Open `.env` and set a real `JWT_SECRET`. Generate one:
   ```bash
   node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
   ```
4. Start it:
   ```bash
   npm run dev
   ```
   The API is now at `http://localhost:3000`. Tables are created automatically on first start.

Try it: open `server/api.http` in VS Code (with the "REST Client" extension) and run the requests top to bottom.

## Running the game (client)

1. Install [Godot 4](https://godotengine.org/download) (standard build, 4.2+, not .NET).
2. In Godot: **Import** -> pick the `client/` folder -> **Edit** -> press **F5**.
3. Sign-in screen. Start the server first (above), or click **Play offline**.

Full walkthrough + controls in [client/README.md](client/README.md).

## Deploying the server to Railway

Step by step in [docs/DEPLOY.md](docs/DEPLOY.md). Short version: New Project ->
Deploy from GitHub -> set Root Directory to `server` -> add PostgreSQL -> add a
`JWT_SECRET` variable -> generate a domain.

## Pushing changes

The repo is already on GitHub. To push new work:

```bash
git add -A
git commit -m "what you changed"
git push
```

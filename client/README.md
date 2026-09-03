# Glungus's Forest - Client

The game itself goes here: the engine project, art, sound, and scripts.
Nothing is built yet - this is a placeholder so the folder exists.

## How the client talks to the backend (`../server`)

1. **Sign-in screen** -> `POST /auth/register` or `POST /auth/login`.
   Save the `token` you get back (in memory, or the engine's secure storage).
2. **On load** -> `GET /save` with `Authorization: Bearer <token>`.
   If it returns `null`, start a new game.
3. **At each checkpoint** -> `PUT /save` with `{ level, world, currency, data }`.
   Put anything extra (skins, pets, quest progress) inside `data`.
4. **Leaderboard screen** -> `GET /leaderboard?sort=level`.
   No token needed.
5. **After beating a boss** -> `POST /leaderboard/boss` with the token.

## Shared data

World and item definitions live in `../shared/`. Load `worlds.json` and
`items.json` at build time or runtime so the client and server never disagree.

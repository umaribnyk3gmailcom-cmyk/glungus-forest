# Deploying the server to Railway

The game client can stay on your PC. The **server** needs to live somewhere the
internet can reach it - that's Railway.

You only do this once. After that, every `git push` auto-deploys.

## 1. Make sure the code is on GitHub

The repo is at <https://github.com/umaribnyk3gmailcom-cmyk/glungus-forest>.
Push any new work first:

```bash
git add -A
git commit -m "..."
git push
```

## 2. Create the Railway project

1. Go to <https://railway.app> and sign in with GitHub.
2. **New Project** -> **Deploy from GitHub repo** -> pick `glungus-forest`.
3. Railway starts building. It will **fail the first time** - that's expected,
   we haven't added the database or settings yet. Keep going.

## 3. Point Railway at the `server/` folder

The repo has three folders; Railway needs to know the backend is in `server/`.

1. Click the service (the box named `glungus-forest`).
2. **Settings** tab -> **Source** section -> **Root Directory** -> type `server` -> save.

## 4. Add the database

1. In the project canvas: **New** (or **+ Create**) -> **Database** -> **Add PostgreSQL**.
2. That's it. Railway automatically gives the server a `DATABASE_URL` variable
   pointing at this database. The server creates its tables on first boot.

## 5. Add the secret

1. Click the `glungus-forest` service -> **Variables** tab -> **New Variable**.
2. Name: `JWT_SECRET`
3. Value: a long random string. Generate one locally with:
   ```bash
   node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
   ```
4. Add it. Railway redeploys automatically.

## 6. Get the public URL

1. Service -> **Settings** -> **Networking** -> **Generate Domain**.
2. You'll get something like `glungus-forest-production.up.railway.app`.
3. Test it in a browser: `https://<that-domain>/health` should show `{"ok":true}`.

## 7. Point the game at it

In `client/scripts/api.gd`, change the first line:

```gdscript
const BASE_URL := "https://glungus-forest-production.up.railway.app"
```

Commit and push. Done - the game now talks to the live server.

## Costs

Railway's free trial covers a small project like this. After the trial it's
usage-based (roughly a few dollars a month for something this size, less if it
sleeps when idle). Check <https://railway.app/pricing> for current numbers.

## Troubleshooting

- **Build fails with "cannot find module"** - Root Directory isn't set to `server`.
- **App crashes on boot, logs mention the database** - the PostgreSQL service
  isn't added, or was added to a different project.
- **Login returns 500** - `JWT_SECRET` isn't set.
- **See the logs**: click the service -> **Deployments** -> click the latest -> **View Logs**.

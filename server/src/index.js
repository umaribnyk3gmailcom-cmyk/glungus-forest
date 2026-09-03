import express from 'express';
import cors from 'cors';
import 'dotenv/config';

import { initDb } from './db.js';
import { registerPlayer, loginPlayer } from './auth.js';
import { saveRouter } from './routes/save.js';
import { leaderboardRouter } from './routes/leaderboard.js';

const app = express();
app.use(cors());
app.use(express.json());

app.get('/', (req, res) => res.json({ game: "Glungus's Forest", status: 'ok' }));
app.get('/health', (req, res) => res.json({ ok: true }));

// --- auth ---
app.post('/auth/register', async (req, res, next) => {
  try {
    const { username, password } = req.body ?? {};
    res.status(201).json(await registerPlayer(username, password));
  } catch (err) {
    next(err);
  }
});

app.post('/auth/login', async (req, res, next) => {
  try {
    const { username, password } = req.body ?? {};
    res.json(await loginPlayer(username, password));
  } catch (err) {
    next(err);
  }
});

// --- game data ---
app.use('/save', saveRouter);
app.use('/leaderboard', leaderboardRouter);

// --- error handler (must be last) ---
app.use((err, req, res, _next) => {
  const status = err.status || 500;
  if (status === 500) console.error(err);
  res.status(status).json({ error: err.message || 'Server error' });
});

const port = process.env.PORT || 3000;

initDb()
  .then(() => {
    app.listen(port, () => console.log(`Glungus's Forest server listening on :${port}`));
  })
  .catch((err) => {
    console.error('Failed to start - could not set up the database:', err);
    process.exit(1);
  });

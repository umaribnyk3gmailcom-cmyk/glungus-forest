# GLUNGUS'S FOREST — Game Design Document

*Draft 1 — based on the original notebook notes.*

---

## 1. Overview

**Glungus's Forest** is a 3rd-person action-adventure RPG. You play a newcomer who
arrives in Glungus's world, learns the ropes, and then has to fight through dozens
of worlds to rescue Glungus after he is captured. Partway through, the game reveals
that everything so far has been a **simulation** — and the real escape is only just
beginning.

- **Genre:** 3rd-person action RPG, level-based, online multiplayer
- **Inspirations:** Terraria (worlds, materials, crafting feel), Blox Fruits
  (level-scaled enemies, progression), Pokémon (how characters, items, the
  quest-giver, and the interface are presented)
- **Perspective:** 3rd person
- **Engine:** Godot 4 (GDScript)
- **Platform target:** PC. Online multiplayer, with a backend hosted on **Railway**
  and source code on **GitHub**

---

## 2. Look & Feel

- **Graphics style:** Terraria-style visuals, but in 3D and 3rd person
- **Character / entity / item / quest-giver / interface style:** Pokémon-inspired
  (clean, readable, colorful UI; expressive character art)
- **Player character:** blocky avatar ("Player-1" in the notes), customizable with
  skins
- **Glungus:** a small cat-like creature — friendly king design
- **Lord Blungus:** Glungus's evil twin — same base shape, alien/corrupted look

*Reference scene from the notes: a side view of a forest — trees, the player walking
in, Glungus standing ahead.*

---

## 3. Story

### Act 1 — The Forest

- **Glungus** is the king of worlds **1–66**.
- You arrive as a **newcomer**. Glungus greets you with a **cutscene** and gives you
  a set of **starter quests**. These quests double as the tutorial — they teach the
  basics: movement, combat, collecting, quests, checkpoints.
- The moment you finish the starter quests, **Glungus is captured** by **Lord
  Blungus** — his evil twin brother, an alien.
- You set out after them. You fight through the worlds, world by world, toward
  Blungus's hideout: the **100th world**.
- At world 100 you face **Lord Blungus** and defeat him. Glungus is freed.

### Act 2 — The Simulation (Glungus's Forest II)

- Freeing Glungus triggers the twist: **none of this was real.** Act 1 took place
  inside a **simulation**, and **you were captured too** — trapped in it alongside
  Glungus the whole time.
- Now the goal changes: **escape the simulation together** and defeat Blungus in
  the real world.
- Once you break out and beat Blungus for good, **Glungus finally explains why he
  was taken**:
  - He discovered there is a level **beyond 100**.
  - In fact there are **500 more secret levels**.
  - **Glungus's family each own specific worlds**, and they've been deliberately
    **keeping him away from that truth**. Blungus was sent to lock him away before
    he could reach it.
  - The real plan (players don't learn this yet — nobody explains their secret
    plan out loud): the family is **quietly replacing Glungus with an impostor,
    Mungus**. Capturing Glungus is step one of the swap.

### Hook for the future

- The 500 secret levels and whatever is really at the top are left open.
- **Mungus** — is the swap already happening? Is the Glungus you rescued really
  Glungus? That's the setup for the next chapter.

---

## 4. Characters

| Character | Role |
|---|---|
| **The Player** | The newcomer / hero. Captured alongside Glungus in Act 2, which makes the escape personal. |
| **Glungus** | King of worlds 1–66. Tutorial quest-giver. Captured at the end of the intro. Knows about the secret levels. |
| **Lord Blungus** | Glungus's evil twin brother. An alien. "Lord of the Aliens." Captures Glungus and hides in world 100. Act 1 + 2 boss. |
| **Glungus's family** | The real antagonists. Each member **owns a specific world**. They're hiding the truth about the levels past 100, they sent Blungus to stop Glungus, and their secret plan is to replace him with Mungus. |
| **Mungus** | The impostor built to **replace Glungus** as king. Looks like Glungus. The family's endgame. |

---

## 5. Core Systems

### Weapons
- **Guns**, **swords**, and **mythical items**
- Obtained/upgraded at the **weapon station** at checkpoints

### Levels & Worlds
- Progression is **level-based**, like Blox Fruits — enemies scale to level.
- **Worlds 1–66** are Glungus's kingdom.
- **Worlds 67–99** are owned by **other members of Glungus's family** — one world
  each. These are the worlds you fight through chasing Blungus, and the family
  quietly works against you here.
- Each world ends with a **portal** to the next world.
- Finishing a world gives **rewards**.
- **World 100** is Blungus's hideout (Act 1 finale).
- **Levels/worlds 101–600** are the **secret levels** — locked, hidden, tied to
  the family's secret. Endgame content.

### Entities / Enemies
- Enemy strength is **based on level**, Blox Fruits style.
- **Mobs** drop currency scaled to their level.

### Pets
- Pets **follow the player**.
- **Some pets attack other players** (useful in PvP).

### Currency
Earned by:
- Completing **quests**
- **Breaking materials** — material rarity is "based on real life" rarity (common
  stone vs. rare metals vs. gems)
- **Killing mobs**, scaled by level

### Quests
- From the **Quest Giver** NPC
- **Daily quests** in the game
- Starter quests from Glungus = tutorial

### Checkpoints
Each checkpoint contains:
- The **checkpoint** itself (respawn / save point)
- **Weapon station**
- **Potion station**
- **Character skins station**
- **Healing chamber**

---

## 6. Multiplayer & Social

- **Online multiplayer** — core feature.
- **PvP:** players can fight; pets can attack other players.
- **Co-op:** (assumed) players can travel through worlds together.
- **Leaderboard:** global ranking. Suggested tracked stats:
  - Highest level reached
  - Highest world / deepest secret level unlocked
  - Total currency earned
  - Bosses defeated / fastest Blungus clear
- **Sign-in system:** each player has an account.
  - Account stores: character progress, level, currency, unlocked worlds, skins,
    pets, quest progress, leaderboard stats
  - Sign-in options to consider: username + password (built - see the server), or
    later "sign in with Google" / Discord (less for players to remember)

---

## 7. Progression Map (quick reference)

```
Newcomer arrives
   → Glungus cutscene + starter quests (tutorial)
      → Glungus captured by Lord Blungus
         → Worlds 1 .......... 66   (Glungus's kingdom)
         → Worlds 67 ......... 99   (one world per family member - they work against you)
         → World 100               (Blungus hideout - BOSS)
            → Glungus freed → TWIST: it was a simulation, you were captured too
               → Escape the simulation (Glungus's Forest II)
                  → Defeat Blungus for real
                     → Glungus reveals: 500 secret levels (101-600),
                       family owns the worlds + is hiding the truth,
                       secret plan = replace Glungus with the impostor Mungus
                        → [future chapters]
```

---

## 8. Technical Notes

**Engine:** Godot 4 (client).
**Source control:** GitHub repo.
**Backend hosting:** Railway.

Current status: the **server** is built (Node + Express + Postgres) and the
**client** has a Godot 4 project with sign-in wired to the backend. Everything
else below is still to do.

The backend needs to handle:

| Feature | What the backend does |
|---|---|
| **Accounts / sign-in** | Register, log in, keep sessions/tokens |
| **Save data** | Store and load each player's progress (level, currency, worlds, skins, pets, quests) |
| **Leaderboard** | Receive score updates, return ranked lists |
| **Currency** | Validate currency earned server-side so it can't be cheated |
| **Multiplayer** | Match players into worlds, sync positions/combat (may need a realtime service, not just HTTP) |
| **Daily quests** | Roll the daily quest list, track per-player completion/reset |

Stack in use:
- **API:** Node.js + Express  (`server/`)
- **Database:** PostgreSQL (Railway one-click Postgres)
- **Realtime multiplayer:** *not built yet* - will need Godot's high-level
  multiplayer (ENet) with a headless Godot server, or WebSockets. Separate from
  the HTTP API above.

Suggested repo layout:
```
glungus-forest/
  client/        # the game
  server/        # Railway backend (API + multiplayer)
  shared/        # data both sides use (item lists, world configs)
  docs/
    GAME_DESIGN.md
  README.md
```

---

## 9. Open Questions / To Decide

1. **Worlds 67–99** — *(answered)* one world per family member. Still to design:
   who the family members are and what each world is like.
2. **Is Blungus a twin brother or a cousin?** The notes say both — pick one.
   ("Evil twin brother" is the stronger story.)
3. **Seed the simulation twist.** For the reveal to land, drop small clues in
   Act 1 — visual glitches, an NPC who says something impossible, Blungus hinting
   "you're not really here."
4. **What is "the truth"?** *(partly answered)* The family each own a world and are
   swapping Glungus for the impostor Mungus. Still to decide: what's really past
   level 600, and why does controlling that require a fake king?
5. **Is the rescued Glungus real, or already Mungus?** Decide now — it changes how
   you write Act 2's ending and whether the player should feel uneasy about the
   "win."
6. **What are the stakes** if the player *doesn't* stop Blungus? Give the world
   something to lose.
7. **Solo vs. co-op story** — does the story work if 4 players are together? Who is
   "the one captured"?
8. **Level cap / balancing** — how far does a normal player get before the secret
   levels? Is 1–100 tens of hours, or a weekend?

---

*End of Draft 1.*

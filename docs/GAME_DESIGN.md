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
- **Inspirations:** Terraria (art style, worlds, materials), Blox Fruits
  (level-scaled enemies, progression), Minecraft (weapon tiers + enchantments),
  Pokémon (how characters, items, the quest-giver, and the interface are
  presented), plus parkour/obstacle-course stages
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

### Worlds & Stages
- The game is **Worlds**, and each World is **100 Stages**.
  - **Stages 1–99** are levels — a mix of combat gauntlets and parkour stages
    (see below). Beat one to unlock the next.
  - **Stage 100** is the **World boss**. Beating it opens the **portal** to the
    next World and hands out World-clear rewards.
- Progression inside a World is **level-based**, Blox Fruits style — mobs and the
  boss scale to your level, and later Stages sit at higher levels.
- **The Worlds** (this is the "1–66 / 67–99 / 100 / 101–600" numbering from the
  earlier notes — those are Worlds, each with its own 100 Stages):
  - **Worlds 1–66** — Glungus's kingdom.
  - **Worlds 67–99** — one per family member; they quietly work against you here.
  - **World 100** — Blungus's hideout (Act 1 finale).
  - **Worlds 101–600** — the secret Worlds, locked, tied to the family's plan.
- *Scope note:* 600 Worlds × 100 Stages is the long-term vision. The build focuses
  on **World 1** first — get its 100 Stages fun, then template the rest.

### Stage types
- **Combat stages** — rooms/areas of level-scaled mobs; clear them all (or reach
  the exit) to finish.
- **Parkour / obstacle stages** — no or few mobs; precision jumps, moving and
  disappearing platforms, spike pits, swinging hazards, timed doors. Pure
  platforming for pacing variety.
- **Boss stage** — Stage 100.
- Most Stages mix the two: a parkour section *then* a fight, or hazards during a
  fight.

### Weapons

**Progression order — you unlock these in sequence:**

1. **Start:** every player begins with a **Wooden Sword**.
2. **Melee / medieval ladder** — the main early-to-mid game. Minecraft-style
   material tiers: **wood → stone → iron → gold → diamond → netherite**, plus
   medieval variants (axes, maces, spears, bows). Higher tier = more damage /
   durability. Unlock and upgrade at the **weapon station** on checkpoints.
3. **Guns** — ranged. **Locked until you've unlocked every melee / medieval
   weapon.** Once the melee ladder is complete, guns open up as the next tier
   (pistols → rifles → heavier).
4. **Mythical items** — rare, one-of-a-kind weapons with special effects. These
   drop rarely throughout (not part of the ladder gate).

### Weapon enchantments
- **Minecraft-style enchantments** applied at an **enchant station** (added to the
  checkpoint stations).
- Melee: Sharpness, Fire Aspect, Knockback, Looting, Sweeping, Unbreaking, Mending.
- Ranged (guns / bows): Power, Punch, Quick Charge, Infinity, Multishot.
- Room for game-original enchants too (e.g. "Glungus's Favor" — extra coins).
- Enchants **cost coins**; higher enchant levels cost more.

### Entities / Enemies
- Enemy strength is **based on level**, Blox Fruits style.
- **Mobs** drop coins scaled to their level, and sometimes **materials** or
  weapon drops.
- Each World has its own mob set themed to that World.

### Pets
- Pets **follow the player**.
- **Some pets attack other players** (useful in PvP).

### Currency — Coins
**Coins are the one and only currency. Everything costs coins:** weapons, weapon
upgrades, enchantments, potions, skins, healing, unlocks — all of it.

Earned by:
- Completing **quests**
- **Killing mobs**, scaled by level
- **Breaking materials** and selling them — material rarity is "based on real life"
  rarity (common stone vs. rare metals vs. gems); rarer material = more coins
- Clearing **Stages** and **Worlds**

Coins are stored on your account (server-validated so they can't be cheated).

### Quests
- From the **Quest Giver** NPC
- **Daily quests** in the game
- Starter quests from Glungus = tutorial

### Checkpoints
Each checkpoint contains:
- The **checkpoint** itself (respawn / save point — free)
- **Weapon station** — buy / upgrade melee-ladder gear, later guns, mythicals *(coins)*
- **Enchant station** — apply weapon enchantments *(coins)*
- **Potion station** — buy potions *(coins)*
- **Character skins station** — buy skins *(coins)*
- **Healing chamber** — heal up *(coins)*

Every station spends **coins**. Checkpoints sit between Stages (and mid-Stage on
the longer ones).

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
         → each World = Stages 1..99 (combat + parkour) then Stage 100 = boss → portal
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

Current status:
- **Server** built (Node + Express + Postgres): sign-in, save data, leaderboard.
- **Client** (Godot 4): sign-in screen, and **World 1 - Glungus's Forest** is
  playable - walk around, talk to Glungus, do the glow-berry starter quest, hit a
  checkpoint (saves to the backend), reach the portal, watch Glungus get snatched.
- **Still to do:** real terrain/art, mobs + combat, guns and Minecraft-tier
  weapons, enchantments, parkour stages, the 100-Stage structure, checkpoint
  stations, pets, daily quests, multiplayer.

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
9. **Stage mix per World** — of the 100 Stages, roughly how many are combat vs
   parkour vs mini-boss? A pattern (e.g. every 10th is a mini-boss, every 5th is
   parkour, Stage 100 is the boss) keeps it from feeling random.
10. **How does a Stage end?** Reach the exit portal, kill everything, or hit a
    survive-the-timer? Probably per Stage type.
11. **Do weapons carry between Worlds, or reset?** Blox Fruits keeps them; a fresh
    start each World makes the Minecraft tier ladder matter more.
12. **Enchantment cap** — one enchant per weapon, or a Minecraft-style stack? And
    can you re-roll a bad one?
13. **Building 100 Stages by hand is a lot.** Decide early: hand-built Stages, or a
    template + a Stage editor / procedural layout with hand-tuned set pieces.

---

*End of Draft 1.*

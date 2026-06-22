# 7-Day Blaze Challenge — Design Spec

**Date:** 2026-06-22  
**Participants:** Eva & Dag  
**Challenge:** 30 minutes of sport every day for 7 consecutive days

---

## Purpose

A shared mobile web page that lets two people log their daily sport minutes and visually track progress across 7 days. Internal use only; no auth, no security requirements.

---

## Architecture

Single `index.html` file. No build step, no framework. Deployed as a static file (can be opened directly from disk or served via any static host).

**State sync:** Firebase Realtime Database (free tier). State is a single JSON blob, read/written directly from the browser using the Firebase JS SDK via CDN. Firebase security rules set to open (no auth required).

---

## Data Model

```json
{
  "startDate": "2026-06-22",
  "eva":  { "1": 45, "2": 30, "3": 0, "4": 0, "5": 0, "6": 0, "7": 0 },
  "dag":  { "1": 20, "2": 35, "3": 0, "4": 0, "5": 0, "6": 0, "7": 0 }
}
```

- Keys `"1"`–`"7"` represent days 1–7 of the challenge
- Value is minutes logged (0 = not yet logged)
- Day is "complete" if value ≥ 30

---

## UI Layout (mobile portrait)

```
┌─────────────────────┐
│  🔥 7-DAY BLAZE  🔥  │
│     CHALLENGE       │
│                     │
│   EVA       DAG     │
│  [🔥 5/7] [🔥 3/7]  │  ← thermometer / flame column
│                     │
│  Day 1  ✅ 45min    │  ← day log rows
│  Day 2  ✅ 30min    │
│  Day 3  — tap to log│
│  ...                │
└─────────────────────┘
```

- Two flame thermometers side by side, one per player
- Below: a shared list of 7 day rows, each showing both players' status
- Each day row has two tap targets — one per player column
- Tapping a player's cell opens an inline number input for that player's minutes
- Both players' entries visible in the same row, independently editable by anyone

---

## Visual Design

| Token | Value |
|-------|-------|
| Background | `#0d0d0d` (near-black) |
| Eva accent | `#ff6b2b` (orange-flame) |
| Dag accent | `#00c9a7` (teal) |
| Success | `#ffd700` (gold) |
| Font | System UI stack, bold/black weight |

**Thermometer:** A vertical column of 7 flame segments (SVG or emoji-based). Completed days light up bottom-to-top with a glow animation. Incomplete days are dim/grey.

**Day rows:** Each row shows the day label, Eva's status (✅ / minutes / —), and Dag's status. Tapping a row expands an input field.

**Milestone:** Confetti burst (CSS-only) when a player reaches 7/7.

---

## Components

1. **`initFirebase(config)`** — initialise Firebase app and return db reference
2. **`renderThermometer(player, days)`** — render 7-segment flame column for one player
3. **`renderDayRows(data)`** — render the 7 log rows with both players' data
4. **`openLogInput(day)`** — show inline input for minute entry, write to Firebase on confirm
5. **`subscribeToData(callback)`** — Firebase `onValue` listener, re-renders on every change

---

## Firebase Setup (one-time, by user)

1. Go to console.firebase.google.com → create project
2. Add a Web app → copy the config object
3. Enable Realtime Database → start in **test mode** (open rules)
4. Paste config into `index.html` where marked

---

## Verification

- Open `index.html` on two phones simultaneously
- Log minutes on phone A → confirm phone B updates in real time (< 2s)
- Log < 30 min → day stays incomplete; log ≥ 30 → day turns green, flame segment lights up
- Log all 7 days for one player → confetti fires
- Refresh page → state persists (loaded from Firebase)

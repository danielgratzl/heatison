# 7-Day Blaze Challenge — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a single-file mobile web app where Eva and Dag track daily sport minutes over 7 days with real-time Firebase sync.

**Architecture:** Single `index.html` with inline CSS + JS. Firebase Realtime Database (CDN compat mode) handles state sync. No build step — open directly in browser or serve statically.

**Tech Stack:** HTML5, CSS3, Vanilla JS (ES6+), Firebase 10.x Realtime Database (CDN compat)

## Global Constraints

- Mobile-only portrait layout, `max-width: 480px`, centered
- Eva accent: `#ff6b2b` | Dag accent: `#00c9a7` | Background: `#0d0d0d` | Gold: `#ffd700`
- Day complete = minutes ≥ 30; 0 = not logged
- Firebase security rules: open (test mode) — no auth required
- No external libraries beyond Firebase CDN
- `user-scalable=no` on viewport (mobile only)

---

### Task 1: HTML scaffold + full CSS

**Files:**
- Create: `index.html`

**Interfaces:**
- Produces: static page with hardcoded sample data, all visual components visible

- [ ] **Step 1: Create `index.html` with full HTML structure and CSS**

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <title>🔥 7-Day Blaze Challenge</title>
  <style>
    :root {
      --bg: #0d0d0d;
      --surface: #1a1a1a;
      --eva: #ff6b2b;
      --dag: #00c9a7;
      --gold: #ffd700;
      --dim: #2a2a2a;
      --text: #f0f0f0;
      --muted: rgba(240,240,240,0.4);
    }
    * { box-sizing: border-box; margin: 0; padding: 0; -webkit-tap-highlight-color: transparent; }
    body {
      background: var(--bg);
      color: var(--text);
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
      min-height: 100vh;
      padding-bottom: 2rem;
      max-width: 480px;
      margin: 0 auto;
    }
    header {
      text-align: center;
      padding: 1.5rem 1rem 0.75rem;
    }
    header h1 {
      font-size: 1.25rem;
      font-weight: 900;
      letter-spacing: 0.08em;
      text-transform: uppercase;
      line-height: 1.3;
    }
    header p {
      font-size: 0.8rem;
      color: var(--muted);
      margin-top: 0.25rem;
      font-weight: 600;
      letter-spacing: 0.05em;
    }

    /* ── Thermometers ── */
    .thermometers {
      display: flex;
      gap: 1rem;
      justify-content: center;
      padding: 1.25rem 1rem 1rem;
    }
    .player-thermo {
      flex: 1;
      text-align: center;
      display: flex;
      flex-direction: column;
      align-items: center;
    }
    .player-name {
      font-size: 1.05rem;
      font-weight: 900;
      text-transform: uppercase;
      letter-spacing: 0.12em;
      margin-bottom: 0.5rem;
    }
    .player-name.eva { color: var(--eva); }
    .player-name.dag { color: var(--dag); }
    .flame-top { font-size: 2rem; margin-bottom: 4px; line-height: 1; }
    .flame-column {
      display: flex;
      flex-direction: column;
      gap: 5px;
      align-items: center;
    }
    .flame-segment {
      width: 48px;
      height: 34px;
      border-radius: 8px;
      background: var(--dim);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.1rem;
      transition: background 0.4s ease, box-shadow 0.4s ease, transform 0.2s ease;
    }
    .flame-segment.lit.eva {
      background: linear-gradient(135deg, #ff4500, #ff6b2b, #ffd700);
      box-shadow: 0 0 14px rgba(255,107,43,0.65);
      transform: scaleX(1.05);
    }
    .flame-segment.lit.dag {
      background: linear-gradient(135deg, #007a5e, #00c9a7, #7fffd4);
      box-shadow: 0 0 14px rgba(0,201,167,0.65);
      transform: scaleX(1.05);
    }
    .score-label {
      margin-top: 0.5rem;
      font-size: 0.85rem;
      font-weight: 800;
      letter-spacing: 0.05em;
      color: var(--muted);
    }

    /* ── Day rows ── */
    .day-log { padding: 0 0.75rem; }
    .day-log-header {
      display: grid;
      grid-template-columns: 1.8fr 2.5fr 2.5fr;
      gap: 0.5rem;
      padding: 0.4rem 0.5rem;
      font-size: 0.7rem;
      font-weight: 800;
      text-transform: uppercase;
      letter-spacing: 0.1em;
      color: var(--muted);
      border-bottom: 1px solid #222;
      margin-bottom: 0.4rem;
    }
    .day-row {
      display: grid;
      grid-template-columns: 1.8fr 2.5fr 2.5fr;
      gap: 0.5rem;
      padding: 0.35rem 0.5rem;
      border-radius: 10px;
      margin-bottom: 0.35rem;
      align-items: center;
    }
    .day-row.today { background: var(--surface); }
    .day-label { display: flex; flex-direction: column; line-height: 1.2; }
    .day-label .num { font-size: 0.9rem; font-weight: 800; }
    .day-label .wday { font-size: 0.72rem; color: var(--muted); font-weight: 600; }
    .player-cell {
      border-radius: 8px;
      padding: 0.45rem 0.4rem;
      text-align: center;
      cursor: pointer;
      font-size: 0.82rem;
      font-weight: 800;
      transition: background 0.15s, transform 0.1s;
      min-height: 42px;
      display: flex;
      align-items: center;
      justify-content: center;
      border: 1px solid transparent;
    }
    .player-cell:active:not(.future) { transform: scale(0.96); }
    .player-cell.eva {
      background: rgba(255,107,43,0.08);
      color: var(--eva);
      border-color: rgba(255,107,43,0.2);
    }
    .player-cell.dag {
      background: rgba(0,201,167,0.08);
      color: var(--dag);
      border-color: rgba(0,201,167,0.2);
    }
    .player-cell.complete.eva { background: rgba(255,107,43,0.22); border-color: var(--eva); }
    .player-cell.complete.dag { background: rgba(0,201,167,0.22); border-color: var(--dag); }
    .player-cell.future { opacity: 0.25; cursor: default; pointer-events: none; }

    /* ── Log input ── */
    .input-wrapper {
      display: none;
      grid-column: 1 / -1;
    }
    .input-wrapper.active {
      display: flex;
      gap: 0.5rem;
      align-items: center;
      padding: 0.4rem 0;
    }
    .input-wrapper input[type=number] {
      flex: 1;
      background: var(--surface);
      border: 2px solid #333;
      border-radius: 8px;
      color: var(--text);
      font-size: 1.1rem;
      font-weight: 800;
      padding: 0.5rem 0.5rem;
      outline: none;
      text-align: center;
      -moz-appearance: textfield;
    }
    .input-wrapper input[type=number]::-webkit-inner-spin-button,
    .input-wrapper input[type=number]::-webkit-outer-spin-button { -webkit-appearance: none; }
    .input-wrapper input[type=number]:focus { border-color: var(--gold); }
    .save-btn {
      background: var(--gold);
      color: #000;
      border: none;
      border-radius: 8px;
      font-size: 0.9rem;
      font-weight: 900;
      padding: 0.5rem 0.9rem;
      cursor: pointer;
      white-space: nowrap;
    }
    .cancel-btn {
      background: #2a2a2a;
      color: var(--text);
      border: none;
      border-radius: 8px;
      font-size: 0.95rem;
      font-weight: 700;
      padding: 0.5rem 0.6rem;
      cursor: pointer;
    }

    /* ── Confetti ── */
    #confetti-container { position: fixed; inset: 0; pointer-events: none; z-index: 999; overflow: hidden; }
    .confetti-piece {
      position: absolute;
      top: -16px;
      border-radius: 2px;
      animation: cffall linear forwards;
    }
    @keyframes cffall {
      0%   { transform: translateY(0)     rotate(0deg);   opacity: 1; }
      85%  { opacity: 1; }
      100% { transform: translateY(110vh) rotate(800deg); opacity: 0; }
    }
  </style>
</head>
<body>
  <header>
    <h1>🔥 7-Day Blaze 🔥</h1>
    <p>30 minutes · every day · 7 days</p>
  </header>

  <section class="thermometers">
    <div class="player-thermo" id="thermo-eva">
      <!-- rendered by renderThermometer() -->
    </div>
    <div class="player-thermo" id="thermo-dag">
      <!-- rendered by renderThermometer() -->
    </div>
  </section>

  <section class="day-log">
    <div class="day-log-header">
      <span></span>
      <span>Eva</span>
      <span>Dag</span>
    </div>
    <div id="day-rows">
      <!-- rendered by renderDayRows() -->
    </div>
  </section>

  <div id="confetti-container"></div>

  <!-- Firebase SDK — compat mode (v8-style API) -->
  <script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js"></script>
  <script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-database-compat.js"></script>

  <script>
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // STEP 1 ▸ Paste your Firebase config here
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // How to get this config:
    //   1. Go to https://console.firebase.google.com
    //   2. Create a project (or use an existing one)
    //   3. Add a Web app (</> icon)
    //   4. Copy the firebaseConfig object shown
    //   5. Enable Realtime Database → start in TEST MODE
    //   6. Replace the placeholder values below
    const firebaseConfig = {
      apiKey:            "PASTE_YOUR_API_KEY",
      authDomain:        "PASTE_YOUR_PROJECT.firebaseapp.com",
      databaseURL:       "https://PASTE_YOUR_PROJECT-default-rtdb.firebaseio.com",
      projectId:         "PASTE_YOUR_PROJECT",
      storageBucket:     "PASTE_YOUR_PROJECT.appspot.com",
      messagingSenderId: "PASTE_YOUR_SENDER_ID",
      appId:             "PASTE_YOUR_APP_ID"
    };
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    // STEP 2 ▸ Set the challenge start date
    const CHALLENGE_START = '2026-06-22';
  </script>
</body>
</html>
```

- [ ] **Step 2: Open in browser and verify layout**

Open `index.html` in a mobile-sized browser window (DevTools → Toggle device toolbar → iPhone SE or similar).

Expected:
- Dark background, header visible, two empty thermometer columns, day-log header row
- No JS errors in console (Firebase SDK will log a "no app" error — that's OK at this stage)

---

### Task 2: Firebase data layer

**Files:**
- Modify: `index.html` — add JS section between `const CHALLENGE_START` line and the closing `</script>`

**Interfaces:**
- Consumes: `firebaseConfig` (object), `CHALLENGE_START` (string `'YYYY-MM-DD'`)
- Produces:
  - `db` (Firebase Database reference, module-global)
  - `subscribeToData(callback: (data: NormalizedData) => void): void`
  - `logMinutes(player: 'eva'|'dag', day: number, minutes: number): void`
  - `NormalizedData = { startDate: string, eva: {[1..7]: number}, dag: {[1..7]: number} }`

- [ ] **Step 1: Add Firebase init + data functions**

Add the following after the `const CHALLENGE_START = ...` line, still inside the `<script>` block:

```javascript
    // ── Firebase ──────────────────────────────────────────
    let db;

    function initFirebase() {
      firebase.initializeApp(firebaseConfig);
      db = firebase.database();
      db.ref('startDate').once('value').then(snap => {
        if (!snap.val()) db.ref('startDate').set(CHALLENGE_START);
      });
    }

    function normalizeData(raw) {
      const out = { startDate: raw.startDate || CHALLENGE_START, eva: {}, dag: {} };
      for (let d = 1; d <= 7; d++) {
        out.eva[d] = raw.eva  ? Number(raw.eva[d]  || 0) : 0;
        out.dag[d] = raw.dag  ? Number(raw.dag[d]  || 0) : 0;
      }
      return out;
    }

    function subscribeToData(callback) {
      db.ref('/').on('value', snap => callback(normalizeData(snap.val() || {})));
    }

    function logMinutes(player, day, minutes) {
      db.ref(`${player}/${day}`).set(Number(minutes));
    }
```

- [ ] **Step 2: Add a temporary init call to test the connection**

After the `logMinutes` function (still inside `<script>`), add:

```javascript
    // temp: remove after verifying connection
    document.addEventListener('DOMContentLoaded', () => {
      initFirebase();
      subscribeToData(data => console.log('data from Firebase:', data));
    });
```

- [ ] **Step 3: Verify Firebase connection**

1. Make sure you have a real Firebase config in `firebaseConfig` (placeholder values will 404)
2. Open `index.html` in the browser
3. Open DevTools Console — you should see `data from Firebase: {startDate: "2026-06-22", eva: {…}, dag: {…}}`
4. Open your Firebase console → Realtime Database → Data — you should see `startDate: "2026-06-22"` was written

If you see a Firebase error instead, double-check `databaseURL` in your config matches what the Firebase console shows.

- [ ] **Step 4: Remove the temporary init call**

Delete the `document.addEventListener('DOMContentLoaded', ...)` block added in Step 2. It will be replaced properly in Task 5.

---

### Task 3: Render functions — thermometer + day rows

**Files:**
- Modify: `index.html` — add JS after `logMinutes` function

**Interfaces:**
- Consumes: `NormalizedData` from Task 2; `db`, `logMinutes`, `subscribeToData` from Task 2
- Produces:
  - `renderThermometer(player: 'eva'|'dag', playerData: {[1..7]: number}): void` — updates `#thermo-{player}`
  - `renderDayRows(data: NormalizedData): void` — updates `#day-rows`
  - `window._lastData` — set on every render (used by input handlers in Task 4)

- [ ] **Step 1: Add helper functions**

Add after `logMinutes`:

```javascript
    // ── Helpers ───────────────────────────────────────────
    function completedCount(playerData) {
      return Object.values(playerData).filter(m => m >= 30).length;
    }

    function getDayLabel(startDate, dayIndex) {
      const [y, m, d] = startDate.split('-').map(Number);
      const date = new Date(y, m - 1, d);
      date.setDate(date.getDate() + dayIndex - 1);
      return date.toLocaleDateString('en-US', { weekday: 'short' });
    }

    function getCurrentDay(startDate) {
      const [y, m, d] = startDate.split('-').map(Number);
      const start = new Date(y, m - 1, d);
      const today = new Date(); today.setHours(0, 0, 0, 0);
      const diff = Math.floor((today - start) / 86400000) + 1;
      return Math.min(Math.max(diff, 1), 7);
    }
```

- [ ] **Step 2: Add `renderThermometer`**

```javascript
    // ── Thermometer ───────────────────────────────────────
    function renderThermometer(player, playerData) {
      const done = completedCount(playerData);
      // Build segments top→bottom (day 7 at top, day 1 at bottom)
      const segments = Array.from({ length: 7 }, (_, i) => {
        const day = 7 - i; // i=0 → day 7 (top), i=6 → day 1 (bottom)
        const lit = playerData[day] >= 30;
        return `<div class="flame-segment${lit ? ` lit ${player}` : ''}">${lit ? '🔥' : ''}</div>`;
      }).join('');

      document.getElementById(`thermo-${player}`).innerHTML = `
        <div class="player-name ${player}">${player === 'eva' ? 'Eva' : 'Dag'}</div>
        <div class="flame-top">${done === 7 ? '🏆' : '🔥'}</div>
        <div class="flame-column">${segments}</div>
        <div class="score-label">${done}/7 days</div>
      `;
    }
```

- [ ] **Step 3: Add `renderDayRows`**

```javascript
    // ── Day rows ──────────────────────────────────────────
    let activeInput = null; // { player: 'eva'|'dag', day: number }

    function renderDayRows(data) {
      window._lastData = data;
      const today = getCurrentDay(data.startDate);

      const rows = Array.from({ length: 7 }, (_, i) => {
        const day = i + 1;
        const isFuture = day > today;
        const isToday  = day === today;
        const weekday  = getDayLabel(data.startDate, day);

        const eMin = data.eva[day]; const dMin = data.dag[day];
        const eLabel = eMin >= 30 ? `✅ ${eMin}m` : eMin > 0 ? `${eMin}m` : isFuture ? '–' : 'tap';
        const dLabel = dMin >= 30 ? `✅ ${dMin}m` : dMin > 0 ? `${dMin}m` : isFuture ? '–' : 'tap';

        const showEInput = activeInput && activeInput.player === 'eva' && activeInput.day === day;
        const showDInput = activeInput && activeInput.player === 'dag' && activeInput.day === day;
        const showInput  = showEInput || showDInput;
        const inputPlayer = showEInput ? 'eva' : 'dag';
        const inputCurrent = showEInput ? eMin : dMin;

        return `
          <div class="day-row${isToday ? ' today' : ''}">
            <div class="day-label">
              <span class="num">Day ${day}</span>
              <span class="wday">${weekday}</span>
            </div>
            <div class="player-cell eva${eMin >= 30 ? ' complete' : ''}${isFuture ? ' future' : ''}"
                 onclick="openLogInput('eva',${day})">${eLabel}</div>
            <div class="player-cell dag${dMin >= 30 ? ' complete' : ''}${isFuture ? ' future' : ''}"
                 onclick="openLogInput('dag',${day})">${dLabel}</div>
            <div class="input-wrapper${showInput ? ' active' : ''}" id="iw-${day}">
              <input type="number" id="min-input" min="0" max="999" placeholder="minutes"
                     value="${inputCurrent || ''}">
              <button class="save-btn"   onclick="saveMinutes('${inputPlayer}',${day})">Save</button>
              <button class="cancel-btn" onclick="closeInput()">✕</button>
            </div>
          </div>`;
      }).join('');

      document.getElementById('day-rows').innerHTML = rows;

      if (activeInput) {
        const inp = document.getElementById('min-input');
        if (inp) { inp.focus(); inp.select(); }
      }
    }
```

- [ ] **Step 4: Add a temporary render test**

After `renderDayRows`, add:

```javascript
    // temp test — remove after verifying
    document.addEventListener('DOMContentLoaded', () => {
      initFirebase();
      subscribeToData(data => {
        renderThermometer('eva', data.eva);
        renderThermometer('dag', data.dag);
        renderDayRows(data);
      });
    });
```

- [ ] **Step 5: Verify rendering**

Open `index.html`. Expected:
- Two thermometer columns show "Eva" / "Dag", flame icon, "0/7 days"
- 7 day rows visible; today's row has slightly lighter background
- Future days show "–" in cells; past/today days show "tap"
- No console errors

- [ ] **Step 6: Remove the temporary render call**

Delete the `document.addEventListener(...)` added in Step 4.

---

### Task 4: Interactive logging + confetti + final wiring

**Files:**
- Modify: `index.html` — add remaining JS functions and the permanent `init()`

**Interfaces:**
- Consumes: `activeInput`, `window._lastData`, `renderDayRows`, `renderThermometer`, `logMinutes`, `subscribeToData`, `completedCount` from previous tasks
- Produces: fully working interactive app

- [ ] **Step 1: Add `openLogInput`, `closeInput`, `saveMinutes`**

Add after `renderDayRows`:

```javascript
    // ── Input handlers ────────────────────────────────────
    function openLogInput(player, day) {
      if (activeInput && activeInput.player === player && activeInput.day === day) {
        activeInput = null; // toggle off
      } else {
        activeInput = { player, day };
      }
      if (window._lastData) renderDayRows(window._lastData);
    }

    function closeInput() {
      activeInput = null;
      if (window._lastData) renderDayRows(window._lastData);
    }

    function saveMinutes(player, day) {
      const input = document.getElementById('min-input');
      if (!input) return;
      const minutes = parseInt(input.value, 10);
      if (!isNaN(minutes) && minutes >= 0) {
        const prevDone = completedCount(window._lastData[player]);
        logMinutes(player, day, minutes);
        // check milestone BEFORE Firebase round-trip
        const projected = Object.assign({}, window._lastData[player], { [day]: minutes });
        if (completedCount(projected) === 7 && prevDone < 7) {
          setTimeout(fireConfetti, 200);
        }
      }
      activeInput = null;
      // optimistic UI close — Firebase subscription will re-render with real data
      if (window._lastData) renderDayRows(window._lastData);
    }
```

- [ ] **Step 2: Add `fireConfetti`**

```javascript
    // ── Confetti ──────────────────────────────────────────
    function fireConfetti() {
      const container = document.getElementById('confetti-container');
      const colors = ['#ff6b2b','#00c9a7','#ffd700','#ff4500','#7fffd4','#ff69b4','#fff'];
      for (let i = 0; i < 90; i++) {
        const el = document.createElement('div');
        el.className = 'confetti-piece';
        const size = 7 + Math.random() * 9;
        el.style.cssText = `
          left: ${Math.random() * 100}vw;
          width: ${size}px; height: ${size}px;
          background: ${colors[i % colors.length]};
          border-radius: ${Math.random() > 0.45 ? '50%' : '2px'};
          animation-duration: ${2 + Math.random() * 2.5}s;
          animation-delay: ${Math.random() * 1.2}s;
        `;
        container.appendChild(el);
        setTimeout(() => el.remove(), 4500);
      }
    }
```

- [ ] **Step 3: Add permanent `init()` + `DOMContentLoaded`**

```javascript
    // ── Boot ──────────────────────────────────────────────
    function init() {
      initFirebase();
      subscribeToData(data => {
        renderThermometer('eva', data.eva);
        renderThermometer('dag', data.dag);
        renderDayRows(data);
      });
    }

    document.addEventListener('DOMContentLoaded', init);
```

- [ ] **Step 4: End-to-end verification**

Open `index.html` in **two browser tabs** (or on two phones on the same network serving the file).

Check each item:

1. Both tabs load with the same data
2. In Tab A, tap Eva's cell for Day 1 → input appears
3. Enter `45`, tap Save → Eva's Day 1 shows `✅ 45m`, thermometer segment lights up
4. Tab B updates automatically within ~2 seconds (no refresh)
5. Enter a value < 30 → day shows the minutes but no ✅, segment stays dim
6. Enter `0` or clear and save → cell resets to "tap"
7. Log all 7 days for one player with ≥ 30 min each → 🏆 appears on their thermometer + confetti fires
8. Refresh the page → all data persists

---

## Post-implementation: Firebase security rules

After verifying everything works, the database is in open test mode (expires after 30 days). For permanent open access, set these rules in the Firebase console under Realtime Database → Rules:

```json
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```

Publish the rules. The app will work indefinitely.

#  Atari Breakout — x86 Assembly (DOS)

A fully playable **Atari Breakout arcade game** built entirely in **x86 16-bit Assembly** (NASM), running in DOS as a `.COM` executable. Rendered directly to video memory (`0xB800`) with real-time keyboard input, ball physics, brick collision, paddle control, scoring, and lives system.

---

##  Gameplay Overview

- Break all bricks by bouncing the ball off your paddle
- **3 lives** — lose one every time the ball falls below the paddle
- **Score points** by destroying bricks (color determines point value)
- **Win** by clearing the entire brick layout
- **Lose** if all 3 lives are used up

---

##  Brick System

| Color  | Value | Byte Code |
|--------|-------|-----------|
|  Blue  | 1 pt  | `1`       |
|  Green | 2 pts | `2`       |
|  Red   | 3 pts | `3`       |

- Brick layout is hardcoded as a flat byte array (`screen`)
- Consecutive same-colored cells form a single brick — when hit, the whole brick is cleared and points are added for each cell

---

## Controls

| Key         | Action                        |
|-------------|-------------------------------|
| `LEFT`  →   | Move paddle left              |
| `RIGHT` →   | Move paddle right             |
| `SPACE`     | Pause / Resume                |
| `ENTER`     | Confirm / Advance screen      |
| `ESC`       | Return to menu / Exit         |

---

## Screens

1. **Welcome Screen** — Shows game title and developer credits, press `ENTER` to continue or `ESC` to exit
2. **Rules Screen** — Shows scoring system and controls, press `ENTER` to start or `ESC` to go back
3. **Game Screen** — Live gameplay with bricks, paddle, ball, score, and lives displayed
4. **Game Over Screen** — Displays `YOU LOOSE!` with final score (red text)
5. **Win Screen** — Displays `YOU WIN! Congrats` with final score (green text)

---

## ⚙️ Technical Details

| Property | Value |
|----------|-------|
| Architecture | x86 16-bit (Real Mode) |
| Format | DOS `.COM` executable (origin `0x0100`) |
| Assembler | NASM |
| Display | Direct video memory write to `0xB800` |
| Input | BIOS `INT 0x16` (keyboard) + DOS `INT 0x21` |
| Grid size | 80 × 25 character text screen |
| Ball position | Stored as video memory offset |
| Paddle size | 7 cells (`=` characters) |

---

##  How It Works (Internals)

### Rendering
- All drawing is done by writing directly to segment `0xB800` (CGA text mode video memory)
- Each screen cell = 2 bytes: `[character byte][attribute/color byte]`
- `0x0720` = space with default attributes (used to clear cells)

### Ball Physics
- Ball position stored as a single video memory offset (`ballpos`)
- Horizontal delta: `balldx` — changes sign on wall collision
- Vertical delta: `balldy` — changes sign on ceiling, paddle, and brick collision
- A delay counter (`BallDelayCounter` / `BallDelayLimit`) throttles ball speed

### Paddle Collision Angles
- Left edge hit (`< 2 offset`) → applies leftward `balldx` adjustment (deg45a)
- Center hit → straight vertical bounce (ceiling logic)
- Right edge hit (`> 12 offset`) → applies rightward `balldx` adjustment (deg45b)

### Brick Collision
- On impact, the ball's vertical direction is reversed
- The hit cell is identified by its ASCII character (`1`, `2`, or `3`)
- Up to 6 adjacent left cells and 6 adjacent right cells of the same type are also cleared (chain break)
- Score is accumulated per cleared cell

### Score Display
- Score is converted from binary to decimal using repeated `div 10` + stack-based digit reversal
- Printed at a fixed position in video memory

### Win Condition
- Win is triggered when `Score == 738` (total possible points from all bricks)

---

##  How to Run

### Requirements
- **DOS** environment (real or emulated)
- **DOSBox** (recommended for modern systems)
- **NASM** assembler (to assemble from source)

### Step 1 — Assemble

```bash
nasm -f bin fpcoal.asm -o fpcoal.com
```

### Step 2 — Run in DOSBox

```bash
# Open DOSBox, then:
mount c /path/to/your/folder
c:
fpcoal.com
```

---

## File Structure

```
fpcoal.asm      ← Complete game source (single file)
README.md       ← This file
```

---

## Developed By

| Roll No   | Name           |
|-----------|----------------|
| 24F-0507  | Fatima Kosar   |
| 24F-0619  | Areeba Fatima  |

---

## Concepts Covered

- x86 real-mode assembly programming
- Direct video memory (VRAM) manipulation
- BIOS and DOS interrupt handling
- Stack-based digit reversal for decimal display
- Collision detection using memory comparisons
- Game loop design with delay counters
- Paddle angle physics logic
- Chain brick clearing algorithm

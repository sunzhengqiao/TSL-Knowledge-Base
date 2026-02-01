# GE_WALL_FRAMING_LOCK.mcr

## Overview
Locks specific wall framing members (studs, plates, headers) and sheathing to preserve manual adjustments, preventing them from being overwritten during automatic wall regeneration.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Operates on Walls and Openings in the 3D model. |
| Paper Space | No | Not applicable for drawings. |
| Shop Drawing | No | Not applicable for drawings. |

## Prerequisites
- **Required Entities:** An existing Wall Element or Opening.
- **Minimum Beam Count:** The Wall must already be framed (contain beams/sheets) before running this script.
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_WALL_FRAMING_LOCK.mcr`

### Step 2: Select Lock Mode
```
Command Line: |Lock framing of:| [0]|Complete walls| [1]|Openings only| [2]|Walls and not openings|
```
**Action:** Type the number corresponding to your desired scope and press Enter.
- **[0] Complete walls:** Locks every beam and sheet in the selected wall.
- **[1] Openings only:** Locks only the framing around openings (headers, trimmers, cripples).
- **[2] Walls and not openings:** Locks the main wall structure (studs/plates) but leaves openings free to regenerate.

### Step 3: Select Elements
```
Command Line: |Select wall(s) to lock|
(Or: |Select wall(s) containing openings and/or individual opening(s)| if Mode 1 was selected)
```
**Action:** Click on the Wall(s) or Opening(s) in the model that you wish to protect, then press Enter.

---

**Note:** The script will automatically verify if the wall is framed. If the wall is empty, a message will appear, and the script will cancel.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Unlock framing** | dropdown | No | Allows you to remove the lock. Selecting `|Unlock|` will delete this TSL instance **and** erase all beams and sheets currently locked by it, allowing the wall to be re-framed from scratch. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **|Erase locked beams and TSL|** | Deletes the protection script and removes all beams and sheets that were currently locked. This restores the wall to an empty state for that specific framing area. |

## Settings Files
None

## Tips
- **Visual Feedback:** After insertion, check the colors of your beams to verify the lock:
  - **Cyan (Color 4):** Beams are **Locked** (safe from regeneration).
  - **Green (Color 32):** Beams are **Unlocked** (will regenerate if the wall changes).
  - **Blue (Color 5):** Sheets are **Locked**.
- **Workflow:** Perform your manual edits to the wall (e.g., add a beam pocket or adjust a header) *before* running this script.
- **Partial Locking:** Use Mode [1] or [2] if you want to allow the main wall layout to update automatically while keeping custom opening details fixed.

## FAQ
- **Q: I changed the wall length, but the studs didn't update.**
- A: The studs are likely locked (Cyan). Use the "Unlock framing" property or the Right-Click menu to erase the lock, then recalculate the wall.
- **Q: What happens to my custom framing if I click "Unlock"?**
- A: The locked beams are **deleted**. You will need to recalculate the wall to generate new framing. Ensure you have saved or documented critical custom dimensions if you need to recreate them.
- **Q: Can I use this on a single door opening?**
- A: Yes. Select Mode [1] (Openings only) during insertion, and you can select individual Opening entities to lock just the frame around that door.
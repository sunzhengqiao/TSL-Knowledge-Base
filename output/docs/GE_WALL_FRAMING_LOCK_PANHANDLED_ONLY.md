# GE_WALL_FRAMING_LOCK_PANHANDLED_ONLY

## Overview
This script enforces a strict framing configuration on a wall by acting as a "lock." It automatically scans the selected wall and deletes all standard framing members (studs), retaining **only** the beams that have specific cutting data ("panhandled" beams). It ensures that only engineered or special pre-cut members remain in the model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D Wall elements and their beams. |
| Paper Space | No | Not designed for 2D view generation or shop drawings. |
| Shop Drawing | No | Not applicable. |

## Prerequisites
- **Required Entities**: A Wall Element that has **already been framed** (generated beams).
- **Minimum beam count**: The wall must contain beams before running the script.
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Select `GE_WALL_FRAMING_LOCK_PANHANDLED_ONLY.mcr` from the file dialog.

### Step 2: Select Wall
```
Command Line: Select wall(s) to lock
Action: Click on the wall(s) you wish to filter and press Enter.
```
*Note: If the wall is empty (no beams), the script will display an error "Wall must be framed prior this operation" and delete itself.*

### Step 3: Automatic Processing
Once inserted, the script automatically:
1.  Scans all beams in the wall.
2.  **Keeps** beams that are "panhandled" (special cuts/engineered members).
3.  **Deletes** all other beams (standard studs).
4.  Changes the color of the remaining beams to **Cyan**.
5.  Draws a **Padlock icon** in the model to indicate the wall is locked.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Unlock framing | dropdown | No | A safety switch to remove the lock. **Set to "Unlock"** to erase the script instance and all beams currently managed by it. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Erase locked beams and TSL | Immediately deletes the script instance and all beams it manages, effectively removing the lock and the associated geometry from the model. |

## Settings Files
None.

## Tips
- **Frame First**: Always ensure your wall is fully framed and generated before running this script. If you run it on an empty wall, it will fail.
- **Visual Indicator**: The script draws a padlock icon near the wall to visually confirm that the framing logic is active.
- **Cyan Beams**: Beams that survive the filter will turn Cyan (Color 4). This helps you visually verify which members are considered "engineered" or "locked."
- **Regeneration**: If you manually modify the wall or force a regeneration, the script will reactivate and delete any new standard framing that might have been added, ensuring only the panhandled beams remain.

## FAQ
- **Q: Why did the script disappear immediately after I selected the wall?**
  A: The wall likely had no beams in it. This script requires the wall to be framed (generated) prior to execution.
- **Q: How do I get my standard framing back?**
  A: You cannot simply "unlock" and keep the current geometry because the script deletes the standard studs during the locking process. To revert, use the "Erase locked beams and TSL" right-click option or set the property to "Unlock," and then re-frame the wall normally.
- **Q: What does "Panhandled" mean?**
  A: In this context, it refers to beams that have specific cutting data or end treatments (often used for jammers, cripples, or engineered members around openings), as opposed to standard rectangular studs.
# hsbParallelLapJoint

## Overview
Creates a parallel lap joint (splice) between two beams to join them end-to-end. This script automatically detects overlapping beams to batch-create joints or prompts for a split location to join non-overlapping beams.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates in the 3D model. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Does not generate 2D drawings directly. |

## Prerequisites
- **Required entities**: GenBeam (Timber beams).
- **Minimum beam count**: 1 or 2.
  - *Note:* If two overlapping beams are selected, they are joined automatically. If beams do not overlap or only one is selected, the script will split the beams at a user-defined location.
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbParallelLapJoint.mcr`

### Step 2: Select Beams
```
Command Line: Select beam(s)
Action: Click on the beams you want to join. Press Enter to confirm selection.
```

### Step 3: Define Location (Conditional)
*Scenario A: Beams overlap*
If the selected beams are parallel and overlap, the script automatically creates the joint instances and finishes.

*Scenario B: Beams do not overlap (or single beam)*
```
Command Line: Select split location
Action: Click in the drawing where you want the lap joint to occur. The script will split the beams at this point and create the overlap.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Length | number | 60 mm | Defines the length of the overlap (lap) where the two beams connect. |
| Side | dropdown | Top | Determines which side of the beam cross-section is reduced (Top, Left, Bottom, or Right). This is relative to the UCS at insertion. |
| Axis Offset | number | 0 | Offsets the joint center from the beam's central axis. Use this to align specific faces (e.g., top flush) when joining beams. |
| Top | number | 0 | Defines a clearance gap on the positive Z-side of the tool (relative to the joint orientation). |
| Center | number | 0 | Defines a clearance gap in the middle of the joint between the two beams. |
| Bottom | number | 0 | Defines a clearance gap on the negative Z-side of the tool (relative to the joint orientation). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Rotate around X-Axis | Cycles the "Side" property (Top → Left → Bottom → Right). Useful for rotating the cut orientation 90 degrees. |
| Flip X Axis | Swaps the two connected beams. It also adjusts the "Side" property (e.g., Top ↔ Bottom) to maintain the visual alignment. |
| Join + Erase | Joins the two separate beam entities into a single GenBeam and removes this script instance. |

## Settings Files
None required.

## Tips
- **Quick Rotate:** You can double-click the joint instance to cycle through the "Side" orientations (Top/Left/Bottom/Right) instead of using the Right-Click menu.
- **Grip Edit:** Use the grip point to slide the joint along the beam axis. The script prevents the grip from moving outside the beam boundaries.
- **Splitting Long Beams:** To join two long beams that touch end-to-end but do not overlap, simply select them both. When prompted for a "split location," click the point where they meet.

## FAQ
- **Q: Why did the script ask me to "Select split location"?**
  **A:** The selected beams did not overlap sufficiently. The script needs you to define where to cut the beams so they can overlap and form the lap joint.
- **Q: Can I change the overlap length after inserting?**
  **A:** Yes, select the joint and change the "Length" property in the Properties Palette, or use the grip point to adjust the position interactively.
- **Q: What happens if I use "Join + Erase"?**
  **A:** The two beams become one single beam entity in the database, and the joint parameters (length, gaps) are no longer editable as they are "burned in" to the new beam geometry.
# hsbAnchoredBeam.mcr

## Overview
This script automates the creation of a traditional timber frame connection between a joist and a post. It generates a tenoned joist with chamfered tips, reinforcing dowel slots (locks), and creates the corresponding mortise and shoulder cuts in the post.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script creates 3D geometry (cuts, bodies, and hardware). |
| Paper Space | No | Not designed for 2D drawings. |
| Shop Drawing | No | Not a shop drawing generation script. |

## Prerequisites
- **Required Entities:** Two GenBeam entities (one Joist and one Post).
- **Minimum Beam Count:** 2
- **Geometry Requirements:**
  - The joist and post must be perpendicular (approximately 90 degrees).
  - The joist and post must physically intersect in 3D space.

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT`
**Action:** Browse and select `hsbAnchoredBeam.mcr`.

### Step 2: Configure Properties (Optional)
If running in manual mode (not from a catalog), a property dialog may appear, or you can rely on default settings.
**Action:** Adjust settings like Chamfer Width, Tenon dimensions, or the number of dowel locks if necessary. You can also change these later in the Properties Palette.

### Step 3: Select Joist
```
Command Line: Please select joist
Action: Click on the horizontal beam (the joist) that will be tenoned.
```

### Step 4: Select Post
```
Command Line: Please select post
Action: Click on the vertical beam (the post) that will receive the mortise.
```

### Step 5: Validation and Generation
**Action:** The script checks if the beams are perpendicular and intersecting. If valid, it cuts the tenon into the joist, drills/mills the dowel slots, cuts the mortise into the post, and adds hardware to the BOM.

## Properties Panel Parameters

### General
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Chamfer Width | Number | 57.0 mm | Defines the length of the 45° bevel cut at the top and bottom of the tenon tip. |
| Shoulder Width | Number | 30.0 mm | Defines the depth of the relief cut (housing) on the post face to accommodate the joist shoulder. |

### Slot (Dowel Locks)
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Amount | Dropdown | 1 | The number of reinforcing dowels (locks) to cut through the tenon (Max 4). |
| Depth in Post | Number | 10.0 mm | The additional depth of the dowel slots beyond the standard size, cutting into the face of the tenon. |
| Width and Height | Number | 40.0 mm | The size (diameter) of the round or square dowels being used. |

### Tenon
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Height | Number | 180.0 mm | The vertical height of the tenon projection. |
| Width | Number | 60.0 mm | The horizontal width of the tenon. |
| Length | Number | 360.0 mm | The length of the tenon (penetration depth into the post). |
| Height Tolerance | Number | 2.0 mm | The vertical clearance/gap allowance for the tenon. |
| Width Tolerance | Number | 2.0 mm | The horizontal clearance/gap allowance for the tenon. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Erase | Removes the script and attempts to repair the beams to their original state (if supported). |
| Properties | Opens the AutoCAD Properties Palette to edit parameters. |

## Settings Files
- **Filename:** None detected.
- **Location:** N/A
- **Purpose:** This script appears to use internal default properties or OPM inputs rather than external XML settings files.

## Tips
- **Perpendicularity:** Ensure your joist is perfectly orthogonal (90°) to the post before running the script. If not, the script will report an error.
- **Intersection:** The joist must physically overlap the post volume. If it is just touching the edge, the script may fail to detect the intersection.
- **Lock Limits:** If you request more dowel locks than can physically fit in the tenon height, the script will automatically reduce the number to the maximum possible amount and issue a warning.
- **Editing:** You can modify dimensions (like Tenon Height or Chamfer Width) via the Properties Palette (Ctrl+1) after insertion to tweak the connection.

## FAQ
- **Q: The script fails with "Selected post and joist are not perpendicular."**
  - **A:** Check your UCS or use the `LIST` command to verify the beams are at exactly 90 degrees to each other. Rotate one beam slightly to correct this.
- **Q: The script fails with "Selected bodies do not intersect."**
  - **A:** The joist needs to be moved so it passes through the post. Use the `MOVE` command to slide the joist deeper into the post.
- **Q: I asked for 4 locks, but only 2 were cut.**
  - **A:** The tenon height is too small to fit 4 locks of the specified diameter. Reduce the `Width and Height` of the locks or increase the `Tenon Height`.
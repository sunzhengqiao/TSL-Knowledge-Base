# GE_WDET_VERTICAL_EDGE

## Overview
Generates vertical blocking (solid timber pieces) between wall studs at a user-selected location. This script automatically adapts to the cavity size to insert structural blocking, firestopping, or drywall backing, and will insert new side studs if the existing gap is too large.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D Wall Elements. |
| Paper Space | No | Not designed for 2D drawings. |
| Shop Drawing | No | Does not process views or dimensions. |

## Prerequisites
- **Required Entities**: A Wall Element (`ElementWallSF`).
- **Minimum Beam Count**: At least 2 vertical studs must exist in the wall.
- **Required Settings**: None strictly required, but the script can read defaults from `_Map` if available.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_WDET_VERTICAL_EDGE.mcr` from the list.

### Step 2: Select Element
```
Command Line: Select an element
Action: Click on the Wall Element where you want to add the blocking.
```

### Step 3: Define Insertion Point
```
Command Line: Select an insertion point
Action: Click on the wall face or edge between two vertical studs where you want the blocking sequence to start.
```
*Note: The script will automatically locate the studs to the immediate left and right of your click point.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Placement Properties** | | | |
| Start Offset | Number | 600 mm (24 in) | Vertical distance from the insertion point to the center of the first block. Set to `0` to place the first block flush on the bottom plate. |
| End Offset | Number | 0 mm (0 in) | Distance from the top of the wall down to the center of the last block. Set to `0` to place the top block flush with the top plate. |
| Spacing | Number | 600 mm (24 in) | The size of the gap (clear space) between adjacent blocking pieces. This is not center-to-center spacing. |
| Blocking Length | Number | 200 mm (8 in) | The vertical height (length) of each individual blocking piece. |
| **Material Properties** | | | |
| Material | Text | SPF | The material code assigned to the new blocking and side studs. |
| Grade | Text | #2 | The structural grade assigned to the new blocking and side studs. |

## Right-Click Menu Options
This script is a "generate and forget" type. Once executed, the script instance deletes itself, leaving only the physical timber. Therefore, there are no right-click menu options to modify the script after insertion. To change parameters, delete the generated beams and re-run the script.

## Settings Files
- **Filename**: `_Map`
- **Location**: Company or Install path (Global TSL config)
- **Purpose**: If present, the script reads default Material, Grade, and Layout settings from this configuration file.

## Tips
- **Automatic Stud Insertion**: If the gap between the two studs you select is larger than the blocking width (approx. 38mm) plus one stud width, the script will automatically copy the nearest stud and insert it to create a correctly sized cavity.
- **Start Offset Zero**: For a standard floor-to-floor blocking run starting at the bottom, set **Start Offset** to `0`. The script calculates the position to sit exactly on the bottom plate.
- **Blocking Width**: The generated blocking has a fixed width of 38mm (1.5 inches).
- **Self-Deleting**: The script removes itself from the model tree after running. Edit the resulting beams using standard AutoCAD/hsbCAD grips and commands.

## FAQ
- **Q: Why do I get the error "Space is too small"?**
  - A: The gap between the two studs where you clicked is narrower than the 38mm blocking width. Move your insertion point to a wider gap or adjust the studs manually.
- **Q: Why do I get the error "Space is too large"?**
  - A: The gap is too wide for a single block but not wide enough to fit a block plus a new stud. Select a location with closer studs, or manually add a stud to split the gap before running the script.
- **Q: Can I edit the spacing after the blocks are created?**
  - A: No. Since the script instance self-deletes upon completion, you cannot change the OPM properties later. You must delete the blocks and run the script again with new settings.
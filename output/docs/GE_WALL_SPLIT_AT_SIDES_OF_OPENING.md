# GE_WALL_SPLIT_AT_SIDES_OF_OPENING.mcr

## Overview
Splits a single framed wall element into multiple distinct manufacturing units (separate wall panels) based on the location of a selected opening, such as a window or door.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script manipulates 3D construction entities (Walls, Beams, Sheets). |
| Paper Space | No | Not applicable for 2D drawing generation. |
| Shop Drawing | No | This is a model/framing modification tool. |

## Prerequisites
- **Required Entities**: A Wall Element containing an OpeningSF (Window or Door).
- **Minimum Requirements**: The wall must be fully framed (Beams and Sheets must exist).
- **Structural Requirements**: The opening must have jack studs (trimmer studs) installed on **both** the left and right sides.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_WALL_SPLIT_AT_SIDES_OF_OPENING.mcr`

### Step 2: Select Opening
```
Command Line: Select Opening
Action: Click on the window or door (OpeningSF) inside the wall you wish to split.
```

### Step 3: Set Split Type
```
Command Line: Set split type		[0: Both sides of opening / 1: Left Side of opening / 2: Right side of opening]
Action: Type the desired number and press Enter.
- 0: Splits the wall on both the left and right sides of the opening (creates three wall sections).
- 1: Splits only the left side of the opening.
- 2: Splits only the right side of the opening.
```

## Properties Panel Parameters
*Note: This script does not expose parameters to the Properties Palette. All configurations are made via the command line during insertion.*

## Right-Click Menu Options
*None available.*

## Settings Files
*None required.*

## Tips
- **Check Framing First**: Ensure the wall has already been processed by the framing generator (Beams and Sheets exist) before running this script.
- **Jack Studs are Critical**: The script calculates the split location based on the position of the jack studs. If jack studs are missing on either side of the opening, the script will fail to validate.
- **Undo**: Use the standard AutoCAD `UNDO` command immediately if the split creates unexpected geometry.

## FAQ
- **Q: Can I use this on a wall that hasn't been framed yet?**
  A: No, the script requires the wall to have existing Beams and Sheets to copy and cut them into the new wall elements.

- **Q: What happens to the sheathing (sheets)?**
  A: The sheets are cut and assigned to the new wall elements automatically along with the studs.

- **Q: Why does the script ask for jack studs on both sides if I only want to split the left side?**
  A: The script logic validates the structural integrity of the opening geometry by ensuring supporting beams exist on both sides before allowing any modification.
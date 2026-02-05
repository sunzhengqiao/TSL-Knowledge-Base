# NA_SheetBreakBacking

## Overview
This script automates the insertion of backing or blocking members at sheathing sheet joints (breaks) within an ElementWall. It ensures structural continuity and provides adequate nailing surfaces by generating or modifying beams at vertical and horizontal sheathing lines.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Must be applied to an existing ElementWall. |
| Paper Space | No | Not intended for layout or detailing views. |
| Shop Drawing | No | This is a 3D modeling script. |

## Prerequisites
- **Required Entities**: An existing ElementWall in the drawing.
- **Minimum Beam Count**: 0 (The wall itself must exist, but specific beam counts within it are not strictly required for insertion).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or `TSLL`)
Action: Browse to and select `NA_SheetBreakBacking.mcr`.

### Step 2: Select Wall Element
```
Command Line: Select an Element
Action: Click on the desired wall in the model.
```
The script will automatically analyze the sheathing layout of the selected wall to determine where backing is needed. It will also automatically remove any duplicate instances of this script or conflicting "Double Stud" scripts found on the same wall.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Sheathing Break Material | Dropdown | 1 Ply | Determines the width/depth of the backing material inserted at sheet breaks. Options include "1 Ply", "2 Ply", "3 Ply", "3x", and "4x". This affects the size of the new studs and how aggressively the script removes conflicting existing studs. |
| Apply to Blocking | Dropdown | Yes | If "Yes", the script modifies horizontal blocking beams that intersect horizontal sheathing breaks to match the backing material dimensions. If "No", horizontal blocking is ignored. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | This script does not add custom items to the right-click context menu. Changes are made via the Properties Panel. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script operates independently using the properties of the selected ElementWall and the OPM parameters.

## Tips
- **Auto-Cleanup**: If you accidentally insert the script twice, or if you have a "Double Stud" script in the same location, this script will automatically erase the conflicts to prevent errors.
- **Sheet Ends**: The script is smart enough to check if an existing stud can be stretched to cover a sheet end. If not, it will create a new backing stud automatically.
- **Modification**: To change the thickness of your backing after insertion, simply select the wall, open the Properties palette (Ctrl+1), locate the script instance, and change the "Sheathing Break Material" dropdown. The wall will update immediately.

## FAQ
- Q: What happens if I change the "Sheathing Break Material" from "1 Ply" to "3x"?
  - A: The script will recalculate the widths of the backing beams. Note that wider configurations (like "3x") use a stricter check for existing studs and are more likely to remove or modify existing studs in the wall to fit the new wider backing.
- Q: Does this work for both vertical and horizontal sheet breaks?
  - A: Yes. It inserts new studs for vertical breaks and modifies existing blocking for horizontal breaks (provided "Apply to Blocking" is set to "Yes").
- Q: Why did some of my existing studs disappear?
  - A: The script removes existing vertical studs that conflict with the geometry of the new backing members to ensure the wall builds correctly.

---
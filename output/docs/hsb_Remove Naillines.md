# hsb_Remove Naillines

## Overview
This script removes all nail line layouts and the specific TSL instances responsible for generating them from selected wall elements. It is useful for clearing existing nail configurations to prepare for a new pattern or to clean up the model for export.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Select 3D Wall Elements (ElementWallSF) here. |
| Paper Space | No | This script does not function in layout views. |
| Shop Drawing | No | This script is for model modification, not detailing. |

## Prerequisites
- **Required entities**: One or more Wall Elements (`ElementWallSF`) must exist in the model.
- **Minimum beam count**: 1 Wall Element must be selected.
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse to and select `hsb_Remove Naillines.mcr`.

### Step 2: Select Elements
```
Command Line: Select one or More Elements
Action: Click on the wall elements you wish to clean up. Press Enter or Right-Click to confirm selection.
```
*(Note: Once confirmed, the script will immediately process the elements and remove itself from the drawing.)*

## Properties Panel Parameters
This script has no editable parameters in the Properties Palette. It executes immediately based on user selection.

## Right-Click Menu Options
This script does not add any custom options to the Right-Click context menu.

## Settings Files
None required.

## Tips
- **Thorough Cleanup**: This script deletes both the visible nail lines and the invisible script instances (`hsb_Apply Naillines to Elements`) attached to the walls. This prevents the nail lines from automatically regenerating if the model updates.
- **Self-Cleaning**: The script automatically deletes its own instance from the project tree after finishing, keeping your project data clean.
- **Validation**: The script skips any invalid elements found in your selection set, so you do not need to filter your selection perfectly.

## FAQ
- **Q: Can I use this on beams or roofs?**
  - A: No, this script is designed specifically for Wall Elements (`ElementWallSF`).
- **Q: Will this delete the wall geometry?**
  - A: No, it only removes the nail lines and the associated generator scripts. The physical wall remains unchanged.
- **Q: Why did nothing happen after I ran the script?**
  - A: This usually means the selected elements did not have any nail lines or generator scripts attached to them.
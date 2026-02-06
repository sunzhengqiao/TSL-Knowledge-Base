# hsb_MultiWallRemoveElement.mcr

## Overview
This utility script removes the 'hsb_Multiwall' sub-map and associated metadata from selected wall elements. It effectively disconnects the selected walls from a Multi-Wall grouping configuration without deleting the actual wall geometry.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the Model Space where Wall Elements are located. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | Not applicable for shop drawings. |

## Prerequisites
- **Required Entities:** Wall Elements (ElementWallSF).
- **Minimum Beam Count:** 1 (You can select multiple walls at once).
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_MultiWallRemoveElement.mcr` from the file dialog.

### Step 2: Select Elements
```
Command Line: Select one or More Elements
Action: Click on the wall elements in your model that you wish to remove the Multi-Wall data from. Press Enter to confirm selection.
```

### Step 3: Automatic Execution
Once the selection is confirmed, the script will automatically run, remove the specific internal data maps, and then delete itself from the drawing. No further input is required.

## Properties Panel Parameters
There are no user-editable parameters in the Properties Palette for this script.

## Right-Click Menu Options
There are no custom context menu options available for this script.

## Settings Files
No external settings files (XML) are required or used by this script.

## Tips
- **Batch Processing:** You can select multiple walls in a single selection window to remove Multi-Wall associations from several elements at once.
- **Self-Cleaning:** The script instance automatically erases itself from the drawing immediately after processing. Do not be alarmed if it disappears from the model space; this is intended behavior.
- **Geometry Preservation:** This script only modifies internal data attributes. The physical geometry of the wall remains unchanged.

## FAQ
- **Q: Did this script delete my wall?**
  **A:** No. The script only removes the internal "hsb_Multiwall" data link. The physical wall element should still be visible in the model.
- **Q: Why did the script icon disappear after I used it?**
  **A:** The script is designed to perform its task once and then erase itself to keep the drawing clean. It does not need to remain in the model after the data is removed.
- **Q: How do I undo this?**
  **A:** You can use the standard AutoCAD `UNDO` command to revert the changes if you ran the script by mistake.
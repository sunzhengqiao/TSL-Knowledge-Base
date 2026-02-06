# hsbGroupVisibilityOff.mcr

## Overview
This script allows you to quickly hide specific hsbCAD structural groups by selecting entities belonging to them. It is designed to clean up the model view by turning off the visibility for the construction phases associated with the selected objects.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script is intended for use in the 3D model. |
| Paper Space | No | Not supported in layout views. |
| Shop Drawing | No | Not intended for manufacturing drawings. |

## Prerequisites
- **Required entities:** Existing hsbCAD entities (e.g., beams, walls) or Elements must be present in the model.
- **Minimum beam count:** 0 (You must select at least one entity to trigger the hide action).
- **Required settings files:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse and select `hsbGroupVisibilityOff.mcr`

### Step 2: Select Entities
```
Command Line: Select entity(s)
Action: Click on the beams, walls, or other entities that belong to the group(s) you want to hide. You can select multiple objects. Press Enter or Right-click to confirm.
```

*Note: The script will automatically identify the structural groups associated with your selection and hide them. The script instance will then remove itself from the drawing.*

## Properties Panel Parameters
This script does not expose any parameters to the Properties Panel.

## Right-Click Menu Options
This script does not add any specific options to the Right-Click context menu.

## Settings Files
No external settings files are required for this script.

## Tips
- **Batch Hiding:** You can select multiple entities from different groups at once. The script will hide all unique groups associated with your selection in a single operation.
- **Restoring Visibility:** Since this script only turns groups off, you will need to use the standard hsbCAD Group Manager or the `-HSB_GROUPSETVISIBLITY` command to make the groups visible again.
- **Auto-Cleanup:** The script automatically deletes itself from the drawing after running. You do not need to manually delete the script instance.

## FAQ
- **Q: Can I use this to hide elements in a 2D Shop Drawing?**
  - A: No, this script only functions in Model Space.
- **Q: Why did the script disappear after I used it?**
  - A: This is normal behavior. The script performs the visibility change and then self-destructs (`eraseInstance`) to keep your drawing clean.
- **Q: What happens if I select an entity that isn't part of a group?**
  - A: The script will ignore entities that do not have a valid group assignment and will only process those that do.
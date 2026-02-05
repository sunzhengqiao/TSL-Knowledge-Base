# NA_GROUP_WALLS_FOR_SHOP_DRAWINGS

## Overview
This script allows you to group multiple wall elements into a single logical entity, preparing them for downstream shop drawing processes. It automatically generates a visual dashed outline in the model to represent the combined geometry of the grouped walls.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be inserted in the model where the walls exist. |
| Paper Space | No | This script does not function in Paper Space. |
| Shop Drawing | No | This script is used to prepare data *before* generating shop drawings. |

## Prerequisites
- **Required Entities**: Wall Elements must already exist in the model.
- **Minimum Selection**: You must select at least one wall during insertion.
- **Conflict Check**: Selected walls must not already be part of another wall group.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or run via your hsbCAD toolbar) → Select `NA_GROUP_WALLS_FOR_SHOP_DRAWINGS.mcr`.

### Step 2: Select Initial Walls
```
Command Line: Select wall(s) to display in a shop drawing as a group
Action: Click on the wall elements you want to include in the group. Press Enter to confirm selection.
```
*Note: If you select walls that are already assigned to another group, the script will report an error and cancel.*

### Step 3: Verify Group Creation
Once inserted, you will see a dashed outline encompassing the selected walls. This outline represents the grouped area for the shop drawing.

### Step 4: Modify Group (Optional)
Right-click on the script instance (the dashed outline or the insertion point) to access context menu options.

## Properties Panel Parameters
This script does not expose any editable parameters in the AutoCAD Properties Palette. All interaction is handled via the command line during insertion and the Right-Click Context Menu.

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Add wall(s)** | Prompts you to select additional walls from the model to append to the current group. The visual outline will update to include the new walls. |
| **Remove wall(s)** | Prompts you to select specific walls to remove from the group. The visual outline will update. If you remove all walls, the script instance will delete itself. |

## Settings Files
No external settings files are required for this script.

## Tips
- **Conflict Resolution**: If the script exits immediately with an error message like "Wall [#] is already grouped...", locate the existing group instance mentioned in the error, use the "Remove wall(s)" option on that group, and then try creating your new group again.
- **Visual Cleanup**: The script applies a small inset (0.5 units) to the visual outline. This makes it easier to see overlapping corners when walls meet at angles.
- **Grouping Non-Adjacent Walls**: You can select walls that are not physically touching. The script will create a unified outline that encompasses all selected elements.

## FAQ
- **Q: Why did the script disappear immediately after I selected the walls?**
  - A: This usually happens if one of the walls you selected is already part of an existing group. Check the command line history for a conflict message.
  
- **Q: Can I use this to group beams or floors?**
  - A: No, this script is designed specifically for Wall Elements. Selecting other entity types may result in errors or unexpected behavior.

- **Q: How do I delete the group entirely?**
  - A: Use the "Remove wall(s)" context menu option to remove walls one by one. When the last wall is removed, the script instance deletes itself automatically. Alternatively, you can simply erase the script instance like a normal CAD entity, though the walls themselves will remain.
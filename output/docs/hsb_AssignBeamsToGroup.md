# hsb_AssignBeamsToGroup

## Overview
This script filters specific beams from a selected wall or floor element based on their Beam Code and moves them into a designated project group. It is typically used to organize loose materials (like sole plates or joists) into separate groups for independent scheduling and manufacturing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the model where the Elements are located. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | This is an organizational script for model entities. |

## Prerequisites
- **Required Entities:** At least one Element (Wall or Floor) containing beams must exist in the model.
- **Minimum Beams:** 0.
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
Execute the `TSLINSERT` command in the AutoCAD command line.
1.  Type `TSLINSERT` and press Enter.
2.  Browse to the location of `hsb_AssignBeamsToGroup.mcr`.
3.  Select the file and click **Open**.

### Step 2: Configure Properties
Upon insertion, a properties dialog will appear automatically.
1.  **Beams with beamcode to Group:** Enter the Beam Codes (e.g., `PL200;ST100`) that you want to move. Separate multiple codes with a semi-colon `;`.
2.  **House Level group name:** Enter the main project group (e.g., `00_GF-Soleplates`). If left empty, the script will use the group of the element you select.
3.  **Floor Level group name:** Enter the sub-group name (e.g., `GF-Loose`).
4.  Click **OK** to confirm.

### Step 3: Select Elements
The command line will prompt for selection.
```
Command Line: 
Select a set of elements
```
1.  Click on the Wall or Floor elements containing the beams you wish to reorganize.
2.  Press **Enter** to finish selection.

**Result:** The script will move the matching beams to the specified group. The script instance will then automatically remove itself from the drawing. To make changes, you must run the script again.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Beams with beamcode to Group | Text | "" | The list of Beam Codes to filter. Use a semi-colon `;` to separate multiple codes (e.g., `CodeA;CodeB`). |
| House Level group name | Text | "00_GF-Soleplates" | The primary (root) group where the beams will be moved. If left empty, the group of the selected element is used. |
| Floor Level group name | Text | "GF-Loose" | The secondary (sub) group name where the beams will be stored. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script instance erases itself immediately after execution. No right-click options are available on the script object. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Multiple Codes:** You can target several different beam types at once by separating them with a semi-colon in the *Beams with beamcode* field (e.g., `200x50;150x50`).
- **Relative Grouping:** If you want the loose materials to stay in the same general folder as the wall they came from, leave the *House Level group name* empty. The script will automatically "inherit" the group from the selected element.
- **Re-running:** Since the script deletes itself after running, do not look for it in the model to edit it. Simply insert `hsb_AssignBeamsToGroup` again to apply different rules or correct mistakes.
- **Synchronization:** The script attempts to clean up previously assigned beams if the element is updated/processed again, ensuring duplicate links are not created.

## FAQ
- **Q: I ran the script, but I can't find it in the model to edit it.**
  - A: This is normal behavior. The script is a "fire and forget" tool that erases itself after moving the beams. Re-insert the script to make changes.
- **Q: What happens if I leave the House Level group name blank?**
  - A: The script will look at the group of the wall or floor you selected and use that as the destination for the loose materials.
- **Q: How do I separate multiple beam codes?**
  - A: Use a semi-colon (`;`) without spaces (e.g., `SP200;JP100`).
# hsb_SetSheetUCS.mcr

## Overview
This script automatically aligns the local orientation (X-axis) of sheet materials (such as floor decking or cladding) to match the X-axis of their parent structural elements. It is typically used to ensure floor sheets run in the same direction as the floor beams or walls.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model elements and sheets. |
| Paper Space | No | Not applicable for 2D layout views. |
| Shop Drawing | No | This script modifies the 3D model geometry, not drawing views. |

## Prerequisites
- **Required entities**: Structural Elements (e.g., Beams, Walls) and associated Sheet entities (e.g., Floors, Roofing).
- **Minimum beam count**: N/A (You must select at least one element containing sheets).
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse to and select `hsb_SetSheetUCS.mcr`.
3. Click **Open**.

### Step 2: Select Elements
```
Command Line: Select a set of elements
Action: Select the beams or walls that contain the sheet materials you want to re-orient. Press Enter or Space to confirm selection.
```

### Step 3: Processing
The script will automatically scan the selected elements, identify any attached sheets, and align their orientation. The script instance will erase itself from the drawing automatically once finished.

## Properties Panel Parameters
There are no editable properties in the Properties Palette for this script.

## Right-Click Menu Options
There are no custom right-click menu options for this script.

## Settings Files
No external settings files are used by this script.

## Tips
- **Parallel Planes Only**: The script only updates sheets that are parallel to the parent element (e.g., a flat floor sheet on a flat floor beam). If a sheet is perpendicular to the element, its orientation will not be changed.
- **Batch Processing**: You can select multiple elements (walls and beams) in a single selection set to process the entire floor or roof layout at once.
- **Self-Cleaning**: The script removes itself from the drawing immediately after running. Do not look for the script instance to edit it later; simply run the `TSLINSERT` command again if you need to make further changes.

## FAQ
- **Q: Why did some of my sheets not rotate?**
  **A:** The script checks if the sheet's plane is parallel to the element's plane. If the sheet is vertical on a horizontal element (or vice versa), the script assumes the orientation is intentional and does not modify it.
- **Q: Do I need to select the sheets individually?**
  **A:** No. Simply select the parent structural elements (beams or walls). The script will find all associated sheets automatically.
- **Q: Can I undo this action?**
  **A:** Yes, you can use the standard AutoCAD `UNDO` command to revert the changes if the result is not as expected.
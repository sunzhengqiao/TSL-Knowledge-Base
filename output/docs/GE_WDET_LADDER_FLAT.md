# GE_WDET_LADDER_FLAT.mcr

## Overview
This script generates horizontal "ladder" blocking (fire blocks or bracing) between two specific wall studs. It identifies the bay selected by the user, removes any existing blocking in that area, and inserts a new pattern of blocking based on defined spacing and offsets.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in Model Space on an existing 3D wall element. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | Not intended for generating 2D detail views directly. |

## Prerequisites
- **Required Entities**: An existing `ElementWallSF` or `Wall` (Stud Frame) with vertical studs.
- **Minimum Beam Count**: The wall must contain at least two vertical studs to define the bay width.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_WDET_LADDER_FLAT.mcr` from the catalog or file dialog.

### Step 2: Select Wall Element
```
Command Line: Select an element
Action: Click on the wall element (Wall or ElementWallSF) where you want to add the blocking.
```

### Step 3: Identify Bay Location
```
Command Line: Select an insertion point
Action: Click inside the specific "bay" (the space between two studs) where you want the ladder blocking to be generated.
```
*Note: The script uses this point to find the nearest left and right studs to act as boundaries.*

### Step 4: Configure Parameters
A "Properties" dialog will appear automatically.
1. Adjust the **Start Offset**, **End Offset**, and **Spacing** as needed.
2. Verify the **Material** and **Grade**.
3. Click **OK** to generate the blocking.

### Step 5: Generation
The script will erase existing blocking in that bay, create the new blocking beams, and then delete itself from the drawing (leaving only the physical beams).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **PLACEMENT PROPERTIES** | - | - | - |
| Start Offset | Number | 600 | The vertical distance from the bottom of the cavity to the center of the first blocking piece. If set to 0, it automatically positions on top of the bottom plate. |
| End Offset | Number | 0 | The distance from the top of the cavity downwards. A value of 0 fills the cavity up to the top plate. |
| Spacing | Number | 600 | The vertical distance between the centers of consecutive blocking pieces. |
| **MATERIAL PROPERTIES** | - | - | - |
| Material | Text | SPF | The wood species code for the new blocking beams (e.g., SPF, SYP). |
| Grade | Text | #2 | The structural grade of the lumber for the new blocking beams. |

## Right-Click Menu Options
This script does not add persistent context menu options because it erases itself immediately after generating the geometry.

## Settings Files
No external settings files (XML/INI) are required for this script. All configuration is handled via the Properties Palette during insertion.

## Tips
- **Script Self-Deletion**: This script runs once and then removes itself from the drawing (`eraseInstance`). You cannot double-click the result later to change settings. To modify the layout, use **Undo** (Ctrl+Z) and run the script again with new parameters.
- **Start Offset 0**: If you set the Start Offset to 0, the script intelligently calculates the position to sit directly on top of the bottom plate, accounting for the plate thickness.
- **Clean Up**: The script automatically detects and deletes any existing blocking within the selected bay before generating the new pattern. You do not need to manually delete old blocking first.
- **Validation**: Ensure you click strictly between two studs. If you click too close to a plate or outside the wall bounds, the script may report "cannot find a connecting stud" and abort.

## FAQ
- **Q: I generated the blocking, but now I want to change the spacing. How do I do that?**
  - A: Since the script instance is deleted after running, you cannot simply edit the properties. You must use the **Undo** command to remove the generated blocking and re-run the script with the correct spacing value.
- **Q: What happens if there is already blocking in that wall bay?**
  - A: The script creates a temporary volume around the insertion point and erases any existing blocking beams found within that volume between the two bounding studs before inserting the new ones.
- **Q: The script gave an error "cannot find a connecting stud". What went wrong?**
  - A: Your insertion point was likely not inside a valid bay defined by two vertical studs. Ensure you click clearly between two studs and not on an opening (door/window) trimmer or the wall plates.
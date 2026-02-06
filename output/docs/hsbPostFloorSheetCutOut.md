# hsbPostFloorSheetCutOut.mcr

## Overview
This script automatically creates a connection between vertical post beams and horizontal floor sheets. It cuts rectangular clearance holes in the sheets to allow posts to pass through, accounting for a specified gap, and splits the sheets into new parts if the cutout divides them.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in Model Space. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: 
  - At least one vertical Post beam (X-axis parallel to World Z).
  - At least one horizontal Floor sheet (Z-axis parallel to World Z).
- **Minimum Beam Count**: 1 Post.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbPostFloorSheetCutOut.mcr`

### Step 2: Select Entities
```
Command Line: Select sheets and beams
Action: Select the vertical post beam(s) and the floor sheet(s) that intersect them. Press Enter to confirm.
```

### Step 3: Configure Parameters
The script will insert. In the Properties Palette (Ctrl+1), adjust the `Gap` if necessary. The script will automatically update the cutout geometry based on the post dimensions and the gap value.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Gap | Number | 0 | Defines the clearance distance between the post beam and the edge of the cutout in the sheet. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add Sheet | Prompts you to select additional sheet(s) to include in the current cutout instance. This can also be triggered by double-clicking the TSL instance. |

## Settings Files
None.

## Tips
- **Sheet Splitting**: If the cutout is large enough to sever the sheet into disconnected parts, the script will automatically create new sheet entities for the resulting pieces.
- **Orientation**: Ensure your post beams are vertical (X-axis up) and floor sheets are horizontal for the script to detect the intersection correctly.
- **Updates**: If you change the `Gap` or the intersecting sheets, the script will update existing geometry automatically without needing to delete and re-insert the TSL.

## FAQ
- **Q: Can I add more sheets to an existing connection without re-inserting?**
  **A:** Yes. Right-click the TSL instance and select "Add Sheet" or simply double-click the instance, then select the new sheets.
- **Q: What happens if the cutout cuts the sheet completely in half?**
  **A:** The script automatically splits the original sheet into two separate new sheet elements in the model.
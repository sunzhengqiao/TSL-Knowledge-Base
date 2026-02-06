# hsbBevelOpeningSill.mcr

## Overview
This script automates the creation of a sloped (beveled) sill cut for window or door openings in timber frame walls. It simultaneously cuts or stretches the adjacent packers and sheathing to match the specified angle.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be run in the 3D model context. |
| Paper Space | No | Not applicable for 2D drawings. |
| Shop Drawing | No | Not intended for shop drawing generation. |

## Prerequisites
- **Required Entities**: An existing wall `Element` containing at least one `Opening` (Window or Door).
- **Construction**:
    - A vertical beam (Sill plate) located immediately below the opening.
    - Side materials (studs or packers) defining the width of the opening.
    - If using "Depth = 0", horizontal packers or sheets must exist below the opening to define the cut height.
- **Minimum Beam Count**: 1 (the sill plate beam).

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the AutoCAD command line.
2.  Browse to and select `hsbBevelOpeningSill.mcr`.

### Step 2: Configure Properties
A dialog will appear (or you can set these later in the Properties Palette):
1.  **Angle**: Set the desired slope for the sill (default is 5.0°).
2.  **Depth**: Enter the vertical distance from the bottom of the opening to start the bevel (default is 102.0 mm).
3.  **Packers are sheets**: Select "Yes" if your infill material is structural sheeting (e.g., plywood/OSB) or "No" if it is dimensional lumber/beams.

### Step 3: Select Opening
```
Command Line: Select openings
Action: Click on the window or door opening in the model.
```
*Note: You can select multiple openings at once.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Angle | Number | 5.0 | Defines the slope of the sill bevel in degrees. |
| Depth | Number | 102.0 | The vertical distance (mm) from the bottom of the opening where the bevel starts. If set to 0, the script calculates this based on the height of detected packers. |
| Packers are sheets | Dropdown | No | Determines if the side materials are "Sheets" (e.g., OSB) or "Beams" (e.g., studs). This affects how the script detects and cuts the material. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No specific context menu options are added by this script. Use the Properties Palette to modify settings. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Dynamic Updates**: After insertion, you can change the `Angle` or `Depth` directly in the AutoCAD Properties Palette (select the script instance). The cuts will update automatically.
- **Depth Calculation**: If you are unsure of the exact depth measurement, set `Depth` to `0`. The script will look for the top of the packers below the window to determine where to start the cut.
- **Multiple Openings**: If you select a main wall `Element` that contains multiple openings, the script will automatically create a separate instance for each opening.

## FAQ
- **Q: Why did the script delete itself immediately after running?**
  **A**: The script performs validation checks. It will delete itself if it cannot find a valid sill beam below the opening, if it cannot detect side boundaries (studs/packers), or if `Depth` is 0 but no packers were found to calculate the height.
- **Q: The side cut isn't matching my sill cut.**
  **A**: Check the `Packers are sheets` property. If your wall uses sheet material (like plywood) on the sides but this is set to "No", the script might be looking for beams instead. Switch it to "Yes".
- **Q: Can I use this on doors?**
  **A**: Yes, as long as there is a beam below the opening (sill/threshold) to receive the bevel cut.
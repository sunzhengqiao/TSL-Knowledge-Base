# HSB_W-WallConnections.mcr

## Overview
This script automates the creation of wall-to-wall connections by calculating and drilling a vertical pattern of holes for mechanical fixings (such as Fix90 connectors). It ensures holes are evenly spaced within the intersecting area of two ElementWalls and updates the BOM data accordingly.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script runs in 3D environment and generates physical drill holes. |
| Paper Space | No | Not applicable for layout generation. |
| Shop Drawing | No | Does not generate 2D views or dimensions. |

## Prerequisites
- **Required Entities**: At least two `ElementWall` entities that physically intersect (touch or overlap).
- **Minimum Beam Count**: 0 (Works on ElementWall entities, not individual beams).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_W-WallConnections.mcr`

### Step 2: Select Walls
```
Command Line: Select a set of elements
Action: Click on the main wall and the intersecting wall(s) you wish to connect.
```
*Note: You can select multiple walls at once. The script will detect intersections between the selected elements and create individual connection instances for every valid junction found.*

### Step 3: Configure Parameters (Optional)
After insertion, the connection instances are created. Select a specific connection instance (or the group) and open the **Properties Palette (OPM)** to adjust settings like offsets or drill diameter.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| \|Drill pattern\| | Separator | | Section header for layout settings. |
| Offset from bottom | Number | 50 mm | The vertical distance from the bottom of the intersection to the center of the first drill hole. |
| Offset from top | Number | 50 mm | The vertical distance from the top of the intersection to the center of the last drill hole. |
| Maximum spacing | Number | 300 mm | The maximum allowed distance between the centers of drill holes. The script will automatically calculate a spacing equal to or less than this value to fit the holes evenly. |
| \|Drills\| | Separator | | Section header for drilling hardware settings. |
| Diameter | Number | 10 mm | The diameter of the drill hole to be created. |
| Fixing | Dropdown | Fix90 | The article number for the wall connector (e.g., Fix90, Fix80, Fix70). This updates the BOM description (e.g., "Wall connector 90mm wall"). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | No custom context menu items are defined for this script. |

## Settings Files
- **Filename**: *None*
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Dynamic Updates**: If you move the walls or change their heights, the script automatically recalculates the drill positions to stay within the new intersection bounds.
- **Spacing Logic**: The `Maximum spacing` is a ceiling value. If you have a wall height of 1000mm with 0 offsets, and set max spacing to 600mm, the script will calculate the exact spacing to fill the height evenly (e.g., dividing the height into sections), rather than strictly leaving a large gap.
- **Visualizing Errors**: If the script instance disappears after insertion, check the command line. It likely reported "No possible drill positions found" (if offsets are too large) or "Surfaces are not connecting!" (if walls do not touch).

## FAQ
- **Q: Why did the script instance disappear immediately after I selected the walls?**
  **A:** This usually happens if the script detects an error. Common causes include:
  1. The walls are in a straight line (inline) rather than intersecting at a corner or T-junction.
  2. The walls do not physically touch or overlap in 3D space.
  3. The calculated connection width is smaller than twice the drill diameter.

- **Q: Can I use this to connect beams?**
  **A:** No, this script is designed specifically for `ElementWall` entities. For beam-to-beam connections, use a different TSL script.

- **Q: How do I change the connector type after the holes are drilled?**
  **A:** Select the connection instance in the model, open the Properties Palette, and change the **Fixing** dropdown. This updates the report/BOM data without altering the geometry.
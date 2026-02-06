# hsbTSL ECS Symbol.mcr

## Overview
This script inserts a visual 3D compass symbol into the model to define a specific local coordinate system (ECS). It is used to establish a custom orientation for views or export axes that differs from the global project coordinates.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be inserted in Model Space. |
| Paper Space | No | Not supported for layout insertion. |
| Shop Drawing | No | This is a setup tool run in the model, though it affects drawing orientations. |

## Prerequisites
- **Required entities:** None
- **Minimum beam count:** 0
- **Required settings files:** None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbTSL ECS Symbol.mcr` from the file list.

### Step 2: Select Insertion Point
```
Command Line: [No specific text, cursor is active]
Action: Left-click anywhere in the Model Space to place the center of the symbol.
```
*Note: Once placed, the symbol appears as a circular grid with three colored arrows indicating the X (Red), Y (Green), and Z (Blue) axes.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Grid Angle | Number | 15 | Sets the interval (in degrees) for the tick marks around the compass circle. This value automatically snaps to the nearest number that divides 360 evenly (e.g., entering 14 will correct to 15). |

## Right-Click Menu Options
This script does not add custom options to the right-click context menu. Standard AutoCAD/hsbCAD options apply.

## Settings Files
None required.

## Tips
- **Maintaining Orthogonality:** The symbol enforces 90-degree angles between axes. If you drag the grip point for the X-axis, the Y and Z axes will automatically rotate to remain perpendicular to it and to each other.
- **Visual Reference:** The arrows follow the standard color coding: Red = X-axis, Green = Y-axis, and Blue = Z-axis.
- **Adjusting Density:** Use the `Grid Angle` property to make the compass ticks finer (e.g., 5 degrees) or coarser (e.g., 45 degrees) depending on how precise you need the visual guide to be.
- **Moving the Origin:** Use the central grip (insertion point) to relocate the entire coordinate system without changing its orientation.

## FAQ
- **Q: I typed 14 for the Grid Angle, but it changed to 15. Why?**
  - **A:** The compass requires 360 degrees to be divided into whole segments. Since 360 divided by 14 is not a whole number, the script automatically corrects the value to 15 to ensure the grid lines align perfectly.
- **Q: Can I skew the axes so they are not at 90 degrees?**
  - **A:** No. This script defines a Cartesian coordinate system, which requires all three axes to be orthogonal (perpendicular) to each other. Moving one axis will always force the others to adjust.
- **Q: How do I rotate the symbol to match a sloping roof?**
  - **A:** Use the grip points at the tips of the arrows (Red, Green, or Blue). Dragging the tip of the Z-axis (Blue), for example, will tilt the system, and the X and Y axes will flatten out accordingly to remain horizontal relative to the new Z vector.
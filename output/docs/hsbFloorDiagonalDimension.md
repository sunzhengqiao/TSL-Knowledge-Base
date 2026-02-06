# hsbFloorDiagonalDimension.mcr

## Overview
Automatically generates a diagonal dimension line in Model Space between two user-selected wall corners. It intelligently calculates measurement points based on wall geometry, allowing you to measure the distance between either the inner or outer shells of the intersecting walls.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script creates dimension entities in the 3D model. |
| Paper Space | No | This script does not function in Layout tabs. |
| Shop Drawing | No | This script is intended for model layout, not manufacturing drawings. |

## Prerequisites
- **Required Entities:** ElementWall entities.
- **Minimum Wall Count:** 4 total (at least 2 walls must form the first corner, and at least 2 walls must form the second corner).
- **Required Settings:** DimStyles must be defined in the current drawing.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or `tsl`)

Action: Browse the script list and select `hsbFloorDiagonalDimension.mcr`.

### Step 2: Configure Properties (Optional)
If the script is not run from a predefined catalog, a dialog may appear, or you can set properties in the Properties Palette before insertion.

Action:
- Select the desired **DimStyle** from the dropdown list.
- Select the **Dimension** type (Inner or Outer).
- Click OK to proceed.

### Step 3: Select First Corner Walls
```
Command Line: Select walls of first corner
Action: Click on at least two walls that intersect to form the first corner.
```
*Note: The script uses these walls to calculate the exact intersection point.*

### Step 4: Select Second Corner Walls
```
Command Line: Select walls of second corner
Action: Click on at least two walls that intersect to form the second corner.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| DimStyle | Dropdown | *Empty* | Selects the visual style (text height, arrowheads, units, layer) for the dimension line from the available styles in the drawing. |
| Dimension | Dropdown | Inner | Defines whether the measurement is taken from the interior faces (**Inner**) or the exterior faces (**Outer**) of the wall assembly. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Swap dimension side | Instantly toggles the 'Dimension' property between 'Inner' and 'Outer' and recalculates the length. (Also triggered by double-clicking the instance). |

## Settings Files
No specific settings files are required for this script. It relies on standard AutoCAD DimStyles defined in the current drawing.

## Tips
- **Verification:** Use this script to quickly verify the diagonal distance (e.g., for sheet material sizing or bracing length) between two complex wall corners.
- **Editing:** You can easily switch between measuring the inside or outside of the walls by simply double-clicking the dimension instance in the model.
- **Selection:** Ensure the walls you select actually touch or intersect in the plan view; otherwise, the script will fail to calculate the intersection.
- **Geometry:** The script is smart enough to handle T-junctions or corners where more than two walls meet, calculating the centroid of the intersection cluster to find the "true" corner point.

## FAQ
- **Q: Why did the script disappear after I selected the walls?**
  - A: The script requires at least two intersecting walls to define a valid corner. If you selected only one wall, or if the selected walls do not physically intersect, the script will erase itself. You must restart and select valid intersecting walls.
- **Q: Can I use this for ceilings or roofs?**
  - A: This script is designed for ElementWall entities in floor plans. It may not work correctly on other element types like beams or slabs unless they are treated as walls by the system.
- **Q: How do I change the arrow style of the dimension?**
  - A: Change the `DimStyle` property in the Properties Palette to a style that has your preferred arrow settings, or modify the DimStyle in the AutoCAD Dimension Style Manager.
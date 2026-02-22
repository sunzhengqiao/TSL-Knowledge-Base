# hsbBrick-CourseDistribution

## Overview

The **hsbBrick-CourseDistribution** script defines the vertical distribution of brick courses across wall elements in hsbCAD. It calculates how many horizontal rows (courses) of bricks fit within the height of your selected walls, and determines the optimal horizontal mortar joint (bed joint) thickness so that courses are evenly distributed without cutting bricks at the top or bottom.

When you run this tool, you select one or more wall elements and configure your brick family and mortar joint tolerances. The script then calculates all possible course count options that satisfy your minimum and maximum mortar joint constraints and presents them in the right-click context menu. You choose the preferred course count, and the script updates the calculated joint thickness accordingly.

In addition to the vertical distribution, the script automatically creates companion distribution scripts for horizontal brick layout: **hsbBrick-BrickDistributionExterior** for exterior walls (one instance per facade plane) and **hsbBrick-BrickDistributionInterior** for interior walls (one instance per wall). These companion scripts inherit the brick family data, joint values, and building reference point from this script. If a valid vertical distribution cannot be achieved within your joint limits, the script falls back to the minimum joint thickness and trims the topmost course.

## Usage Environment

| Attribute | Value |
|-----------|-------|
| Script Type | O-Type (Object) - exists as a persistent entity in Model Space |
| Beams Required | 0 |
| Intended Space | Model Space |
| Units | Millimeters (default) |
| Settings File | `hsbBrickFamilyDefinitions.xml` in the Company TSL Settings folder |

## Prerequisites

- At least one **ElementWall** must exist in the drawing before running this script.
- All walls selected in a single run must be of the same type: either all exterior or all interior. The first wall you select determines the type, and any walls of the opposite type are automatically excluded.
- The brick family catalog (`hsbBrickFamilyDefinitions.xml`) should be configured in your company settings folder. If no file is found, the script creates a default catalog with a single "M50" brick family (188 x 88 x 48 mm).
- For exterior walls, openings (windows, doors) that exist on those walls will be automatically detected and used for snap reference lines in the visual graph.

## How to Use

1. Run the script from the hsbCAD command line or menu (command: `TSLCONTENT`).
2. A dialog appears. Select a brick family from the list, or choose a saved catalog entry. Adjust mortar joint limits and zone if needed, then click OK.
3. At the "Select element(s)" prompt, click on one or more wall elements in the drawing. Press Enter when done.
4. Click a point in the drawing to set the insertion location for the distribution graph.
5. The script places the course distribution object. A schematic graph appears showing the wall heights, opening heights (exterior walls only), and the calculated brick course layout.
6. Right-click the placed object to see the context menu, which lists all valid course count options and allows you to set a building reference point.
7. Click a course count option (for example, "12 Courses [x]") to select it. The calculated joint thickness updates automatically in the Properties panel.
8. Optionally, use "Select reference point" from the context menu to define a building-level reference origin for aligning horizontal brick distribution across multiple walls.

**For exterior walls:** One CourseDistribution instance is created for all selected exterior walls together. One BrickDistributionExterior instance is created for each unique facade plane (group of walls lying in the same plane).

**For interior walls:** One CourseDistribution instance is created per storey level. One BrickDistributionInterior instance is created per individual wall.

## Properties Panel (OPM Parameters)

These parameters appear in the AutoCAD Properties Palette when the script instance is selected.

### General

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Family | String (list) | First family in the XML catalog | The brick family to use, defining brick length, width, height, and color. The list is populated from `hsbBrickFamilyDefinitions.xml`. |
| Zone | Integer (list) | 0 | Zone identifier for brick laying, ranging from -5 to +5. Used to coordinate brick courses across different areas or facades. |

### Mortar Course Joint

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Minimum | Double | 9 mm | Minimum allowed thickness of the horizontal mortar bed joint between courses. |
| Maximum | Double | 15 mm | Maximum allowed thickness of the horizontal mortar bed joint between courses. |
| calculated | Double | (read-only) | The computed optimal bed joint thickness for the currently selected course count. Updated automatically when you pick a different course count from the context menu. |

### Mortar Butt Joint

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Minimum | Double | 9 mm | Minimum vertical mortar joint thickness. This value is passed on to the companion horizontal distribution scripts (BrickDistributionExterior / BrickDistributionInterior). |
| Maximum | Double | 15 mm | Maximum vertical mortar joint thickness. Passed on to the companion horizontal distribution scripts. |

## Right-Click Menu Options

Right-click on the placed CourseDistribution object to access the following options:

| Menu Item | Description |
|-----------|-------------|
| **N Courses** (one entry per valid count) | Each item shows a valid number of brick courses that satisfies your minimum and maximum joint constraints. The currently active selection is marked with `[x]`. Clicking an item saves that course count and recalculates the bed joint thickness. |
| **Select reference point** | Prompts you to click a point in the drawing to define the building reference origin. This reference point is used by the companion horizontal distribution scripts to align brick courses consistently across all walls. The reference point is stored as a vector so it remains stable even if you move the CourseDistribution object. |

## Visual Display

The script draws a schematic graph in the drawing (not a real 3D model) that shows:

- **Wall height lines**: Horizontal tick marks with dimension labels for the bottom and top of each selected wall.
- **Opening height lines** (exterior walls only): Tick marks showing the bottom and top edges of each opening, and snap reference lines at the brick courses nearest to each opening edge.
- **Brick course layout**: Filled rectangles representing each course, alternating between full-length and half-length bricks to show the staggered bond pattern. Colored according to the selected brick family color.
- **Reference point**: A filled circle drawn at the building reference point location.
- **Grip point**: A draggable grip at the top of the distribution range. Drag it vertically to change the reference height used for course calculation.

## Tips and Notes

1. **Adjusting the reference height**: The primary grip point sits at the top of the distribution range. Dragging it up or down changes the total height over which courses are calculated, which in turn changes how many valid course counts are available in the context menu.

2. **No valid distribution**: If the wall height and brick size combination cannot produce any course count within your joint limits, the script automatically accepts the minimum joint thickness and trims the last course. A message in the command line informs you when this fallback is used.

3. **Mixed wall types not allowed**: All walls in one run must be either all exterior or all interior. If you select a mix, the script discards any walls that differ from the type of the first wall selected.

4. **Interior walls and storeys**: For interior walls, the script reads the storey grouping from each wall's element group name. It creates a separate CourseDistribution instance for each storey level, allowing independent course distribution per floor.

5. **Automatic recalculation**: The script tracks changes to the linked walls and their openings. If a wall is moved or an opening is modified, the distribution automatically recalculates.

6. **Catalog entries**: When inserting the script with a command key that matches a saved catalog entry name, the script applies those saved property values silently, skipping the dialog. This enables automated or batch insertion workflows.

7. **Companion scripts**: The horizontal distribution scripts (BrickDistributionExterior and BrickDistributionInterior) are created automatically on first placement. Do not manually delete them; they depend on this script for brick family data, joint values, and the building reference point.

8. **Brick family configuration**: Add or modify brick families in `hsbBrickFamilyDefinitions.xml` located in your company TSL Settings folder. Each family entry specifies a name, length, width, height, and display color. Changes to the XML file are picked up when the script recalculates (the file is cached in the drawing database for performance).

## Related Scripts

| Script | Relationship |
|--------|-------------|
| **hsbBrick-BrickDistributionExterior** | Created automatically by this script for each facade of exterior walls. Handles horizontal (along-wall) brick distribution. |
| **hsbBrick-BrickDistributionInterior** | Created automatically by this script for each interior wall. Handles horizontal brick distribution with intersection logic for crossing walls. |
| **hsbBrick-3dBricks** | Generates 3D brick geometry based on the distribution data. |

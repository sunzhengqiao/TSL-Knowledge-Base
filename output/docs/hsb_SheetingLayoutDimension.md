# hsb_SheetingLayoutDimension.mcr

## Overview
Automates the generation of layout dimensions for wall elements in Paper Space viewports. It is used to quickly dimension stud spacing, sheathing boards, or battens on production drawings without manual measurement.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed for annotations in layouts. |
| Paper Space | Yes | Script operates inside a layout tab on a selected viewport. |
| Shop Drawing | Yes | Used for creating production drawings and elevations. |

## Prerequisites
- **Required Entities:** A Layout tab containing a Viewport that displays an hsbCAD Element (e.g., a wall).
- **Minimum Beam Count:** 0 (The script detects element boundaries even if no beams are present).
- **Required Settings:** None.
- **View Orientation:** The Viewport must be set to an orthographic view (Front, Back, Left, Right, or Plan). The wall must appear perfectly vertical or horizontal on the screen.

## Usage Steps

### Step 1: Launch Script
Navigate to the desired Layout tab in AutoCAD.
1. Type `TSLINSERT` in the command line.
2. Browse and select `hsb_SheetingLayoutDimension.mcr`.

### Step 2: Select Viewport
```
Command Line: Select a viewport, you can add others later on with the HSB_LINKTOOLS command.
Action: Click inside or on the border of the viewport showing the wall you wish to dimension.
```
*Note: Once selected, the script will immediately calculate and place the dimension based on default properties.*

### Step 3: Adjust Properties
1. Select the dimension object (or the script anchor) if not already selected.
2. Open the **Properties** palette (Ctrl+1).
3. Modify parameters such as **Direction**, **Dimension type**, or **Offset** to fit your drawing standards.
4. The dimension will update automatically as you change properties.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Direction | dropdown | Horizontal | Sets the orientation of the dimension chain. **Horizontal** measures across the wall (stud spacing), **Vertical** measures up the wall (plate heights/battens). |
| Side of beams/sheets | dropdown | Left | Determines which face of the timber members the dimension lines snap to (Left face, Centerline, Right face, or Both sides). |
| Zones to use | dropdown | Use zone index | Chooses between dimensioning a specific construction layer or all layers in the element. |
| Zone to dimension | number | 0 | Selects the specific layer to dimension (when "Use zone index" is active). 0 is typically the main frame (studs); 1+ usually indicates sheathing or cladding. |
| Side of delta dimensioning | dropdown | Above | Controls whether the dimension text/ticks appear above or below the dimension line. |
| Dimension type | dropdown | Delta perpendicular | Defines the calculation logic. **Delta** shows individual spacing (e.g., 600, 600), while **Cumulative** shows running totals (e.g., 600, 1200). |
| Dimension Style | dropdown | *(Project List)* | Selects the visual CAD style (text height, arrow style, color) from the project's available dimension styles. |
| Offset from Element | number | 100 | Sets the distance (in mm) between the wall element and the dimension line in Paper Space. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None available | This script does not add specific custom commands to the right-click context menu. Use the Properties palette to modify settings. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **View Alignment:** If you see an error "Vectors not aligned," check your viewport. The wall must be straight (not rotated relative to the screen edges). Use AutoCAD's `PLAN` command or `UCS` `World` to align the view before running the script.
- **Clutter Control:** If the dimension overlaps with other notes, increase the **Offset from Element** value in the properties.
- **Switching Layers:** To dimension sheathing instead of studs, set **Zones to use** to "Use zone index" and change **Zone to dimension** to `1` (or the appropriate index for your cladding material).
- **Multiple Viewports:** You can run the script multiple times on the same layout to dimension different viewports independently.

## FAQ
- **Q: Why does the script disappear after I select the viewport?**
  A: The script calculates the position based on the current view. If the view is not perfectly aligned (orthographic), the script may fail to find the wall edges silently or report an error. Ensure the wall is strictly horizontal or vertical in the viewport.
- **Q: Can I dimension both studs and sheathing at the same time?**
  A: Not simultaneously on the same line. You must insert the script twice: once configured for Zone 0 (studs) and once configured for Zone 1 (sheathing).
- **Q: How do I change between "Delta" (spacing) and "Cumulative" (total length) dimensions?**
  A: Select the dimension, open Properties, and change the **Dimension type** option (e.g., switch from "Delta perpendicular" to "Cummulative perpendicular").
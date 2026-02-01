# HSB_D-RotatedSheets.mcr

## Overview
This script generates a detailed 2D schedule of sheet elements (such as wall panels or roof sections) on a Paper Space layout. It arranges the sheets in a customizable grid with automatic dimensions, labels, and geometry views, filtering by specific zones or orientations to focus on non-standard or rotated components.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed for Paper Space layouts only. |
| Paper Space | Yes | This is the primary workspace. Must be used on a layout tab containing a viewport of an hsbCAD Element. |
| Shop Drawing | No | This is a detailing/scheduling tool for layouts. |

## Prerequisites
- **Required Entities**: An hsbCAD Element (containing Sheets) visible in a viewport on the current layout.
- **Minimum Beam Count**: 0 (This script works with Sheets/Element entities, not beams directly).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_D-RotatedSheets.mcr`

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the viewport in Paper Space that displays the 3D model/Element you wish to detail.
```

### Step 3: Set Origin Point
```
Command Line: Select a point for first detail
Action: Click on the layout to define the top-left (or origin) corner of the sheet grid.
```

### Step 4: Configure Properties
After insertion, select the script instance and open the **Properties Palette** (Ctrl+1) to adjust filters, grid spacing, and dimension styles.

## Properties Panel Parameters

### Selection
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show only sheets with | dropdown | No alignment filter | Filters sheets based on orientation. Use "Thickness not aligned..." to exclude standard flat panels and only show rotated parts (e.g., kneewalls). |
| Draw sheets in zone | dropdown | 10 | Selects the construction zone (Index 0-10) to extract sheets from. |

### Grid
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Distance to next sheet (horizontal) | number | 100 | The width of the frame allocated for each sheet detail. |
| Distance to next sheet (vertical) | number | 100 | The height of the frame allocated for each sheet detail. |
| Distance to next viewport (horizontal) | number | 10 | The horizontal gap between sheet details in the grid. |
| Distance to next viewport (vertical) | number | 10 | The vertical gap between sheet details in the grid. |
| Number of columns | number | 3 | The number of sheet details placed horizontally before wrapping to the next row. |
| Number of rows | number | 3 | The maximum number of rows allowed for the grid. |

### Viewport Style
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Scale factor | number | 1 | Scale of the sheet geometry inside the frame. Set to 0 to match the source viewport's scale. |
| Dimension style viewport | dropdown | *Empty* | The CAD dimension style used for labels inside the detail frame. |
| No-plot layer name | text | G-Anno-View | The layer assigned to the grid rectangles and non-critical text (typically a non-plotting layer). |
| Show sheet number | dropdown | Yes | Toggles the visibility of the sheet number label. |
| Columns | dropdown | Left to right | Determines the direction in which columns are filled. |
| Swap sheet | dropdown | No | Swaps the orientation of the sheet geometry projection (Rotates 90 degrees). |

### Measurements
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension style | dropdown | *Empty* | The CAD dimension style used for the overall dimensions of the sheet. |
| Offset edge dimension | number | 100 | The offset distance for dimension lines from the sheet geometry. |
| Show material | dropdown | Yes | Toggles the visibility of the material label. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Resets the positions of sheets for the current Element, snapping them back to the automatic grid layout. Use this if you want to undo manual movements. |
| Recalculate All | Clears all stored position data for all instances of this script in the drawing, resetting everything to default. |

## Settings Files
None required.

## Tips
- **Manual Adjustment**: You can click and drag individual sheet details to move them manually. The script remembers these positions even after recalculation.
- **Filtering Complex Parts**: To create a schedule for only kneewalls or dormer cheeks, set "Show only sheets with" to "Thickness not aligned with element thickness".
- **Capacity Warnings**: If you see a warning that not all sheets are placed, increase the "Number of rows" or "Number of columns" in the Grid properties.
- **Resetting Layout**: If the layout becomes messy, right-click the script instance and select "Recalculate" to snap all sheets back to a clean grid.

## FAQ
- **Q: Why are my standard floor panels missing?**
  A: Check the "Show only sheets with" property. If "Thickness not aligned..." is selected, standard panels parallel to the element axes are filtered out.
- **Q: How do I change the scale of the details?**
  A: Adjust the "Scale factor" property in the Viewport Style category.
- **Q: The grid runs off the page. How do I fix it?**
  A: You can either decrease the "Distance to next sheet" (frame size) values or increase the "Number of rows/columns" and change the "Columns" direction to wrap the grid differently.
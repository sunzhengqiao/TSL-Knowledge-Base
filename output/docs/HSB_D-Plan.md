# HSB_D-Plan

## Overview
Automatically generates a complete set of plan dimensions (openings, perimeter, and overall extents) for a selected floor group, aligning them to grid lines or the building envelope.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in Model Space. |
| Paper Space | No | Not supported for Paper Space layouts. |
| Shop Drawing | No | Not designed for Shop Drawing generation. |

## Prerequisites
- **Required Entities**: A model containing at least one Floor Group with Elements (panels) or GenBeams.
- **Minimum Beams**: None, but geometry is required to generate dimensions.
- **Required Settings**:
  - The TSL script `HSB_D-Aligned` must be available in the catalog (used to draw the actual dimension lines).
  - AutoCAD/hsbCAD Dimension Styles must be defined in the drawing.
  - Grid lines (optional, required if using grid reference features).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_D-Plan.mcr` from the list.

### Step 2: Configure Properties
```
Dialog: HSB_D-Plan Properties
Action:
1. Select the 'Floorgroup' to dimension from the dropdown list.
2. Adjust dimension offsets, styles, and grid settings as needed.
3. Click OK to confirm.
```

### Step 3: Set Insertion Point
```
Command Line: Pick insertion point:
Action: Click anywhere in the Model Space (typically near the floor plan) to place the script instance.
```
*Note: The script will immediately calculate and spawn the dimension lines based on the selected floor group.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| FloorGroupName | dropdown | First Available | Selects the specific floor group to process for dimensions. |
| DimensionStyleConstructiveBeams | dropdown | Standard | Sets the visual style (font, arrows) for beam label text. |
| TextSizeConstructiveBeams | number | -1 | Overrides text height for beam labels. (-1 uses Style default). |
| OffsetDimensionLines | number | 1000 mm | Distance between the building geometry and the first dimension line. |
| DistanceBetweenDimensionLines | number | 400 mm | Vertical spacing between subsequent dimension chains. |
| UseElementOutlineAsFrameOutline | Yes/No | No | **Yes**: Dimensions measure to panel cladding (Net size). **No**: Measures to structural beams. |
| GridAsReference | Yes/No | Yes | If Yes, extension lines snap to grid lines instead of wall faces. |
| GridTolerance | number | 1000 mm | Search radius for snapping to grid lines. |
| CatalogOpeningDimensionLines | dropdown | Standard | Catalog preset for the 'Openings' dimension chain styling. |
| DescriptionOpeningDimensionLines | text | Openings | Label text identifying the Opening dimension chain. |
| CatalogPerimeterDimensionLines | dropdown | Standard | Catalog preset for the 'Perimeter' dimension chain styling. |
| FloorGroupNameDimensionLines | dropdown | Same as Source | Assigns generated dimensions to a specific group for layer management. |
| ShowInDisplayRepresentation | dropdown | Standard | Controls visibility of dimensions in specific view configurations (e.g., Plan, Framing). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate dimensions | Refreshes all dimension lines based on the current geometry and property settings. |

## Settings Files
- **Dependent TSL**: `HSB_D-Aligned`
- **Purpose**: This script acts as a master controller that spawns instances of `HSB_D-Aligned` to draw the individual dimension lines. Ensure this script is present in your TSL catalog path.

## Tips
- **Net vs. Structural Dimensions**: Use the `UseElementOutlineAsFrameOutline` property to toggle between measuring to the outer cladding (finished size) and the structural timber centerlines/surfaces.
- **Grid Snapping**: If your dimensions look messy or stop short of the grid, verify the `GridTolerance` value. If the grid is further than this distance from the wall, the script will ignore the grid line.
- **Updating Dimensions**: You can change offsets or text styles via the Properties Palette (Ctrl+1) after insertion. The script will automatically erase old lines and generate new ones upon updating a property.

## FAQ
- **Q: Why did the script run but no dimensions appeared?**
  - A: Ensure you selected a valid `FloorGroupName` that actually contains elements or beams. Also, check if the `HSB_D-Aligned` TSL is available in your catalog.
- **Q: How do I move the dimension lines?**
  - A: Do not move the script insertion point to move dimensions. Instead, change the `OffsetDimensionLines` property to move the entire stack closer or further from the building.
- **Q: Can I dimension multiple floors at once?**
  - A: No, one instance of `HSB_D-Plan` dimensions one specific Floor Group. Insert multiple instances (one per floor) if needed.
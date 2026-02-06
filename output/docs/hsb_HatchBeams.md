# hsb_HatchBeams

## Overview
This script applies hatch patterns (shading) to timber beams in 2D Paper Space layouts or generated Shop Drawings. It allows users to visually distinguish specific material types, zones, or beam layers using customizable patterns, scales, and colors.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script generates 2D geometry for drawings only. |
| Paper Space | Yes | User selects a Viewport to apply hatching. |
| Shop Drawing | Yes | User selects a ShopDrawView entity for automatic generation. |

## Prerequisites
- **Required Entities**: A Viewport (in Paper Space) or a ShopDrawView entity (in Shop Drawings).
- **Minimum Beams**: At least one beam must be present in the selected view/zone.
- **Required Settings**: The script `HSB_G-FilterGenBeams` must be loaded in the drawing if you wish to use the "Filter definition" property.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Select `hsb_HatchBeams.mcr` from the file dialog.

### Step 2: Configure Initial Settings
1.  The Properties Palette will appear.
2.  Set the **Drawing space** property to your target environment:
    *   `|paper space|` for manual detailing on layouts.
    *   `|shopdraw multipage|` for automated drawing generation.
3.  Adjust **Hatch pattern**, **Angle**, and **Scale** as needed.

### Step 3: Select Context
1.  Look at the command line.
2.  **If in Paper Space**:
    *   Prompt: `Select Viewport:`
    *   Action: Click on the viewport border where you want the hatching to appear.
3.  **If in Shopdraw Multipage**:
    *   Prompt: `Select ShopDrawView:`
    *   Action: Click on the ShopDrawView entity (typically the view label or representation in the model).

### Step 4: Refine Filters (Optional)
1.  After insertion, select the script instance in the drawing.
2.  In the Properties Palette, modify **Hatch Only Beams with Code** (e.g., `TP;BP;`) to target specific beam types.
3.  Modify **Zone to hatch** (`nZones`) to target a specific layer index if dealing with a wall or floor element.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone to hatch | Number | 2 | Index of the construction layer to hatch (e.g., specific wall layer). |
| Location in zone | Dropdown | All | Determines how the profile is calculated: `All` (full projection), `Front`, or `Back` (skin only). |
| Hatch Only Beams with Code | String | TP;BP; | Filters beams by their short codes (e.g., Top Plate, Bottom Plate). Use semi-colons to separate. |
| Hatch Only Beams with Name | String | | Filters beams by their full Name property. |
| Filter definition | Catalog | | Links to an external advanced filter (`HSB_G-FilterGenBeams`) for complex selection logic. |
| Hatch pattern | Pattern | _HatchPatterns | Visual pattern style for standard beams. |
| Angle | Number | 45 | Rotation angle of the hatch pattern (degrees). |
| Hatch Scale | Number | 1 | Density/spacing of the hatch pattern. |
| Color Hatch | Number | 1 | Color index of the hatch for standard beams. |
| Hatch pattern SPline | Pattern | _HatchPatterns | Visual pattern style specifically for curved beams (Splines). |
| Angle SPline | Number | 45 | Rotation angle for spline hatches. |
| Hatch Scale SPline | Number | 1 | Density for spline hatches. |
| Color Hatch SPline | Number | 1 | Color index for spline hatches. |
| Drawing space | Dropdown | \|paper space\| | Sets the target environment (`|paper space|` or `|shopdraw multipage|`). |
| Default colour should be beam colour | Dropdown | No | If `Yes`, overrides the hatch color settings with the beam's native entity color. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Update / Refresh | Recalculates and redraws the hatches based on current beam geometry and script properties. (Note: Properties changes also trigger automatic updates). |

## Settings Files
- **Script**: `HSB_G-FilterGenBeams`
- **Purpose**: Provides advanced filtering capabilities. If you define a "Filter definition" in the properties, ensure this script is loaded in the drawing.

## Tips
- **Skin Hatching**: Use `Location in zone` set to `Front` or `Back` to hatch only the outer skin of a wall (e.g., for sheathing or cladding representation) rather than the full cross-section.
- **Curved Walls**: The script automatically detects "Spline" beams. Use the `...SPline` properties to give curved walls a different hatch style than straight walls.
- **Layer Isolation**: If hatches appear in the wrong location, check the `Zone to hatch` index. Increasing or decreasing this number shifts the layer selection within the element.

## FAQ
- **Q: Why did the hatch not appear?**
  - **A**: Ensure you selected a valid Viewport or ShopDrawView. Check if the `Zone to hatch` index actually contains beams, or if your `Hatch Only Beams with Code` filter is excluding all beams.
- **Q: Can I hatch different wall layers with different patterns?**
  - **A**: Yes. Insert the script multiple times. Set one instance to `Zone to hatch` = 1 with Pattern A, and a second instance to `Zone to hatch` = 2 with Pattern B.
- **Q: What does the error "Beams could not be filtered!" mean?**
  - **A**: This means you have selected a `Filter definition`, but the required TSL script `HSB_G-FilterGenBeams` is not loaded in your drawing. Load the script to fix this.
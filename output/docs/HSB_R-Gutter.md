# HSB_R-Gutter.mcr

## Overview
This script generates structural timber gutter laths (box gutters) based on a selected 2D polyline outline and a specified drain position. It automatically calculates and applies sloped cuts to the timber beams to ensure correct water flow towards the drain.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script creates 3D beams and visual markers. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: A Polyline representing the gutter outline.
- **Minimum Beam Count**: None.
- **Required Settings Files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_R-Gutter.mcr`

### Step 2: Select Gutter Outline
```
Command Line: |Select the gutter|
Action: Click on the Polyline that defines the shape of the gutter area.
```

### Step 3: Position Drain
```
Command Line: |Select the position of the drain.|
Action: Click a point in the model where the rainwater pipe (drain) is located. This point determines the direction and start of the slope calculation.
```

### Step 4: Configure Properties (Optional)
If you are inserting the script manually (not from a catalog), a dialog box may appear allowing you to adjust the slope, dimensions, and group assignment before generation.

## Properties Panel Parameters

### Gutter
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Assign gutter to group | dropdown | - | Sets the group (e.g., Roof, Floor) to assign the generated entities to. |
| Slope [%] | number | 1 | Sets the pitch or fall of the gutter towards the drain. |
| Reference height | number | 0 | Sets the vertical Z-height (elevation) for the gutter geometry. |

### Gutter laths
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Start height | number | 20 mm | The height (thickness) of the timber lath at the lowest point (near the drain). |
| Width | number | 48 mm | The width (depth) of the timber plank used for the gutter wall. |
| Offset from drain | number | 150 mm | The distance from the center of the drain to the start of the timber laths. |
| Minimum length | number | 150 mm | The shortest allowable length for a gutter lath segment. (Shorter segments are skipped). |
| Offset from selected area | number | 5 mm | Sets the inset distance from the selected polyline to the inner edge of the gutter. |
| Color gutter laths | number | 5 | The display color (AutoCAD Index) for the generated laths. |

### Drain
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Color drain | number | 5 | The display color for the drain marker. |
| Diameter drain | number | 80 mm | The visual diameter of the drain circle drawn in the model. |
| Description | text | RWP | Text label for the drain (e.g., "RWP"). |
| Dimension style | dropdown | _DimStyles | The dimensioning style used for the drain label. |
| Text size | number | -1 mm | The height of the text label. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| (None) | This script does not define custom context menu items. Use the Properties Palette to modify parameters and trigger recalculation. |

## Settings Files
No external settings files are required for this script.

## Tips
- **Lath Visibility**: If the gutter laths do not appear on one side of the drain, check if the distance from the drain to the gutter edge is greater than the **Offset from drain** + **Minimum length**.
- **Slope Calculation**: The script calculates the height of the lath at the far end based on the **Start height**, the length of the gutter, and the **Slope [%]**. Increase the slope percentage if water flow is a concern.
- **Grouping**: Use the **Assign gutter to group** property immediately after insertion to ensure the generated beams appear in the correct Lists/Exports.

## FAQ
- **Q: Why does the script show "Extremes cannot be calculated for this gutter!"?**
  A: This usually happens if the selected polyline is irregular (e.g., self-intersecting or a circle) or if the drain point is placed in a geometrically ambiguous location relative to the polyline segments. Try using a rectangular polyline.
- **Q: How do I change the location of the drain after insertion?**
  A: You cannot directly grip-edit the drain point in the standard version of this script behavior (depending on specific hsbCAD version constraints), but you can erase the instance and re-insert it, or modify the properties if the drain point was mapped to a grip.
- **Q: Can I use a curved polyline for the gutter?**
  A: The script is primarily designed for linear gutters where "Start" and "End" sides can be clearly determined relative to the drain. Complex curves may result in unexpected behavior.
# HSB_D-SheetOpening.mcr

## Overview
Automatically creates dimension lines for openings (windows, doors, and cutouts) in wall sheets or panels within a shop drawing viewport.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed for layouts. |
| Paper Space | Yes | This script must be run in a Layout tab. |
| Shop Drawing | Yes | Requires a viewport containing an Element. |

## Prerequisites
- **Required Entities**: An existing Layout with a Viewport displaying an Element (e.g., a Wall or Floor).
- **Openings**: The selected Element must contain tools (cutouts/openings) within its sheet layers.
- **Minimum Beam Count**: 0.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_D-SheetOpening.mcr`

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click inside the viewport that shows the wall/element you want to dimension.
```

### Step 3: Select Position
```
Command Line: Select a position
Action: Click in the drawing area to define where the dimension line will be placed (e.g., above or below the wall).
```

## Properties Panel Parameters

### Selection
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone | Number | 1 | Selects the specific layer index (1-10) of the element build-up to analyze for openings. |
| Merge sheets | Dropdown | No | If 'Yes', treats multiple adjacent sheets as a single profile. If 'No', dimensions sheets individually. |
| Merge sheets with gap | Number | 10.0 | The maximum gap width (mm) to ignore when merging adjacent sheets. |

### Filter
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Filter beams with beamcode | Text | | Excludes beams matching this Beam Code from extent calculations. |
| Filter beams and sheets with label | Text | | Excludes entities matching this Label. |
| Filter beams and sheets with material | Text | | Excludes entities made of this Material. |
| Filter beams and sheets with hsbID | Text | | Excludes entities with this specific hsbCAD ID. |
| Filter zones | Text | | Excludes entities belonging to specific zones. |

### Positioning
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Position | Dropdown | Horizontal top | Sets where the dimension line is placed (Horizontal top/bottom, Vertical left/right). |
| Dimension per opening | Dropdown | No | If 'Yes', creates a dimension for every opening. If 'No', creates one chain dimension for all openings. |
| Offset in paperspace units | Dropdown | No | If 'Yes', the offset distance is fixed on the printed paper. If 'No', it scales with the viewport. |
| Offset | Number | 6.0 | Distance between the object geometry and the dimension line. |

### Style
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension style | Dropdown | [System] | Selects the visual style (arrows, text) for the dimensions. |
| Color | Number | 1 | AutoCAD color index for the dimension lines (e.g., 1 = Red, 7 = White/Black). |
| Default name color | Number | -1 | Color index for the script instance name display. |
| Filter other element color | Number | 30 | Color used to indicate the script is filtered out relative to other elements. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the dimensions to reflect changes in the model or property settings. |

## Settings Files
No specific settings files are required for this script.

## Tips
- **Composite Walls**: If dimensioning a wall made of multiple narrow boards, set **Merge sheets** to "Yes" to create a clean dimension line across the entire aggregate opening, rather than broken lines for every board joint.
- **Consistent Plotting**: Enable **Offset in paperspace units** if you want the dimension line to maintain the exact same distance from the wall on paper, regardless of the Viewport scale (e.g., 1:50 vs 1:100).
- **Troubleshooting**: If dimensions do not appear, check the **Zone** property. It must match the specific layer of the wall that contains the openings.

## FAQ
- **Q: Why are my dimensions appearing in the middle of the wall instead of the edge?**
  A: Check the **Position** property. It might be set to "Vertical" when you need "Horizontal", or the reference point selected during insertion was interpreted differently than expected.
- **Q: What does "Merge sheets with gap" do?**
  A: It allows the script to ignore small joints (e.g., 10mm gaps between OSB boards) so it treats the surface as one solid sheet for dimensioning purposes.
- **Q: Can I dimension openings in the inner layer of a cavity wall?**
  A: Yes. Change the **Zone** property to match the index number of the inner layer sheet.
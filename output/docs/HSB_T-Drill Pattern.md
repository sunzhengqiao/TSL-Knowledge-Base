# HSB_T-Drill Pattern.mcr

## Overview
This script automates the creation of through-holes (drills) and counterbores along timber beams. It is designed for ventilation or service holes and supports patterns like parallel rows, zig-zag, or center line placement with automatic spacing calculations.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates exclusively in the 3D model environment. |
| Paper Space | No | Not intended for layout or detailing views. |
| Shop Drawing | No | This script creates physical tooling (Drills), not 2D annotations for drawings. |

## Prerequisites
- **Required entities**: One or more Timber Beams (GenBeam).
- **Minimum beam count**: 1.
- **Required settings**: None (uses internal property defaults).

## Usage Steps

### Step 1: Launch Script
Run the `TSLINSERT` command in AutoCAD and select `HSB_T-Drill Pattern.mcr` from the list.

### Step 2: Configure Properties
Upon launch, a Properties Dialog will appear.
- **Action**: Set the desired drill diameter, offsets, and distribution pattern (e.g., "Zig-zag"). Click **OK** to confirm.

### Step 3: Select Beams
```
Command Line: Select one or more beams
Action: Click on the beam(s) in the model where you want the drill pattern applied. Press Enter to finish selection.
```

### Step 4: Completion
The script calculates the positions based on the beam length and settings, adds the drill operations to the beams, and displays a 2D symbol indicating the hole locations.

## Properties Panel Parameters

### Orientation
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Swap side | Dropdown | No | Swaps the Width (Y) and Height (Z) axes. Use this to move the drill pattern from the side faces to the top/bottom faces. |
| Flip | Dropdown | No | Mirrors the drill pattern to the opposite side of the reference face (e.g., Top to Bottom). |

### Start positions
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Y-offset front | Number | 30 mm | Distance from the beam's side edge to the center of the first row of drills. |
| X-offset front | Number | 85 mm | Longitudinal distance from the beam's start (left) end to the center of the first drill. |
| Y-offset back | Number | 30 mm | Distance from the opposite side edge to the center of the second row (if applicable). |
| X-offset back | Number | 35 mm | Longitudinal distance from the beam's end (right) end to the center of the last drill. |

### Distribution
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Maximum Spacing | Number | 600 mm | Maximum allowable center-to-center distance. The script automatically adjusts this to fit an even number of holes. |
| Distribution pattern | Dropdown | Front and back | Determines layout: <br>• *Front and back*: Two parallel lines.<br>• *Zig-zag*: Alternating lines.<br>• *Centre line*: Single line through the beam center. |

### Drill & sinkhole
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Drill Diameter | Number | 14 mm | Diameter of the through-hole. |
| Diam Sinkhole | Number | 40 mm | Diameter of the counterbore (recess) at the drill entry. Set to 0 to disable. |
| Depth Sinkhole | Number | 15 mm | Depth of the counterbore. |

### Symbol
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Symbol Size | Number | 50 mm | Scale of the 2D visual annotation in plan view. |

## Right-Click Menu Options
No custom context menu items are defined for this script. Use the AutoCAD Properties Palette to modify parameters.

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: All configuration is handled via the Properties Palette/Dialog.

## Tips
- **Automatic Spacing**: If you set the Maximum Spacing to 600mm, but the beam length allows for a spacing of 580mm to fit perfectly, the script will use 580mm.
- **Zig-Zag Pattern**: When using "Zig-zag", holes are placed at both the Front and Back positions at the very start and very end of the beam to ensure stability.
- **Dynamic Updates**: If you stretch or change the length of the beam after insertion, the drill pattern will automatically recalculate to maintain the correct spacing and distribution.
- **Center Line Mode**: Selecting "Centre line" for the Distribution pattern ignores the Y-offsets and places holes exactly in the middle of the beam, regardless of "Swap side" settings.

## FAQ
- **Q: Why are my holes not exactly 600mm apart?**
  **A:** The script prioritizes even distribution between the start and end points. The actual spacing will be equal to or less than the "Maximum Spacing" value to ensure the holes fit perfectly within the specified range.
- **Q: How do I drill through the top of the beam instead of the side?**
  **A:** Set the "Swap side" property to "Yes". This exchanges the beam's width and height axes for the drill calculation.
- **Q: Can I use this for a single hole?**
  **A:** Yes. Set the "Distribution pattern" to "Centre line" or set the X-offsets (Front and Back) to be very close together, effectively creating a single hole (or a pair) at a specific location.
# HSB_E-MarkerlinesVerticalBeams.mcr

## Overview
This script creates marker lines on specific zones of floor or roof elements to indicate the positions of intersecting vertical beams (such as wall studs or columns). It is typically used for manufacturing alignment or to mark drilling points on horizontal panels.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script interacts with 3D Element and Beam entities. |
| Paper Space | No | This script operates on the model geometry, not 2D views. |
| Shop Drawing | No | Tooling is applied directly to the element in the model. |

## Prerequisites
- **Required entities**: An Element (Floor, Roof, or Wall) that intersects with vertical beams.
- **Minimum beam count**: 0.
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `HSB_E-MarkerlinesVerticalBeams.mcr`.

### Step 2: Select Elements
```
Command Line: Select a set of elements
Action: Click on the Floor or Roof elements in the model where you want to mark the vertical beam locations. Press Enter to confirm selection.
```

### Step 3: Adjust Properties (Optional)
If the results are not as expected, select the Element, find the TSL instance in the Project Manager or Properties Palette, and adjust the parameters (see below). Run **Recalculate** to update.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Selection** | *separator* | | |
| Apply tooling to element type(s) | dropdown | Roof | Filters which elements are processed. Options include Roof, Floor, Wall, or combinations (e.g., "Roof;Floor"). |
| Only mark beams with beamcode | text | | Filters vertical beams by their Beam Code. Leave empty to mark all vertical beams. Use semicolons to separate multiple codes (e.g., "Stud;Post"). |
| **Tooling** | *separator* | | |
| Length markerline | number | 300.0 | Sets the visible length of the marker line (in mm). |
| Apply tooling to | dropdown | Zone 1 | Selects the specific material zone (layer) on which to draw the markers (e.g., Top surface, Bottom surface). |
| Toolindex | number | 10 | Defines the tooling number used for CAM/CNC export and determines the visual style (color/layer) in CAD. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None specific) | No custom context menu items are defined. Standard hsbCAD options (Recalculate, Erase) apply when selecting the script instance. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Beam Filtering**: If your roof has many small members (like purlins) intersecting, use the "Only mark beams with beamcode" property to target only major structural members (like walls or columns).
- **Visual Overlap**: If beams are very close together, reduce the "Length markerline" value to prevent the lines from overlapping and becoming unreadable.
- **Element Type**: Ensure "Apply tooling to element type(s)" matches the elements you selected. If you select a Floor but the property is set only to "Roof", no markers will appear.

## FAQ
- **Q: I ran the script, but no lines appeared.**
  - A: Check the "Apply tooling to element type(s)" property. If you selected a Wall but the property is set to "Roof", it will not process. Also, ensure the beams intersecting the element are actually vertical relative to that element.
- **Q: Can I mark beams on the bottom surface of a floor?**
  - A: Yes. Change the "Apply tooling to" property to the Zone number that corresponds to the bottom surface or sheathing layer of your floor element.
- **Q: How do I change the color of the lines?**
  - A: You cannot change the color directly in this script. The color is determined by the "Toolindex". You must modify the layer or tool style associated with that Tool Index in your hsbCAD or AutoCAD configuration.
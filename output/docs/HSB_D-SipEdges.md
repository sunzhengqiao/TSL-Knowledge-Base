# HSB_D-SipEdges.mcr

## Overview
This script automates the annotation of Structural Insulated Panels (SIPs) by calculating and displaying bevel angles along panel edges and intersection angles at corners within 2D PaperSpace viewports.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is intended for 2D drawings only. |
| Paper Space | Yes | The script must be inserted into a layout tab containing a viewport of the model. |
| Shop Drawing | Yes | Used for creating production drawings showing precise cut angles. |

## Prerequisites
- **Required Entities:** An `ElementRoof` containing valid **SIP** (Structural Insulated Panel) data.
- **Minimum Beam Count:** 0 (This script relies on Element/SIP geometry, not beams).
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `HSB_D-SipEdges.mcr` from the script list.

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the viewport in PaperSpace that displays the Roof Element you wish to annotate.
```
Note: The script will automatically detect if the viewport contains valid Roof/SIP data. If no data is found, the script will exit silently.

### Step 3: Adjust Settings
Action: Select the inserted script object in PaperSpace. Open the **Properties Palette** (Ctrl+1) to toggle visibility, change precision, or adjust text locations.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Show edge angles** | Dropdown | Yes | Toggles the visibility of the bevel angles along the SIP edges. |
| **Show corners** | Dropdown | Yes | Toggles the visibility of the angles at the intersections (corners) of the SIP edges. |
| **Round off edge angles** | Dropdown | No | If set to **Yes**, edge angles are rounded to whole integers (e.g., 27°). If **No**, decimals are shown (e.g., 26.57°). |
| **Round off corners angles** | Dropdown | No | If set to **Yes**, corner angles are rounded to whole integers. |
| **Switch direction** | Dropdown | Yes | Reverses the sign of the edge angle (Clockwise vs. Counter-Clockwise) to match specific machinery standards. |
| **Offset from edge** | Number | 10 mm | Sets the distance from the physical edge of the panel to the center of the edge angle text. |
| **Offset from corner** | Number | 5 mm | Sets the distance from the corner vertex to the center of the corner angle text. |
| **Angle color** | Integer | 1 | Sets the AutoCAD color index for the edge angle text. |
| **Corner color** | Integer | 1 | Sets the AutoCAD color index for the corner angle text. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Erase** | Removes the script and all associated annotations from the drawing. |
| **Recalculate** | Refreshes the annotations based on the current geometry and property settings. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Cluttered Drawing?** If the angles overlap with other dimensions, increase the **Offset from edge** or **Offset from corner** values in the Properties palette.
- **Visual Distinction:** Change the **Angle color** to a different color (e.g., Red or Magenta) so production crews can easily differentiate angle annotations from standard dimensions.
- **Precision Control:** Use the **Round off...** options to simplify the drawing for manufacturing if decimal precision is not required.

## FAQ
- **Q: I inserted the script but nothing happened.**
  - A: Ensure the selected viewport contains a generated Roof Element with valid SIP data. The script will not run on empty viewports or standard beams without SIP information.
- **Q: How do I hide the corner angles but keep the edge angles?**
  - A: Select the script object, open the Properties Palette, and change **Show corners** to "No".
- **Q: The angle sign is wrong for my machinery (positive instead of negative).**
  - A: Use the **Switch direction** property in the Properties Palette to invert the sign of the calculated angles.
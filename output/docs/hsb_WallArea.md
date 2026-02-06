# hsb_WallArea.mcr

## Overview
This script calculates the net surface area (in square meters) of a wall element and annotates the result on your drawing layout. It automatically subtracts the area of openings (windows and doors) from the total wall surface to provide an accurate material or cladding area.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed for 2D Layouts. |
| Paper Space | Yes | This script must be run in a Layout tab. |
| Shop Drawing | No | It is used for annotating layouts, not generating shop drawings. |

## Prerequisites
- **Required Entities:** A Layout tab containing a **Viewport** that is currently displaying a 3D Wall **Element**.
- **Minimum Beam Count:** The Element must contain at least one beam (GenBeam).
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Select `hsb_WallArea.mcr` from the file list.

### Step 2: Select Insertion Point
```
Command Line: Select Point for insert
Action: Click in the Paper Space layout where you want the area label to appear.
```

### Step 3: Select Viewport
```
Command Line: Select the viewport
Action: Click on the viewport frame that displays the wall element you wish to measure.
```
*Note: The script will automatically calculate the area based on the element shown in that viewport and display the text label.*

## Properties Panel Parameters

Once the script is inserted, select the text label and open the **Properties** palette (Ctrl+1) to adjust the following settings:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Set Dimstyle | dropdown | _DimStyles | Select the Dimension Style to control the text height, font, and appearance of the area label. |
| Enter Colour | number | -1 | Sets the color of the text. Enter `-1` to use the current Layer's color (ByLayer), or enter a number from 0-255 for a specific AutoCAD Color Index. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add custom options to the right-click context menu. |

## Settings Files
No external settings files are required for this script.

## Tips
- **Changing Text Size:** To change the size of the text, do not scale the object. Instead, select the label, open the **Properties** palette, and change the **Set Dimstyle** property to a dimension style with a different text height.
- **Moving the Label:** You can click and drag the text label to reposition it anywhere on the layout without affecting the calculation.
- **Geometry Accuracy:** The script uses the shadow profiles of the wall beams. If beams overlap significantly, the script has a built-in fallback to calculate area using the Element's bounding box minus openings.

## FAQ
- **Q: Does the area include windows and doors?**
  - **A:** No. The script calculates the "Net Area" by subtracting the area of any openings found in the element from the gross wall surface.
- **Q: Why is my text the wrong color?**
  - **A:** Check the **Enter Colour** property in the Properties palette. If it is set to a specific number (e.g., 1 for Red), it overrides the layer color. Set it to `-1` to make it follow the layer color.
- **Q: Can I update the area if I modify the wall?**
  - **A:** Yes. The script links to the element. If you change the wall length or add/remove openings in the model, update the viewport, and the script will recalculate the area automatically.
# hsb_DimemsionAngleStuds

## Overview
This script automatically generates angle dimensions in Paper Space for the left and right end studs of a wall. It is specifically designed to annotate the cut angle of gable ends, raked walls, or any wall where the vertical studs are not perfectly rectangular.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script does not operate in Model Space. |
| Paper Space | Yes | Dimensions are drawn directly onto the Layout. |
| Shop Drawing | Yes | Used for 2D detailing and annotation. |

## Prerequisites
- **Required Entities**: A Layout Viewport displaying a valid hsbCAD Element (e.g., a wall).
- **Minimum Beam Count**: The element must contain at least one beam.
- **Required Settings**: None. However, an AutoCAD Dimension Style must exist in the drawing to format the text correctly.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `hsb_DimemsionAngleStuds.mcr` from the script list.

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the border of the layout viewport that displays the wall you wish to annotate.
```
**Note:** The script will automatically analyze the wall shown in that viewport.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension Style | dropdown | _DimStyles | Selects the CAD Dimension Style (e.g., Standard, ISO-25) to control text font, height, and arrow style for the angle. |
| Color | number | 5 | Sets the AutoCAD Color Index for the dimension lines and text (Default 5 is Blue). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are available for this script. |

## Settings Files
- **None**: This script does not use external settings files.

## Tips
- **Vertical Walls**: If the wall end studs are perfectly vertical (90°), the script will not draw a dimension for that side, as there is no angle to mark.
- **Dimension Precision**: To change how many decimal places are shown (e.g., 90.00° vs 90°), change the Dimension Style property to a style configured with your desired precision, or modify the style in the Dimension Style Manager.
- **Viewport Orientation**: Ensure your viewport is oriented correctly before running the script, as the dimensions are placed based on the view direction.

## FAQ
- **Q: Why did the script not draw anything?**
  A: The script only draws dimensions if the left or right studs are angled. If the wall is rectangular, or if the selected viewport does not contain a valid hsbCAD element, no dimensions will appear.
- **Q: Can I change the color of the dimensions after inserting?**
  A: Yes. Select the script instance in the drawing and change the "Color" property in the Properties palette.
- **Q: Where do the dimensions appear?**
  A: The dimensions are created directly in Paper Space (on your Layout), not in the Model Space view.
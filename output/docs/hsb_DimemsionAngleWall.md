# hsb_DimemsionAngleWall.mcr

## Overview
Automatically generates roof pitch angle dimensions for angled top plate walls directly in Paper Space. It annotates the angle between the wall surface and the horizontal floor joist direction.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed for layout generation. |
| Paper Space | Yes | Must be run on a layout containing a viewport of an hsbCAD model. |
| Shop Drawing | N/A | Used in general layout drawings. |

## Prerequisites
- **Required Entities**: A viewport showing an hsbCAD Element (Model) containing Angled Top Plate beams.
- **Minimum Beam Count**: At least one "Angled Top Plate" (Left or Right type) must exist in the model.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_DimemsionAngleWall.mcr` from the list.

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the viewport frame in Paper Space that displays the wall you wish to dimension.
```

### Step 3: Configure Properties
```
Action: The Properties Palette will appear automatically.
Action: Adjust the Dimension Style, Color, or Offset as needed.
Action: Close the Properties Palette or click elsewhere in the drawing to generate the dimensions.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension Style | Dropdown | _DimStyles | Selects the CAD dimension style to control text font, size, and arrowheads for the angle annotation. |
| Color | Number | 5 | Sets the AutoCAD Color Index (ACI) for the dimension lines and text. Default is Blue (5). |
| Offset DimLine | Number | 100 | Sets the distance (in mm) from the wall surface to the dimension arc. |
| | | | |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are available for this script. Use the Properties Palette to make changes. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Viewport Validity**: Ensure the viewport you select is active and linked to a valid hsbCAD model. If the script runs but produces no output, check if the model actually contains "Angled Top Plate" beams.
- **Finding Walls**: The script automatically identifies the furthest left and furthest right angled walls in the model to place the dimensions.
- **Updating**: If you modify the wall pitch in the model, you can select the script entity and change a property (e.g., nudge the Offset) to force a refresh/recalculation of the angle.

## FAQ
- **Q: Why did nothing appear when I ran the script?**
  **A:** The script only works on "Angled Top Plate" beams. If your walls are vertical or use a different subtype, the script will not find geometry to dimension. Also, ensure the selected viewport actually contains an Element.
- **Q: How do I change the text size of the angle?**
  **A:** You cannot change the text size directly in this script's properties. Instead, change the `Dimension Style` property to a style that uses your desired text height and font settings.
- **Q: Can I move the dimension arc?**
  **A:** Yes. Select the generated dimension object in Paper Space and modify the `Offset DimLine` value in the Properties Palette to move the arc closer or further from the wall.
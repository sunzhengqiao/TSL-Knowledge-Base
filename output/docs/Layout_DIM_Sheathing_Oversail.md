# Layout_DIM_Sheathing_Oversail.mcr

## Overview
Automates the dimensioning of sheathing oversails in Paper Space layout views. It calculates and draws dimensions indicating how much sheathing material extends past the timber frame structure based on a selected viewport.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script operates in Layout tabs. |
| Paper Space | Yes | This is the primary environment for the script. |
| Shop Drawing | Yes | Used to annotate overhang details in production drawings. |

## Prerequisites
- **Required Entities**: An hsbCAD Element (e.g., Wall or Floor) containing both structural beams and sheathing sheets.
- **Minimum Beam Count**: 1 (Though typically a frame with multiple beams is required to define a boundary).
- **Required Settings**: A Paper Space Layout with an active Viewport that is linked to the Model Space Element.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Layout_DIM_Sheathing_Oversail.mcr`

### Step 2: Specify Insertion Point
```
Command Line: (Prompts for point)
Action: Click anywhere in the Paper Space layout to define the script anchor point.
```

### Step 3: Select Viewport
```
Command Line: Select a viewport, you can add others later on with the HSB_LINKTOOLS command.
Action: Click the edge or inside of the viewport that displays the 3D model you wish to dimension.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Direction | dropdown | Horizontal | Sets the orientation of the dimension line (Horizontal or Vertical relative to the element). |
| Zone index | dropdown | 1 | Selects the construction zone (layer) containing the sheathing sheets to measure (-5 to 5). |
| Dimension Style | dropdown | (Current) | Selects the AutoCAD Dimension Style to control text height and arrow appearance. |
| Side of delta dimensioning | dropdown | Above | Positions the dimension text either "Above" or "Below" the dimension line. |
| Offset From Element | number | 150 mm | Sets the distance between the timber frame and the dimension line in Paper Space. |
| Delta text direction | dropdown | None | Rotates the dimension text (None, Parallel, or Perpendicular to the line). |
| Color | number | 1 | Sets the AutoCAD color index for the dimension lines and text. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | This script does not add custom items to the right-click context menu. Use the Properties Panel to modify settings. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external XML settings files.

## Tips
- **Missing Dimensions?**: If dimensions do not appear, verify that the **Zone index** matches the zone where your sheathing is applied, and ensure the sheathing actually extends past the frame by more than 1mm.
- **Cluttered Drawings**: Use the **Offset From Element** property to move dimension lines away from dense structural details.
- **Quick Orientation**: Switch between **Horizontal** and **Vertical** directions to quickly document oversails on different sides of the wall or floor.

## FAQ
- Q: Why are my dimensions showing the wrong scale?
- A: Ensure the **Dimension Style** selected in the properties matches the scale of your viewport and drawing standards.
- Q: Can I dimension multiple walls with one script instance?
- A: No, one script instance is linked to a specific viewport and element. Insert the script again for additional elements or viewports.
- Q: The script places dimensions in the wrong location.
- A: Check the **Direction** property. If set to Horizontal, it measures along the element's X-axis. Change to Vertical to measure along the Y-axis.
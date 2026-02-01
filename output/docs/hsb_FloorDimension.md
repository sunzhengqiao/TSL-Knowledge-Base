# hsb_FloorDimension.mcr

## Overview
This script automates the generation of 2D architectural dimensions for floor layouts in Paper Space. It calculates and draws dimensions for joists, floor beams, and trusses based on the projection of a selected Viewport.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | Dimensions are created specifically for Layout views. |
| Paper Space | Yes | Script must be run in a Layout tab containing a Viewport. |
| Shop Drawing | No | This is a detailing tool for layout plans. |

## Prerequisites
- **Required Entities**: A Layout (Paper Space) with an active Viewport displaying a hsbCAD Floor Element.
- **Beams**: The element must contain structural members (Joists, Floor Beams, or Trusses) to dimension.
- **Minimum Beam Count**: 0 (Script handles empty layouts gracefully).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_FloorDimension.mcr` from the list.

### Step 2: Configure Initial Settings (Optional)
A dialog may appear allowing you to pre-configure the dimension style and offsets.
Action: Adjust settings if necessary and click **OK**.

### Step 3: Select Viewport
```
Command Line: Select the viewport from which the element is taken
Action: Click on the Viewport in Paper Space that displays the floor plan you wish to dimension.
```

### Step 4: Review Results
The script automatically processes the visible beams and draws dimension lines in Paper Space.

### Step 5: Adjust (Optional)
Select the generated dimension entity and open the **Properties Palette** (Ctrl+1) to fine-tune offsets or toggle specific dimension layers (e.g., turning on Overall dimensions).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension Style | dropdown | _DimStyles | Selects the visual style (arrows, text size, scale) for dimensions. |
| Offset From Element | number | U(150, 8) | The gap distance between the floor element outline and the first dimension line. |
| Offset Between Lines | number | U(150, 8) | The vertical spacing between parallel dimension lines (e.g., between joists and overall dims). |
| Show OverAll Dimension | dropdown | No | Toggles the display of the total width/length dimension of the floor. |
| Show OverAll Shape Dimension | dropdown | No | Toggles dimensions for the internal shape or steps of the floor (vertices, setbacks). |
| Show Beams Dimension | dropdown | No | Toggles the dimensioning of individual joists, floor beams, or trusses. |
| Beams Dimension Type | dropdown | Delta | **Delta**: Shows center-to-center spacing. <br> **Cumulative**: Shows running distance from the start. |
| Joist Dimension Side | dropdown | Left | Determines where the dimension extension line originates: Start, End, Center, or Both sides of the beam. |
| Color | number | 1 | Sets the AutoCAD Color Index (ACI) for the dimension entities. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None defined* | Standard hsbCAD context options apply. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: This script relies on standard AutoCAD/hsbCAD Dimension Styles present in the drawing rather than external XML files.

## Tips
- **Layout Clarity**: If your floor plan is complex, increase the "Offset Between Lines" value to prevent text overlap.
- **Truss Handling**: This script detects Trusses and calculates their shadow profile for accurate dimensioning, treating them as solid elements for the overall boundary.
- **Delta vs. Cumulative**: Use "Delta" for manufacturing or spacing checks (e.g., "600mm o.c.") and "Cumulative" for installation positioning (e.g., "600", "1200", "1800").

## FAQ
- **Q: I selected the viewport, but no dimensions appeared.**
  A: Ensure the Viewport is linked to a valid hsbCAD Element that contains beams (Joists, Floor Beams). If the element is empty or the script cannot find the coordinate system, it will exit silently.
- **Q: How do I change the arrow style or text height of the dimensions?**
  A: Do not change this in the script properties. Instead, select the desired "Dimension Style" in the properties palette that matches your CAD standards (e.g., "_DimStyles" or a custom style defined in your template).
- **Q: The dimensions are appearing on top of my drawing.**
  A: Increase the "Offset From Element" property to push the dimension chain further away from the floor outline.
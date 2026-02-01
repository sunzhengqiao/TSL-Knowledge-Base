# HSB-DimensionFloor.mcr

## Overview
This script automates the creation of detailed floor dimensions in Paper Space layouts. It calculates and annotates joist spacing, opening locations, and overall floor lengths based on the 3D model geometry.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | Script operates on Layouts. |
| Paper Space | Yes | Dimensions are drawn directly in the Layout. |
| Shop Drawing | Yes | Designed for production floor plans. |

## Prerequisites
- **Required Entities**: A Layout (Paper Space) containing a Viewport that displays an hsbCAD Element (Floor).
- **Minimum Beam Count**: 1 (Usually a floor consisting of multiple joists/beams).
- **Required Settings**: Valid hsbCAD Dimension Styles must exist in the drawing to control text size and arrowheads.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse to and select `HSB-DimensionFloor.mcr`.

### Step 2: Select Viewport
```
Command Line: Select a viewport.
Action: Click on the viewport frame in your Layout that displays the floor plan you wish to dimension.
```

### Step 3: Configure Properties
1. The Properties Palette (or default dialog) will appear automatically.
2. Adjust the dimension offsets or layout style if needed.
3. Close the dialog or press Enter to place the script.

### Step 4: Automatic Update
The script will immediately calculate the floor geometry and draw the dimensions in Paper Space. If you change the 3D model (e.g., move a joist), right-click the dimension script and select **Recalculate** to update the annotations.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Distance dimension line to element | Number | 300 mm | Sets the gap between the floor edge and the first dimension line. |
| Distance between dimlines | Number | 200 mm | Controls the vertical spacing between stacked dimension lines. |
| Distance text | Number | 100 mm | Sets the offset distance for text labels (e.g., "Total length") from the dimension line. |
| Dimension layout | Dropdown | (Project Default) | Selects the visual style (text height, arrows) from the project's hsbCAD Dimension Styles. |
| Distance vertical dims look into the element | Number | 500 mm | Defines how far inward from the left/right edges the script searches for internal joists to dimension. |
| Distance horizontal dims look into the element | Number | 500 mm | Defines how far inward from the top/bottom edges the script searches for internal members to dimension. |
| Dimension side vertical beams | Dropdown | Center | Places horizontal dimensions relative to vertical beams: Left, Center, or Right face. |
| Dimension first joist | Dropdown | No | If "No", the outer rim joist is excluded from spacing dimensions to reduce clutter. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Refreshes the dimensions based on current model geometry or property changes. |
| Properties | Opens the parameters palette to adjust offsets and styles. |
| Erase | Removes the script instance and all generated dimensions. |

## Settings Files
- **Dimension Styles**: This script relies on the standard `_DimStyles` collection defined in your hsbCAD project or drawing environment, rather than a separate XML configuration file.

## Tips
- **Clutter Control**: If joist spacing dimensions are too crowded near the rim, set **Dimension first joist** to "No".
- **Adjusting Scale**: The visual size of arrows and text is controlled by the **Dimension layout** property. Select a style that matches your viewport scale (e.g., 1:50 or 1:100).
- **Moving Dimensions**: To move the entire stack of dimensions further away from the floor, simply increase the **Distance dimension line to element** value.

## FAQ
- **Q: The script ran, but no dimensions appeared.**
- **A:** Ensure the Viewport you selected contains a valid hsbCAD Element with visible beams. If the Element is empty or invalid, the script will exit silently.
- **Q: How do I change the text height of the dimensions?**
- **A:** You cannot change the text height directly in the script properties. Instead, change the **Dimension layout** property to select a different Dimension Style that has your desired text height settings.
- **Q: Can I use this on a Roof Element?**
- **A:** This script is specifically designed for floor layouts (horizontal planes). While it may technically run on roofs, the logic is optimized for floor joist direction and spacing.
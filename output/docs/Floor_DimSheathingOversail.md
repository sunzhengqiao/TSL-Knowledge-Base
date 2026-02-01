# Floor_DimSheathingOversail.mcr

## Overview
This script automates the dimensioning of floor sheathing oversails (overhangs) in Paper Space layouts. It calculates and draws linear dimensions indicating how much the floor sheeting extends beyond the structural timber beams.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | The script is designed for Paper Space annotation. |
| Paper Space | Yes | This is the primary environment; the script transforms model coordinates to the 2D view. |
| Shop Drawing | Yes | Specifically used to document sheathing details in production drawings. |

## Prerequisites
- **Required Entities**: An hsbCAD Element with both structural beams and sheathing sheets.
- **Minimum Beam Count**: The script requires beams to establish a reference boundary.
- **Required Settings**: None, but a valid AutoCAD Dimension Style must exist in the drawing.
- **Setup**: You must be on an AutoCAD Layout containing a Viewport linked to the model.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Floor_DimSheathingOversail.mcr` from the list.

### Step 2: Select Insertion Point
```
Command Line: (Point prompt)
Action: Click in the Paper Space layout to set the origin point for the dimension line.
```

### Step 3: Select Viewport
```
Command Line: Select a viewport, you can add others later on with the HSB_LINKTOOLS command.
Action: Click the border of the viewport that displays the floor/element you wish to dimension.
```

### Step 4: Configure Properties
Press `Ctrl+1` to open the Properties Palette and adjust the **Direction** or **Zone index** if the dimensions do not appear as expected.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Direction | dropdown | Horizontal | Sets the orientation of the dimension line. **Horizontal** measures along the X-axis, **Vertical** measures along the Y-axis. |
| Zone index | dropdown | 5 | Selects the construction layer (Zone) containing the sheathing panels. (-5 to 5). |
| Delta text direction | dropdown | None | Controls the rotation of the dimension text for the oversail measurement (None, Parallel, or Perpendicular). |
| Cumm text direction | dropdown | Parallel | Controls the rotation of text for cumulative dimensions (if applicable). |
| \|Dimstyle\| | dropdown | (Empty) | Select the AutoCAD Dimension Style to use for visual appearance (arrows, text size, color). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are defined for this script. Use the Properties palette to modify settings. |

## Settings Files
- None used.

## Tips
- **No Dimensions Showing?**: If the dimension does not appear, the sheathing might not extend far enough past the beam. The script ignores oversails smaller than approximately 1mm.
- **Wrong Layer?**: Ensure the **Zone index** matches the specific layer in your hsbCAD model where the floor sheets are located.
- **Switching Orientation**: If you need to dimension the side walls instead of the front/back, change the **Direction** property from "Horizontal" to "Vertical" in the properties palette.
- **Moving the Dimension**: You can move the script using the AutoCAD `MOVE` command or grip edit the insertion point to reposition the dimension line.

## FAQ
- **Q: Why does the dimension appear but shows zero or very small length?**
  A: The sheeting edge might be flush with or only slightly overlapping the beam edge. The script only draws visible dimensions for significant overhangs.
- **Q: Can I dimension multiple zones at once?**
  A: No, each script instance dimensions only one Zone index. Insert the script multiple times with different Zone settings to document multiple layers.
- **Q: The text is upside down. How do I fix it?**
  A: Change the **Delta text direction** property to "Parallel" or "Perpendicular" to adjust the text rotation.
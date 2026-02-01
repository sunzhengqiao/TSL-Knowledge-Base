# GE_PLOT_SHEATHING_OVERSAIL

## Overview
Automatically dimensions the overhang (oversail) distance of sheathing sheets relative to the timber frame on 2D layout drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed specifically for Layout generation. |
| Paper Space | Yes | The script must be inserted into an AutoCAD Layout containing a Viewport. |
| Shop Drawing | Yes | Used for detailing panel manufacturing dimensions. |

## Prerequisites
- **Required Entities**: An AutoCAD Layout with a Viewport linked to an hsb Element.
- **Element Content**: The Element must contain structural Beams and Sheathing Sheets.
- **Minimum Beams**: 0 (Script exits silently if no beams or sheets are found).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_PLOT_SHEATHING_OVERSAIL.mcr`

### Step 2: Set Insertion Point
```
Command Line: (No specific prompt)
Action: Click anywhere in the Paper Space layout to define the script's anchor point.
```

### Step 3: Select Viewport
```
Command Line: Select a viewport, you can add others later on with the HSB_LINKTOOLS command.
Action: Click on the viewport border that displays the wall/floor element you want to dimension.
```

### Step 4: Adjust Properties
After insertion, select the script anchor (invisible or represented by a point) and open the **Properties Palette** (Ctrl+1) to configure the dimension settings (Direction, Zone, Offset, etc.). The script will automatically update the dimensions in the viewport.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Direction | dropdown | Horizontal | Sets the orientation of the measurement line relative to the element (Horizontal or Vertical). |
| Zone index | dropdown | 5 | Selects the material layer (zone) to measure. Commonly 5 for exterior sheathing. |
| Dimension Style | dropdown | _DimStyles | Selects the AutoCAD Dimension Style to use for the annotation. |
| Side of delta dimensioning | dropdown | Above | Determines if the dimension text is placed Above or Below the dimension line. |
| Offset From Element | number | 150 | Distance in mm from the Element's origin (0,0) to the dimension line location. |
| Delta text direction | dropdown | None | Controls text rotation: None (Horizontal), Parallel, or Perpendicular to the line. |
| Color | number | 1 | Sets the AutoCAD Color Index (1-255) for the dimension lines and text. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are defined for this script. |

## Settings Files
- None.

## Tips
- **Missing Dimensions?** If no dimensions appear, check if the selected **Zone index** actually contains sheathing sheets that extend past the timber frame. If the sheathing is flush with or inside the frame, no oversail dimension will be drawn.
- **Multiple Viewports:** You can link additional viewports to this script after insertion using the `HSB_LINKTOOLS` command if your workflow supports it.
- **Visual Clarity:** Use the **Offset From Element** property to move the dimension line away from the model geometry if the drawing is too crowded.
- **Standardization:** Set the **Dimension Style** to your company standard style immediately after insertion to ensure annotations match your drawing standards.

## FAQ
- **Q: Why don't I see any dimensions after running the script?**
- **A:** This usually happens for three reasons: 1) The selected Zone has no sheets. 2) The sheets do not actually extend past the frame (oversail is 0). 3) The Viewport is not linked to a valid hsb Element.

- **Q: Can I dimension both horizontal and vertical oversails with one script?**
- **A:** No, you must insert the script once for Horizontal and once for Vertical (changing the "Direction" property for each instance) if you need dimensions on both sides.

- **Q: How do I change the color of the dimensions?**
- **A:** Select the script in Paper Space, open the Properties Palette, and change the "Color" property to the desired AutoCAD Color Index (e.g., 1 for Red, 2 for Yellow, etc.).
# GE_PLOT_BEAM_SHOW_VERY_TOP_PLATES.mcr

## Overview
This script generates a 2D representation of the top wall plates (very top plates) in a Paper Space layout. It allows you to visually identify and hatch these specific plates within a selected viewport for detailing or presentation purposes.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed for Paper Space layouts. |
| Paper Space | Yes | Required. You must select a viewport to execute. |
| Shop Drawing | No | This is a detailing/layout visualization tool. |

## Prerequisites
- **Required Entities**: A Layout tab with a Viewport.
- **Minimum Beam Count**: 0.
- **Required Settings**: The selected Viewport must be linked to a valid hsbCAD Element containing beams classified as "Very Top Plate" or "Very Top Sloped Plate".

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_PLOT_BEAM_SHOW_VERY_TOP_PLATES.mcr` from the file dialog.

### Step 2: Select Viewport
```
Command Line: Select the viewport from which the element is taken
Action: Click on the viewport border inside your Layout tab that displays the wall you wish to detail.
```

### Step 3: Adjust Appearance (Optional)
After insertion, select the script object (if visible or selectable) and modify the hatch settings in the Properties Palette to suit your plotting style.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| \|Hatch\| | Header | N/A | Read-only category header. |
| Display Hatch | dropdown | \|Yes\| | Toggles the hatch fill on or off. If set to "\|No\|", only the outline of the top plates is drawn. |
| Pattern | dropdown | DOTS | Selects the CAD hatch pattern to fill the top plates (e.g., SOLID, ANSI31, NET). |
| Scale | number | U(10,.5) | Adjusts the scale/density of the selected hatch pattern. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are added by this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not use external settings files.

## Tips
- **Viewport Link**: Ensure the viewport you select is actually looking at an hsbCAD Element. If the viewport is not linked to an element, the script will not generate any geometry.
- **Beam Classification**: This script specifically looks for beams classified as *Very Top Plate* or *Very Top Sloped Plate*. If your wall generation uses different naming, the script may not display anything.
- **Updates**: If you modify the 3D model (e.g., change wall height or plate size), the script will automatically update the next time the drawing is recalculated or regenerated.

## FAQ
- **Q: I ran the script, but nothing happened.**
- **A:** Ensure the selected viewport is linked to an element. Also, verify that the wall actually contains beams with the specific "Very Top Plate" classification.
- **Q: How do I change the color of the hatch?**
- **A:** The hatch color is usually controlled by the AutoCAD Layer settings (Layer 0 or current layer) or the script's display properties. You can select the generated hatch and change its color via the standard AutoCAD Properties palette.
- **Q: Can I use this in Model Space?**
- **A:** No, this script is designed explicitly for Paper Space viewports to create 2D layout details.
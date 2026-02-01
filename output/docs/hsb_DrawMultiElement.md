# hsb_DrawMultiElement.mcr

## Overview
This script visualizes timber wall elements grouped as 'multiwalls' in a 3D schematic layout. It arranges panels in a stacked or tabular view, allowing you to verify their sequence and spatial arrangement for transport or assembly.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary environment for the script. |
| Paper Space | No | Not supported in layout views. |
| Shop Drawing | No | This is a model visualization tool, not a drawing generator. |

## Prerequisites
- **Required Entities**: Elements (Walls) that contain internal MapX data with the key `hsb_Multiwall`.
- **Minimum Beam Count**: 1 (Though typically used for multiple grouped elements).
- **Required Settings**: None required; however, the external process creating the 'multiwalls' must have tagged the elements correctly.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_DrawMultiElement.mcr` from the list.

### Step 2: Place Visualization
```
Command Line: |Pick a point|
Action: Click in the Model Space to define the origin (top-left usually) for the multiwall layout.
```
*Note: The script will automatically search the model for elements tagged as multiwalls and draw them relative to this point.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Vertical offset between panels | number | 4000 | The vertical distance (in mm) placed between successive multiwall panels in the view. |
| Horizontal offset between panels | number | 0 | The horizontal spacing (in mm) applied between distinct groups of multiwalls (used when a Grouping format is set). |
| Dimension Style | dropdown | _DimStyles | The drafting standard used to determine text font and arrow style for labels. |
| Text Height | number | -1 | The explicit height for text labels. Set to -1 to use the height defined in the Dimension Style. |
| Text Color | number | -1 | The CAD Color Index (1-255) for the text labels. Set to -1 to use the default layer color. |
| Grouping format | text | | A logic string used to sort multiwalls into visual clusters (e.g., `%Elevation%` or `%Zone%`). If empty, all walls are stacked in a single list. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Refresh all Multielements | Re-scans the entire model for Elements with 'hsb_Multiwall' data and redraws the schematic. Use this if new multiwalls were added or updated. |
| Delete Multiwalls | Removes the 'hsb_Multiwall' internal data tag from all elements, effectively un-grouping them and clearing the visualization. |

## Settings Files
- No specific settings files are used by this script. It relies on OPM (Object Property Model) properties for configuration.

## Tips
- **Organizing by Floor**: To view walls separated by floor or phase, enter the attribute name (e.g., `%Elevation%`) into the **Grouping format** property. The script will create a new column for each elevation.
- **Adjusting Layout**: If walls overlap visually, increase the **Vertical offset between panels**. If groups are too close, increase the **Horizontal offset**.
- **Moving the View**: You can use the standard AutoCAD `MOVE` command or grip-edit the script instance anchor point to relocate the entire visualization schema.

## FAQ
- **Q: I inserted the script, but nothing is visible.**
  - A: Ensure your wall elements actually contain the 'hsb_Multiwall' internal data. This data is usually applied by a separate multiwall generation tool. Try right-clicking and selecting "Refresh all Multielements".
- **Q: How do I change the size of the text labels?**
  - A: You can either set an explicit **Text Height** in the properties, or set it to -1 and change the text size within your selected **Dimension Style**.
- **Q: What does the 'Horizontal offset' do?**
  - A: It only creates space between *groups* of walls. You must define a **Grouping format** (like `%Phase%`) for the horizontal offset to take effect; otherwise, all walls stack in a single vertical column.
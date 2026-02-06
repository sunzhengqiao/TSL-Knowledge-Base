# hsb_ShowFloorDiagonal

## Overview
Calculates and dimensions the maximum diagonal length of a timber floor or roof panel within a Layout Viewport. It is used to annotate production drawings with structural measurements required for bracing calculations or transport logistics.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script interacts specifically with Layout Viewports. |
| Paper Space | Yes | This is the primary environment. Dimensions are created in Paper Space. |
| Shop Drawing | Yes | Used to annotate production layouts. |

## Prerequisites
- **Layout Viewport**: A viewport on a layout tab that contains a valid hsbCAD Element.
- **Element Data**: The selected element must have generated geometry (Beams or Sheets).
- **Dimension Styles**: At least one dimension style must be loaded in the current AutoCAD drawing.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_ShowFloorDiagonal.mcr`

### Step 2: Select Viewport
```
Command Line: Select the viewport from which the element is taken
Action: Click on the border of the viewport containing the element you wish to measure.
```
*The script will automatically calculate the diagonal and place the dimension in Paper Space.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dim style | Dropdown | (Current) | Selects the dimension style (arrow style, text font) for the annotation. |
| Text Height | Number | 1 | Sets the text height in **mm** (Paper Space units). This ensures the text size remains constant regardless of viewport scale. |
| Zone to calculate diagonal | Dropdown | 0 | Determines which part of the element is measured. `0` measures the entire assembly. `1`-`10` measures specific construction layers (floors/roofs). |
| Exclude Beam With BeamCode | Text | (Empty) | Enter Beam Codes to exclude specific beams (e.g., blocking) from the calculation. Separate multiple codes with a semicolon `;`. |
| Color | Number | 3 | Sets the AutoCAD Color Index for the dimension line and text (e.g., 3 = Green). |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add specific items to the right-click context menu. Use the Properties Palette to modify settings. |

## Settings Files
- **Filename**: *None*
- **Location**: *N/A*
- **Purpose**: *N/A*

## Tips
- **Ignoring Blocking**: If you have blocking or trimmers sticking out of the main panel area, copy their Beam Codes into the "Exclude Beam With BeamCode" property. The script will then calculate the diagonal based on the main structural shape only.
- **Layer Specifics**: If you only need the diagonal of a specific floor sheet (e.g., the top layer), change the "Zone to calculate diagonal" to the corresponding index number.
- **Text Readability**: The script automatically calculates text orientation to ensure the dimension text reads from left to right. If you manually adjust the dimension grip afterwards, it may override this logic.

## FAQ
- **Q: Why didn't the dimension appear?**
  - **A**: Ensure the selected Viewport actually contains an hsbCAD Element. Also, check if your "Exclude Beam With BeamCode" filter accidentally removed all geometry, or if the "Zone" selected contains no data.
- **Q: Can I change the units of the dimension?**
  - **A**: The dimension units are controlled by your AutoCAD dimension style settings (set in the *Dim style* property), not directly by the script.
- **Q: The text is too small to read on the printed plot.**
  - **A**: Increase the *Text Height* property in the palette. Since this value is in Paper Space mm, increasing it to 2.5 or 3.0 will make it larger on the plot without affecting the model geometry.
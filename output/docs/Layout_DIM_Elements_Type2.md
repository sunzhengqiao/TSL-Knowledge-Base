# Layout_DIM_Elements_Type2.mcr

## Overview
Automates the creation of dimension lines for timber construction elements (walls or floors) in Paper Space layouts. It calculates dimensions based on Model Space entities (beams/sheets) and projects them into the selected Layout viewport, labeling positions based on specific zones and alignment settings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | Script operates within Paper Space Layouts. |
| Paper Space | Yes | Script requires a Viewport to be selected. |
| Shop Drawing | Yes | Used for generating production layout dimensions. |

## Prerequisites
- **Required Entities:** A Layout (Paper Space) tab containing at least one Viewport linked to a valid hsbCAD Element (Wall or Floor).
- **Minimum Beam Count:** 1 (The element must contain structural data).
- **Required Settings:** Standard AutoCAD Dimension Styles must exist in the drawing.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Layout_DIM_Elements_Type2.mcr` from the list.

### Step 2: Select Insertion Point
```
Command Line: Select point
Action: Click in the Paper Space (Layout) where you want the dimension line to appear.
```

### Step 3: Select Viewport
```
Command Line: Select a viewport, you can add others later on with the HSB_LINKTOOLS command.
Action: Click on the border of the Viewport that displays the element you wish to dimension.
```

*Note: Once inserted, the dimension will generate. You can modify its appearance and behavior using the Properties Palette (Ctrl+1).*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Direction | dropdown | Horizontal | Sets the orientation of the dimension line on the sheet (Horizontal or Vertical). |
| Side of beams/sheets | dropdown | Left | Determines which side of the timber members is used to place dimension points (Left, Center, Right, or Left and right). |
| Zones to use | dropdown | Use zone index | Selects whether to dimension the entire element ("All") or a specific construction layer ("Use zone index"). |
| Zone index | dropdown | 5 | The specific layer index to dimension. Use **0** to dimension structural beams instead of sheathing. |
| Delta text direction | dropdown | None | Controls the rotation of text for individual segment lengths (None, Parallel, or Perpendicular). |
| Cumm text direction | dropdown | Parallel | Controls the rotation of text for cumulative/running dimensions. |
| Numbering Direction | dropdown | Left | Sets the sorting order for the dimension chain (Left-to-Right or Right-to-Left). |
| Dimension Style | dropdown | *(Current)* | Selects the visual style (arrows, text size) for the dimension from available AutoCAD styles. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add specific items to the right-click context menu. Edit properties via the palette. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Viewport Alignment:** Ensure your viewport view is "straight" (Plan, Front, or Side elevation). If the view is rotated (isometric or arbitrary angle), the script may fail with an error: "Error! Vectors not aligned."
- **Filtering Content:** To dimension only the structural studs (timber) and ignore the sheathing sheets, set **Zones to use** to "Use zone index" and set **Zone index** to `0`.
- **Numbering Order:** Use the **Numbering Direction** property to reverse the dimension chain if the numbers start from the wrong side of the element.
- **Text Readability:** If dimension text overlaps, try changing the **Delta text direction** to "Perpendicular" to rotate individual measurements.

## FAQ
- **Q: Why do I get an error saying "Vectors not aligned"?**
  **A:** The script cannot determine the horizontal/vertical axes because the Viewport is rotated too much. Use the AutoCAD `DVIEW` or `MVSETUP` commands (or the hsbCAD Viewport tools) to square the view to the screen.
- **Q: How do I switch between dimensioning the OSB sheets and the timber studs?**
  **A:** In the Properties Palette, change **Zone index**. If it is currently `5`, `4`, etc., it dimensions sheets. Change it to `0` to dimension the structural beams.
- **Q: Can I move the dimension line after inserting it?**
  **A:** Yes. Select the dimension entity in Paper Space and use standard AutoCAD move commands or grips to reposition it. The dimension values will remain linked to the model space geometry.
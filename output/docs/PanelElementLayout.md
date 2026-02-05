# PanelElementLayout.mcr

## Overview
This script automates the dimensioning of Wall or Roof panel elements directly in Paper Space viewports. It creates detailed shop drawings by generating configurable dimension chains, offsets, and elevation markers around the selected panel geometry.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script operates specifically on Layout tabs. |
| Paper Space | Yes | Designed for use on static hsbCAD Viewports. |
| Shop Drawing | Yes | Used for generating production drawings. |

## Prerequisites
- **Required Entities**: A Paper Space Viewport containing a Wall or Roof Element (with geometry).
- **Minimum Beam Count**: 0.
- **Required Settings**: Valid AutoCAD Dimension Styles must exist in the drawing for the script to reference.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `PanelElementLayout.mcr`

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the viewport border that displays the Wall or Roof element you wish to dimension.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension Style Near | String | *Empty* | The AutoCAD dimension style to use for the front face of the panel. |
| Dimension Style Far | String | *Empty* | The AutoCAD dimension style to use for the back (far) face of the panel. |
| Beam Dimstyle | Dropdown | \|Do Not Dimension\| | Determines how internal members (studs/joists) are dimensioned. Choose "\|Do Not Dimension\|" or "\|Combine with Near\|". |
| Dimension Chain Spacing | Number | 1 | The distance between stacked dimension lines (e.g., between overall height and detailed dimensions). |
| Dimension point tolerance | Number | .125 | Points closer than this distance (in inches) are merged to prevent duplicate dimensions. |
| Limit Extension Lines | Dropdown | Yes | If "Yes", extension lines stop at the panel geometry. If "No", they extend fully to the dimension line. |
| Detail Level | Dropdown | Extremes | Sets the detail level. "Extremes" dimensions only the overall width/height; "All Points" dimensions every vertex and opening. |
| Display Top Dim | Dropdown | Yes | Toggle to enable or disable dimensioning on the top edge. |
| Display Bottom Dim | Dropdown | Yes | Toggle to enable or disable dimensioning on the bottom edge. |
| Display Left Dim | Dropdown | Yes | Toggle to enable or disable dimensioning on the left edge. |
| Display Right Dim | Dropdown | Yes | Toggle to enable or disable dimensioning on the right edge. |
| Dim Connected Female Elements | Dropdown | Yes | If "Yes", includes dimensions for intersecting elements (e.g., perpendicular walls) attached to the main panel. |
| Use Grips | Dropdown | Yes | If "Yes", enables interactive handles (Grips) on dimension lines for dragging and adjusting locations. |
| Top Dim Offset | Number | 12 | Distance from the top edge of the panel to the first dimension line. |
| Bottom Dim Offset | Number | 12 | Distance from the bottom edge of the panel to the first dimension line. |
| Left Dim Offset | Number | 12 | Distance from the left edge of the panel to the first dimension line. |
| Right Dim Offset | Number | 12 | Distance from the right edge of the panel to the first dimension line. |
| Add Sip Points Left | Dropdown | Yes | Includes dimension points for specific sub-elements on the left side. |
| Add Sip Points Right | Dropdown | Yes | Includes dimension points for specific sub-elements on the right side. |
| Top Dim Type | Dropdown | Delta | Sets the logic: "Delta" (individual spacing), "Cummulative" (running total), or "Both". |
| Bottom Dim Type | Dropdown | Delta | Sets the logic: "Delta", "Cummulative", or "Both". |
| Left Dim Type | Dropdown | Delta | Sets the logic: "Delta", "Cummulative", or "Both". |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add Near Points | Allows you to click in Paper Space to add custom points to the front-face dimension chain. |
| Remove Near Points | Allows you to click on existing dimension points to remove them from the chain. |
| Reset Added/Removed Points | Clears all manually added or removed points, reverting to the automatic geometric calculation. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies on standard AutoCAD properties and does not require external XML settings files.

## Tips
- **Cleaner Drawings**: Set **Detail Level** to "Extremes" for overall dimensions only, or "All Points" for full fabrication details.
- **Adjusting Layouts**: If dimensions overlap with other annotations, use the **Grips** (if enabled) or increase the **Dim Offset** properties to move the dimension strings further away from the panel.
- **Tolerance**: If you see duplicate dimensions very close to each other, slightly increase the **Dimension point tolerance** to merge them.

## FAQ
- **Q: The script displays "Nothing to dimension" in the viewport.**
  - **A:** This means the selected viewport does not contain a valid Wall or Roof Element with geometry (Sips). Ensure the element is generated and visible in Model Space.
- **Q: Can I dimension the back side of the panel differently?**
  - **A:** Yes. Set the **Dimension Style Far** property to a different AutoCAD style (e.g., one with dashed lines or a different color) to distinguish back-face dimensions.
- **Q: How do I move a dimension line without changing the offset property for all sides?**
  - **A:** Ensure **Use Grips** is set to "Yes". Select the script instance, click the square grip on the dimension text/arrow, and drag it to the desired location.
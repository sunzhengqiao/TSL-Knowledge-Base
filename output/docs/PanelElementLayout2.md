# PanelElementLayout2.mcr

## Overview
This script automatically generates detailed dimension lines for Wall or Roof elements containing Structural Insulated Panels (SIPs) directly in Paper Space viewports. It is designed to create clean shop drawings by handling overall dimensions, individual panel joints, and openings with user-configurable styles.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script does not run in Model Space. |
| Paper Space | Yes | This script must be inserted on a layout containing a viewport. |
| Shop Drawing | Yes | Intended for creating production drawings and detailing. |

## Prerequisites
- **Required Entities**: A viewport on a Paper Space layout that is linked to a valid Element (Wall or Roof) containing SIPs.
- **Minimum Beam Count**: 0
- **Required Settings**: None. The script relies on the geometry of the selected element.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `PanelElementLayout2.mcr` from the list.

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the viewport in Paper Space that displays the wall or roof element you wish to dimension.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension Style Near | dropdown | *First available* | Sets the visual style (text size, arrows) for dimensions on the front face of the element. |
| Dimension Style Far | dropdown | *First available* | Sets the visual style for dimensions on the back face of the element. |
| Beam Dimstyle | dropdown | Combine with Near | Determines if internal beams are included in the dimension chain or ignored. |
| Dimension Chain Spacing | number | 1 | The distance between stacked dimension lines (e.g., between overall and detailed dims). |
| Dimension point tolerance | number | 0.125 | Threshold to merge nearby dimension points. Increase this if you see duplicate/cluttered dimensions. |
| Limit Extension Lines | dropdown | Yes | If 'Yes', extension lines stop at the dimension line (cleaner look). If 'No', they extend to the geometry. |
| Detail Level | dropdown | Extremes | 'Extremes' dimensions only total width/height. 'All Points' dimensions every opening, corner, and joint. |
| Display Top Dim | dropdown | Yes | Toggles visibility of the top horizontal dimension line. |
| Display Bottom Dim | dropdown | Yes | Toggles visibility of the bottom horizontal dimension line. |
| Display Left Dim | dropdown | Yes | Toggles visibility of the left vertical dimension line. |
| Display Right Dim | dropdown | Yes | Toggles visibility of the right vertical dimension line. |
| Dim Connected Female Elements | dropdown | Yes | Includes dimensions for intersecting walls (e.g., partitions) attached to the main wall. |
| Use Grips | dropdown | Yes | Enables interactive grips to drag and adjust dimension lines after creation. |
| Top Dim Offset | number | 12 | Distance from the top of the element geometry to the first dimension line. |
| Bottom Dim Offset | number | 12 | Distance from the bottom of the element to the first dimension line. |
| Left Dim Offset | number | 12 | Distance from the left edge to the first dimension line. |
| Right Dim Offset | number | 12 | Distance from the right edge to the first dimension line. |
| Add Sip Points Left | dropdown | Yes | Includes SIP panel joint points on the left side in the dimension chain. |
| Add Sip Points Right | dropdown | Yes | Includes SIP panel joint points on the right side in the dimension chain. |
| Top Dim Type | dropdown | Delta | Style of measurement: 'Delta' (individual segments), 'Cummulative' (running total), or 'Both'. |
| Bottom Dim Type | dropdown | Delta | Style of measurement for the bottom dimension chain. |
| Left Dim Type | dropdown | Delta | Style of measurement for the left dimension chain. |
| Right Dim Type | dropdown | Delta | Style of measurement for the right dimension chain. |
| Off Lower Pt Left | number | 0 | Vertical offset for the start point of the left vertical dimension (useful to align with floor levels). |
| Off Lower Pt Right | number | 0 | Vertical offset for the start point of the right vertical dimension. |
| Add Base Dim | number | 0 | Adds an extra dimension segment below the wall bottom (e.g., for foundation height). |
| Add Elevation | number | 0 | Adds a constant value to all vertical dimensions to convert them to Absolute Levels/RL. |

## Right-Click Menu Options
*No specific custom menu items were detected in the analysis. Standard context options (like Erase or Properties) apply.*

## Settings Files
- **Filename**: None specified
- **Location**: N/A
- **Purpose**: The script uses dimension styles defined in your current CAD template.

## Tips
- **Cleaning up clutter**: If your dimensions look messy with many overlapping points, try increasing the **Dimension point tolerance** (e.g., from 0.125 to 0.25 or 0.5) to merge points that are very close together.
- **Interactive adjustment**: Ensure **Use Grips** is set to 'Yes'. After the script runs, you can select the dimensions in AutoCAD and use the blue grips to drag the lines into a clearer position without changing the properties.
- **Absolute Levels**: To show RL (Reduced Levels) instead of just local heights, set **Add Elevation** to your ground level height (e.g., 100.0).
- **Offsetting dimensions**: If the dimension text is colliding with the wall geometry, increase the **Dim Offset** values (Top, Bottom, Left, Right) to push the chains further away from the element.

## FAQ
- **Q: Why are no dimensions showing up?**
  **A:** Check the **Display Top/Bot/Left/Right Dim** properties in the palette. Ensure the side you want to dimension is set to 'Yes'. Also, verify that the selected viewport actually contains an Element with SIPs.
  
- **Q: What is the difference between 'Delta' and 'Cumulative' dimension types?**
  **A:** 'Delta' shows the size of each segment (e.g., 300, 400, 500). 'Cumulative' shows the running total distance from the start (e.g., 300, 700, 1200). 'Both' will display both values if space permits.

- **Q: How do I dimension the wall height relative to the floor finish rather than the bottom plate?**
  **A:** Use the **Off Lower Pt Left** or **Off Lower Pt Right** parameter. Enter the vertical distance from the bottom of the wall model to your desired reference line (e.g., the floor finish).
# HSB_G-Distribution.mcr

## Overview
This script calculates and visualizes a linear distribution pattern (such as stud or joist layout) between two user-selected points. It exports the calculated position coordinates to the MapIO, allowing other scripts to generate actual timber elements based on this layout.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Distribution is visualized using geometry in Model Space. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required entities**: None.
- **Minimum beam count**: 0.
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-Distribution.mcr` from the list.

### Step 2: Define Start Point
```
Command Line: Select start distribution
Action: Click in the drawing to set the starting point for the distribution.
```

### Step 3: Define End Point
```
Command Line: Select end distribution
Action: Click to set the ending point. The script will automatically calculate and display the distribution.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Spacing | Number | 600 | Sets the center-to-center distance between distribution positions (in mm). |
| Distribution type | Dropdown | From start to end | Sets the alignment logic. Options: From start to end, From end to start, From centre, From centre (no position in centre). |
| Distribute evenly | Dropdown | No | If set to "Yes", the spacing is automatically adjusted to fit the exact distribution length without a remainder. |
| Start offset | Number | 0 | Sets the offset distance (in mm) from the start point before distribution begins. |
| End offset | Number | 0 | Sets the offset distance (in mm) from the end point before distribution ends. |
| Use start as position | Dropdown | No | Specifies whether the start point must be a distribution position. |
| Use end as position | Dropdown | No | Specifies whether the end point must be a distribution position. |
| Allowed distance between positions | Number | 10 | The tolerance (in mm) allowed for snapping distribution points to the start or end edges. |
| Show dimension lines | Dropdown | Yes | Toggles the visibility of the dimension lines in the model. |
| Dimension style | Dropdown | _DimStyles | Selects the dimension style to be used for displaying measurements. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add custom items to the right-click context menu. Edit properties via the Properties Palette (Ctrl+1). |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Grip Editing**: After insertion, select the distribution element and use the blue grips to move the Start or End points. The positions will recalculate automatically.
- **Even Distribution**: If you need the layout to fill the space exactly with no partial gap at the end, change "Distribute evenly" to "Yes".
- **Center Alignment**: Use the "From centre" options when you want the layout to be symmetric around the midpoint of the selected line.
- **Data Usage**: The small circles drawn by this script represent data points. Other scripts (e.g., wall generators) can read these points to automatically create studs or joists.

## FAQ
- **Q: Why don't I see any distribution circles?**
  A: Check your "Spacing" value. If it is set too large for the total length, or if your "Start offset" and "End offset" sum up to more than the total length, no positions will be generated.
- **Q: How do I force a stud at the very start and end?**
  A: Set "Use start as position" and "Use end as position" to "Yes". Ensure "Allowed distance between positions" is sufficient to capture the edge.
- **Q: Can I change the arrow style of the dimension line?**
  A: Yes, change the "Dimension style" property to match your preferred drafting standard configured in hsbCAD.
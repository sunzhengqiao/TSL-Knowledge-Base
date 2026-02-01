# hsb_DimensionHeadBinder

## Overview
This script automatically dimensions the head binder (top plate) of a timber wall element displayed in a Paper Space viewport. It generates dimensions for the overall plate length and indicates specific side overhangs if the top plate extends beyond the structural wall bounds.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script must be run from a Layout tab. |
| Paper Space | Yes | This is the primary environment. You must select a viewport containing an element. |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: A Layout tab with a Viewport containing a valid timber wall Element.
- **Minimum Beam Count**: 1 (The element must contain beams to calculate dimensions).
- **Required Settings Files**: None.

## Usage Steps

### Step 1: Launch Script
```
Command: TSLINSERT
Action: Browse and select hsb_DimensionHeadBinder.mcr
```

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the viewport border or inside the viewport that displays the wall element you wish to dimension.
```

### Step 3: Configure Properties
```
Action: Press Enter to confirm selection. The Properties Palette (OPM) will open.
Action: Adjust the "Dim Style" or "Offset" values if necessary. The script will automatically recalculate and draw the dimensions.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dim Style | text | Current Style | Sets the AutoCAD dimension style (e.g., arrows, text size) used for the generated dimensions. |
| Offset | number | 150 | Sets the distance (in mm) between the element geometry and the dimension line. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are defined for this script. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Overhang Threshold**: Side overhang dimensions only appear if the top plate extends more than 5mm past the structural studs. Small discrepancies will not be dimensioned.
- **Viewport Orientation**: The script automatically detects the orientation of the wall within the viewport. Ensure your viewport is aligned correctly before running the script.
- **Dynamic Updates**: If you change the wall geometry or viewport scale, select the script entity and right-click to "Recalculate" (if available) or re-run the command to update dimensions.

## FAQ
- **Q: Why don't I see dimensions for the left or right side?**
  **A:** The script only draws side overhang dimensions if the difference between the top plate edge and the structural wall edge is greater than 5mm. If they are flush or very close, no dimension is drawn.

- **Q: The dimension text is too small or huge.**
  **A:** This is controlled by the "Dim Style" property. Select the dimension object in the drawing, open the Properties Palette, and change the "Dim Style" to a style with your preferred text height settings.

- **Q: Can I use this in Model Space?**
  **A:** No, this script is designed specifically for creating dimensions on Layouts (Paper Space) based on a Viewport selection.
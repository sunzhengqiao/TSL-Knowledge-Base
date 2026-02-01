# HSB_D-Log.mcr Documentation

## Overview
This script automatically creates dimensions for log wall elements in Paper Space. It can dimension wall perimeters, notches, or machining tools, with intelligent filtering and scaling options to suit production drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | The script must be inserted in a Layout (Paper Space). |
| Paper Space | Yes | Dimensions are drawn directly in the layout, linked to a Viewport. |
| Shop Drawing | Yes | Designed for generating 2D production drawings with correct scaling. |

## Prerequisites
- **Required Entities**: A Layout containing a Viewport that displays a valid hsbCAD Element (Log Wall).
- **Minimum Beam Count**: 0 (Processes existing geometry).
- **Required Settings Files**: 
  - `HSB_G-FilterGenBeams.mcr` (Required if using named beam filters).
  - `HSB_L-Notch.mcr` (Required for Notch dimensioning, version 2.00 or higher).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_D-Log.mcr`

### Step 2: Configure Properties
```
Dialog: Properties Palette
Action: 
1. Select the 'DimObject' (Perimeter, Notches, or Tools).
2. Set 'Filter' properties if you need to exclude specific beams.
3. Adjust 'Position' and 'Offset' settings as needed.
```

### Step 3: Select Viewport
```
Command Line: Select viewport:
Action: Click inside the viewport boundary that shows the log wall you want to dimension.
```

### Step 4: Place Script Reference
```
Command Line: Select point for script name:
Action: Click a location in Paper Space to place the script name tag. 
Note: This tag acts as a handle; right-click it later to access menu options.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Dimension Settings** |
| sDimObject | dropdown | Perimeter | Choose what to dimension: **Perimeter** (wall outline), **Notches**, or **Tools** (Drills/Aris/Doves). |
| sPosition | dropdown | Horizontal bottom | Position of dimensions relative to wall: Horizontal (bottom/top), Vertical (left/right), or Angled (4 quadrants). |
| sUsePSUnits | dropdown | Yes | **Yes**: Offsets are fixed paper size (mm). **No**: Offsets are model size (scale with viewport zoom). |
| dDimOff | number | 100 | Distance between the wall edge and the dimension line. |
| **Angle Dimensions** |
| sWithAngle | dropdown | Yes | Show angular dimensions for angled wall segments. |
| dSizeAngleSymbol | number | 200 | Radius size of the angle arc symbol. |
| dAngleOffset | number | 200 | Distance from the dimension line to the angle vertex. |
| **Visual Style** |
| sDimStyle | string | (empty) | AutoCAD Dimension Style to use for linear dimensions. |
| sDimStyleAngle | string | (empty) | AutoCAD Dimension Style to use for angle text. |
| nColorDimension | number | -1 | Color of linear dimensions (-1 = ByLayer). |
| nTextColorAngle | number | -1 | Color of angle text. |
| nLineColorAngle | number | -1 | Color of angle lines/arc. |
| **Beam Filtering** |
| genBeamFilterDefinition | dropdown | (empty) | Select a predefined filter catalog entry (requires HSB_G-FilterGenBeams). |
| sFilterBC | string | (empty) | Exclude beams by Beam Code (e.g., "ST;BLK"). Use semicolons to separate codes. |
| sFilterLabel | string | (empty) | Exclude beams/sheets by Label name. |
| sFilterMaterial | string | (empty) | Exclude elements by Material name (e.g., "C24"). |
| sFilterHsbID | string | (empty) | Exclude elements by specific hsbID. |
| **Advanced** |
| sScriptnameNotch | string | HSB_L-Notch | The script name to look for when dimensioning notches (must be v2.00+). |

## Right-Click Menu Options
*Access these by right-clicking the Script Name point placed in Step 4.*

| Menu Item | Description |
|-----------|-------------|
| **Filter this element** | Hides dimensions for this specific element. The script name turns **Red**. |
| **Remove filter for this element** | Shows dimensions for this element again. The script name turns **Orange**. |
| **Remove filter for all elements** | Resets all instances of this script in the drawing to unfiltered state. |

## Settings Files
- **Filename**: `HSB_G-FilterGenBeams.mcr`
- **Location**: hsbCAD Company or Install path
- **Purpose**: Provides named filter definitions to easily select groups of beams for dimensioning.

## Tips
- **Paper Space vs. Model Units**: Keep `sUsePSUnits` set to **Yes** if you want the dimension line to stay a fixed distance from the wall on your printed drawing, regardless of how much you zoom in the viewport.
- **Visibility**: If dimensions disappear, check if the script name tag is Red (Filtered). Right-click and select "Remove filter for this element".
- **Notch Compatibility**: Ensure your project uses `HSB_L-Notch` version 2.00 or higher; otherwise, notch dimensions may not generate correctly.
- **Updating Views**: If you change the wall geometry in Model Space, run `_REGEN` in the Layout to update the dimensions.

## FAQ
- **Q: Why are my dimensions huge or tiny?**
  - A: Check the `sUsePSUnits` property. If it is **No**, the offset distance is treated as Model Space millimeters. Changing the viewport scale will make the offset look different. Set it to **Yes** for consistent paper output.
  
- **Q: Can I dimension just the floor logs and exclude the wall logs?**
  - A: Yes. Use the `sFilterBC` or `sFilterLabel` properties to exclude the specific codes or labels used for your wall logs.

- **Q: The script places dimensions, but they are in the wrong spot.**
  - A: Change the `sPosition` property. For angled walls, try one of the "Angled" options to align the dimension line parallel to the wall slope.
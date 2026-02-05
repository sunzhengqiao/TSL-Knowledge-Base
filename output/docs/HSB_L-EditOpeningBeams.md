# HSB_L-EditOpeningBeams

## Overview
This script automatically adds angled sarking (drip) cuts to the ends of log wall beams that intersect with window or door openings. It ensures proper water shedding and fitting for jambs and lintels by adjusting beam geometry based on customizable offsets and angles.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model entities (Log Walls and Openings). |
| Paper Space | No | Not designed for layout views or 2D drawings. |
| Shop Drawing | No | Does not generate dimensions or annotations for manufacturing drawings. |

## Prerequisites
- **Required Entities**: The model must contain Log Wall elements (`ElementLog`) with defined Openings (`Opening`).
- **Minimum Beam Count**: 0 (The script scans the element for existing beams).
- **Required Settings Files**: None.

## Usage Steps

### Step 1: Launch Script
Execute the `TSLINSERT` command in AutoCAD and select `HSB_L-EditOpeningBeams.mcr` from the list.

### Step 2: Configure Selection Scope
Before selecting geometry, check the **Properties Palette** (OPM).
1.  Locate the **Selection set** category.
2.  Choose one of the following options for the `Select elements or openings` property:
    *   **Elements**: Processes all openings within the selected Log Wall(s).
    *   **Opening**: Processes only the specific opening(s) you select in the next step.

### Step 3: Select Geometry
Depending on your choice in Step 2, the command line will prompt you:

**If Elements was selected:**
```
Command Line: Select a set of elements
Action: Click on the Log Wall(s) containing the openings you wish to process. Press Enter to confirm.
```

**If Opening was selected:**
```
Command Line: Select a set of openings
Action: Click directly on the window or door openings within the walls. Press Enter to confirm.
```

### Step 4: Processing
The script will automatically:
1.  Remove any previous instances of this script attached to the selected items to prevent duplicates.
2.  Identify beams ending inside the opening profile.
3.  Apply the calculated cuts and draw symbols.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Selection set** | | | |
| Select elements or openings | dropdown | Elements | Determines if you select whole walls or just individual openings for processing. |
| **Cut & Symbol** | | | |
| Offset cut | number | 7 mm | The distance from the opening face into the wall where the cut begins. |
| Angle cut | number | 45 deg | The angle of the cut relative to the beam axis (e.g., 45° for a standard drip cut). |
| Symbol size | number | 15 mm | The visual size of the arrow symbol drawn in the model to indicate the cut. |
| Symbol color | integer | 1 (Red) | The CAD color index used for the annotation symbol. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Refreshes the script logic. Use this after manually moving the opening or resizing the wall to ensure cuts update to the new geometry. |

## Settings Files
None. This script relies entirely on the Properties Palette for configuration.

## Tips
- **Duplicate Prevention**: If you run the script on an element that already has these cuts, the script will automatically erase the old instance before creating the new one. You can safely re-run the script to update settings.
- **Visual Feedback**: The script draws a colored arrow/symbol at the cut location. If you do not see the symbol, check if the beam ends actually penetrate the opening polygon.
- **Unit Independence**: The script handles internal unit conversions (mm/inches) automatically using the `U()` function, ensuring offsets remain correct regardless of your project units.

## FAQ
- **Q: Why did the script not cut any beams?**
  - A: Ensure that the end points of the beams (centerline) actually fall within the polygon boundary of the selected opening. If the beams stop short or extend too far past the opening, the script may not detect the intersection.
- **Q: How do I change the angle of the drip cut?**
  - A: Select the script instance (or the opening/element it is attached to), open the Properties Palette, and modify the **Angle cut** value. The 3D model will update immediately.
- **Q: Can I use this on standard framed walls?**
  - A: No, this script is designed specifically for Log Walls (`ElementLog`). It will not function on standard timber frame walls.
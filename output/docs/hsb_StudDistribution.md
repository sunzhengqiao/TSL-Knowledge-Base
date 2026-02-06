# hsb_StudDistribution.mcr

## Overview
This script standardizes the stud layout within a wall element by redistributing them at a uniform spacing. It deletes existing studs on one side of a user-selected point and regenerates them based on a specified center-to-center distance.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D elements within the model. |
| Paper Space | No | Not intended for layout views or shop drawings. |
| Shop Drawing | No | Does not generate detailing views. |

## Prerequisites
- **Required Entities**: An existing wall Element containing beams.
- **Minimum Beam Count**: At least one beam must exist on the side of the wall you intend to keep (to serve as an anchor/reference).
- **Required Settings Files**: None.

## Usage Steps

### Step 1: Launch Script
```
Command: TSLINSERT
Action: Browse and select hsb_StudDistribution.mcr
```
*Note: Upon selection, the Properties palette (OPM) will display the script settings. You can adjust the "Distance Between Studs" and "Redistribute to" direction before proceeding to the prompts.*

### Step 2: Select Element
```
Command Line: Select an element
Action: Click on the wall element where you want to redistribute studs.
```

### Step 3: Select Distribution Point
```
Command Line: Select Distribution Point
Action: Click a point on the wall element (e.g., at a door opening or corner) to define where the redistribution should start.
```
*Note: Studs will be removed and regenerated starting from this point, extending backwards in the direction specified in the properties.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Distance Between Studs | Number | 400 mm | The center-to-center spacing for the new studs. Common values are 400mm or 600mm. |
| Redistribute to | Dropdown | Left | Determines which side of the distribution point is cleared and regenerated. **Note:** "Left" and "Right" refer to the element's local X-axis direction, not necessarily the screen view. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script runs once and erases itself immediately after execution. There are no persistent context menu options. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Local Axes**: If the studs are distributing to the wrong side, check the element's local coordinate system. "Left" follows the element's local X-axis.
- **Anchor Stud**: Ensure there is at least one stud on the "Keep" side of your selected point. The script uses this stud to determine height and material for the new ones.
- **Blocking**: Be aware that any blocking or short framing members on the redistribution side will be deleted to accommodate the new layout.

## FAQ
- **Q: Can I undo the changes?**
  - A: Yes, use the standard AutoCAD `UNDO` command immediately after running the script.
- **Q: Why did the script disappear after I ran it?**
  - A: This is a "run-once" automation script. It erases its own instance from the model after finishing the geometric changes to keep your drawing clean.
- **Q: What happens if I select a point outside the element?**
  - A: The script requires the distribution point to be valid relative to the element. If the point is invalid, the script may exit without making changes.
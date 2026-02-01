# hsb_CheckModularStuds.mcr

## Overview
This script analyzes wall elements to detect gaps where stud spacing exceeds the defined modular spacing. It offers the option to either automatically generate filler studs to fix the issue or draw visual markers (circles) to indicate where the spacing violations occur.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D wall elements and beams. |
| Paper Space | No | Not intended for 2D layout or detailing views. |
| Shop Drawing | No | Does not interact with shop drawing views or dimensions. |

## Prerequisites
- **Required Entities**: Wall elements (ElementWallSF) containing existing structural beams (studs).
- **Minimum Beam Count**: 0 (The script will check and report, but requires existing plates/studs to calculate spacing correctly).
- **Required Settings Files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or select from your hsbCAD TSL Catalog) → Select `hsb_CheckModularStuds.mcr`

### Step 2: Configure Options
```
Dialog: TSL Properties
Action: Choose the desired operation mode:
- "Create Stud": Automatically inserts new studs where gaps are too wide.
- "Show Circle": Draws red circles (or selected color) to mark gaps without changing geometry.
Set the "Circle Colour" if using the visual mode, then click OK.
```

### Step 3: Select Walls
```
Command Line: Select a set of elements
Action: Click on the wall elements you wish to check. Press Enter to confirm selection.
```

### Step 4: Review Results
- **If Create Stud**: New studs will be generated at the midpoint of detected gaps. The script will remove itself from the walls automatically.
- **If Show Circle**: Colored circles will appear in the model at locations where spacing is incorrect. The script remains attached to the wall to maintain these visuals.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Select Option | Dropdown | Create Stud | Determines the action taken when a spacing violation is found.<br>- **Create Stud**: Physically adds a new stud to the model.<br>- **Show Circle**: Draws a visual marker only. |
| Circle Colour | Number | 1 | Specifies the color index (ACI) for the warning circles when "Show Circle" is active. (e.g., 1 = Red). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific items to the right-click context menu. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Openings are Ignored**: The script intelligently detects window and door openings. It will not place filler studs or draw warning circles inside the clear opening area, even if the gap between jambs is large.
- **Modifying Results**: If you use "Show Circle" mode, you can later change the option to "Create Stud" via the Properties palette. Select the script instance attached to the wall, change the property, and the script will execute the creation logic.
- **Removing Visuals**: To remove the warning circles, select the script instance on the wall and delete it, or change the wall geometry to fix the spacing and regenerate.
- **Splitting Blocking**: If the script creates a new stud, it will automatically split any blocking/bracing beams that intersect with the new stud location.

## FAQ
- Q: I selected "Create Stud", but no new studs appeared.
- A: Ensure there are actual gaps larger than the defined modular spacing in the selected walls. Also, verify that the gap midpoint is not located within an opening (window/door).
- Q: Why did the script disappear from the wall after I ran it?
- A: When using the "Create Stud" option, the script performs a one-time modification to the model and then self-deletes to prevent duplicate studs on future regenerations.
- Q: How do I change the color of the warning circles?
- A: Select the wall, double-click the script instance (or access via Properties), and change the "Circle Colour" integer value.
# hsb_CreateBoardsBetweenStuds.mcr

## Overview
This script generates sheathing boards (such as OSB or plywood) between wall studs within a specified area of a wall element. It automatically cuts the boards around wall openings and adds vertical timber battens at every cut edge for structural support.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be run in 3D Model Space. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | This is a modeling script, not a detailing tool. |

## Prerequisites
- **Required Entities**: An existing hsbCAD Wall Element.
- **Minimum Beams**: The wall must contain vertical beams (studs). Specifically, there must be a stud located at the base (Zone 0) for the script to calculate dimensions correctly.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `hsb_CreateBoardsBetweenStuds.mcr`.

### Step 2: Select Wall Element
```
Command Line: Please select an Element
Action: Click on the desired wall element in the drawing.
```

### Step 3: Define Start Point
```
Command Line: Pick Starting Point, must be inside of the element
Action: Click a point inside the wall width to define the left boundary of the sheathing area.
```

### Step 4: Define End Point
```
Command Line: Pick Ending Point
Action: Click a point inside the wall width to define the right boundary of the sheathing area.
```
*Note: The order of points (Left-to-Right or Right-to-Left) does not matter; the script will automatically sort them.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sLocation | String | Front | Side of the wall to apply sheathing (Front or Back). |
| dOffset | Double | 300 | Vertical distance from the bottom of the wall to the bottom edge of the sheathing (mm). |
| dSheetHeight | Double | 1200 | Vertical height of the sheathing board (mm). |
| dSheetThickness | Double | 15 | Thickness of the sheet material (mm). |
| sSheetMaterial | String | OSB3 | Commercial name/code for the sheet material. |
| dBattenWidth | Double | 50 | Horizontal width (thickness) of the vertical battens (mm). |
| dBattenHeight | Double | 50 | Depth of the vertical battens perpendicular to the wall (mm). |
| sName | String | Battens | Name assigned to the batten beams. |
| sMaterial | String | CLS | Material grade/species of the timber battens. |
| sGrade | String | C16 | Structural strength grade of the timber battens. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| None | The script instance erases itself automatically after execution. Standard properties can be modified via the Properties Palette *before* the geometry is generated. |

## Settings Files
None. This script does not rely on external XML settings files.

## Tips
- **Zone 0 Requirement**: Ensure your wall element has a stud at the very bottom (Zone 0). If the script reports "no beam for zone 0 found," check your wall construction.
- **Point Selection**: You do not need to click exactly on a stud. Clicking anywhere between two studs allows the script to calculate the boundaries automatically.
- **Static Geometry**: Once the boards and battens are created, they are standard 3D objects. To change dimensions, you must delete the generated objects and run the script again.

## FAQ
- **Q: Can I modify the boards after they are created?**
  A: No. The script creates static geometry and removes itself. You must delete the boards and re-run the script with new parameters to make changes.
- **Q: Why did the script fail to find the wall?**
  A: Ensure you are selecting a valid hsbCAD Element that contains vertical beams. Empty elements or elements without vertical structure cannot be processed.
- **Q: What happens if I pick points outside the wall width?**
  A: The script requires points to be inside the element width to project the geometry correctly. If points are outside, the script may fail or produce unexpected results.
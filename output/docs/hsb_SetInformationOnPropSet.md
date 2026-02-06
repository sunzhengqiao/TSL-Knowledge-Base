# hsb_SetInformationOnPropSet.mcr

## Overview
This script automatically calculates the wall thickness for door and window openings within selected wall elements and updates their Property Sets with this data. It ensures that the `hsbDoorInformation` attached to openings accurately reflects the wall geometry for BIM scheduling.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary environment for the script. |
| Paper Space | No | Not supported in Paper Space. |
| Shop Drawing | No | Not designed for Shop Drawing contexts. |

## Prerequisites
- **Required Entities**: Wall Elements (`ElementWall`) that contain Openings.
- **Minimum Beam Count**: 0 (The script operates on Wall Elements).
- **Required Settings**: The drawing must contain the Property Set definitions `hsbDoorInformation` and `Door Schedule`.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or your company's custom insert command) → Select `hsb_SetInformationOnPropSet.mcr`

### Step 2: Select Walls
```
Command Line: Select an Elements
Action: Click on one or more Wall Elements in the model that contain the openings you wish to update. Press Enter or Right-Click to confirm selection.
```

### Step 3: Automatic Processing
Once confirmed, the script will automatically:
1.  Scan all selected walls for openings.
2.  Calculate the wall thickness for each opening.
3.  Update the `WallThickness` and `Weight` properties in the `hsbDoorInformation` Property Set for each opening.
4.  Remove itself from the drawing (it will disappear from the model after completion).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not expose any editable properties in the Properties Palette. It runs entirely via command-line input. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not add custom options to the right-click context menu. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external XML settings files. It relies on the Property Set definitions currently loaded in your AutoCAD/hsbCAD project.

## Tips
- **Batch Processing**: You can select multiple walls at once during the selection prompt to update information for many openings simultaneously.
- **Verification**: After the script runs (and disappears), select a door or window and check the Properties Palette under the `hsbDoorInformation` tab to verify that the `WallThickness` has been updated.
- **Clean Up**: Since the script erases itself after running, you do not need to manually delete it from the drawing.

## FAQ
- **Q: The script disappeared immediately after I selected the walls. Did it fail?**
  - A: No. This script is designed as a "Fire and Forget" tool. It automatically erases itself from the model once it finishes updating the property data to keep your drawing clean.
  
- **Q: Why didn't the properties update on my doors?**
  - A: Ensure that the elements you selected are valid Wall Elements (`ElementWall`) and that they actually contain openings. Also, verify that the Property Set definition `hsbDoorInformation` exists in your drawing.
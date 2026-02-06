# hsb_SolePlateSplitAtDoors.mcr

## Overview
This script automatically splits wall sole plates (bottom plates) at the location of door openings and removes the section of the plate located directly under the door width.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the 3D model. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This is a model modification script. |

## Prerequisites
- **Wall Element**: A wall must exist in the model that contains Door type openings.
- **Beams**: At least one beam representing the sole plate (bottom plate) must exist to be processed.
- **Context**: The selected beams must be located within the vertical projection of the wall's door openings.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SolePlateSplitAtDoors.mcr` from the file dialog.

### Step 2: Select Wall
```
Command Line: |Select wall|
Action: Click on the wall element (Element) that contains the door definitions.
```

### Step 3: Select Beams
```
Command Line: |Select beams that need be splitted at door positions|
Action: Select the sole plate (bottom plate) beams that run through the doors. Press Enter to confirm selection.
```

**Note**: The script will automatically process the splits, delete the middle segments under the doors, and then remove its own instance from the model.

## Properties Panel Parameters
This script does not expose any parameters to the AutoCAD Properties Palette (OPM). All configuration is handled via command-line selection.

## Right-Click Menu Options
This script does not add specific items to the entity context menu.

## Settings Files
No external settings files are required or used by this script.

## Tips
- **Verification**: Ensure your wall element has defined "Door" type openings. Windows or other opening types will be ignored by this script.
- **Self-Deleting**: This tool acts as a command. Once it finishes splitting and erasing the beam segments, it deletes itself from the drawing automatically.
- **Selection**: You can select multiple sole plate beams in Step 3 if they all need to be split by the same set of doors.

## FAQ
- **Q: I ran the script, but nothing happened.**
  A: Check the command line history. If it says "one wall needed," you may have missed selecting the wall element. If it says "Soleplate beams needed," ensure you selected beams in Step 2. Also, verify the wall actually contains Doors and not just Windows.

- **Q: Did it split the plate?**
  A: The script will physically cut the selected beam at the door jambs and delete the center piece. You should see two separate beam segments remaining where there used to be one continuous beam.

- **Q: Can I use this for windows?**
  A: No, this script specifically filters for Door type openings (`_kDoor`). It will not cut plates for windows.
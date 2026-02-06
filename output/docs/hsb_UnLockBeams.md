# hsb_UnLockBeams.mcr

## Overview
This script detaches selected timber beams from their parent floor or layout, effectively "unlocking" them for independent modification. It removes the hierarchical link and changes the beam color to indicate they are no longer grouped with the original structure.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates on 3D beam entities within the model. |
| Paper Space | No | This script is not designed for use in layout views or shop drawings. |
| Shop Drawing | No | This script does not generate detailing views. |

## Prerequisites
- **Required Entities**: GenBeam (Timber Beams) must exist in the drawing.
- **Minimum Beam Count**: 1 (You must select at least one beam for the script to take effect).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: Type `TSLINSERT` in the command line and select `hsb_UnLockBeams.mcr` from the file dialog.

### Step 2: Select Beams
```
Command Line: Select Beams
Action: Click on individual beams or use a window selection to choose the beams you wish to unlock. Press Enter to confirm selection.
```

### Step 3: Completion
The script will automatically process the selected beams, remove their parent link, change their color to orange (Color Index 32), and then erase its own instance from the drawing.

## Properties Panel Parameters

This script does not expose any editable parameters in the AutoCAD Properties Palette.

## Right-Click Menu Options

This script does not add specific options to the entity right-click menu.

## Settings Files
No external settings files (XML or otherwise) are required or used by this script.

## Tips
- **Visual Indicator**: The unlocked beams will change to Color Index 32 (usually Orange) to provide immediate visual feedback that they have been detached from the parent floor.
- **Clean Up**: The script instance automatically erases itself after running. You do not need to delete the script icon manually.
- **Independence**: Once unlocked, these beams will not move automatically if the original floor or layout is modified.

## FAQ
- **Q: Why did the script icon disappear immediately after I selected the beams?**
  - A: This is normal behavior. The script is designed to perform its function (unlocking the beams) and then remove its own instance from the drawing to keep your model clean.

- **Q: Can I re-lock the beams to the floor later?**
  - A: This script does not have a "re-lock" function. You would typically need to recreate the beams within the floor layout or use other specific hsbCAD tools to re-establish the link.

- **Q: What does the color change mean?**
  - A: The color change to orange indicates that the beam's "Panhand" (parent handle) has been cleared, meaning it is now a free-standing element no longer controlled by the parent layout.
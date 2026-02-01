# hsb_BoxBlock.mcr

## Overview
This script automates the creation of box blocks within timber wall elements. It identifies specific beams marked as "BOXBLOCK", splits them, and inserts new top and bottom block components with predefined material properties.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the 3D model. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities:** At least one hsbCAD Element containing Beams.
- **Beam Configuration:** Beams intended for box block generation must have the `beamCode` property starting with "BOXBLOCK".
- **Orientation:** The target beams must be aligned parallel to the Element's local Y-axis.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_BoxBlock.mcr` from the file browser.

### Step 2: Select Elements
```
Command Line: Please select Elements
Action: Click on the wall elements (or use a crossing window) that contain the beams marked "BOXBLOCK". Press Enter to confirm selection.
```

### Step 3: Automatic Processing
Once elements are selected, the script automatically:
1. Filters beams for the code "BOXBLOCK".
2. Calculates split points and block spacing.
3. Splits the original beams.
4. Creates new Top and Bottom box block beams.
5. Erases itself from the drawing.

## Properties Panel Parameters
This script does not expose editable parameters in the Properties Palette. It uses internal constants (Length: 200mm, Material: CLS, Grade: C16).

## Right-Click Menu Options
This script does not add custom options to the right-click menu. Since it erases itself after execution, standard hsbCAD entity editing options apply to the resulting beams only.

## Settings Files
No external settings files are required for this script.

## Tips
- **Beam Code:** Ensure the beams you wish to modify are strictly named with the prefix "BOXBLOCK" (case-insensitive check).
- **Orientation:** Verify that the beams run parallel to the element's local Y-axis. Beams running in other directions will be ignored by the script.
- **Script Removal:** The script instance deletes itself immediately after generating the blocks. If you need to make changes, you must undo (Ctrl+Z) and re-run the script.

## FAQ
**Q: The script ran but didn't create any blocks. Why?**
A: Check that the target beams have the correct `beamCode` ("BOXBLOCK") and that they are oriented correctly relative to the element (Beam X-axis parallel to Element Y-axis).

**Q: Can I edit the length of the blocks after the script runs?**
A: Yes. The resulting box blocks are standard beams. You can select them and manually adjust their geometry or properties in the Properties Palette.

**Q: Where did the script instance go after I ran it?**
A: By design, this script erases itself after processing to clean up the drawing. The generated blocks remain as independent entities.
# hsb_SIP-JoinBottomPlate.mcr

## Overview
This script automatically joins separate bottom plate and pressure-treated soleplate segments within a selected SIP panel into single continuous beams. It runs once and then removes itself to clean up the drawing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D Element and Beam objects. |
| Paper Space | No | Not applicable to layouts. |
| Shop Drawing | No | This script does not generate 2D views or annotations. |

## Prerequisites
- **Required Entities**: An Element (representing a SIP panel) containing beams.
- **Beam Types**: The Element must contain beams designated as "Bottom Plates" (`_kPanelBottomPlate`) or "Pressure Treated Soleplates" (`_kPanelPressureTreatedPlate`).
- **Geometry**: Beams must be collinear and touching or overlapping to be joined successfully.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT`
**Action**: Browse to the file `hsb_SIP-JoinBottomPlate.mcr`, select it, and click **Open**.

### Step 2: Select Element
```
Command Line: Select Element
Action: Click on the desired SIP panel in the model.
```
**Result**:
- The script scans the selected panel.
- If valid bottom plates or soleplates are found, they are merged into single beams.
- The script instance automatically deletes itself.
- If the panel is empty or contains no valid beam types, the script exits silently.

## Properties Panel Parameters

This script does not expose any parameters to the Properties Panel (OPM).

## Right-Click Menu Options

This script does not add any options to the Right-Click context menu.

## Settings Files

This script does not require external settings files.

## Tips
- **Single-Use Script**: This script is designed to run only once upon insertion. You do not need to manually delete it from the element.
- **Visual Check**: After running, verify that the bottom plates are now represented by single beams spanning the full length of the wall.
- **Safety Limit**: The script has a safety limit of 100 join operations per plate type. If you receive an error message "Safety Limit reached," check for gaps between beams or misalignments that might prevent the join operation.

## FAQ
- **Q: What happens if I select a panel that has already been processed?**
  A: The script will find no segments to join (since they are already single beams) and will simply delete itself, leaving the panel unchanged.
- **Q: Why did the script disappear after I selected the element?**
  A: This is intended behavior. The script performs its task and removes its instance automatically to keep the drawing clean.
- **Q: I received an error message about joining soleplates. What should I do?**
  A: This indicates a geometry issue preventing the join (e.g., beams are not collinear or are too far apart). Check the soleplate geometry in the selected panel and try again.
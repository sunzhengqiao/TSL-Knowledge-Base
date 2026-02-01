# GE_BEAM_REMOVE_PANHAND

## Overview
This script disconnects selected structural beams from their associated wall layout lines (panhandles). It converts wall-generated beams into standalone elements, preventing them from being automatically updated or controlled by the original wall definition.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the 3D model. |
| Paper Space | No | Not supported in drawing layouts. |
| Shop Drawing | No | Not applicable for shop drawing views. |

## Prerequisites
- **Required Entities**: At least one existing hsbCAD Beam that is currently linked to a panhandle (wall layout line).
- **Minimum Beam Count**: 1.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse to and select `GE_BEAM_REMOVE_PANHAND.mcr`.
3. Click **Open**.

### Step 2: Select Beams
```
Command Line: select a set beams
Action: Click on the beams you wish to detach from the wall layout control. Press Enter when selection is complete.
```

### Step 3: Completion
The script automatically processes the selected beams, removes their link to the panhandle, and then erases itself from the drawing. A message displaying the count of affected beams will appear in the command line history.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script has no editable properties in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not add specific items to the right-click context menu. |

## Settings Files
- **Filename**: None.
- **Location**: N/A.
- **Purpose**: This script operates without external settings files.

## Tips
- **"Fire and Forget" Script**: It is normal for this script instance to disappear immediately after processing. This indicates it has successfully finished its task.
- **Independent Editing**: Use this script when you need to modify a specific wall beam (e.g., changing its length or position) without affecting the rest of the wall or being overwritten by wall updates.
- **Verification**: After running the script, you can verify the disconnection by editing the wall layout line; the detached beam should no longer move or update.

## FAQ
- **Q: Does this delete my beam?**
  **A:** No. The script only removes the logical link between the beam and the wall control line. The physical beam remains in the model.
- **Q: Can I undo this action?**
  **A:** You can use the standard AutoCAD `UNDO` command immediately after running the script if you made a mistake.
- **Q: How do I put the beam back on the wall?**
  **A:** You generally cannot simply "re-attach" it. You would typically need to delete the detached beam and regenerate the wall section, or manually adjust the beam to match the wall layout.
# HSB_G-RemovePosnumSubMaps.mcr

## Overview
This script clears the position numbering ('Posnum') sub-map data from all entities contained within the current selection or group. It is typically used to batch-reset position numbers to force a re-calculation or to clean up data before generating new shop drawings.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for entity processing. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not intended for 2D layouts. |

## Prerequisites
- **Required Entities**: A selection of entities (beams, walls, etc.) must be grouped or selected before running the script.
- **Minimum Beam Count**: 0 (Works on any group size).
- **Required Settings**: None.

## Usage Steps

### Step 1: Prepare Selection
1.  In the AutoCAD Model Space, select the timber elements or entities you wish to process.
2.  Ensure these elements are recognized as a group or active selection set.

### Step 2: Launch Script
1.  Type `TSLINSERT` in the command line and press Enter.
2.  Browse to and select `HSB_G-RemovePosnumSubMaps.mcr`.
3.  The script will automatically execute on the selected group.
4.  The script instance will self-delete immediately upon completion.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| *None* | - | - | This script has no user-editable properties. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add specific context menu options. |

## Settings Files
- **None**: This script does not use external settings files.

## Tips
- **Grouping**: Ensure your elements are correctly grouped before execution. If no group is detected, the script may not find any entities to process.
- **Re-numbering**: Use this script before running an automatic numbering macro to ensure a clean slate for position numbers.
- **Self-Cleaning**: This script automatically removes itself from the drawing after running; do not be alarmed if the script entity disappears immediately.

## FAQ

- **Q: Does this script delete my geometry?**
  **A**: No. It only removes the specific "Posnum" data attached to the entities. The physical beams and elements remain unchanged.

- **Q: How do I know it worked?**
  **A**: You can verify by checking the properties of an element. The position number fields associated with that entity should be empty or reset.

- **Q: Can I undo this action?**
  **A**: Yes, you can use the standard AutoCAD `UNDO` command to restore the sub-map data if the script was run recently.
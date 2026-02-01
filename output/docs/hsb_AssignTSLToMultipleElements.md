# hsb_AssignTSLToMultipleElements.mcr

## Overview
This utility script allows you to take an existing TSL script instance (such as a specific connector or machining configuration) from your model and apply it to a group of selected construction elements at once. It is ideal for bulk-applying connection logic or manufacturing details to multiple beams or panels without having to insert and configure them individually.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the 3D model. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | Not intended for 2D drawing generation. |

## Prerequisites
- **Required Entities**:
  - At least one existing **TSL Instance** (Source) already inserted in the model to copy logic from.
  - At least one **Element** (Target) (e.g., beams, walls, panels) to assign the script to.
- **Minimum Beam Count**: 0
- **Required Settings Files**: None

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Navigate to the script location and select `hsb_AssignTSLToMultipleElements.mcr`.

### Step 2: Select Source TSL
```
Command Line: Select a TSL
Action: Click on an existing TSL instance in your model that has the desired configuration (e.g., a specific connector or machining point) that you want to copy.
```

### Step 3: Select Target Elements
```
Command Line: Select a set of elements
Action: Select one or more construction elements (beams, walls, etc.) that you want to attach the selected script to. Press Enter to confirm the selection set.
```

### Step 4: Completion
The script will automatically assign the logic from the Source TSL to all selected Target Elements. The script instance used to run this command will remain in the model but can be deleted if no longer needed.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not have editable parameters in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | No specific context menu items are added by this script. |

## Settings Files
This script does not use external settings files.

## Tips
- **Template Usage**: Configure one connector or machining detail exactly how you want it (correct offsets, sizes, etc.), then use this script to apply that "perfect" setup to many other elements.
- **Visibility**: Ensure the layer containing your Source TSL is thawed and unlocked, otherwise you cannot select it in Step 2.
- **Cleanup**: Since the script instance itself remains in the drawing after running (similar to a standard insert), you can safely delete the `hsb_AssignTSLToMultipleElements` instance from the model once you have finished the assignment to keep your drawing clean.

## FAQ
- **Q: What happens if I select the wrong TSL as the source?**
  A: You cannot undo the assignment using the standard AutoCAD Undo command immediately after running if elements have already regenerated. However, you can select the affected elements and use the "Erase TSL" or similar commands in hsbCAD to remove the incorrectly assigned scripts, then re-run this tool.
- **Q: Can I apply this to nested elements?**
  A: This script applies the TSL to the elements you select in Step 3. If those elements are part of a larger assembly, ensure you are selecting the exact structural elements you wish to modify.
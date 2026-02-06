# hsb_LockBeams.mcr

## Overview
This script visually marks a selection of timber beams as "locked" or finalized by changing their color to a specific index and synchronizing their pan data with their associated elements. It is useful for distinguishing completed design work from active modifications.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model elements. |
| Paper Space | No | Not designed for layout or detailing views. |
| Shop Drawing | No | Not intended for manufacturing drawings. |

## Prerequisites
- **Required Entities**: GenBeam (Timber beams) must exist in the model.
- **Minimum Beam Count**: 1 (You must select at least one valid beam for the script to take effect).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select the file `hsb_LockBeams.mcr`.

### Step 2: Select Beams
Command Line: `Select a set of entities`
Action: Click on the timber beams (GenBeams) you wish to lock or mark. You can select multiple beams. Once your selection is complete, press `Enter` or right-click and select "Go".

### Step 3: Processing
Action: The script will automatically process the selected beams. It will change their color to Index 233 and update their properties. The script instance will then remove itself from the drawing automatically.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not create a persistent instance or expose properties to the Properties Palette. It runs once and terminates. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | No custom context menu options are added by this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Color Visibility**: Ensure your AutoCAD visual style or layer settings allow you to see the specific "By Object" color, otherwise the change to Color Index 233 might not be visible.
- **Validation**: If you select non-beam entities (like lines or text), the script will ignore them and only process valid timber beams.
- **Workflow**: This is a "fire and forget" tool. Once you select the beams, the script applies the changes and closes immediately; you do not need to manually delete the script instance.

## FAQ
- **Q: What color index is used?**
  A: The script sets the selected beams to Color Index 233.
- **Q: I selected beams but nothing happened.**
  A: Ensure you selected valid `GenBeam` entities and not other objects. Also, check if your layer colors are overriding entity colors.
- **Q: Can I undo this action?**
  A: Yes, you can use the standard AutoCAD `UNDO` command to revert the color and property changes if needed.
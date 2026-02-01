# assignMepItemsToGroup.mcr

## Overview
This script automatically organizes MEP (Mechanical, Electrical, and Plumbing) items by assigning them to the correct structural elements or module floor groups based on their physical location within the model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in Model Space. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**:
  - **Elements**: Structural timber elements (e.g., walls, floors) must be present in the model.
  - **MEP Items**: TSL instances specifically named `mepitem` must be present.
- **Minimum Entities**: At least 1 Element must exist in the drawing.
- **Required Settings**:
  - Elements must have the MapKey `text.modul` assigned to define module names.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or select from hsbCAD TSL palette) → Select `assignMepItemsToGroup.mcr`

### Step 2: Automatic Execution
```
Command Line: Script initiates automatically.
Action: The script processes the drawing without further prompts.
```
*Note: Do not wait for command line input. The script will scan the model, update group assignments, report the number of items processed to the command line history, and delete itself immediately upon completion.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script runs a batch process and deletes itself. It has no persistent properties to edit. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not remain in the drawing; thus, it has no context menu options. |

## Settings Files
- **Filename**: None.
- **Location**: N/A.
- **Purpose**: This script relies on existing MapKeys (`text.modul`) within the drawing elements rather than external settings files.

## Tips
- **MapKey Setup**: Ensure your structural elements have the `text.modul` MapKey populated correctly. If this MapKey is missing or invalid for a module, items inside that module's bounds will not be assigned to the Floor Group.
- **Script Naming**: This utility specifically looks for TSL instances named `mepitem`. Ensure your MEP accessories are generated using this script name.
- **Verification**: After running, check your Project Manager or Element hierarchy to verify that MEP items appear under the correct Element Groups or Floor Groups.

## FAQ
- **Q: I ran the script, but nothing happened and I can't find it.**
  **A**: This is normal behavior. `assignMepItemsToGroup.mcr` is a "fire and forget" utility. It performs the assignment and automatically erases itself from the drawing to prevent clutter.
- **Q: Why were some of my MEP items not assigned to a Floor Group?**
  **A**: Check the `text.modul` MapKey on the Elements in that area. The script skips Floor Group assignment if the Module Name is empty or contains the `@` character.
- **Q: Can I undo the changes?**
  **A**: Yes, you can use the standard AutoCAD `UNDO` command to revert the group changes made by the script.
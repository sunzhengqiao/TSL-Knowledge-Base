# HSB_E-RemoveModuleData.mcr

## Overview
This script clears the manufacturing module name from specific timber beams within a selected hsbCAD Element, based on a chosen manufacturing Zone index. It is used to dissociate groups of beams from a module without deleting the physical geometry.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model Elements and beams. |
| Paper Space | No | Not designed for 2D layouts or views. |
| Shop Drawing | No | Not intended for generating drawing views. |

## Prerequisites
- **Required Entities**: At least one valid hsbCAD `Element` existing in the model.
- **Minimum Beam Count**: 0 (The script targets data on the Element/Beams, not specific beam counts).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Navigate to the folder containing `HSB_E-RemoveModuleData.mcr` and select it.

### Step 2: Configure Zone Settings
1.  Before selecting elements, open your **Properties Palette** (Ctrl+1) if not already open.
2.  Look for the parameter **|Zone to change|** under the category **|Element Zone|**.
3.  Select the desired Zone index from the dropdown list (options 0 through 10).
    *   *Note: Values 0-5 correspond to standard zones. Values 6-10 are used for specific alternate zones (mapped internally to negative indices).*

### Step 3: Select Elements
```
Command Line: |Select elements|
Action: Click on the desired Element(s) in the drawing view and press Enter.
```
4.  The script will automatically process the selection, clear the module data for beams in the specified zone, and finish.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| |Zone to change| | Dropdown | 0 | Determines which manufacturing zone within the Element to process. The script will only remove module data from beams assigned to this specific zone index. |

## Right-Click Menu Options
This script does not add specific options to the entity right-click menu.

## Settings Files
No external settings files are required for this script.

## Tips
- **Data Loss**: This script removes data (the Module assignment). Ensure you have selected the correct Zone, as this action changes the production grouping of the beams.
- **Zone Mapping**: If you need to target "negative" zones (often used for alternate groupings in hsbCAD), select options 6 through 10. These map to zones -1 through -5 respectively.
- **Batch Processing**: You can select multiple Elements during the command prompt step. The script will apply the zone change to all selected Elements simultaneously.

## FAQ
- **Q: What exactly gets deleted?**
  - **A**: The script clears the text string in the 'Module' property for the beams located in the specified zone. It does not delete the beams themselves.
- **Q: I ran the script but nothing happened.**
  - **A**: Ensure you selected a valid hsbCAD Element and that the chosen zone actually contains beams. If the zone is empty or the element is invalid, the script will terminate without making changes.
- **Q: How do I undo this?**
  - **A**: You can use the standard AutoCAD `UNDO` command immediately after running the script to revert the changes.
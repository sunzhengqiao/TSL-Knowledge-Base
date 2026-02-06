# hsb_SetLooseBeamName

## Overview
This script is a utility tool used to batch rename a selection of loose beams to a specific identifier (such as B1, B2, etc.) in a single operation. It is useful for assigning assembly codes or names to groups of timber elements for better organization in lists and production data.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model entities. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Not applicable for shop drawing views. |

## Prerequisites
- **Required Entities**: Loose beams (GenBeam) must already exist in the model.
- **Minimum Beam Count**: 1
- **Required Settings**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SetLooseBeamName.mcr` from the file list and click Open.

### Step 2: Configure Beam Name
Before proceeding to the selection prompt, locate the **Properties Palette** (usually on the right side of the screen).
1. Find the property named **Beam Names**.
2. Click the dropdown menu and select the desired identifier (e.g., B1, B2, B3...).
3. Once set, the command line will proceed to the next step.

### Step 3: Select Beams
```
Command Line: Please select beams
Action: Click on the loose beams you wish to rename.
```
- You can select multiple beams.
- Once all beams are highlighted, press **Enter** or **Right-click** to confirm the selection.

### Step 4: Completion
The script will immediately apply the selected name to the 'Name' property of all chosen beams and then automatically delete its own instance from the model.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Beam Names | dropdown | B1 | The specific identifier code to apply to the selected beams. Options range from B1 to B20. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific options to the entity right-click menu. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A (Script uses internal fixed list for options).

## Tips
- **Set Property First**: Ensure you change the "Beam Names" property in the Properties Palette *before* you finish selecting the beams in the model. The value is locked in once you confirm the selection.
- **Self-Cleaning**: You do not need to delete the script instance after running; it removes itself automatically.
- **Batching**: You can window-select multiple beams at once during the selection step to rename them all rapidly.

## FAQ
- Q: Can I use a custom name not in the list (e.g., "Rafter1")?
  A: No, this script currently only supports the fixed list of options from B1 to B20.
- Q: What happens if I cancel the selection?
  A: The script will simply delete itself, and no changes will be made to your beams.
- Q: I ran the script, but nothing happened.
  A: Ensure you actually selected beams and pressed Enter. If you missed the selection step, the script exits silently.
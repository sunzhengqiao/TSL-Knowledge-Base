# hsb_SetBeamId.mcr

## Overview
This script allows you to quickly assign or update the internal ID (hsbId) for multiple selected beams simultaneously. It is useful for batch updating element numbers, production codes, or ERP references without editing each beam individually.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary environment for selecting and modifying 3D beams. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required entities**: At least one Beam must exist in the model to modify.
- **Minimum beam count**: 1 (The script will run without errors if 0 are selected, but no changes will be made).
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SetBeamId.mcr` from the file dialog.

### Step 2: Configure ID Value
```
Command Line: [Script instance appears in model]
Action: 
1. Ensure the script instance is selected.
2. Open the Properties Palette (Ctrl+1).
3. Locate the parameter "ID to set in the Beam".
4. Change the value from the default "999" to your desired identifier (e.g., "FL-01", "A-100").
```

### Step 3: Select Beams
```
Command Line: Select a set of beams
Action: 
1. Click to select individual beams or use a window selection to select multiple beams.
2. Press Enter or Spacebar to confirm the selection.
```

*(Note: The script will automatically apply the ID and erase itself after confirmation.)*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| ID to set in the Beam | Text | 999 | The specific alphanumeric code to assign to the selected beams' internal hsbId property. This does not change the physical geometry, only the data identifier. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script runs immediately upon insertion and interaction; it does not retain persistent context menu options. |

## Settings Files
None.

## Tips
- **Set ID First**: Modify the "ID to set in the Beam" property in the Properties Palette *before* clicking on the beams in the model. This ensures the correct ID is applied as soon as you make your selection.
- **Batch Updates**: You can use window selection (dragging from left to right) or crossing selection (dragging right to left) to update dozens of beams in a single operation.
- **Script Behavior**: The script instance will disappear automatically after processing the beams. This is normal behavior for a utility script.

## FAQ
- **Q: Can I use letters and numbers in the ID?**
  A: Yes, the ID parameter accepts any text string (e.g., "101", "Wall-A", "Mfg-Code").
- **Q: I accidentally included spaces in my ID. Will this cause errors?**
  A: No, the script automatically removes leading and trailing spaces from your input to ensure clean data.
- **Q: What happens if I cancel the selection?**
  A: If you press Esc instead of selecting beams, the script will simply erase itself without making any changes to the model.
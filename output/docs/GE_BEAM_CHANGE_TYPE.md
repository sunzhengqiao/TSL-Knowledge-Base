# GE_BEAM_CHANGE_TYPE.mcr

## Overview
This utility allows you to batch update the "Type" classification (e.g., Solid Timber, Glulam, CLT) of one or more existing beams in your model. It is useful for quickly correcting material assignments or converting generic beams to specific catalog types.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script interacts directly with beams in the 3D model. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities:** At least one existing Beam (`GenBeam`) in the drawing.
- **Minimum Beam Count:** 1
- **Required Settings:** Standard `_BeamTypes` catalog (default hsbCAD system catalogs).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or `TSL` depending on configuration) → Browse and select `GE_BEAM_CHANGE_TYPE.mcr`.

### Step 2: Select New Beam Type
1.  After loading the script, open the **Properties Palette** (Ctrl+1).
2.  Locate the parameter **New Beam Type**.
3.  Select the desired material type (e.g., "Glulam", "Solid Wood", "CLT") from the dropdown list.

### Step 3: Select Beams to Update
```
Command Line: Select beam(s)
Action: Click on the beams you wish to change. You can select multiple beams one by one or use a window selection.
```

### Step 4: Confirm Changes
1.  Press **Enter** or **Space** to confirm the selection.
2.  The script will update the selected beams and automatically remove itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| New Beam Type | dropdown | (First entry in list) | Select the target beam type (material classification) to apply to the selected beams. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add persistent items to the right-click menu. |

## Settings Files
- **Filename:** None
- **Location:** N/A
- **Purpose:** This script uses the internal hsbCAD `_BeamTypes` catalog; no custom XML settings files are required.

## Tips
- **Batch Processing:** You can select as many beams as needed in a single operation to speed up your workflow.
- **Undo:** You can use the standard AutoCAD `U` (Undo) command to revert the changes if you selected the wrong type or wrong beams.
- **Script Removal:** Do not be alarmed if the script "disappears" after pressing Enter. It is designed to delete itself (`eraseInstance`) immediately after updating the beams to keep your drawing clean.

## FAQ
- **Q: Does this script change the dimensions of the beam?**
  - **A:** It changes the *Type* property. Whether dimensions change depends on your catalog settings. If the new Type has different default profile logic, the beam may update, but it primarily affects material classification and machining defaults.
- **Q: Can I use this on elements other than beams?**
  - **A:** No, this script is specifically designed for `GenBeam` entities. Other elements like walls or panels will be ignored.
- **Q: Why didn't the beam change?**
  - **A:** Ensure that the beam you selected was not on a locked layer. Also, verify that you selected a valid "New Beam Type" from the dropdown before selecting the beams.
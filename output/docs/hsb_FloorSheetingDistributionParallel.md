# hsb_FloorSheetingDistributionParallel.mcr

## Overview
This script automatically redistributes floor or roof sheathing boards (e.g., OSB or Plywood) in a parallel pattern across a selected element. It optimizes the layout to minimize waste by calculating the most efficient cut positions and reusing offcuts in adjacent columns.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in 3D Model Space. |
| Paper Space | No | Not supported for drawing views. |
| Shop Drawing | No | Not supported for shop drawing generation. |

## Prerequisites
- **Required Entities**: An existing Element (Floor or Roof).
- **Existing Data**: The selected Element **must already have construction sheets generated** in the Zone specified by the `nZones` parameter (default is Zone 1). This script replaces/reorganizes existing sheets rather than creating them from scratch.
- **Minimum Beam Count**: 0 (This script manipulates sheet entities, not beams).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_FloorSheetingDistributionParallel.mcr`

### Step 2: Configure Settings (Dialog)
```
Dialog: Dynamic Configuration Dialog
Action: A dialog window may appear upon insertion. Adjust the Sheathing Width, Length, Thickness, and Distribution Location as needed. Click OK to proceed.
```

### Step 3: Select Elements
```
Command Line: Select one, or more elements
Action: Click on the Floor or Roof elements in the model that you wish to apply the sheathing distribution to. Press Enter to confirm selection.
```

### Step 4: Automatic Calculation
```
Action: The script attaches to the selected elements and automatically recalculates the sheet layout based on the properties. Existing sheets in the target zone are erased and replaced by the new optimized distribution.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Distribution location | dropdown | Top left | Sets the origin corner for the sheathing layout and the direction of the run (e.g., Top-Left runs towards Bottom-Right). |
| Zone to Redistribute the Sheets | number | 1 | Specifies which construction layer (Zone) to replace. Ensure the element has sheets in this zone before running. |
| Sheathing Width | number | 600 | The standard width of the raw board material (e.g., 600mm). |
| Sheathing Length | number | 2400 | The standard length of the raw board material (e.g., 2400mm). |
| Sheathing Thickness | number | 22 | The thickness of the sheathing material. |
| Minimum sheet length | number | 100 | The smallest permissible length for a usable cut piece. Shorter leftovers are trimmed or handled differently. |
| Mininum sheet width | number | 150 | The smallest permissible width for the last board in a row. Prevents narrow strips. |
| Trim waste length by | number | 4 | Tolerance used to decide if a leftover piece is effectively "full length" and can be reused as a new board. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Redistribute Sheets | Deletes the current sheathing layout in the assigned zone and recalculates it from scratch using the current Property values. |

## Settings Files
None. This script relies on Properties and user input.

## Tips
- **Existing Sheets Required**: If the script seems to do nothing, check the `nZones` property. The element must already have sheets generated in that specific zone (often done via the "Generate Construction" tool) for this script to redistribute them.
- **Optimization**: The script automatically attempts to use offcuts from the end of one row to start the next, creating a staggered (running bond) effect where possible.
- **Corner Logic**: Use the `Distribution location` property to flip the entire pattern. For example, switch from "Top left" to "Bottom right" if you want the full sheets to start at the opposite end of the floor.

## FAQ
- **Q: Why did the script not create any sheets?**
  A: This script redistributes *existing* sheets. You must first generate construction sheets on the element (e.g., using the standard Floor or Roof generation tools) into the Zone defined in the properties (default Zone 1).
  
- **Q: How do I change the board size?**
  A: Select the element, open the Properties Palette (Ctrl+1), find the script instance, and modify the `Sheathing Width` or `Sheathing Length`. Then right-click and select "Redistribute Sheets".

- **Q: The last row is very narrow. How do I fix that?**
  A: Increase the `Mininum sheet width` property. The script will then adjust the previous columns to ensure the last column meets this minimum width requirement.
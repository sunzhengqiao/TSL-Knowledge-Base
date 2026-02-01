# GE_WALL_SPLIT_BY_LENGTH.mcr

## Overview
This script automatically splits long wall elements into shorter segments suitable for manufacturing or transport. It ensures that splits respect specific safety distances from wall openings (windows/doors) and wall edges to maintain structural integrity.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is where the script must be run. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: Existing Wall elements (hsbCAD Elements) in the model.
- **Minimum Beam Count**: At least one wall element.
- **Required Settings**: None required; all parameters are set via the Properties Palette.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT` → Select `GE_WALL_SPLIT_BY_LENGTH.mcr`

### Step 2: Configure Parameters
**Action**: Upon running the script, the Properties Palette (OPM) will appear.
*   Adjust the **Max. Wall Length**, **Min. Distance to Opening**, and **Min. Distance to Wall Edge** as required for your project.
*   Choose whether to **Frame walls after split**.

### Step 3: Select Walls
```
Command Line: Please select the elements
Action: Click on the wall element(s) you wish to split and press Enter.
```

**Result**: The script will process the selected walls, creating splits at valid locations. If "Frame walls after split" was set to "Yes", the framing for the new segments will be automatically generated.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Max. Wall Length | Number | 3600 | The maximum allowable length for a single wall panel (e.g., for transport or machine limits). |
| Min. Distance to Opening | Number | 300 | The minimum "keep-out" zone around windows/doors. Splits will not be placed closer than this distance to an opening. |
| Min. Distance to Wall Edge | Number | 300 | The minimum allowable length for the start or end segment of a wall. Prevents tiny unusable wall slivers. |
| Frame walls after split | Dropdown | Yes | If "Yes", the script automatically generates the timber framing (studs/plates) for the new wall segments. If "No", only the outline is split. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific items to the entity context menu. |

## Settings Files
- **None Required**: This script operates independently without external settings files.

## Tips
- **Check Openings**: If a wall has windows or doors placed very close together, the script may fail to split the wall if there is no gap large enough to satisfy the "Max. Wall Length" minus the "Min. Distance to Opening" on both sides.
- **Units**: The parameters are in millimeters (mm). Ensure you account for unit conversion if working in imperial, though the script handles internal unit independence.
- **Performance**: If generating framing automatically ("Yes"), processing a large number of complex walls may take a moment.

## FAQ
- **Q: Why didn't my wall split?**
  - **A**: The wall might be shorter than the specified "Max. Wall Length," or the openings might be positioned such that there is no valid spot to cut without violating the safety distances.

- **Q: Can I undo the changes?**
  - **A**: Yes, you can use the standard AutoCAD `UNDO` command to revert the wall splits and framing generation.

- **Q: What happens if the script cannot find a valid split point after 30 tries?**
  - **A**: The script will report an error for that specific wall and stop splitting it, leaving it in its original state to prevent errors.
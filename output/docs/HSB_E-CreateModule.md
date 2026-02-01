# HSB_E-CreateModule.mcr

## Overview
This script automatically groups specific generic beams (GenBeams) within a selected construction Element into logical "Modules" based on a filter catalog. It assigns a specific naming convention and a visual color to the beams to organize them for production planning or export filtering.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D Elements and GenBeams. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This is a model management tool. |

## Prerequisites
- **Required Entities**: At least one Element (Wall/Floor/Roof) containing Generic Beams (GenBeams).
- **Required Settings**: The script `HSB_G-FilterGenBeams` must be loaded in the drawing, and the relevant Filter Catalogs must be defined.

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT`
**Action:** Browse and select `HSB_E-CreateModule.mcr`.

### Step 2: Configure Properties
**Action:** A configuration dialog will appear (or you can configure later via the Properties palette).
1.  **GenBeam filter catalog**: Select the filter rule set (e.g., "TopChords", "Rafters") from the dropdown. This determines which beams inside the element are included in the module.
2.  **Color**: Set the desired AutoCAD Color Index (e.g., 2 for Yellow) to visually highlight the grouped beams.
3.  Click **OK** to confirm.

### Step 3: Select Element
```
Command Line: Select element(s)
```
**Action:** Click on the Element(s) in the model that contain the beams you wish to group.
**Result:** The script processes the selection, identifies the relevant beams, assigns them a Module Name (e.g., `ElementNumber_Index`), and changes their color.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **GenBeam filter catalog** | Dropdown | "" | Selects the logic rule set (from `HSB_G-FilterGenBeams`) to determine which beams belong to this module. |
| **Color** | Number | 2 | Sets the visual display color (AutoCAD Color Index 0-255) of the beams assigned to the module. |
| **ShrinkDistance** | Number | 5 | A clearance offset (in mm) applied to the geometric boundary to ensure touching or slightly overlapping modules are distinct. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **ManualInsert** | Re-runs the grouping logic using the currently selected properties and element geometry to update the module assignments, then erases the script instance. |

## Settings Files
- **Dependency**: `HSB_G-FilterGenBeams.tsl`
- **Location**: Must be loaded in the current hsbCAD drawing.
- **Purpose**: Provides the filtering logic (Catalogs) required to select which specific beams are grouped into the module.

## Tips
- **Visual Verification**: Use the **Color** property to quickly verify if the correct beams are being grouped by the selected filter catalog.
- **Dependency Check**: If the script fails to group beams, ensure `HSB_G-FilterGenBeams` is loaded in the drawing.
- **Boundary Issues**: If separate groups of beams are accidentally merging into one module, try increasing the **ShrinkDistance** value slightly.

## FAQ
- **Q: Why didn't the beams change color or get a name?**
  A: Ensure that the `HSB_G-FilterGenBeams` script is loaded in the drawing and that the selected "GenBeam filter catalog" actually matches beams within your element.
- **Q: How do I undo the grouping?**
  A: You can select the beams and manually clear the Module property, or run the script again with a different configuration to overwrite the previous assignment.
- **Q: What does the Module Name look like?**
  A: The script automatically generates a name in the format `ElementNumber_Index` (e.g., `1005_1`).
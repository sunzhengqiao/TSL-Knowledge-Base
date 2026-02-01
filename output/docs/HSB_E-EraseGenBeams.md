# HSB_E-EraseGenBeams

## Overview
A batch deletion utility that selectively removes Generic Beams (GenBeams) from selected Elements based on predefined filter criteria. This tool is ideal for cleaning up specific types of temporary or incorrect beams (e.g., formwork, bracing) within a structural element in bulk.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model entities. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Not designed for detail drawing generation. |

## Prerequisites
- **Required Entities**: Element (to define the scope of the search) and GenBeam (entities to be deleted).
- **Minimum Beam Count**: 0 (The script searches for beams to delete; it does not require existing beams to run).
- **Required Settings**:
  - The script `HSB_G-FilterGenBeams` must be loaded and compiled in the current drawing.
  - Filter definitions must be configured in the catalog used by `HSB_G-FilterGenBeams`.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-EraseGenBeams.mcr`

### Step 2: Configure Filter (if applicable)
```
Dialog: Script Properties
Action: If running manually (without a preset Execute Key), a dialog appears. Select the desired 'Filter definition for GenBeams' from the dropdown list to specify which beams to target.
```

### Step 3: Select Element
```
Command Line: Select element(s)
Action: Click on the Element(s) in the model that contain the beams you wish to erase. Press Enter to confirm selection.
```

### Step 4: Execution
The script will automatically apply the filter, identify matching beams, and erase them from the model.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Filter definition for GenBeams | Dropdown | [Empty] | Selects the specific criteria (rule set) used to identify which beams should be deleted. Options are populated from the external filter script (e.g., filtering by beam name, material, or size). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| ManualInsert | Re-runs the beam erasing logic using the currently selected filter properties on the attached Element. |

## Settings Files
- **Dependency**: `HSB_G-FilterGenBeams.tsl`
- **Location**: Must be loaded in the current hsbCAD drawing environment.
- **Purpose**: Provides the logic and catalog entries for filtering beam entities.

## Tips
- **Verify Dependencies**: Ensure `HSB_G-FilterGenBeams` is loaded; otherwise, this script will fail with a warning.
- **Undo**: You can use the standard AutoCAD `UNDO` command to restore beams if you accidentally delete the wrong ones.
- **Catalog Setup**: Check your Filter catalog to ensure the definition correctly targets the beams you intend to delete before running the script on large assemblies.

## FAQ
- **Q: The script reports "GenBeams could not be filtered!" What do I do?**
  A: This means the script `HSB_G-FilterGenBeams` is not loaded in your drawing. You need to insert and compile `HSB_G-FilterGenBeams` first.
- **Q: No beams were deleted even though I selected an element.**
  A: Check your "Filter definition for GenBeams" setting. It is likely that no beams within the selected element currently match the criteria defined in that filter.
- **Q: Can I use this to delete structural beams?**
  A: Yes, if a filter definition exists that matches those structural beams. Use with caution and ensure your filter is specific enough to avoid unintended data loss.
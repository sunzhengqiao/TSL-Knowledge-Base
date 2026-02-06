# hsbMetalPart-Properties

## Overview
This script automates the assignment of position numbers (PosNum), names, dimensions, and physical properties (volume, weight, surface area) to metal parts such as MassGroups, GenBeams, and Sheets. It is essential for preparing accurate Bill of Materials (BOM) data and production labels.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script processes 3D entities in the model. |
| Paper Space | No | Not designed for layout space. |
| Shop Drawing | No | Not intended for drawing annotations. |

## Prerequisites
- **Required Entities**: MassGroups, GenBeams, Beams, Sheets, or Panels present in the model.
- **Property Set Definition**: The drawing catalog must contain a Property Set Definition (e.g., `hsbMetalPart`) with the following fields: `POSNUM`, `GROSVOLUME`, `NAME`, `GROSWEIGHT`, `SURFACE`, `LENGTH`, `WIDTH`, `HEIGHT`.
- **Minimum Count**: At least one valid entity must be selected.

## Usage Steps

### Step 1: Launch Script
Execute the command `TSLINSERT` and select `hsbMetalPart-Properties.mcr` from the list.

### Step 2: Configure Options (Optional)
Immediately after insertion, you can change the numbering settings in the **Properties Palette** (Ctrl+1) before proceeding to the next step.
- Adjust **Start Number Parent** or **Start Number Child** if needed.
- Toggle **Keep existing PosNum** to `Yes` if you want to preserve manual numbering.

### Step 3: Select Entities
```
Command Line: Select a set of metalparts (Massgroups, Beams, Sheets)
Action: Click on the desired entities in the model or drag a selection window. Press Enter to confirm.
```
*(Note: The script instance will automatically disappear from the drawing after processing is complete.)*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Start Number Parent | number | 1 | The starting position number for the main or parent metal parts (e.g., the main plate of a connection). |
| Start Number Child | number | 100 | The starting position number for nested parts (e.g., bolts or stiffeners inside a MassGroup). |
| Keep existing PosNum | dropdown | No | If set to `Yes`, the script will skip entities that already have a position number. If `No`, all selected entities will be renumbered. |
| Automatic Naming | dropdown | No | If set to `Yes`, automatically generates the `NAME` property (e.g., "Part 1", "Part 100.1") based on the position number. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| ALL | Automatically selects all MassGroup entities in the entire Model Space for processing. |
| releasePosNum | Prompts you to select entities and removes their existing Position Numbers (PosNum). |

## Settings Files
- **None**: This script does not rely on external XML settings files. It relies on the standard hsbCAD Property Set Definitions configured in your project or catalog.

## Tips
- **Renumbering Strategy**: Use the **Keep existing PosNum** option set to `Yes` when you have manually numbered critical parts but want to auto-number the rest of the assembly.
- **Cleaning Data**: Use the **releasePosNum** right-click option to strip all numbering from a selection before running a completely new numbering sequence.
- **Dimensions Calculation**: The script automatically detects the correct orientation (using ECS Markers or local beams) to calculate accurate Length, Width, and Height for nested parts.
- **GenBeam Names**: If **Automatic Naming** is enabled and the entity is a GenBeam, the script attempts to copy the GenBeam's name to the property set.

## FAQ
- **Q: Why did the script icon disappear immediately?**
  - A: This is a "utility" script. It runs once to update the data and then automatically erases itself from the drawing to keep your model clean.
- **Q: The properties were not updated. What went wrong?**
  - A: Check if the correct Property Set Definition is attached to the entities and contains the required fields (specifically `POSNUM`). The script removes property sets that do not contain the required fields.
- **Q: Can I number beams and panels with this script?**
  - A: Yes, the script supports numbering for Beams, Sheets, and Panels if they are identified as parent entities.
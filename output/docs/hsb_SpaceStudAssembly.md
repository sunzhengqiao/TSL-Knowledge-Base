# hsb_SpaceStudAssembly.mcr

## Overview
This script aggregates a selection of structural members (studs, sheets, and plates) into a single logical "Space Stud" or "Group" subassembly. It automatically generates a unique production name and modifies beam codes to ensure correct data export for manufacturing and CNC processes.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be inserted in the 3D model where the structural members exist. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This is a model-level script for pre-production. |

## Prerequisites
- **Required Entities**: At least one GenBeam (Beam), optionally Sheets or TslInst entities to be included in the assembly.
- **Minimum Beam Count**: 1
- **Required Settings**: None required (script handles defaults internally).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SpaceStudAssembly.mcr`

### Step 2: Insertion
```
Command Line: [Insertion point usually implied or clicks to locate the assembly]
Action: Click to place the script instance near or on the primary beam of the desired assembly.
```
*Note: The script automatically aligns its coordinate system to the primary beam it detects or is attached to, and gathers connected entities into the group.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | String | Empty String (Space Stud) | **Space Stud (Empty)**: Prefixes beam codes with 'SS' and sets sub-labels. **Group**: Preserves original beam codes and groups data differently. |
| Width | Number | Read from Material | The material width (thickness) of the assembly members. Used for export data. |
| Height | Number | Read from Material | The material height (depth) of the assembly members. Used for export data. |
| Length | Number | Auto-Calculated | The overall length of the assembly, determined by the longest beam. Updates automatically if geometry changes. |
| SubAssemblyName | String | Auto-Generated | A unique identifier (e.g., "Length-Angle") used to group identical assemblies in production lists. Read-only. |

## Right-Click Menu Options
This script does not add specific custom options to the right-click context menu. Use the Properties palette to modify parameters.

## Settings Files
No external settings files are used by this script.

## Tips
- **Switching Modes**: Use the **Type** property in the Properties palette. Select "Group" if you want to keep original beam naming (e.g., for standard walls), or leave it blank (Space Stud) to enforce "SS" naming for specialized assemblies.
- **Geometry Updates**: If you stretch or modify the beams in the assembly, the script will automatically recalculate the **Length** and **SubAssemblyName**. This ensures your production lists always reflect the current geometry.
- **Automatic Deletion**: If you delete a beam that belongs to this assembly, the script instance will erase itself on the next update/calculation to prevent data corruption.

## FAQ
- **Q: Why did my script instance disappear?**
  **A**: This usually happens if a beam within the assembly was deleted. The script validates the number of beams; if the count changes, it erases itself. Re-insert the script on the remaining geometry.
- **Q: How do I change the material size in the export data?**
  **A**: Select the script instance, open the Properties (OPM), and manually adjust the **Width** or **Height** parameters. These values are exported to the production database.
- **Q: What is the difference between "Space Stud" and "Group" modes?**
  **A**: In "Space Stud" mode, the script renames your beams to start with "SS" (e.g., SS-01). In "Group" mode, your original beam names are preserved. Choose "Group" if you want to organize existing frames without renaming them.
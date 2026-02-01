# AssemblyDefinition

## Overview
Groups a selection of timber elements (GenBeams or Elements) into a single logical assembly unit for production and logistics. It automatically calculates dimensions, weight, and manages numbering for the grouped parts.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model entities. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | While it provides data for shop drawings, it is inserted in the model. |

## Prerequisites
- **Entities**: Structural GenBeams or Elements must exist in the model.
- **Minimum Count**: 0 (Script allows creating empty assemblies, but typically requires at least 1 beam to calculate data).
- **hsbCAD Version**: 27.3.4 or higher (recommended for proper data cleanup).

## Usage Steps

### Step 1: Launch Script
**Command**: `hsb_ScriptInsert`
**Action**: Select `AssemblyDefinition.mcr` from the file list.

### Step 2: Define Assembly Origin
```
Command Line: Pick insertion point:
Action: Click in the model to place the assembly's coordinate system (local origin).
```

### Step 3: Select Assembly Members
```
Command Line: Select beams/elements:
Action: Select the timber parts (beams, panels) you want to include in this assembly.
```

### Step 4: Confirm Selection
```
Command Line: Continue with empty assembly? [Yes/No]
Action: 
- If you selected items: This prompt usually skips automatically.
- If you selected 0 items: Type 'Yes' to create an empty placeholder assembly or 'No' to cancel.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sFormat | String | `ASS-@(PosNum)` | The naming template for the assembly (e.g., "Pack-1"). |
| sPrefixFormat | String | `F-@(_kModelSpaceIndex)` | Grouping prefix code (e.g., "Floor1-") added to the name. |
| nPrefixIndex | Integer | 1 | Auto-incrementing number used with the prefix to ensure unique names. |
| dWeight | Double | 0.0 | **(Read Only)** Total weight of all elements in the assembly. |
| Length | Double | 0.0 | **(Read Only)** Physical length of the assembly bounding box (X-axis). |
| Width | Double | 0.0 | **(Read Only)** Physical width of the assembly bounding box (Y-axis). |
| Height | Double | 0.0 | **(Read Only)** Physical height of the assembly bounding box (Z-axis). |
| nStartPosNum | Integer | 1 | The starting position number for the main assembly. |
| nStartPosNumItems | Integer | 1 | The starting number used for renumbering the parts inside this assembly. |
| sStrategy | String | `Select` | Method to group entities: `Select` (fixed list) or `byContact` (includes touching parts). |
| sInformation | String | Empty | Free text field for notes or instructions for production. |
| dScale | Double | 1.0 | Visual scale factor for the drawn X/Y/Z axes in the model. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add Entities | Opens a selection box to add new beams/elements to the current assembly. Updates weight and dimensions. |
| Remove Entities | Prompts you to select items currently in the assembly to remove them. |
| Renumber Items | Resets the position numbers of all parts inside the assembly based on `nStartPosNumItems`. |
| Update Assembly | Forces a recalculation of the bounding box and weight without changing the entity list. |

## Settings Files
- **Filename**: None specified.
- **Location**: N/A
- **Purpose**: This script relies on internal hsbCAD entity data and properties rather than external XML configuration files.

## Tips
- **Dynamic Grouping**: Set `sStrategy` to `byContact` if you want the assembly to automatically grab new beams that physically touch the existing members.
- **Organizing Floors**: Use the `sPrefixFormat` (e.g., "Floor1-") combined with `nPrefixIndex` to automatically number different assemblies on the same level (Floor1-1, Floor1-2).
- **Visibility**: If the assembly axes are too small to see, increase the `dScale` property in the properties palette.

## FAQ
- **Q: Why is my assembly weight 0.0?**
  **A**: The assembly may have no entities assigned. Use the "Add Entities" right-click option to select timber parts.
- **Q: How do I rename the assembly without changing the numbering?**
  **A**: Modify the `sFormat` property. You can use static text (e.g., "RoofTruss") or variables like `@(PosNum)`.
- **Q: What happens if I delete a beam that is part of an assembly?**
  **A**: The script automatically detects missing entities. On the next update, it will recalculate the dimensions and weight based on the remaining parts.
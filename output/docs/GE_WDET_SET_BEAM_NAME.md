# GE_WDET_SET_BEAM_NAME.mcr

## Overview
A utility script that standardizes the naming, color coding, material assignment, and labeling of beams within timber wall elements. It enforces project naming conventions (e.g., "STUD", "TOP PLATE") and updates properties for BOM and production reports.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used to modify ElementWall entities directly in the 3D model. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | This is a model editing tool. |

## Prerequisites
- **Required Entities**: ElementWall entities containing beams.
- **Minimum Beam Count**: 0 (Walls can be empty or fully populated).
- **Required Settings**: None (all settings are internal script properties).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_WDET_SET_BEAM_NAME.mcr`

### Step 2: Select Wall Elements
```
Command Line: Please select Elements
Action: Click on one or more timber wall elements (ElementWall) in the model. Press Enter to confirm selection.
```
*Note: Once selected, the script will automatically process the walls based on the current Property settings and then erase itself from the drawing.*

### Step 3: Modify Settings (Optional)
If you wish to change naming conventions or colors before the script processes (or if you re-insert the script for adjustments):
```
Action: Select the script instance (if visible) or use the Properties Palette to change parameters like "Set Default Color", "Material", or specific beam names.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Set Default Color | dropdown | No | If "Yes", applies a single color to all beams. If "No", applies type-specific colors. |
| Set Module Beam with Default Color | dropdown | No | If "Yes", forces color updates on beams belonging to a module. If "No", module beams retain their current color. |
| Set Information Field | dropdown | No | If "Yes", automatically fills the beam's "Information" field with its Name (if empty). |
| Set subLabel | dropdown | No | If "Yes", sets the beam's SubLabel to the Element Group name. |
| Append Wall Type | dropdown | No | If "Yes", appends the Wall Type code to the beam's SubLabel. |
| Filter Beams | text | X; | A list of beam codes separated by `;` (e.g., `X;BRACE`) to exclude from color changes. |
| Default Color | number | 7 | The AutoCAD Color Index (1-255) used if "Set Default Color" is Yes. |
| Name (Jack Over Opening) | text | LINTOL PACKERS | Sets the name for beams located above openings. |
| Name (Jack Under Opening) | text | SILL STUDS | Sets the name for beams located under openings. |
| Name (Cripple Stud) | text | CRIPPLE | Sets the name for cripple studs. |
| Name (King Stud) | text | STUD | Sets the name for king studs. |
| Name (TopPlate) | text | TOP PLATE | Sets the name for top plates. |
| Name (Bottom Plate) | text | BOTTOM PLATE | Sets the name for bottom plates. |
| Name (Header) | text | LINTOL | Sets the name for header/linthel beams. |
| Material To Set | text | CLS | Default material species assigned if the beam has no material or is marked 'PACKER'. |
| Grade To Set | text | C16 | Default structural grade assigned if the beam has no grade. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Forces the script to re-run and apply the current property settings to the linked wall elements. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: All configuration is handled via the Properties Palette (OPM).

## Tips
- **Auto-Erase**: This script automatically erases itself from the drawing after processing. Do not be alarmed if it disappears; the changes to the beams remain.
- **Smart Defaults**: The script attempts to infer the Material and Grade from existing "Stud" beams in the wall. If none are found, it uses the values defined in "Material To Set" and "Grade To Set".
- **Color Filtering**: Use the `Filter Beams` property to prevent specific elements (like metal braces or hardware) from being recolored. Add their beam codes to the list separated by semicolons.

## FAQ
- **Q: Why did the script disappear immediately after I selected the walls?**
  - A: This is intended behavior. The script is a "run-once" utility. It processes the data and deletes itself to keep the drawing clean.
- **Q: Some beams did not change color even though I enabled "Set Default Color".**
  - A: Check if "Set Module Beam with Default Color" is set to "No". If a beam belongs to a module and this setting is No, the script will skip it. Also, verify the beam code is not listed in the "Filter Beams" property.
- **Q: Can I change the names of the beams after the script has run?**
  - A: Yes, but you will need to insert the script again, adjust the "Name" properties in the palette, and select the walls again to overwrite them.
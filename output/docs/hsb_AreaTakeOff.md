# hsb_AreaTakeOff.mcr

## Overview
Calculates floor area, perimeter, and opening statistics (windows, doors) based on selected wall elements. It also exports material data for floor sheeting to the hsbCAD database or Excel for estimation purposes.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script is intended to be used in the 3D model to select wall elements. |
| Paper Space | No | Not designed for layout views. |
| Shop Drawing | No | Not used for generating manufacturing drawings. |

## Prerequisites
- **Required Entities**: `ElementWall` (Wall entities must exist in the model).
- **Minimum Beam Count**: 0.
- **Required Settings**: `Inv_Sheet.xml` must be present in your temporary path (`_kPathPersonalTemp`) to populate floor sheeting options.

## Usage Steps

### Step 1: Launch Script
Execute the command `TSLINSERT` in the AutoCAD command line and select `hsb_AreaTakeOff.mcr` from the list.

### Step 2: Select Walls
```
Command Line: Please select Walls
Action: Select the wall elements in the model that define the floor area you want to calculate.
```
*Note: Ensure the walls you select have the correct wall codes assigned (e.g., 'A' or 'B') so the script can identify them as external walls.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show in Disp Rep | text | (empty) | Specifies in which display representation (e.g., Plan, 3D) the calculated floor outline is visible. |
| Line Type | dropdown | (empty) | Sets the line style (e.g., Continuous, Dashed) for the floor outline. |
| Dim style | dropdown | (empty) | Assigns a dimension style to the entity. |
| Color Foundation Lines | number | 3 | Sets the color index (0-255) for the floor outline. Default is Green (3). |
| Code External Walls | text | A;B; | Defines the wall codes used to identify external walls. Separate codes with a semicolon (;). Only walls matching these codes are included in the calculation. |
| Floor Sheet Type | dropdown | (empty) | Selects the specific floor sheeting material (e.g., OSB 18mm) to report in the export data. |
| % Extra for Cavity Closer | number | 15 | Adds a percentage allowance to opening perimeters to account for trim/wastage (e.g., 15%). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are defined. Use the Properties Palette to modify parameters. |

## Settings Files
- **Filename**: `Inv_Sheet.xml`
- **Location**: `_kPathPersonalTemp` (Your personal hsbCAD temp folder).
- **Purpose**: Provides the catalog of sheeting materials (Description, Part Number, Dimensions) used to populate the "Floor Sheet Type" dropdown.

## Tips
- **Wall Codes are Critical**: If the calculated area is 0, check the **Code External Walls** property. It must match the codes assigned to your wall entities exactly (e.g., if your walls are code "EXT", enter "EXT;" in the property).
- **Cavity Closer Allowance**: Use the **% Extra for Cavity Closer** property to automatically increase the perimeter length for openings in the export data, ensuring you order enough material for trim work.
- **Visualizing the Result**: The script draws a polyline 15mm inward from the selected walls. Change the **Color Foundation Lines** or **Line Type** properties to make this outline stand out against your walls.

## FAQ
- **Q: Why is the floor area showing as 0?**
- **A**: Check the **Code External Walls** property. The script only calculates area for walls whose codes match the list in this field (e.g., "A;B;"). Ensure your selected walls actually have these codes.
- **Q: Where does the "Floor Sheet Type" list come from?**
- **A**: It is loaded from the `Inv_Sheet.xml` file. If the dropdown is empty, check that this file exists in the correct temp folder and is formatted correctly.
- **Q: Can I include internal walls in the calculation?**
- **A**: Only if you add their wall codes to the **Code External Walls** property string. By default, it is set to filter for external walls only.
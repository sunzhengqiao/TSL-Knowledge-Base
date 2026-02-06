# hsb_Insulation.mcr

## Overview
This script automatically generates 3D insulation sheets within timber frame walls based on specific wall types. It calculates material quantities, cuts insulation around studs and openings, and outputs data for production reports.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script generates 3D bodies and modifies the model. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Does not generate 2D shop drawings directly. |

## Prerequisites
- **Required Entities**: An existing Wall Element (e.g., External Wall).
- **Minimum Beam Count**: 0 (Processes any beams present in the wall).
- **Required Settings**: None (All settings are managed via the Properties Panel).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_Insulation.mcr`

### Step 2: Assign to Element
```
Command Line: Select Element:
Action: Click on the wall element in the model where you want to generate insulation.
```

### Step 3: Configure Properties
```
Action: Select the inserted script instance (or the element if attached).
Open the Properties Palette (Ctrl+1).
Modify the "Wall types for this Insulation" to include the Element Code of the selected wall.
```
*Note: The script processes immediately once the properties match the element's code.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Wall types for this Insulation | Text | EA;EB; | Defines which Element Codes (e.g., EA, EB) will have insulation generated. Separate codes with a semicolon (;). |
| Insulation Name | Dropdown | Crown FrameTherm Roll 40 | Select the manufacturer and product name for the main wall areas. |
| Other Insulation Type | Text | [Empty] | If "Other Insulation Type" is selected above, enter the custom name here. |
| Attach Insulation to Zone | Dropdown | 10 | Selects the construction layer (Zone) inside the wall to fill. Options 1-10 map to specific internal zones; 0 implies a specific default logic. |
| Insulation Thickness | Number | 90 mm | The thickness of the insulation batt. Set to `0` to automatically match the wall cavity depth. |
| Insulation Stock Width | Number | 1200 mm | The standard width of the raw material (e.g., roll width) used for quantity calculations. |
| Insulation Stock Length | Number | 8000 mm | The standard length of the raw material bundle or roll for optimization. |
| Insulation Stock Units | Dropdown | Rolls | The unit of measure for reports (Rolls, Slabs, Batts, Boards). |
| Insulation Name for Connections | Dropdown | Crown FrameTherm Roll 40 | The product name for insulation used specifically at junctions or connection areas. |
| Other Insulation Type (Conn) | Text | [Empty] | Custom name for connections if "Other" is selected. |
| Insulation Thickness (Conn) | Number | 90 mm | Thickness for insulation used in connection areas. |
| Minimum Width | Number | 20 mm | Scrap filter. Any piece narrower than this will not be created. |
| Width Decrease | Number | 0 | Horizontal allowance (friction fit). Reduces the sheet width to ensure easy fit between studs. |
| Height Decrease | Number | 0 | Vertical allowance (friction fit). Reduces the sheet height. |
| Stop Insulation at Flat Stud | Yes/No | No | If "Yes", prevents insulation from being generated where it interferes with flat studs (dwangs/noggins) in connection zones. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Refreshes the insulation geometry based on current wall geometry and script properties. (Triggered automatically when properties change). |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: All configuration is handled directly through the AutoCAD Properties Palette using the parameters listed above.

## Tips
- **Auto-Fit Thickness**: Set `Insulation Thickness` to `0` to let the script automatically calculate the exact depth of the wall cavity. This is useful if wall depths vary.
- **Friction Fit**: Use the `Width Decrease` and `Height Decrease` parameters (e.g., 5mm) to shrink the insulation slightly. This ensures the batts fit snugly between studs without bowing the wall.
- **Filtering**: To exclude specific walls, remove their Element Code from the `Wall types for this Insulation` list.
- **Connection Details**: If you use rigid foam for corners but wool for the general wall, configure the `Insulation Name` (General) and `Insulation Name for Connections` differently.

## FAQ
- **Q: I inserted the script, but no insulation appeared.**
  - A: Check the `Wall types for this Insulation` property. Ensure the Element Code of your wall (e.g., "EA") is listed in that string. It must match exactly (including semicolons).
- **Q: Why are there small gaps in my insulation?**
  - A: Check your `Width Decrease` and `Height Decrease` values. If they are set too high, the insulation will pull away from the studs. Set them to `0` for a perfect fill, or a small value (2-5mm) for friction fit.
- **Q: Insulation is missing around windows/doors.**
  - A: This may be controlled by the `Stop Insulation at Flat Stud` setting or the logic for connection zones. Try switching `Stop Insulation at Flat Stud` to "No".
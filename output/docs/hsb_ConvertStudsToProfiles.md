# hsb_ConvertStudsToProfiles.mcr

## Overview
This script allows you to convert standard rectangular studs within selected wall elements into 3D extrusion profiles (such as I-joists or custom timber sections). It provides detailed filtering options to exclude specific components like top plates, opening framing, or beams with specific codes from the conversion.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on Wall Elements (`ElementWallSF`) in the model. |
| Paper Space | No | Not designed for layout views or shop drawings. |
| Shop Drawing | No | Not designed for detailing views. |

## Prerequisites
- **Required Entities**: Wall Elements (`ElementWallSF`) must exist in the drawing and contain beams.
- **Catalog Entries**: An Extrusion Profile (e.g., an I-Joist shape) must exist in the hsbCAD Extrusion Profile catalog to be selected in the properties.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the AutoCAD command line.
2.  Select `hsb_ConvertStudsToProfiles.mcr` from the file dialog.

### Step 2: Configure Properties
1.  The Properties Palette will appear automatically.
2.  Select the desired **Extrusion profile name** from the dropdown list.
3.  Adjust the **Code Profile Wall** to match the code of the walls you want to process (default is `I;J;`).
4.  Set the various exclusion toggles (e.g., `Top Plate`, `Header`, `Ignore all opening beams`) to `Yes` for any members you **do not** want to convert.

### Step 3: Select Walls
```
Command Line: Select a set of elements
Action: Click on the Wall Elements (ElementWallSF) you wish to modify and press Enter.
```
*Note: Select the wall entity, not the individual beams inside it.*

### Step 4: Execution
The script will process the selected walls, applying the chosen profile to eligible beams and skipping excluded ones. The script instance will then automatically remove itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Extrusion profile name | Dropdown | (Catalog List) | Select the 3D extrusion profile (e.g., I-Joist) to apply to the studs. |
| Code Profile Wall | Text | I;J; | The wall code(s) to process. Separate multiple codes with a semicolon (;). |
| Top Plate | Dropdown | No | If "Yes", top plates are excluded and keep their original shape. |
| Bottom Plate | Dropdown | No | If "Yes", bottom plates are excluded and keep their original shape. |
| Blocking | Dropdown | No | If "Yes", blocking members are excluded from conversion. |
| Ignore all opening beams | Dropdown | No | If "Yes", all framing around openings (cripples, jacks, headers, etc.) is excluded. |
| First Cripple | Dropdown | No | If "Yes", excludes the cripple stud immediately adjacent to the opening. |
| All Cripples | Dropdown | No | If "Yes", excludes all cripple studs above/below openings. |
| King Studs | Dropdown | No | If "Yes", excludes king studs (full height studs at opening sides). |
| Jacks Above/Below Opening | Dropdown | No | If "Yes", excludes jack studs (trimmers). |
| Left/Right Studs | Dropdown | No | If "Yes", excludes the first and last studs of the wall (boundary studs). |
| Sill/Transom | Dropdown | No | If "Yes", excludes sills and transoms (horizontal members at openings). |
| Header | Dropdown | No | If "Yes", excludes header beams (lintels above openings). |
| Packer | Dropdown | No | If "Yes", excludes packer beams (spacers). |
| Exclude Beams with Code | Text | (Empty) | Enter beam codes to exclude (e.g., `STD;SPR`). Beams matching these codes will not be converted. |
| Minimum length of beam | Number | 0 | Beams shorter than this length (in project units) will not be converted. |

## Right-Click Menu Options
None. This script executes once and automatically removes itself (`eraseInstance`) from the drawing upon completion. To modify settings, re-insert the script.

## Settings Files
- **Catalog Location**: hsbCAD Catalog database.
- **Purpose**: The script uses the Extrusion Profile catalog to populate the list of available profiles in the Properties Palette.

## Tips
- **Filtering by Wall Code**: If you have both interior and exterior walls, use the `Code Profile Wall` property to target only specific types. Ensure the codes in the property match the codes assigned to your Wall Elements in the drawing.
- **Master Switch for Openings**: Use `Ignore all opening beams` = "Yes" if you want to quickly keep all opening framing (cripples, jacks, headers) as standard solid timber while converting the main wall studs.
- **Short Lengths**: Use `Minimum length of beam` to prevent very small filler pieces or blocking from being converted to complex profiles, which can improve performance and model cleanliness.

## FAQ
- **Q: Why did nothing happen when I ran the script?**
  - A: Check the `Code Profile Wall` property. If the default (`I;J;`) does not match the actual codes of the walls you selected, the script will skip them. Also, ensure you selected Wall Elements (`ElementWallSF`), not individual beams.
- **Q: Can I undo the changes?**
  - A: Yes, use the standard AutoCAD `UNDO` command immediately after running the script if the results are not as expected.
- **Q: How do I convert all beams including plates?**
  - A: Set all exclusion properties (Top Plate, Bottom Plate, Header, etc.) to "No". The script will then attempt to convert every beam found in the wall that matches the length and code filters.
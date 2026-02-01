# FLR_SimpsonHanger.mcr

## Overview
Automates the insertion and sizing of Simpson Strong-Tie joist hangers based on the geometry of selected joists and carrying beams. It also supports the automatic generation of web stiffeners and backer blocks based on configuration rules.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be inserted in 3D model context. |
| Paper Space | No | Not supported for detail views. |
| Shop Drawing | No | Not a shop drawing script. |

## Prerequisites
- **Required Entities**:
  - Joist Beams or Trusses (must be parallel to each other).
  - Carrying Beams (Headers).
- **Minimum Beam Count**: At least one Joist and one Carrying Beam.
- **Required Settings**:
  - `.NET` DLL: `ExcelData.dll` located in `<hsb install>\Excel\ExcelReader\`.
  - Excel Database: `HangerList.xls` located in `<hsb Company>\Excel\`.
  - Dependent Script: `FLR_HangerList.mcr` (used to import Excel data).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `FLR_SimpsonHanger.mcr` from the file dialog.

### Step 2: Select Joists
```
Command Line: Select Joists, all must be parallel
Action: Click to select the joist beams that require hangers. Press Enter to confirm selection.
```
*Note: All selected joists must be parallel to each other. Non-perpendicular joists relative to the header will be filtered out automatically.*

### Step 3: Select Carrying Beams
```
Command Line: Select Carrying Beams
Action: Click to select the beam(s) that the joists bear onto (the rim beam or header). Press Enter to confirm.
```
*Note: The script will automatically calculate the placement for each joist against the selected carrying beam.*

## Properties Panel Parameters

| Parameter | Type | Options | Description |
|-----------|------|---------|-------------|
| Execution Mode | Dropdown | Standard / Manual | **Standard**: Automatically selects hanger model based on Excel library lookup.<br>**Manual**: Allows user to specify hanger model and nails manually. |
| Notes | String | - | User-defined text notes for the instance. |
| Web Stiffener | Dropdown | Yes / No | (If available) Toggles the creation of a stiffener beam inside TJI joist webs. |
| Backer Block | Dropdown | None / Single / Double | (If available) Toggles the creation of backer blocks between joists. |
| Nails / Model | Text / Dropdown | Varied | In **Manual** mode, allows direct input of hanger model name and nail patterns. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Update Hanger List | Executes the import routine to refresh the hanger library from the Excel file. Use this if you have added new hangers to `HangerList.xls`. |

## Settings Files
- **Filename**: `HangerList.xls`
- **Location**: `<hsb Company>\Excel\`
- **Purpose**: Acts as the database for Simpson hanger properties. It contains dimensions, model names, and nail patterns that the script queries to match the joist geometry.

## Tips
- **Standard vs Manual Mode**: Use "Standard" mode for automatic efficiency. Only switch to "Manual" if you need to force a specific hanger that the automatic lookup missed.
- **Orientation**: Ensure your joists are modeled perpendicular to the carrying beam. The script filters out joists that are not perpendicular.
- **Library Updates**: If you change the Excel file, you must right-click the script instance and select "Update Hanger List" to see the changes in the current drawing session.
- **Grouping**: The script creates slave instances attached to specific joists. Modifying the master instance properties usually updates all slaves, or you can modify individual slaves via the Properties palette.

## FAQ
- **Q: Why did the hanger not appear on one of my joists?**
- **A**: The script filters for joists that are perpendicular to the carrying beam. If the joist is skewed or not parallel to the others selected, it may be ignored.
- **Q: How do I fix "Implicit failure if map length is 0"?**
- **A**: This means the hanger library is empty. Ensure `HangerList.xls` exists in your Company folder and run the "Update Hanger List" command from the right-click menu.
- **Q: Can I use this for I-Joists (TJI)?**
- **A**: Yes, the script has specific logic for TJI joists, including options for web stiffeners. Ensure the joist type is defined correctly in your hsbCAD settings.
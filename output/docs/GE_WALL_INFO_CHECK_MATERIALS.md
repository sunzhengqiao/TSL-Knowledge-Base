# GE_WALL_INFO_CHECK_MATERIALS.mcr

## Overview
This script inspects a selected Wall Element to verify that all Beams (studs/plates) and Sheets (sheathing) have valid Grades/Materials and defined Weight values according to your hsbFramingDefaults inventory. If errors are found, it generates an on-screen table identifying the specific components that lack valid inventory data or weight definitions.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script is intended for 3D Model usage only. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities:** An existing Wall (Element) in the drawing.
- **Minimum Beams:** N/A (Script checks walls, which contain beams).
- **Required Settings:** `hsbFramingDefaults.Inventory.dll` must be properly configured with Lumber and Sheathing definitions (via hsbFramingDefaultsEditor).

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT`
**Action:** Select `GE_WALL_INFO_CHECK_MATERIALS.mcr` from the file dialog.

### Step 2: Select Wall
```
Command Line: |Select a wall|
Action: Click on the Wall element you wish to audit.
```

### Step 3: Position Report
```
Command Line: |Select point to create table|
Action: Click anywhere in the model space to place the material report table.
```

**Note:** If no issues are found (all grades and weights are valid), a notice will appear stating "No issues found", and the script instance will automatically erase itself. The tables only appear if problems exist.

## Properties Panel Parameters

These parameters can be adjusted in the AutoCAD Properties Palette (Ctrl+1) after the script is inserted.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Beam info color | Number | 4 | The AutoCAD color index (ACI) used for text and lines regarding Beam issues. |
| Sheathing info color | Number | 3 | The AutoCAD color index (ACI) used for text and lines regarding Sheathing issues. |
| Dimstyle | Dropdown | Current | The dimension style used for pointers and leader lines. |
| Show pointer | Dropdown | Yes | Toggles the visibility of the pointer lines connecting the table to the wall elements. |
| Highlight beams | Dropdown | No | If set to Yes, beams with invalid data will be highlighted visually. |
| Highlight sheets | Dropdown | No | If set to Yes, sheets with invalid data will be highlighted visually. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add specific custom context menu items. |

## Settings Files
- **Filename:** `hsbFramingDefaults.Inventory.dll`
- **Location:** Defined in your hsbCAD configuration (Company or Install path).
- **Purpose:** Provides the master list of Lumber and Sheathing materials. The script checks the Wall elements against this file to ensure every beam grade and sheet material exists and has a weight defined.

## Tips
- **Automatic Cleanup:** Don't worry if the script seems to "fail" or disappear immediately after insertion; this means your wall passed all checks.
- **Troubleshooting:** If you see "UNDEFINED WEIGHT VALUES" in the table, open your hsbFramingDefaultsEditor and ensure that specific size/grade or material/thickness combination has a weight value assigned.
- **Visual Feedback:** Enable the "Highlight beams" or "Highlight sheets" properties in the palette if the wall is complex and you need to quickly locate the specific offending studs or panels.
- **Updates:** Modifying the Inventory file externally does not automatically update the drawing. You must update the wall geometry or force a recalculation (e.g., by changing a property) to refresh the check.

## FAQ
- **Q: Why did the script disappear immediately after I selected a point?**
  - A: The script performs a self-check. If it finds no missing grades, materials, or weights, it displays a success message and erases itself to keep your drawing clean.

- **Q: What does "BEAMS WITH NOT VALID GRADE" mean?**
  - A: It means a specific beam in the wall has a Grade assigned (e.g., "SPF") that does not exist in your Lumber Inventory map. You either need to change the beam's grade or add that grade to your Inventory defaults.

- **Q: Can I move the table after creating it?**
  - A: Yes. Select the script instance (it might be easier to select the text in the table) and use the standard AutoCAD Move command or grips to relocate the report. The pointers will update automatically.
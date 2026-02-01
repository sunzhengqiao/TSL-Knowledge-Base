# hsb_CreateSheetAroundOpening.mcr

## Overview
This script automatically generates structural sheathing or blocking sheets (e.g., OSB or plywood) around door and window openings in designated wall types. It allows precise control over placement (top, bottom, sides) and material properties.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D wall elements. |
| Paper Space | No | Not applicable for 2D drawing generation. |
| Shop Drawing | No | Does not generate views or dimensions. |

## Prerequisites
- **Required Entities**: Walls (ElementWallSF) containing Openings (OpeningSF).
- **Minimum Beam Count**: Not applicable (Script selects whole elements).
- **Required Settings**: None (Uses internal properties).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_CreateSheetAroundOpening.mcr`

### Step 2: Select Wall Elements
```
Command Line: Select a set of elements
Action: Click on the wall elements (or use a window selection) that contain the openings you wish to sheet. Press Enter to confirm.
```

### Step 3: Configure Properties
After selection, the script attaches to the elements. Select an element and open the **Properties Palette** (Ctrl+1) to adjust settings like thickness, placement sides, and material.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Wall Code (`psExtType`) | Text | A;B; | Determines which walls are processed based on their wall code. Separate multiple codes with semicolons (e.g., "EXT;INT;"). |
| Sheet Thickness (`dThick`) | Number | 9 | Thickness of the sheathing material to be created (in project units, typically mm). |
| Sheet Name (`sName`) | Text | OSB | The identifier/name of the sheet entity for reporting and lists. |
| Material (`sMaterial`) | Text | OSB | The physical material grade applied to the sheet (must exist in your catalog). |
| Zones (`nZones`) | Integer | 0 | The construction layer or zone index to which the sheet is assigned. |
| Top (`sTop`) | Yes/No | No | If set to "Yes", generates a sheet above the opening. |
| Bottom (`sBottom`) | Yes/No | No | If set to "Yes", generates a sheet below the opening. |
| Sides (`sSides`) | Yes/No | No | If set to "Yes", generates sheets on the left and right jambs of the opening. |
| Gap Side (`sGapSide`) | Yes/No | Yes | If set to "Yes", applies a gap to the opening geometry equal to the sheet thickness to prevent clashes. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the sheet geometry based on current property values or changes in the wall geometry. |
| Delete | Removes the script and all generated sheets from the selected elements. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies entirely on the Properties Palette for configuration and does not require external XML settings files.

## Tips
- **Visibility**: By default, `sTop`, `sBottom`, and `sSides` are set to "No". You must change at least one of these to "Yes" to see generated sheets.
- **Wall Filtering**: Ensure the `Wall Code` property matches the wall codes defined in your project (e.g., "EXT") or the script will skip those walls.
- **Gap Handling**: Use `sGapSide` = "Yes" if you want the script to automatically adjust the opening size (Gap properties) to accommodate the thickness of the new sheet. This prevents the sheet from overlapping the opening geometry incorrectly.

## FAQ
- **Q: I ran the script but nothing appeared.**
  **A:** Check the Properties Palette. By default, the Top, Bottom, and Sides options are set to "No". Change the relevant side(s) to "Yes" and recalculate.
  
- **Q: Can I apply this to multiple walls at once?**
  **A:** Yes, during the insertion prompt, you can select multiple wall elements using a window selection.

- **Q: What unit is the thickness in?**
  **A:** The unit follows your current project settings (typically millimeters for timber construction).
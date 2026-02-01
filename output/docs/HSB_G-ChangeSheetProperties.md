# HSB_G-ChangeSheetProperties

## Overview
This script allows you to batch modify the thickness, material, and display color of selected sheeting or cladding panels. It automatically adjusts the panel position to maintain the existing face alignment, ensuring the exterior or interior surface location remains unchanged when the thickness varies.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script runs in the 3D model. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Not applicable for 2D drawings. |

## Prerequisites
- **Required Entities:** Existing Sheet elements (cladding/sheathing) in the model.
- **Minimum Beam Count:** 1 or more sheets.
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `HSB_G-ChangeSheetProperties.mcr` from the file dialog.

### Step 2: Configure Properties
The script will load default properties. If a catalog execute key is not used, you must manually adjust the settings in the AutoCAD Properties Palette (press `Ctrl+1` if not visible).
- Set the desired **New Thickness**.
- Enter the **New Material** name (must exist in your hsbCAD catalog).
- Set the **New Color** index (or leave as -1 to ignore color changes).

### Step 3: Select Sheets
Command Line: `Select Sheets:`
Action: Click on the sheet elements you wish to modify. You can select multiple sheets. Press `Enter` to confirm selection.

### Step 4: Execution
The script will update the geometry, material, and color of the selected sheets and then automatically delete itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| New Thickness | Number | 12.5 | The physical thickness of the sheet (e.g., 12.5, 15, 18). Common unit is mm. |
| New Material | String | Groen gips | The name of the material to assign to the sheets (e.g., "OSB", "Plywood"). |
| New Color | Integer | -1 | The AutoCAD color index (1-255). Set to -1 to keep the existing color unchanged. |

## Right-Click Menu Options
*Note: This script runs once and deletes itself upon completion. It does not persist in the drawing to offer context menu options.*

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Face Alignment:** When changing the thickness, the script calculates the difference and moves the sheet along its local Z-axis. This ensures the face of the sheet (the side you likely care about for finishes) stays in the exact same position relative to the structure.
- **Color Preservation:** If you only want to change the material or thickness without changing the visual color, ensure the **New Color** parameter is set to `-1`.
- **Batching:** You can window select multiple sheets at the prompt to update an entire wall section quickly.

## FAQ
- **Q: What happens if I enter a material name that doesn't exist?**
- **A:** The script will assign the text string as the material name, but it may not render correctly or have the correct physical properties if it isn't defined in your hsbCAD material database.
- **Q: Why did the script disappear from my drawing?**
- **A:** This is a utility script designed to perform an action and exit. It automatically erases its instance after applying the changes to keep your drawing clean.
- **Q: Can I use this on structural beams?**
- **A:** No, this script is designed specifically for "Sheet" entities (cladding/sheathing), not GenBeams or Columns.
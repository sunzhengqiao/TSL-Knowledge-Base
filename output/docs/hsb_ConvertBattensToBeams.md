# hsb_ConvertBattensToBeams.mcr

## Overview
This script converts sheet-based battens (often used for layout or modeling) into solid structural Beam entities for manufacturing. It applies specific material properties, color coding, and horizontal top cuts to the new beams based on user settings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D hsbCAD Elements. |
| Paper Space | No | |
| Shop Drawing | No | This script does not generate 2D views directly. |

## Prerequisites
- **Required Entities**: hsbCAD Elements containing Sheets in the specific zones you wish to process.
- **Minimum Beam Count**: 0 (This script creates beams from sheets, not vice versa).
- **Required Settings**: None specific, but material catalogs must be available if assigning specific grades/materials.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_ConvertBattensToBeams.mcr` from the file dialog.

### Step 2: Select Elements
```
Command Line: Select a set of elements
Action: Click on the hsbCAD Element(s) in the model that contain the sheets you want to convert. Press Enter to confirm selection.
```

### Step 3: Configure Properties
After selection, the script instance is created. Select the script instance in the drawing and open the **Properties Palette** (Ctrl+1). Adjust parameters such as the target Zone, Top Cut distance, and Material properties.

### Step 4: Execute Conversion
Trigger the script calculation by changing any parameter value in the Properties Palette or using the standard hsbCAD Recalculate command. The sheets will be converted to beams, and the original sheets will be erased.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone to Convert the Battens | dropdown | 0 | Select the construction zone (1-10) containing the sheets to convert. |
| Size to cut the Top of the Battens | number | 0 | Distance (mm) from the top of the batten to apply a horizontal saw cut. |
| Align height to Z of the element | dropdown | No | If "Yes", rotates the batten so its height is horizontal relative to the element's Z-axis (laying flat vs. standing). |
| Overwrite zone material | dropdown | Yes | If "Yes", applies the script's material settings; if "No", keeps the original sheet properties. |
| Beam Name | text | [Empty] | Assigns a specific name to the generated battens. |
| Beam Material | text | [Empty] | Sets the timber material species (e.g., C24). |
| Beam Grade | text | [Empty] | Sets the structural strength grade. |
| Beam Code | text | [Empty] | Sets the production code used for CNC/export. **Note:** Semicolons are not allowed. |
| Beam Color | number | -1 | Sets the Autodesk color index (0-255). Use -1 to keep the original sheet color. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No specific custom context menu items are defined for this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies entirely on Properties Palette inputs and does not use external XML settings files.

## Tips
- **Disappearing Beams**: If your beams disappear after running the script, check the **Size to cut the Top of the Battens** parameter. If this value is greater than the length of the batten, the script deletes the beam because it is too short.
- **Material Updates**: If your material or grade settings are not applying to the new beams, ensure **Overwrite zone material** is set to "Yes".
- **Orientation**: Use the **Align height to Z** property to toggle between vertical studs (standing) and horizontal laths (flat) orientation automatically.

## FAQ
- **Q: Why did I get an error "Beam Code set by Convert Battens to beam TSL is not valid"?**
  **A:** You likely used a semicolon (;) in the **Beam Code** property. Remove the semicolon and try again.
- **Q: Can I undo this operation?**
  **A:** Yes, use the standard AutoCAD `UNDO` command to revert the conversion and restore the original sheets.
- **Q: What happens to the original sheets?**
  **A:** The script deletes the original sheets after successfully creating the beams. Ensure you have a backup if you need to retain the sheet geometry.
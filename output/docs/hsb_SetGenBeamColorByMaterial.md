# hsb_SetGenBeamColorByMaterial.mcr

## Overview
This script automatically assigns specific colors to General Beams (GenBeams) based on their material property. It is designed to help users visually distinguish different timber grades or material types directly within the 3D model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on elements in the 3D model. |
| Paper Space | No | Not intended for layout views. |
| Shop Drawing | No | Not intended for production drawings. |

## Prerequisites
- **Required Entities**: `Elements` containing `GenBeams`.
- **Minimum Beams**: 0 (Script processes all beams found in selected elements).
- **Required Settings**: `Materials.xml` must be present in your company folder (`...\_kPathHsbCompany\Abbund\Materials.xml`).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SetGenBeamColorByMaterial.mcr`

### Step 2: Configure Properties (Optional)
Before selecting elements, you can open the **Properties Palette (OPM)** in AutoCAD.
- Set the desired **Material X** (e.g., "C24") and the corresponding **Color X** (AutoCAD Color Index) for up to 5 different material types.

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the desired Elements (e.g., walls, roofs) in the model that contain the beams you want to colorize. Press Enter to confirm selection.
```

### Step 4: Execution
The script will immediately scan the selected elements. Any beam with a material matching your settings will change color. The script instance will then delete itself automatically.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Material 1 | Dropdown | (Empty) | Select the first material name (e.g., C24) from the company materials list. |
| Color 1 | Number | -1 | Enter the AutoCAD Color Index (0-255) to apply to Material 1. (-1 = ByLayer). |
| Material 2 | Dropdown | (Empty) | Select the second material name. |
| Color 2 | Number | -1 | Enter the AutoCAD Color Index to apply to Material 2. |
| Material 3 | Dropdown | (Empty) | Select the third material name. |
| Color 3 | Number | -1 | Enter the AutoCAD Color Index to apply to Material 3. |
| Material 4 | Dropdown | (Empty) | Select the fourth material name. |
| Color 4 | Number | -1 | Enter the AutoCAD Color Index to apply to Material 4. |
| Material 5 | Dropdown | (Empty) | Select the fifth material name. |
| Color 5 | Number | -1 | Enter the AutoCAD Color Index to apply to Material 5. |

## Right-Click Menu Options
*(None available)*

## Settings Files
- **Filename**: `Materials.xml`
- **Location**: `_kPathHsbCompany\Abbund\`
- **Purpose**: This file provides the list of valid material names (e.g., GL24h, C24) that appear in the Property dropdowns.

## Tips
- **Fire and Forget**: This script deletes itself immediately after running. If you need to change the color mapping later, you must re-run the script.
- **Standard Undo**: You can use the standard AutoCAD `U` (Undo) command to revert the color changes if the result is not as expected.
- **Material Match**: The script compares material names without case sensitivity (e.g., "c24" will match "C24"). Ensure the names in your model match the names in `Materials.xml`.

## FAQ
- **Q: I get an error "Materials not been set..." when running the script.**
  **A:** The `Materials.xml` file is missing from your `Abbund` folder. Ensure you have run the `hsbMaterial` utility or contact your support desk to generate this file.

- **Q: The color didn't change on my beam.**
  **A:** Check that the material name assigned to the beam exactly matches one of the "Material X" properties you configured in the palette. Also, ensure the beam is inside an Element that you selected during Step 3.

- **Q: How do I find the AutoCAD Color Index number?**
  **A:** In AutoCAD, type `COLOR` to open the Select Color dialog. The index number (1-255) is displayed next to the color swatch.
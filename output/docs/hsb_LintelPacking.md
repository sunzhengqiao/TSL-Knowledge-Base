# hsb_LintelPacking.mcr

## Overview
Automatically generates packers (spacer beams or sheets) above lintels/headers or below transoms in wall openings. It fills vertical gaps using either stacked layers of specific thicknesses or a single custom-height piece, and automatically handles small jack stud clearances.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on ElementWallSF entities in the 3D model. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: ElementWallSF (Wall elements containing openings/windows/doors).
- **Minimum Beam Count**: N/A (Script targets Wall Elements).
- **Required Settings**: Catalog entry (for initial property loading).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_LintelPacking.mcr`

### Step 2: Configure Properties
The Properties palette will appear automatically upon insertion.
**Action**: Configure the Packer names, materials, and heights. Choose whether to create "Sheet" or "Beam" entities.

### Step 3: Select Wall Elements
```
Command Line: Select one or More Elements
Action: Click on the Wall Elements (ElementWallSF) that contain the openings you wish to pack.
```

### Step 4: Finish Selection
```
Action: Press Enter or Right-Click to confirm selection.
```
The script will calculate the gaps, generate the packers, and then remove itself from the model, leaving only the new timber/sheet entities.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Select Packers Object** | dropdown | Sheet | Choose whether to generate "Sheet" (e.g., Plywood/OSB) or "Beam" (solid timber) entities. |
| **Packing- First Sheet /BeamName** | text | | Name/Stock code for the first (primary) packer layer. |
| **Packing- First Sheet/Beam Material** | text | | Material grade for the first packer. |
| **Enter the height of packer one** | number | 9 | Thickness of the primary packer (mm). |
| **Packing- Second Sheet Name** | text | | Name for the second packer layer. |
| **Packing- Second Sheet Material** | text | | Material for the second packer. |
| **Enter the height of packer two** | number | 0 | Thickness of the second packer (mm). |
| **Packing- Third Sheet/Beam Name** | text | | Name for the third packer layer. |
| **Packing- Third Sheet/Beam Material** | text | | Material for the third packer. |
| **Enter the height of packer three** | number | 0 | Thickness of the third packer (mm). |
| **Packing- Forth Sheet/Beam Name** | text | | Name for the fourth packer layer. |
| **Packing- Forth Sheet Material** | text | | Material for the fourth packer. |
| **Enter the height of packer four** | number | 0 | Thickness of the fourth packer (mm). |
| **Packing- Fifth Sheet/Beam Name** | text | | Name for the fifth packer layer. |
| **Packing- Fifth Sheet Material** | text | | Material for the fifth packer. |
| **Enter the height of packer five** | number | 0 | Thickness of the fifth packer (mm). |
| **Packing- Sixth Sheet/Beam Name** | text | | Name for the sixth packer layer. |
| **Packing- Sixth Sheet Material** | text | | Material for the sixth packer. |
| **Enter the height of packer six** | number | 0 | Thickness of the sixth packer (mm). |
| **Enter the minimum JackLength** | number | 40 | Minimum length for Jack studs. If the gap is smaller than this, Jack studs/Sills are removed to allow the packer to run full height. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not attach to the entity permanently. It runs once and erases itself. |

## Settings Files
- **Filename**: None specified in script properties.
- **Location**: N/A
- **Purpose**: N/A (Uses standard Properties Palette for configuration).

## Tips
- **Single Beam Mode**: If you set all "Enter the height of packer..." fields (1 through 6) to **0**, the script will ignore the stacking logic and generate a single packer that fills the exact gap height using the properties defined for "Packer One".
- **Stacked Packer Mode**: If you define specific heights (e.g., 45mm and 30mm), the script will attempt to fill the gap using a combination of these standardized sizes.
- **Auto-Cleanup**: If you have very small trimmers or jack studs that conflict with the packers, lower the "minimum JackLength" value. The script will automatically erase these conflicting studs to allow the packer to sit correctly.
- **Re-running**: Since the script erases itself after execution, you cannot simply click on the wall to edit the settings. You must select the wall and re-run the script to update the packers.

## FAQ
- **Q: I ran the script, but I can't find it to edit the settings.**
- **A:** This is a "Run Once" script. It erases itself after generating the geometry. To change settings, re-run the script on the same wall elements; it will regenerate the packers with the new settings.
- **Q: What happens if the gap is smaller than my defined packer heights?**
- **A:** In "Stacked Packer Mode", the script tries to fill as much as possible with the defined sizes. If the remaining gap is smaller than the smallest defined packer, it may leave a small void unless you are in "Single Beam Mode".
- **Q: Can I use this for doors as well as windows?**
- **A:** Yes, as long as the openings are part of a selected ElementWallSF, the script will process both windows (lintels) and doors (transoms/head).
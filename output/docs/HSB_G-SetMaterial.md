# HSB_G-SetMaterial.mcr

## Overview
This script is a batch processing tool that updates the **Material** or **Grade** properties of beams and sheets within selected Elements. It allows for up to 15 specific mapping rules, enabling you to swap materials (e.g., changing all OSB sheets to Fermacell) or update grades based on beam codes or existing material names.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model elements. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Not applicable for 2D drawings. |

## Prerequisites
- **Required Entities**: You must have at least one **Element** (Wall, Floor, Roof, etc.) in the drawing containing beams or sheets.
- **Minimum Beams**: 0 (The script handles empty elements gracefully).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Run the following command in the AutoCAD command line:
```
Command: TSLINSERT
```
In the file dialog, select `HSB_G-SetMaterial.mcr` and click **Open**.

### Step 2: Configure Properties
The **Properties Palette** will appear automatically. Configure the mapping rules before selecting elements:
1.  **Set material to**: Choose whether to update the `Material` property or the `Grade` property of the beams/sheets.
2.  **Material Sets (Mat 1 - Mat 15)**: Enter the new material/grade name you want to assign (e.g., "C24", "Fermacell", "Kerto").
3.  **BeamCode Sets (BmCode 1 - BmCode 15)**: (Optional) Enter specific beam codes to target.
    *   *Example*: If `Mat 1` is "C24" and `BmCode 1` is "Stud", all beams with code "Stud" will be set to grade "C24".
    *   If left blank, the script uses the *current* material of the beam to decide if it should be updated.

### Step 3: Select Elements
Once properties are set, the command line will prompt:
```
Command Line: |Select one or more elements|
Action: Click on the desired Wall, Floor, or Roof elements in the model view. Press Enter to confirm selection.
```

### Step 4: Processing
The script will automatically attach to the selected elements, update the beam/sheet data according to your rules, and then **erase itself** from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Set material to** | Dropdown | Material | Determines if the script updates the **Material** or the **Grade** property of the entities. |
| **Mat 1** to **Mat 15** | String | *Empty* | The target value (name of material or grade) to apply. This works in conjunction with the BeamCode filter or the current material name. |
| **BmCode 1** to **BmCode 15** | String | *Empty* | A filter list of beam codes (e.g., `STUD;PLATE`). If filled, the script only updates entities matching these codes. Separate multiple codes with a semicolon. |

## Right-Click Menu Options
This script does not create a persistent menu entry, as it automatically erases itself immediately after execution.

## Settings Files
- **Filename**: None required.
- **Location**: N/A.
- **Purpose**: The script relies entirely on user input via the Properties Palette.

## Tips
- **BeamCode Priority**: If you enter text in a `BmCode` field, the script prioritizes matching the BeamCode over the existing material name. Use this to force specific structural members (like top plates) to a certain grade, regardless of what they were previously.
- **Multiple BeamCodes**: You can target multiple beam types in one rule by separating them with semicolons (e.g., `WAL;FLR;RIM`).
- **Batch Swapping**: To swap all sheets of one type to another (e.g., OSB to Fermacell), leave the `BmCode` fields empty. The script will automatically match the entity's *current* material to determine if it needs updating (based on internal logic for common sheeting types).
- **Verification**: Since the script deletes itself after running, check the **Properties Palette** of a few beams/sheets in the element to verify the changes were applied successfully.

## FAQ
- **Q: I ran the script, selected elements, but nothing seemed to happen. Did it work?**
  - A: The script is designed to erase itself after completion. Check the command line history or select a beam/sheet and look at its Properties to see if the Material or Grade has changed.
- **Q: How do I change the material of only the "Studs" and not the "Plates"?**
  - A: In the Properties Palette, enter `STUD` (or your specific stud code) into `BmCode 1` and your desired material into `Mat 1`. Leave the other sets empty.
- **Q: Can I use this script to rename materials?**
  - A: Yes, simply set `sSetMaterialTo` to "Material" and define the mappings. Note that the mapping logic relies on recognizing the current material name or beam code.
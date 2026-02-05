# HSB_G-PropertyMapping.mcr

## Overview
This script acts as an automated "Find and Replace" tool for BIM data. It scans all structural beams in the model, identifies those matching specific criteria (Conditions), and updates their properties (Setters) automatically during model recalculation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script runs in the 3D model context. |
| Paper Space | No | Not designed for layout views. |
| Shop Drawing | No | Does not process 2D drawing generation. |

## Prerequisites
- **Required entities**: `GenBeam` elements (Beams/Columns) must exist in the model to be processed.
- **Minimum beam count**: 0 (The script will simply do nothing if no beams exist).
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT`
**Action:** Browse the file list and select `HSB_G-PropertyMapping.mcr`.

### Step 2: Configure Mapping Rules
**Action:**
1. Ensure the script instance is selected (it may appear as a cross or preview point in the model).
2. Open the **Properties Palette** (press `Ctrl+1`).
3. Scroll to the "Condition" section to define **Which beams to find**.
4. Scroll to the "Property Mapping" section to define **What to change**.

### Step 3: Apply Changes
**Command:** `TSLRECALC` or Save the drawing.
**Action:** The script will automatically scan the entire model, filter beams based on your Conditions, and apply the new values defined in the Setters.

## Properties Panel Parameters

### General Settings

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Sequence Number | Integer | 2000 | Determines when this script runs relative to other scripts during regeneration. Use lower numbers to run earlier. |

### Condition Section (Filtering)
*These parameters define the "IF" logic. All active conditions must be true for a beam to be updated.*

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Condition 1..6 | Dropdown | ` --- ` | Select the property to check (e.g., Name, Material, Type, Zone). Select ` --- ` to ignore. |
| Value condition 1..6 | String | Empty | The value to match. (See Tips for specific input formats for Types/Isotropics). |

### Property Mapping Section (Updates)
*These parameters define the "THEN" logic. All active setters are applied to matching beams.*

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Setter 1..10 | Dropdown | ` --- ` | Select the property to modify (e.g., Material, Grade, Label, Color). Select ` --- ` to ignore. |
| Value property 1..10 | String | Empty | The new value to write into the selected property. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Forces the script to re-run the mapping logic immediately. |
| Erase | Removes the script instance, stopping all automatic mapping. |

## Settings Files
- **Filename**: N/A
- **Location**: N/A
- **Purpose**: This script relies on internal lists for Beam Types and Isotropics; no external XML file is required.

## Tips
- **Disable specific lines**: If you only need to check one condition but leave others for later, set the unused `Condition` dropdowns to ` --- `.
- **Using Names vs. Indices**:
    - For **Type** and **Isotropic**: You can type the name (e.g., "Solid Timber") or the numeric index found in the hsbCAD lists.
    - Names are not case-sensitive and ignore spaces/underscores.
- **Zone Logic**:
    - If the value starts with a number (e.g., "5"), the script calculates the Zone Layer prefix automatically based on the current beam's layer.
    - If the number is greater than 5, it wraps mathematically (e.g., Input 7 becomes Zone -2).
    - To specify a letter prefix explicitly (e.g., "A5"), start the text with a letter.
- **Execution Order**: If you have multiple property mapping scripts, use the **Sequence Number** to ensure they run in the correct order (e.g., set a Label first, then move that beam to a Zone based on the new Label).

## FAQ
- **Q: I inserted the script and set the properties, but nothing happened.**
  - **A:** The script runs on model recalculation. Press `TSLRECALC` or save the drawing to trigger the update.
- **Q: Why did some beams not update?**
  - **A:** Check your Conditions. If a beam fails *any one* of the active Condition checks, it will be skipped. Ensure the "Value condition" exactly matches the current state of the beam.
- **Q: How do I see the numeric index for a Beam Type?**
  - **A:** Use the `HSB_I-ListBeamTypes` script to generate a list of all valid indices and names.
- **Q: Can I use this script to change the visual Color of the beams?**
  - **A:** Yes. Select "Color" in the `Setter` dropdown and enter the integer color index (e.g., 1 for Red, 5 for Blue) in the `Value property`.
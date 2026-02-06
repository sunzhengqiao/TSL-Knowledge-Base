# Set Floor Beam Colour and ID

## Overview
This script batch assigns specific material properties, AutoCAD colors, and internal manufacturing IDs to selected floor beams based on a predefined product catalog. It is used to apply consistent data standards and visual coding to structural elements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in Model Space where beams are located. |
| Paper Space | No | Not applicable for 2D layouts or sheets. |
| Shop Drawing | No | Does not generate views or annotations for drawings. |

## Prerequisites
- **Required entities**: Existing Beam entities (GenBeam) in the model.
- **Minimum beam count**: At least 1 beam must be selected for the script to process.
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Select `Set Floor Beam Colour and ID.mcr` from the file dialog.

### Step 2: Configure Beam Attributes
A dialog window will appear automatically upon insertion. Configure the following fields before proceeding:
1. **Select Beam Type**: Click the dropdown to choose the specific product (e.g., C16Joist, TJI - 350, Glulam).
2. **Enter Timber Grade**: Type the structural grade (e.g., C24, GL24h).
3. **Enter Beam Name**: Type a specific name or mark for the beams.
4. Click **OK** to confirm your settings.

### Step 3: Select Beams
```
Command Line: select a set of beams
Action: Click on the beams in the model you wish to modify. Press Enter to confirm selection.
```
*Note: The script will automatically apply the color, ID, grade, and name to all selected beams and then remove itself from the drawing.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Select Beam Type | dropdown | C16Joist | Determines the product class, which automatically sets the AutoCAD Color and HSB ID (e.g., TJI - 350). |
| Enter Timber Grade | text | (Space) | Sets the structural grade attribute on the beam (e.g., C16, C24). |
| Enter Information | text | (Space) | A text field for notes. *Note: Currently, this field does not update the beam entity.* |
| Enter Beam Name | text | (Space) | Assigns a name or mark to the beam for identification in schedules. |

## Right-Click Menu Options
There are no right-click menu options available. The script instance deletes itself immediately after processing the beams to keep the drawing clean.

## Settings Files
None required.

## Tips
- **Visual Verification**: The script changes the AutoCAD Color Index of the beams. Use this to visually verify that the correct product type has been assigned to different areas of the floor.
- **Batch Processing**: You can window select multiple beams at once during the "select a set of beams" prompt to apply properties to an entire floor section quickly.
- **Re-running**: Since the script deletes itself after use, simply run `TSLINSERT` again if you need to modify a different set of beams with new properties.

## FAQ
- **Q: Why did the script disappear after I selected the beams?**
  - A: This is intended behavior. The script runs once to update the data and then self-destructs (`eraseInstance`) so it does not clutter your project tree.
- **Q: I entered text in the "Information" field, but I don't see it on the beam.**
  - A: The current version of the script defines this field in the dialog, but the logic to write this data to the beam entity is not implemented. Only Grade, Name, Color, and ID are updated.
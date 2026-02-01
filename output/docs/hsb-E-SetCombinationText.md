# hsb-E-SetCombinationText

## Overview
This script allows you to batch-assign custom text labels (Text 1 through Text 5) to existing Combination elements (walls or floors) in your model. It is a utility tool that updates the properties of selected elements without creating new geometry.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates here and selects existing `hsb-E-Combination` entities. |
| Paper Space | No | Not designed for layout views or detailing. |
| Shop Drawing | No | Not intended for manufacturing drawings. |

## Prerequisites
- **Required entities**: `hsb-E-Combination` instances (e.g., walls or floors) must exist in the model.
- **Note**: The target Combination elements must have their text properties initialized (already containing data or defined) for the script to update them successfully. If a target text slot is completely empty/uninitialized, the script will skip updating that specific slot.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb-E-SetCombinationText.mcr`

### Step 2: Input Text Values
```
Dialog: "hsb-E-SetCombinationText"
Action: A dialog window will appear prompting you to enter text strings.
```
- Enter the desired text into fields **Text 1** through **Text 5**.
- Leave fields empty if you do not wish to update that specific slot.
- Click **OK** to confirm.

*(Note: If you run the script from a catalog entry with saved settings, this dialog may be skipped, and the saved values will be used automatically.)*

### Step 3: Select Entities
```
Command Line: Select entity(s)
Action: Click on the Combination elements (walls/floors) you wish to update.
```
- You can select multiple entities at once.
- Only valid `hsb-E-Combination` instances will be processed.

### Step 4: Completion
The script updates the properties of the selected entities and automatically removes itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Text 1 | Text | Empty | The text string to assign to the "Text 1" property of the selected element. |
| Text 2 | Text | Empty | The text string to assign to the "Text 2" property of the selected element. |
| Text 3 | Text | Empty | The text string to assign to the "Text 3" property of the selected element. |
| Text 4 | Text | Empty | The text string to assign to the "Text 4" property of the selected element. |
| Text 5 | Text | Empty | The text string to assign to the "Text 5" property of the selected element. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| None | This script erases itself immediately after execution and does not remain in the model for editing. |

## Settings Files
None required. The script uses its internal properties or catalog presets for configuration.

## Tips
- **Batch Processing**: You can select multiple walls or floors in a single run to apply the same labels (e.g., "Phase 1" or "Quality Check") to a group of elements.
- **Catalog Usage**: Save your script properties in a Catalog if you frequently use the same set of texts. Running the script from the catalog will bypass the dialog and speed up the workflow.
- **Property Initialization**: Ensure the Combination elements you are targeting actually have the specific text properties active. If the script seems to fail, check if the text fields on the element are currently empty or not defined in the element's own script.

## FAQ
- **Q: Why didn't the text update on my element?**
  **A**: The script is designed to only update text slots that are already initialized (contain existing data) on the target Combination element. If the target field is completely blank or undefined, the script will skip it to avoid errors. You may need to manually initialize the property on the element first.
- **Q: Can I undo this action?**
  **A**: Yes, you can use the standard AutoCAD `UNDO` command to revert the property changes if needed.
- **Q: Does this script work on single beams?**
  **A**: No, this script is designed specifically for `hsb-E-Combination` entities (panels/walls), not individual beams.
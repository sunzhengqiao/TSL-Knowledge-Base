# hsb_SetOpeningFloorDescriptionFromCatalog

## Overview
This batch utility allows you to apply a specific catalog configuration (such as descriptions, material codes, or preset dimensions) to multiple selected Roof or Floor openings simultaneously.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be executed in the model where OpeningRoof or OpeningFloor entities exist. |
| Paper Space | No | Not designed for layout or paper space usage. |
| Shop Drawing | No | This script modifies model data, not shop drawing views. |

## Prerequisites
- **Required Entities**: At least one `OpeningRoof` or `OpeningFloor` entity in the drawing.
- **Minimum beam count**: N/A (Selects entities, not beams).
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SetOpeningFloorDescriptionFromCatalog.mcr`

### Step 2: Define Catalog Name
A dialog box will appear when the script starts.
```
Dialog: Opening Catalog Name
Action: Type the name of the catalog entry you wish to apply (e.g., "StandardFloorTypeA"). Click OK to proceed.
```

### Step 3: Select Openings
```
Command Line: Select a set of Opening Roof/Floors
Action: Click on the desired Roof or Floor openings in the model. You can select multiple entities. Press Enter to confirm your selection.
```
*Note: The script will process the selected entities and then delete itself automatically.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Opening Catalog Name | Text | "" | The specific name of the catalog preset to apply to the selected openings. This name must match exactly (case-insensitive) with an existing catalog entry. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add persistent context menu items, as it erases itself after execution. |

## Settings Files
- **Filename**: None required
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Exact Spelling**: Ensure the Catalog Name entered matches the name in your database exactly. If the name does not match, the specific opening will be skipped without an error message.
- **Batch Processing**: You can select a mix of Roof and Floor openings in one go. The script automatically detects the type and applies the correct catalog logic.
- **Script Deletion**: The script instance removes itself from the drawing immediately after running. You do not need to manually delete it.

## FAQ
- **Q: What happens if I enter a catalog name that doesn't exist?**
  A: The script will skip the update for the selected entities and leave them unchanged. No error message will be displayed.
- **Q: Can I undo the changes made by this script?**
  A: Yes, you can use the standard AutoCAD `UNDO` command to revert the changes if the result is not as expected.
- **Q: Why did the script disappear from my drawing after I used it?**
  A: This is a "run-once" utility script. It is designed to execute its task and delete its own instance from the drawing automatically to keep the model clean.
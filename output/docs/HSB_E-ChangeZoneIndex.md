# HSB_E-ChangeZoneIndex

## Overview
This script allows you to batch update the Zone Index classification for timber beams and sheets. It provides options to target specific elements or individual pieces based on filters such as material, beam code, and labels.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the 3D Model. |
| Paper Space | No | Not supported in layouts. |
| Shop Drawing | No | Not supported in drawing generation mode. |

## Prerequisites
- **Required Entities**: Existing Elements (Walls/Floors) or GenBeams/Sheets in the model.
- **Minimum Beam Count**: 0 (Script runs on selection).
- **Required Settings**: `HSB_G-FilterGenBeams` (System dependency).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-ChangeZoneIndex.mcr`

### Step 2: Configure Properties
Once inserted, the Properties Palette will appear. Adjust the parameters below to define which items to select and how to filter them before confirming the selection.

### Step 3: Select Entities
After configuring properties, look at the AutoCAD command line:
```
Command Line: Select one or more entities [or Select one or more elements]
Action: Click the beams, sheets, or elements in the model that you wish to process, then press Enter.
```
*Note: The prompt text changes based on your "Input mode" selection in the Properties panel.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Input mode | dropdown | Beams/sheets | Choose whether to select individual beams/sheets manually or select entire Elements (which processes all beams inside them). |
| Filter mode | dropdown | Exclude | Determines how other filters work. "Exclude" removes matching items from selection; "Include" keeps only matching items. |
| Filter beams with beamcode | text | [Empty] | Enter a Beam Code (e.g., `STUD`) or list (e.g., `STUD;PLATE`) to filter specific structural types. |
| Filter beams and sheets with label | text | [Empty] | Enter a label or list of labels (separated by semicolons) to filter by user-assigned labels. |
| Filter beams and sheets with material | text | [Empty] | Enter a material code or list (e.g., `C24;GL24h`) to filter by material grade. |
| From zone | number | 0 | The current Zone Index of the beams you want to change. Only beams currently in this zone will be affected. |
| To zone | number | 1 | The new Zone Index to assign to the filtered beams. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are available for this script. |

## Settings Files
- **Dependency**: `HSB_G-FilterGenBeams`
- **Purpose**: Provides the underlying logic for filtering generic beams based on the script's criteria.

## Tips
- **Multiple Filters**: When entering values for Beam Code, Label, or Material filters, use a semicolon (`;`) to separate multiple values (e.g., `C24;C18`).
- **Source Zone Logic**: The `From zone` parameter acts as a master switch. If a selected beam is not in the specific "From zone" you defined, it will be ignored, regardless of other filters.
- **Zone Range**: The dropdown offers values 0–10. Values 6–10 are internally mapped to negative zones (-1 to -5) by the script, allowing for specialized negative zone indexing if your project uses it.

## FAQ
- **Q: I selected beams, but their zone didn't change. Why?**
  A: Check the `From zone` setting. The script only changes beams that are currently assigned to that specific source zone. If your beam is in Zone 0 and the script is set to change beams from Zone 1, nothing will happen.
  
- **Q: How do I select everything in a wall except the studs?**
  A: Set `Input mode` to Elements, set `Filter mode` to Exclude, and type `STUD` (or the relevant code) into the `Filter beams with beamcode` field. Select the wall element, and the script will update all non-stud beams.

- **Q: Can I use wildcards in the filter fields?**
  A: This script typically looks for exact matches or semicolon-separated lists. Wildcards (like * or ?) are generally not supported in the text filter fields for this specific script version.
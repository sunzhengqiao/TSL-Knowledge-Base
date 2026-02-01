# hsb_DetailBuilderSheetInformation.mcr

## Overview
This script performs a batch update of material attributes (Name, Material, Grade, Information, and Labels) and regenerates the standardized 'BeamCode' for sheeting or cladding materials within selected wall elements. It parses a condensed material string from existing sheet entities and redistributes the data into the correct properties for production and export.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the Model Space where ElementWall entities are located. |
| Paper Space | No | This script does not support layout or viewport operations. |
| Shop Drawing | No | This is not a shop drawing script (does not use `sd_` prefixes). |

## Prerequisites
- **Required Entities**: `ElementWall` entities that contain `Sheet` (cladding/boarding) entities.
- **Minimum Beam Count**: 0 (It processes sheets attached to walls, not standalone beams).
- **Required Data**: The Sheet entities must contain a 'material' string property formatted with specific delimiters (`; `) to be parsed correctly.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_DetailBuilderSheetInformation.mcr`
The script will load into the drawing environment.

### Step 2: Select Elements
```
Command Line: Select a set of elements
Action: Click to select one or more Wall elements in the model. Press Enter to confirm selection.
```
*Note: The script will save your selection and pause. It will not process immediately.*

### Step 3: Trigger Processing
```
Command Line: (Right-click or Calculate)
Action: Right-click on the script instance (or the drawing background) and select "Calculate" (or run `hsbCalc`).
```
*This step triggers the parsing logic. The script will loop through the selected walls and update their sheets.*

### Step 4: Completion
The script processes the data and automatically erases itself from the model once finished. No further cleanup is required.

## Properties Panel Parameters

This script does not expose any user-editable properties in the AutoCAD Properties Palette.

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Calculate | Executes the batch update of Sheet properties and BeamCodes based on the parsed material strings. |

*(Note: No custom context menu items are added by this script; it relies on the system default calculation trigger.)*

## Settings Files
None used. This script operates purely on the geometry and string data present in the selected entities.

## Tips
- **Delimiter Matters**: Ensure the material string in your sheets uses the separator `; ` (semicolon followed by a space). Sheets without this format will be skipped.
- **Batch Processing**: You can select multiple walls at once during Step 2 to update an entire floor or section quickly.
- **Auto-Cleanup**: The script is designed to delete itself automatically after processing. Do not be alarmed if it disappears from the model after the calculation is complete.

## FAQ
- **Q: Why didn't my sheets update?**
  - A: Check the 'material' property of your sheets. They must contain the `; ` delimiter for the script to recognize and parse the data.
- **Q: Can I use this on Roof elements?**
  - A: The script is designed specifically for `ElementWall` entities. While it may work if roofs share the exact same structure, it is intended for walls.
- **Q: Where is the script after I run it?**
  - A: The script automatically erases itself from the drawing immediately after finishing the update to keep your project clean.
- **Q: What exactly happens to the BeamCode?**
  - A: The script constructs a new BeamCode string in a fixed format (13 indices long) using the data extracted from the material string, replacing the previous code.
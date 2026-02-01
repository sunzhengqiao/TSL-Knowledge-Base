# GE_SHEET_TAG_CUT_UNCUT_PIECES.mcr

## Overview
This script automates the tagging and labeling of sheathing panels (such as plywood or OSB) by distinguishing between standard full sheets (4'x8') and custom cut pieces. It is used to organize production lists and shop labeling by applying unique sequential tags to either the cut pieces or the full sheets based on your selection.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in Model Space where Sheet entities exist. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required entities**: Sheet (Sheathing) elements must exist in the model.
- **Minimum sheet count**: 1 or more.
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_SHEET_TAG_CUT_UNCUT_PIECES.mcr`

### Step 2: Configure Properties
Upon insertion, the Properties Palette will display.
**Action:** Adjust the settings before selecting entities if needed.
- Set **Tag on** to `|CUT|` for partial sheets or `|UNCUT|` for full 4'x8' sheets.
- Enter a **Prefix** (e.g., "WALL-") and **Start count on** number.
- Select the desired **Color** and **Dimstyle** for the text tags.

### Step 3: Select Sheeting
```
Command Line: Select sheeting(s)
Action: Click on the sheet entities you wish to process. You can select multiple sheets or use a window selection.
```
**Action:** Press `Enter` to confirm selection.

### Step 4: Processing
The script will automatically filter the selected sheets based on the "Tag on" setting, sort them spatially, and apply the labels. Text tags will appear at the center of the qualifying sheets.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Tag on | dropdown | |CUT| | Determines which subset of sheets to process. Choose `|CUT|` for custom-sized pieces or `|UNCUT|` for standard full sheets (4'x8'). |
| Start count on | number | 1 | The starting integer for the numbering sequence (e.g., set to 10 to start numbering at 10, 11, 12...). |
| Prefix | text | | A text string added to the beginning of the label (e.g., if Prefix is "A" and Start is 1, the label reads "A1"). |
| Color | number | 1 | The AutoCAD Color Index (ACI) used for the text tag (1 = Red, etc.). |
| Dimstyle | dropdown | *Current* | Selects the Dimension Style from the drawing to control the text height and font of the tag. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are added by this script. Use the Properties Palette to modify settings. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Standard Size Definition**: The script defines an "Uncut" sheet as a piece with an area of 32 sq.ft. and dimensions of exactly 96" x 48" (within a small tolerance). Any sheet deviating from this (even slightly) is considered "Cut".
- **Updating Tags**: If you move or rotate the sheets after tagging, the script will automatically recalculate. The text tags will move with the sheets, and the numbering order will update based on the new spatial arrangement.
- **Re-ordering**: If you change the "Start count on" or "Prefix" in the Properties Palette, the script will immediately re-sequence and redraw all labels.
- **Selection**: If you select nothing during the prompt, the script instance will erase itself automatically.

## FAQ
- **Q: Why are my full 4'x8' sheets not showing up when I select "UNCUT"?**
  A: Check your dimensions. The script uses a strict tolerance of +/- 0.01 inches. If your sheet is modeled as 95.99" or 48.01", it may be classified as "Cut".
- **Q: What happens if I delete a sheet that has been tagged?**
  A: The script will detect the deletion and automatically renumber the remaining sheets to close the gap in the sequence.
- **Q: Can I tag both cut and uncut sheets at the same time?**
  A: No, you must run the script once for "CUT" pieces and once for "UNCUT" pieces (or insert two instances of the script with different settings).
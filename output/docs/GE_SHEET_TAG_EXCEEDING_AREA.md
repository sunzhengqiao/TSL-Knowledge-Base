# GE_SHEET_TAG_EXCEEDING_AREA

## Overview
This script identifies sheeting materials (such as OSB or Plywood) that exceed a specific maximum area. It automatically assigns a label to these sheets and places a 3D text marker in the model to flag them for special handling or production planning.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for selecting Sheet entities. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: Sheet entities (e.g., roof or floor sheathing).
- **Minimum Beam Count**: 1 (Must select at least one sheet during insertion).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT`
**Action:** Browse and select `GE_SHEET_TAG_EXCEEDING_AREA.mcr` from the file list.

### Step 2: Select Sheeting
```
Command Line: |Select sheeting|(s)
Action: Click on the sheeting entities in the model.
```
- You can select multiple sheets.
- Press **Enter** or **Space** to confirm your selection.

### Step 3: Review Results
- The script calculates the area of the selected sheets in square feet.
- If a sheet's area is larger than the limit, a tag is created.
- **Note:** If no sheets exceed the limit, the script will automatically delete itself and display a message in the command line.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Limit area (sq ft) | Number | 35 | The maximum allowable area. Sheets larger than this will be tagged. |
| Start count on | Number | 1 | The starting number for the sequence (e.g., set to 10 to start numbering at 10). |
| Prefix | Text | | Text added before the number (e.g., type "HEAVY-" to generate "HEAVY-1"). |
| Color | Number | 1 | The AutoCAD color index used for the 3D text marker (1 = Red). |
| Dimstyle | Dropdown | | The dimension style that controls the font and size of the text marker. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add custom context menu items. Use the Properties palette to modify settings. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Auto-Adjustment:** If the script disappears immediately after insertion, check the command line. It likely means no sheets met the area criteria. Select the script (if it persists) or re-insert it and increase the "Limit area (sq ft)" value.
- **Visibility:** Use the "Color" property to set the text marker to a highly visible color (like Red or Yellow) to easily identify large panels in the 3D model.
- **Filtering:** You can adjust the area threshold at any time by selecting the script instance and changing the properties. The tags will update automatically.

## FAQ
- **Q: Why did the script disappear after I selected sheets?**
  **A:** The script automatically deletes itself if none of the selected sheets exceed the "Limit area." Increase the limit value or select larger sheets.
  
- **Q: Can I change the labels after they are created?**
  **A:** Yes. Select the script instance in the model and modify the "Prefix" or "Start count on" in the Properties palette. The labels and text markers will update immediately.

- **Q: How is the area calculated?**
  **A:** The script calculates the physical area of the sheet body and converts it to square feet (sq ft) for comparison against your limit.
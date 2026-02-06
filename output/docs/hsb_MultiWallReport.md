# hsb_MultiWallReport.mcr

## Overview
This script generates a visual on-screen report that maps individual Element numbers to their parent MultiWall group IDs. It is used to verify which shop drawings or wall elements belong to specific MultiWall configurations directly within the CAD model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be run in the model space where Elements are located. |
| Paper Space | No | Not supported for Paper Space usage. |
| Shop Drawing | No | This is a model-level reporting script, not a shop drawing annotation. |

## Prerequisites
- **Required Entities**: One or more `Element` entities (typically walls).
- **Data Requirement**: Selected Elements must contain the `hsb_Multiwall` sub-map with a valid 'Number' attribute. Elements without this data will be skipped.
- **Minimum Beam Count**: N/A (Script operates on Elements, not individual beams).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse to the location of `hsb_MultiWallReport.mcr`, select the file, and click **Open**.

### Step 2: Select Elements
```
Command Line: Select one or More Elements
Action: Click on the timber wall Elements you wish to analyze.
```
Action: After selecting the desired Elements, press **Enter** or right-click to confirm selection.

### Step 3: View Report
The script will immediately generate a text table at your cursor location (or the script's insertion point).
- **Column 1**: Displays the MultiWall Number.
- **Column 2**: Displays the Element Numbers that belong to that MultiWall group.

## Properties Panel Parameters
None. This script does not expose editable parameters in the Properties Palette.

## Right-Click Menu Options
None. The script does not add specific commands to the entity context menu.

## Settings Files
- **Filename**: N/A
- **Location**: N/A
- **Purpose**: No external settings files are required for this script.

## Tips
- **Moving the Report**: The report text behaves like standard CAD text. You can select it and use the **Move** command or drag the grip point to relocate it for better visibility.
- **Updating Data**: The report is a static snapshot of the data at the time of insertion. If you modify Element properties or MultiWall groupings, you must delete the existing report and run the script again to see the updated information.
- **Data Verification**: If the report appears empty for selected elements, check if those elements actually have the `hsb_Multiwall` data assigned to them.

## FAQ
- **Q: Why did the script not display any text for some of the walls I selected?**
  A: The script only lists Elements that have valid `hsb_Multiwall` data. If an Element was selected but does not belong to a MultiWall group or is missing the specific data attribute, it will be ignored.

- **Q: How do I refresh the report after changing wall assignments?**
  A: You must erase the current text report instance and insert the script again. The report does not automatically update when model changes occur.

- **Q: Can I use this in a layout view?**
  A: No, this script is designed to read entity data from Model Space only.
# hsbProjectData.mcr

## Overview
Inserts and manages text labels that display user-defined project metadata (such as Project Name, Number, or City) directly in the CAD drawing. It acts as a smart tag that reads data from the project database.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary usage environment for placing project labels. |
| Paper Space | No | Not supported for insertion in Layouts. |
| Shop Drawing | No | Not designed for Shop Drawing context. |

## Prerequisites
- **Required Entities**: None.
- **Minimum Beam Count**: 0.
- **Required Settings**:
  - `hsbProjectData.dll` (Required).
  - `hsbProjectDataConfig.xml` (Optional; if missing, defaults to standard hsbCAD project data).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbProjectData.mcr` from the catalog.

### Step 2: Configure Project Data
A configuration dialog will appear automatically upon insertion.
- **Action**: Select the data fields (e.g., Project Name, Address, Revision) you want to display from the list. You can select multiple items at once.
- **Action**: Click **OK** to confirm or **Cancel** to stop.

### Step 3: Place Labels
```
Command Line: Specify insertion point:
Action: Click in the Model Space where you want the label(s) to appear.
```
*Note: If you selected multiple items in the previous step, they will be inserted as a stack at the clicked location.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Field Name | dropdown | (First available) | Selects the specific project data field to display (e.g., Project Name, City). |
| Text Height | number | U(20) | Sets the height of the text characters in the drawing. |
| Horizontal | dropdown | Center | Sets horizontal alignment relative to the insertion point (Left, Center, Right). |
| Vertical | dropdown | Center | Sets vertical alignment relative to the insertion point (Bottom, Center, Top). |
| Dimstyle | dropdown | (Current) | Assigns a specific Dimension Style to determine font and text appearance. |
| Color | number | 3 | Sets the CAD color index for the text. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are configured for this script. |

## Settings Files
- **Filename**: `hsbProjectDataConfig.xml`
- **Location**: `<Company Path>\TSL\CATALOG`
- **Purpose**: Defines custom field names and default values for the project data. If this file is missing, the script uses default standard fields.

## Tips
- **Bulk Insertion**: You can insert multiple labels at once by selecting multiple fields in the initial dialog. They will be stacked vertically based on the "Text Height" setting.
- **Updating Text**: If project information changes (e.g., the Project Name is updated in the main project properties), use the "Update Project Data" functionality (if available in your environment) or the script manager to refresh the underlying data. The labels will automatically update to reflect changes.
- **Changing Content**: To change what a specific label displays after insertion, select the label, open the **Properties Palette**, and change the **Field Name** option.

## FAQ
- **Q: Why does my text display "???"?**
  **A**: This means the script cannot find the data field specified in "Field Name" within the current project database. Select the label and choose a valid Field Name in the Properties Palette.
- **Q: Can I change the font style of the label?**
  **A**: Yes. Select the label and change the "Dimstyle" property in the Properties Palette to a dimension style that uses your desired font.
- **Q: The text is too small/large when I plot.**
  **A**: Adjust the "Text Height" property. Remember that this value is typically in millimeters and scales with your plot scale.
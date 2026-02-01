# GE_PLOT_SHOW_POSNUM.mcr

## Overview
This script generates a material schedule (cut list) in Paper Space for beams within a selected viewport. It automatically groups identical beams, assigns alpha-numeric position labels (A, B, C...), and places a detailed table on the layout along with corresponding labels on the beams.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | Script must be inserted on a Layout tab. |
| Paper Space | Yes | The script inserts the table and labels on the current layout. |
| Shop Drawing | No | This is a detailing/scheduling tool, not a generator for shop drawings. |

## Prerequisites
- **Required Entities**: A Layout (Paper Space) containing a viewport. The viewport must be displaying a valid hsbCAD Element (e.g., a Wall or Floor panel).
- **Minimum Beam Count**: 0 (The script will generate an empty table if no beams are found).
- **Required Settings**: The drawing must have valid Dimension Styles defined (managed by the global `_DimStyles` variable) to control text size.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT` → Select `GE_PLOT_SHOW_POSNUM.mcr`

### Step 2: Select Insertion Point
```
Command Line: Select upper left point of rectangle
Action: Click in Paper Space where you want the top-left corner of the schedule table to be located.
```

### Step 3: Select Viewport
```
Command Line: Select the viewport from which the element is taken
Action: Click on the border of the viewport that displays the model/wall you want to schedule.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dim style | Dropdown | (From Global List) | Selects the text style used for the table and labels. Changing this resizes the table and marker text. |
| Table header | String | "Text can be changed in the OPM" | The title text displayed at the top of the schedule table. |
| Header color | Number | 3 (Green) | The AutoCAD color index used for the header text. |
| Translate hsbId | Dropdown | Yes | If "Yes", shows readable names (e.g., "Stud"). If "No", shows raw internal codes (e.g., "18"). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are available for this script. |

## Settings Files
- **Filename**: None specific.
- **Location**: N/A
- **Purpose**: This script relies on the global `_DimStyles` variable configuration within the hsbCAD environment, not a specific external XML file.

## Tips
- **Label Placement**: The script includes collision detection. If a beam label would overlap with another, it automatically shifts its position along the beam to remain readable.
- **Resizing**: To quickly change the size of the table and labels, simply change the "Dim style" property to a style with a different text height (e.g., switch from "Standard" to a larger architectural font).
- **Moving the Table**: You can select the script object and use the grip edit point (the original insertion point) to move the table to a different location on the sheet.
- **Data Grouping**: Beams are only grouped together if they have the exact same Width, Height, Length, and HsbId/Name.

## FAQ
- **Q: Why is the table empty?**
  A: Ensure the viewport you selected is actually looking at an hsbCAD Element (Wall/Floor) and that the Element contains beams. The script cannot process plain AutoCAD lines or empty viewports.

- **Q: I see numbers (e.g., "18") in the table instead of names (e.g., "Stud").**
  A: Change the "Translate hsbId" property in the Properties Palette to "Yes". If names still do not appear, the specific beam code may not be mapped in the global hsbId configuration.

- **Q: The labels are too small to read on the printed drawing.**
  A: Select the script in Paper Space, open the Properties Palette, and change the "Dim style" to a style with a larger text height defined in your AutoCAD dimension styles.
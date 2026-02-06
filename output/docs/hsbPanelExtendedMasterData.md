# hsbPanelExtendedMasterData.mcr

## Overview
This script generates a visual data table in Model Space that displays extended properties of a Master Panel, including dimensions, net/gross area, material quality, and yield. It also attaches attribute data to the element for use in production lists or data extraction.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script is designed to run and display data in Model Space only. |
| Paper Space | No | Not supported for layout generation. |
| Shop Drawing | No | This is not a shop drawing generation script. |

## Prerequisites
- **Required Entities**: A `MasterPanel` entity must exist in the drawing.
- **Minimum Count**: At least 1 MasterPanel must be selected during insertion.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Run the `TSLINSERT` command in the AutoCAD command line and select `hsbPanelExtendedMasterData.mcr` from the list.

### Step 2: Configure Properties
A dialog box will appear upon insertion.
- **Unit**: Select the desired unit (e.g., mm, m, inch).
- **Decimals**: Choose the number of decimal places (0-4).
- **Dimstyle**: Select the text style for the table.
- **Color**: Select the color for the text.
- Click **OK** to confirm.

### Step 3: Select Panels
```
Command Line: Select other panels
Action: Click on the MasterPanel(s) you wish to analyze. Press Enter to finish selection.
```

### Step 4: Generation
The script will automatically generate a text table below each selected panel containing the calculated data. If the script detects mixed styles within the panel or unknown material qualities, a warning will be displayed in the command line.

## Properties Panel Parameters

After insertion, select the generated script instance (the data table origin point) and open the **Properties Palette** (Ctrl+1) to modify the following:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Unit | Dropdown | mm | Sets the unit of measurement for displayed dimensions (Length, Width, Height, Perimeter) and Areas. Options: mm, cm, m, inch, feet. |
| Decimals | Dropdown | 0 | Sets the precision (number of decimal places) for numerical values in the table. |
| Dimstyle | Dropdown | Standard | Defines the text style (font, height) used for the data table. |
| Color | Number | 3 | Sets the AutoCAD color index for the text table. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No specific custom context menu options are provided for this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external settings or XML files; it uses internal properties.

## Tips
- **Live Updates**: If you modify the geometry of the MasterPanel (e.g., change size or add openings), the data table will automatically recalculate and update the next time the drawing regenerates.
- **Moving the Table**: You can use the standard AutoCAD **Move** command or grip-edit the script insertion point to relocate the data table if it conflicts with other elements.
- **Data Aggregation**: The script analyzes all ChildPanels within the MasterPanel to calculate the Net Area (envelope minus openings) and detect material quality.
- **Unit Conversion**: Changing the `Unit` property in the palette instantly converts the displayed values without needing to delete and re-run the script.

## FAQ
- **Q: I see a warning "Style variation in Masterpanel". What does this mean?**
  A: This means the ChildPanels nested inside your MasterPanel have different styles assigned to them. The script will continue to function but will report this inconsistency.
  
- **Q: How do I change the text size of the data table?**
  A: Select the script instance, open the Properties Palette (Ctrl+1), and change the **Dimstyle** property to a text style with your desired height/font settings.

- **Q: Can I use this on elements other than MasterPanels?**
  A: No. The script is designed specifically to read MasterPanel entities. If attached to another entity type, it will erase itself.

- **Q: The "Quality" field is empty in my table. Why?**
  A: The script looks for specific strings (VI, BVI, NVI) in the material name of the panel. If your material naming convention differs, the script reports "Unknown Quality" and leaves the field blank.
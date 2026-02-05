# LinkedScheduleTable.mcr

## Overview
This script automatically generates linked schedule tables (such as beam takeoffs or material lists) in Paper Space. It formats data from a MapObject, allowing for chained tables that continue data listings from one table to the next.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed for Layouts only. |
| Paper Space | Yes | Requires a Viewport to define the model context. |
| Shop Drawing | No | This is a detailing/annotation tool. |

## Prerequisites
- **Required Entities**: A Viewport on the current Layout.
- **Data Source**: A valid MapObject structure containing schedule entries (`mpRow`) linked to the model elements.
- **Minimum Beam Count**: 0 (Data is retrieved from the MapObject, not by manually selecting beams).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `LinkedScheduleTable.mcr` from the list.

### Step 2: Configure Properties
Before placing the table, adjust settings in the **Properties Palette** (OPM).
- Set the **Title Text** (e.g., "Floor 1 Beam Schedule").
- Configure **Units** (`inch` or `mm`) and **Dimension Format**.
- Define **Column Headers** (comma-separated) matching your data keys.

### Step 3: Define Insertion Point
```
Command Line: Select upper left point of table:
Action: Click in the Paper Space layout to place the top-left corner of the table.
```

### Step 4: Link Table (Optional)
You can chain this table to a previous one to continue a list, or start fresh.
```
Command Line: Select previous table <Enter for Viewport>:
Action: 
- Option A (Chaining): Click an existing LinkedScheduleTable instance to continue its data.
- Option B (New): Press Enter to skip this and define a new data source.
```

### Step 5: Select Data Source
If you skipped the previous step (Option B):
```
Command Line: Select Viewport:
Action: Click the viewport on the layout that displays the model elements you wish to schedule.
```

### Step 6: Generation
The script calculates the column widths and row heights based on your text settings and draws the table. If the data exceeds the space, you can insert a new instance and link it to this one to show the remaining rows.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Title Text** | String | "" | The main header label displayed at the top of the table. |
| **Dimstyle** | String | _DimStyles | The dimension style used for text font and size settings. |
| **Units** | String | inch | Unit system for numerical values (`inch` or `mm`). |
| **Dim Format** | String | By Dimstyle | Format for numbers (Decimal, Fractional Inch, Ft-Inch, etc.). |
| **Precision** | Integer | 2 | Number of decimal places for numeric values (0-4). |
| **Title Height** | Double | -1 | Height of the title text. (-1 uses Dimstyle height). |
| **Text Height** | Double | -1 | Height of the row content text. (-1 uses Dimstyle height). |
| **Text Color** | Integer | 0 | AutoCAD Color Index (0-255) for table text. |
| **Line Color** | Integer | 1 | AutoCAD Color Index (0-255) for table borders/grid. |
| **Extra Width** | Double | 6 | Padding added to cell widths for text spacing. |
| **Extra Height** | Double | 3 | Padding added to row heights for text spacing. |
| **Zone** | Integer | 0 | Filter to show only elements within a specific construction zone. |
| **Column Headers** | String | "" | Comma-separated list defining the columns (e.g., "Mark,Length,Grade"). |
| **Show Quantity** | String | No | Toggles a column displaying the count of items ("Yes" or "No"). |
| **Format 1-7** | String | "" | Specific formatting strings applied to corresponding columns. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Select Previous Table** | Allows you to link this table to a different upstream table. Updates the starting data element. |
| **Select Viewport** | Re-associates the table with a different Viewport to change the model context. |
| **Recalculate** | Refreshes the table geometry and data based on current properties. |

## Settings Files
- **MapObject Data**: This script relies on data injected into the drawing's MapObject by other hsbCAD processes (e.g., export scripts). It does not typically use a standalone external XML configuration file for its core logic.

## Tips
- **Chaining Tables**: If your list is too long for one sheet, insert a second instance of the script and select the first table as the "Previous Table". The second table will automatically start listing items where the first one ended.
- **Formatting**: Set `Title Height` or `Text Height` to `-1` to automatically sync text size with your selected Dimstyle.
- **Unit Compatibility**: If using millimeters, ensure the **Dim Format** is set to "Decimal". Using "Fractional" with mm is automatically corrected by the script.

## FAQ
- **Q: Why is my table empty?**
- **A: Ensure you selected a Viewport that is linked to valid model elements. The script also requires a MapObject with `mpRow` data to be present; ensure you have run the necessary export/generation commands in hsbCAD.
  
- **Q: How do I change the column order or add columns?**
- **A**: Modify the **Column Headers** property in the Properties Palette. The script parses this comma-separated string to generate columns automatically.

- **Q: Can I move the table after inserting it?**
- **A**: Yes. Use the standard AutoCAD **Move** command or grip-edit the insertion point. If you have chained tables, moving the leader table will update the position logic for the followers.
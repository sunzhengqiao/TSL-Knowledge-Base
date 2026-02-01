# GE_PROJECT_DATA.mcr

## Overview
Inserts a customizable Project Information and Revision table into the drawing. This script allows you to define project metadata (Client, Architect, Address) and manage a revision history, automatically syncing this data with global hsbCAD Project Properties for use in labels and reports.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script is designed for insertion into the 3D model or 2D plan view. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required entities**: None.
- **Minimum beam count**: 0.
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Select `GE_PROJECT_DATA.mcr` from the file dialog.

### Step 2: Select Insertion Point
```
Command Line: Select the upper left corner of the table
Action: Click in the drawing to place the top-left corner of the project table.
```

### Step 3: Edit Project Data
1. After insertion, the Properties Palette (OPM) will open automatically.
2. Enter the Project details (Name, Number, Client, etc.).
3. Fill in the initial Revision history if applicable.
4. The table geometry in the drawing updates instantly to reflect your entries.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Visual Settings** | | | |
| Dim Style | dropdown | _DimStyles | Selects the AutoCAD dimension style to control font and text appearance. |
| Text Height | number | U(10) | Sets the height of the text in the table. Row height adjusts automatically (2x text height). |
| **Project Information** | | | |
| Project Name | text | | Sets the official Project Name (updates global hsbCAD Project Name). |
| Project Title | text | | The specific title or phase of the plan. |
| Project Number | text | | Unique Job ID (updates global hsbCAD Project Number). |
| Client | text | | Name of the client or owner. |
| Architect | text | | Name of the architectural firm or architect. |
| Address Line 1 | text | | First line of the site address. |
| Address Line 2 | text | | Second line of the site address (updates global Project City). |
| Designer | text | | Lead designer/engineer name (updates global Project User). |
| Checker | text | | QA/Checker name (updates global Project User). |
| Date | text | | Project start or issue date (updates global Project Street). |
| **Revisions** | | | |
| Revision 1-17 | text/date | | Enter the Date and Description for up to 17 revisions. The script automatically highlights the latest revision with a non-empty date. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Refreshes the script geometry if manual changes were made or to force an update. |

## Settings Files
None used.

## Tips
- **Column Widths**: You can adjust the width of the table columns by selecting the table and dragging the **5 square grips** located at the top edge.
- **Global Data**: Changes made to Project Name, Number, Designer, and Date in this table automatically update the global hsbCAD project properties, which can be utilized by other scripts (e.g., labels).
- **Latest Revision**: The script identifies the "Latest Revision" based on the last entry in the list that has a date filled in. Ensure you fill in the Date field for the revision you want to mark as current.

## FAQ
- **Q: How do I resize the columns?**
  A: Select the table in the drawing. You will see 5 grip points at the top of the table. Click and drag these grips left or right to resize the specific columns.
- **Q: Why didn't the global project properties update?**
  A: Ensure you have entered text into the relevant fields (e.g., Project Name, Project Number) in the Properties Palette and pressed Enter. The table must remain in the drawing to maintain the link.
- **Q: Can I change the text font?**
  A: Yes. Use the "Dim Style" property in the Properties Palette to select any existing Dimension Style in your drawing to match text fonts and sizes.
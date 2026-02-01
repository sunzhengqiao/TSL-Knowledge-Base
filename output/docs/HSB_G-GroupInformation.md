# HSB_G-GroupInformation.mcr

## Overview
Generates a 2D schedule table listing all Stick Frame wall types found in the model and their total quantities. This tool is used to place a Bill of Quantities (BOQ) or Wall Type summary directly in the model view.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script scans _kModelSpace for wall elements. |
| Paper Space | No | Not supported for this script. |
| Shop Drawing | No | This script operates on the 3D model, not 2D layouts. |

## Prerequisites
- **Required entities**: `ElementWallSF` (Stick Frame walls) must exist in the model.
- **Minimum beam count**: 0 (Script will generate a table with headers even if no walls are found).
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-GroupInformation.mcr`

### Step 2: Select Position
```
Command Line: Select a position
Action: Click in the Model Space where you want the top-left corner of the schedule table to be placed.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Style | String | "" | Visual separator label for the Properties palette. |
| Dimension style | dropdown | "     " | Selects the CAD Dimension Style to define text font and height for the table. |
| Textcolor header | number | 1 | Sets the color of the header row ('WallType' and 'Amount'). Uses standard AutoCAD Color Index (1 = Red, etc.). |
| Textcolor content | number | 5 | Sets the color of the data rows (Wall Names and Counts). Uses standard AutoCAD Color Index (5 = Blue, etc.). |
| Column width | number | U(500) | Defines the horizontal spacing between columns in millimeters. Increase if wall names are cut off. |
| Row height | number | U(75) | Defines the vertical spacing between rows in millimeters. Increase if text overlaps vertically. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | No custom context menu options are provided by this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Updating Data**: If you add or remove walls in the model, use the **hsbCAD Update** command (or recalculate the drawing) to refresh the counts in the table.
- **Text Overlap**: If the text in the table looks squashed, increase the **Row height** property. If wall names are too long for the column, increase the **Column width** property.
- **Styling**: To change the font type or size of the text, change the **Dimension style** property to a different style defined in your CAD template.

## FAQ
- Q: Why is my table empty (showing only headers)?
  A: The script could not find any `ElementWallSF` (Stick Frame) entities in the Model Space. Ensure you have drawn walls using the Stick Frame tool.
- Q: How do I change the text font?
  A: You cannot change the font directly in this script's properties. You must select a different **Dimension style** from the dropdown that utilizes your desired font settings.
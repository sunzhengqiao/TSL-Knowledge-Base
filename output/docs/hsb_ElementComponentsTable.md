# hsb_ElementComponentsTable

## Overview
This script automatically generates a material schedule table in Paper Space. It reads the construction layers (Zones, Materials, and Heights) of a timber element displayed in a selected viewport and creates a formatted list detailing the build-up.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed for layouts. |
| Paper Space | Yes | The script must be inserted onto a layout containing a viewport. |
| Shop Drawing | No | Used primarily for general layout documentation. |

## Prerequisites
- **Required Entities**: A Layout (Paper Space) with at least one Viewport.
- **Model Content**: The selected Viewport must contain a valid hsbCAD Element (e.g., a Wall, Floor, or Roof) with assigned construction layers.
- **Settings**: None required (uses standard Text/Dim styles from the drawing).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or your company's custom insert command) → Select `hsb_ElementComponentsTable.mcr`

### Step 2: Select Insertion Point
```
Command Line: Select insertion point:
Action: Click in the Paper Space layout where you want the top-left corner of the table to be placed.
```

### Step 3: Select Viewport
```
Command Line: Select the viewport...
Action: Click on the viewport border that displays the element you wish to schedule.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Table Title** | String | Element Components | The main header text displayed at the top of the table. |
| **Dim Style** | String | _DimStyles | The text style used for the table content. Changing this updates the font and automatically adjusts column widths. |
| **Scale** | Double | 1.0 | A multiplier to resize the entire table. Increase to make text and lines larger; decrease to make them smaller. |
| **character size** | Double | 17.0 | The base text height (in drawing units) for the table content. |
| **Table Text Color** | Integer | 1 (Red) | The AutoCAD color index for the main data rows (Zone, Material, Height). |
| **Title Text Color** | Integer | 1 (Red) | The AutoCAD color index for the main Table Title. |
| **Header Text Color** | Integer | 1 (Red) | The AutoCAD color index for the column headers (Zone, Material, Height). |
| **Line Color** | Integer | 1 (Red) | The AutoCAD color index for the grid lines and table borders. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Update** | Recalculates the table based on changes to the model (e.g., added layers) or property changes. |
| **Erase** | Removes the script and the generated table from the drawing. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies on standard AutoCAD/hsbCAD entities and does not require external XML settings files.

## Tips
- **Move the Table**: Select the table and use the grip edit point at the top-left corner to move it to a new location.
- **Adjusting Size**: Instead of changing the `character size` directly, try using the `Scale` property to quickly enlarge or shrink the entire table proportionally.
- **Visual Grouping**: The script automatically groups rows by "Zone". If two consecutive rows belong to the same zone, the Zone name is only displayed once for the first row to keep the table clean.
- **Insulation Naming**: If the element contains insulation, the script will label it specifically as "INSULATION" followed by the beam name for clarity.

## FAQ
- **Q: Why did the script disappear immediately after insertion?**
  A: This usually happens if you canceled the Viewport selection or if the selected Viewport does not contain a valid hsbCAD Element. Ensure you click a viewport with an active wall/floor/roof.
- **Q: The table text is too small/large for my sheet.**
  A: Select the script, open the Properties Palette, and change the `Scale` factor (e.g., set to 1.5 for larger text).
- **Q: How do I change the font?**
  A: Change the `Dim Style` property to a different Text Style defined in your AutoCAD drawing. The table will automatically resize its columns to fit the new font.
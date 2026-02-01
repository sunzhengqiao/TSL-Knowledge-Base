# hsb_CheckingTable.mcr

## Overview
Generates a 2D schedule table in Model Space that summarizes structural and manufacturing properties (Height, Pitch, Lintel, Nailing) of selected wall elements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The table is inserted at a user-defined point in the active UCS. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: Wall Elements.
- **Specific Requirements**:
    - To populate **Nailing** info: The script `hsb_Apply Naillines to Elements` must be attached to the elements.
    - To populate **Lintel** info: An ElemText with Code `WINDOW` and SubCode `HEADER` must exist on the elements.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_CheckingTable.mcr`

### Step 2: Configure Properties (Initial)
```
Dialog: Properties Palette (if appearing)
Action: (Optional) Set the Table Title, select a Dimstyle, or adjust colors before placing the table.
```

### Step 3: Place Table
```
Command Line: Pick a Point
Action: Click in the Model Space to define the insertion point (top-left corner) of the table.
```

### Step 4: Select Elements
```
Command Line: Please select Elements
Action: Select the wall elements you wish to include in the schedule. Press Enter to confirm selection.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Table Title | text | [Empty] | The descriptive header text displayed at the top of the table. |
| Dimstyle | dropdown | _DimStyles | The dimension style used to format text. This controls the text height and overall scale of the table. |
| Table Text Color | number | 7 | CAD Color Index for the data content text. |
| Title Color | number | 4 | CAD Color Index for the main table title text. |
| Header Color | number | -1 | CAD Color Index for the column headers (e.g., "Group", "Height"). -1 = ByLayer. |
| Line Color | number | -1 | CAD Color Index for the table grid lines. -1 = ByLayer. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are added by this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external XML settings files.

## Tips
- **Resizing the Table**: To change the physical size of the table, change the `Dimstyle` property to a style with larger or smaller text settings.
- **Visual Grouping**: The table automatically groups rows by element code. If the "Group" name is identical to the row above it, the cell is left blank to create a cleaner, grouped visual effect.
- **Data Validation**: If columns appear empty, verify that the prerequisite TSL scripts or ElemTexts are correctly applied to the source wall elements.

## FAQ
- **Q: Why is the "Nailing" column empty?**
- **A:** Ensure the script `hsb_Apply Naillines to Elements` is attached to the selected wall elements.

- **Q: Why is the "Lintel" column empty?**
- **A:** You must add an ElemText with Code `WINDOW` and SubCode `HEADER` to your wall elements to display this data.
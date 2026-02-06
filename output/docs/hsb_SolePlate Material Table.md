# hsb_SolePlate Material Table

## Overview
Generates a graphical Bill of Materials (BOM) table for Soleplates in the model. It displays dimensions, quantities, and units based on aggregated data stored in the instance map.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be inserted into Model Space. |
| Paper Space | No | Not supported for layout insertion. |
| Shop Drawing | No | This is a model reporting/scheduling tool. |

## Prerequisites
- **Data Source**: An instance map named `mpTable` must exist in the model data. This map acts as the source for the table content (Description, Width, Height, Qty, Unit).
- **Script Dependency**: The script `hsb_SolePlate TableEntry` must be present in the hsbCAD search path to handle individual row generation.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or use the hsbCAD catalog browser) → Select `hsb_SolePlate Material Table.mcr`.

### Step 2: Configure Properties
**Action**: The Properties Palette will appear automatically upon insertion.
**Details**: Set the Text Style, Colors, or Group Names before placing the element.

### Step 3: Place Table
```
Command Line: Pick a Point
Action: Click anywhere in the Model Space to define the bottom-left origin of the table.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimstyle | Dropdown | *Current Style* | Selects the text style (font and size) for the entire table. Changing this automatically recalculates column widths to fit the text. |
| Color Header and Lines | Number | 171 | Sets the AutoCAD color index for the table title, column headers, and grid lines. |
| Row Color | Number | 143 | Sets the AutoCAD color index for the data text inside the rows. |
| House Level group name | Text | 00_GF-Soleplates | Defines the top-level group name in the CAD model structure for this element. |
| Floor Level group name | Text | GF-Soleplates | Defines the second-level group name in the CAD model structure for this element. |
| Show Table Dim in Disp Rep | Text | *Empty* | Intended for display representation filtering (currently inactive). |
| Table Title | Text | SOLEPLATE BOM | Sets the header text displayed at the top of the table. |

## Right-Click Menu Options
None defined in this script. Standard AutoCAD grips and properties options apply.

## Settings Files
No external settings files (XML/TXT) are used by this script. It relies entirely on the Instance Map data (`mpTable`) and Properties Palette inputs.

## Tips
- **Auto-Sizing**: If the text looks cut off or the columns are too wide, change the **Dimstyle** property. The script will dynamically resize the columns based on the new font metrics.
- **Updating Data**: If the underlying model data changes, you usually do not need to delete the table. Ensure the `mpTable` is updated by the source process, and the script will refresh the next time the drawing is recalculated or opened.
- **Colors**: Use distinct colors for Headers vs. Rows to improve readability on the shop floor.

## FAQ
- **Q: I inserted the script, but it disappeared immediately.**
  - **A**: The script requires a data map named `mpTable` to function. If this data is not present in the model instance, the script erases itself automatically. Ensure the prerequisite data processing step has been completed before inserting the table.

- **Q: How do I change the table title?**
  - **A**: Select the table in the drawing, open the Properties Palette (`Ctrl+1`), and edit the **Table Title** field.

- **Q: Can I move the table after inserting it?**
  - **A**: Yes. Use the standard AutoCAD Move command or drag the grip point associated with the script instance. The graphical table and sub-instances will move together.
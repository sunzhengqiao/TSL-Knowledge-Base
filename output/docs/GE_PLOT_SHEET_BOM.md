# GE_PLOT_SHEET_BOM.mcr

## Overview
This script generates a customizable Bill of Materials (BOM) table for sheeting elements directly on a layout (Paper Space). It aggregates data from a selected viewport's element, allowing you to list materials, dimensions, quantities, and zones in a formatted table suitable for plotting.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed for layouts. |
| Paper Space | Yes | Must be inserted in a Layout containing a Viewport. |
| Shop Drawing | No | This creates a schedule table, not production CAM data. |

## Prerequisites
- **Required Entities:** A Layout (Paper Space) with at least one Viewport linked to an hsbCAD Element containing sheeting data.
- **Minimum beam count:** 0.
- **Required settings files:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_PLOT_SHEET_BOM.mcr`

### Step 2: Configure Initial Settings
```
Action: A Property Dialog will appear automatically upon insertion.
What to do: Adjust the Table Header, Column Headers, and filtering options if necessary, then click OK.
```

### Step 3: Select Insertion Point
```
Command Line: Select upper left point of rectangle
Action: Click in the Paper Space where you want the top-left corner of the table to be located.
```

### Step 4: Select Source Viewport
```
Command Line: Select the viewport from which the element is taken
Action: Click on the viewport border that displays the 3D model containing the sheeting elements you wish to list.
```

## Properties Panel Parameters
After insertion, select the table to modify these parameters in the Properties Palette.

### General Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Table header | text | Sheeting List | The main title displayed at the top of the table. |
| Dim style | dropdown | *Current* | The dimension style to use for text within the table. |
| Justification | dropdown | Top | Anchor point of the table. "Top" grows downward; "Bottom" grows upward from the picked point. |
| Header color | number | 7 | The AutoCAD color index for the header text. |
| Multiply output by 25.4 | dropdown | No | If "Yes", multiplies dimensions by 25.4 (e.g., converting mm to inches). |

### Column Headers
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Material header | text | Mat. | Label for the material column. |
| Qty header | text | Qty | Label for the quantity column. |
| Width header | text | Width | Label for the width column. |
| Height header | text | Height | Label for the height column. |
| Number header | text | Num. | Label for the position number column. |
| Zone header | text | Zone | Label for the zone column. |

### Column Visibility & Layout
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Width Material Col. | number | *Value* | Width of the Material column. Set to **0** to hide this column. |
| Width Qty Col. | number | *Value* | Width of the Quantity column. Set to **0** to hide this column. |
| Width Width Col. | number | *Value* | Width of the Width dimension column. Set to **0** to hide this column. |
| Width Height Col. | number | *Value* | Width of the Height dimension column. Set to **0** to hide this column. |
| Width Num Col. | number | *Value* | Width of the Number column. Set to **0** to hide this column. |
| Width Zone Col. | number | *Value* | Width of the Zone column. Set to **0** to hide this column. |

### Filtering Options
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zones to use | dropdown | Use zone index | Determines how zones are filtered. Options: "Use zone index" or "All". |
| Zone index | dropdown | 5 | The specific zone number to analyze if "Use zone index" is selected. |
| Filter Material | text | GYP | Filters the list to only include sheets containing this text (e.g., "GYP" for Gypsum). Leave empty to include all. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the table data if the source element has changed or if properties were modified via the command line. |

## Settings Files
No external settings files are used.

## Tips
- **Hide Columns:** To remove specific information from the table (like the Zone), simply set that column's width property to `0`.
- **Specific Materials:** Use the **Filter Material** property to create a schedule for only floor sheathing or only wall sheathing by typing the material name used in your catalogs.
- **Unit Conversion:** If working in imperial but the model is metric, set "Multiply output by 25.4" to **Yes** to convert displayed dimensions.

## FAQ
- Q: Why is my table empty?
  A: Ensure the Viewport you selected actually contains an element with sheeting data (sheets) assigned to it, and that your "Filter Material" setting matches the material names in the model.
- Q: How do I change the text size?
  A: The script uses the selected "Dim style" settings. Change the text height in the AutoCAD Dimension Style Manager (DDIM) for the style selected in the script properties.
- Q: Can I list multiple specific zones at once?
  A: No, you can either list a single specific zone index or set "Zones to use" to "All" to show every zone.
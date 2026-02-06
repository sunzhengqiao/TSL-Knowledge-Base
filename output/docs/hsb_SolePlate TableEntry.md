# hsb_SolePlate TableEntry.mcr

## Overview
This script is a sub-component used to automatically generate a single row in a material table for Sole Plates. It reads data passed from a parent script to display material properties (Description, Width, Height, Quantity, Unit) and exports data for production lists.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script draws text and geometry relative to an origin point in Model Space. |
| Paper Space | No | Not designed for Paper Space layout. |
| Shop Drawing | No | This is a documentation/model space script, not a shop drawing generator. |

## Prerequisites
- **Parent Script**: `hsb_SolePlate Material Table` (This script is usually called automatically by this parent).
- **Required Map Data**: The script requires a `_Map` passed during insertion containing:
    - `ptOrg`: The insertion point (Point3d).
    - `mapTableObject`: A map containing material data (Description, Width, Height, Qty, Unit).
- **Linked Entity**: At least one entity must be linked (`_Entity[0]`) for the script to group itself correctly.

## Usage Steps

### Step 1: Automatic Execution (Typical)
This script is generally **not** launched manually by the user. It is instantiated automatically by the `hsb_SolePlate Material Table` script when generating a full material list.

### Step 2: Manual Launch (For Testing Only)
If testing this script manually without the parent caller:
```
Command Line: TSLINSERT
Action: Select hsb_SolePlate TableEntry.mcr from the list
```
*Note: If run manually without the required Map data (`ptOrg` and `mapTableObject`), the script will detect missing data and immediately erase itself from the drawing.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Row height | Double | 100 mm | Sets the vertical height of the table row. Adjust if text overlaps or spacing is too large. |
| Column width | Double | 1000 mm | Sets the width of the columns. Used if specific widths are not provided by the parent map. |
| Dimension style | String | _DimStyles | Specifies the Dimension Style to use for text appearance (font, size). |
| Content color | Integer | -1 | Sets the color of the table text and lines. -1 indicates "ByLayer" color. |

## Right-Click Menu Options
No custom context menu items are added by this script.

## Settings Files
No external settings files (XML) are used by this script. It relies on the `_Map` provided by the parent `hsb_SolePlate Material Table` script.

## Tips
- **Formatting**: If the table text looks cramped, increase the **Row height** or **Column width** in the properties palette.
- **Layer Control**: The script assigns itself to the group of the linked Sole Plate entity. If you delete the Sole Plate, this table entry should also be removed.
- **Data Export**: This script automatically exports data to the DXI interface for BOM generation. Ensure your export settings are configured correctly in the main hsbCAD setup.

## FAQ
- **Q: Why did the script disappear immediately after I inserted it?**
  **A:** This script requires specific coordinate and material data (`ptOrg`, `mapTableObject`) to be passed to it via a Map. If run manually without the parent script supplying this data, it will self-delete to prevent errors. Use the `hsb_SolePlate Material Table` script to generate these rows.

- **Q: Can I change the text font?**
  **A:** Yes. Select the table entry, open the Properties palette, and change the **Dimension style** property to a style that uses your preferred font.

- **Q: The text is the wrong color. How do I fix it?**
  **A:** Select the entry and change the **Content color** property. Set it to `-1` to use the color of the layer the script is placed on, or enter a specific color index (e.g., 1 for Red, 2 for Yellow, etc.).
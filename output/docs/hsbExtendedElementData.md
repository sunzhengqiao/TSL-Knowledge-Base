# hsbExtendedElementData.mcr

## Overview
This script automatically calculates geometric properties (dimensions, area, volume, and insulation) for a selected timber Element. It writes these values to an AutoCAD Property Set for scheduling and can display a data table directly in the model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D Elements. |
| Paper Space | No | Not supported in layout views. |
| Shop Drawing | No | Not designed for detail generation. |

## Prerequisites
- **Required Entities**: An existing hsbCAD Element (Wall, Floor, or Roof).
- **Minimum Beam Count**: 0.
- **Required Settings**: An AutoCAD Property Set Definition must exist in the drawing if you wish to export data. It must contain the following properties defined as **Real Numbers**: `Height`, `Width`, `Length`, `Perimeter`, `AreaNet`, `AreaGros`, `Insulation`.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT` → Select `hsbExtendedElementData.mcr` from the list.

### Step 2: Configure Properties
A dialog box appears upon insertion. Configure the default settings (Units, Decimals, Property Set Name) and click **OK**.

### Step 3: Select Element
```
Command Line: Select Element
Action: Click on the desired timber Element in the 3D model.
```
*Note: You can select multiple elements. If the script is already attached to an element, it will skip it.*

### Step 4: Review Output
The script attaches to the element. If **Show table** is enabled, a text box displaying the calculations will appear near the element. The calculated values are automatically written to the specified Property Set.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Unit** | dropdown | mm | The unit of measurement used for displayed values and data written to Property Sets (mm, cm, m, inch, feet). |
| **Decimals** | number | 2 | The number of decimal places shown in the on-screen text table. |
| **Length taken from** | dropdown | \|entire Element\| | Defines the geometry used for length calculation: <br>• **entire Element**: Includes all layers (cladding, plaster).<br>• **Zone 0**: Structural timber zone only.<br>• **Element Outline**: Based on the 2D outline profile. |
| **Height taken from** | dropdown | \|entire Element\| | Defines the geometry used for height calculation (Options same as Length). |
| **Width taken from** | dropdown | \|entire Element\| | Defines the geometry used for thickness calculation. (Options: entire Element, Zone 0, Wall Outline). |
| **Net Area: ignore Openings < DU** | number | 0 | Sets a threshold area. Openings smaller than this value are ignored in the Net Area calculation (useful to ignore drill holes). |
| **Color** | number | 222 | AutoCAD color index for the dimension lines and text table. |
| **Dimstyle** | dropdown | [Empty] | The text style used for the on-screen table. Leave blank to use a default, or select a specific style from your drawing. |
| **Show table** | dropdown | \|No\| | Controls visibility of the data table in the model:<br>• **No**: Hides the table (data is still written to Property Sets).<br>• **WCS**: Table aligns with World Coordinates.<br>• **ECS**: Table aligns with Element orientation (rotates with wall). |
| **Property Set Name** | dropdown | [Empty] | The name of the AutoCAD Property Set Definition to write data to. If left blank, no data is written to properties. |

## Right-Click Menu Options
*Note: This script does not add specific custom items to the right-click context menu. Standard hsbCAD script options (e.g., Refresh, Erase) apply.*

## Settings Files
No specific external settings files (XML) are required for this script beyond standard hsbCAD catalogs.

## Tips
- **Zone 0 vs Entire Element**: Use "Zone 0" as the source for dimensions if you need structural timber quantities (net frame), excluding finishes like gypsum board or siding.
- **Scheduling**: Since the script writes directly to AutoCAD Property Sets, you can create a standard AutoCAD Schedule Table to display these values in drawings.
- **Performance**: If inserting on hundreds of elements, consider setting **Show table** to "No" initially to reduce visual clutter, then enable it only for specific elements as needed.
- **Moving the Table**: If the table obstructs your view, select the script instance (often visible as a small grip or the text itself) and use AutoCAD Move commands or grips to relocate it.

## FAQ
- **Q: Why are my Property Sets not updating?**
  - **A**: Check that the **Property Set Name** matches the definition in your drawing exactly. Ensure the properties inside that definition are spelled correctly (`Height`, `Width`, `Length`, etc.) and are defined as **Real Numbers** (Double), not Text.
- **Q: The Net Area seems too large/small.**
  - **A**: Adjust the **Net Area: ignore Openings < DU** parameter. If small service holes are reducing your area incorrectly, increase this value to filter them out.
- **Q: Can I use this for Roofs and Floors?**
  - **A**: Yes, the script works on any hsbCAD Element. For Walls, the table reference point is the "Arrow"; for other elements, it uses the Origin.
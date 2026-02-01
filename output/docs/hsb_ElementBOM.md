# hsb_ElementBOM.mcr

## Overview
Automates the creation of a Bill of Materials (BOM) table for timber construction elements (walls, floors, roofs) directly in layout views. It aggregates data from viewports or shop drawings, allowing detailed filtering of beams, sheets, hardware, and materials, and places a formatted table on the sheet.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is intended for layout documentation. |
| Paper Space | Yes | Use this mode to generate a BOM from a standard viewport. |
| Shop Drawing | Yes | Use "Shopdraw multipage" mode to generate a BOM from a specific shopdrawing view entity. |

## Prerequisites
- **Required Entities**: Element, GenBeam, Sheeting, or Material entities must exist in the selected view.
- **Minimum Beam Count**: 0 (Works with empty or specific subsets of elements).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_ElementBOM.mcr`

### Step 2: Configure BOM Settings
```
Action: An initial configuration dialog appears (or Properties Panel opens).
```
Set your preferred filtering options (e.g., exclude specific materials, toggle metal parts on/off) and click OK.

### Step 3: Place Table
```
Command Line: Pick a point to show the table
Action: Click in the Paper Space layout where you want the top-left corner of the BOM table to appear.
```

### Step 4: Select Data Source
The prompt depends on the "Drawing Space" property selected in Step 2.

**If "Drawing Space" is set to `|paper space|`:**
```
Command Line: Select the viewport from which the element is taken
Action: Click the border of the viewport containing the model view you wish to list.
```

**If "Drawing Space" is set to `|shopdraw multipage|`:**
```
Command Line: Select the view entity from which the module is taken
Action: Click the specific shopdrawing view entity (frame) in the model or layout.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Drawing space | dropdown | \|paper space\| | Selects the environment: Paper Space Viewport or Shopdraw Multipage view entity. |
| Dim Style | dropdown | *Current* | AutoCAD Dimension Style used to determine text font and height for the table. |
| Color | number | 3 | AutoCAD color index for the table frame and text lines. |
| Beam names to exclude | text | "" | Semicolon-separated list of beam names to hide (e.g., "WEB;STRINGER"). |
| Filter by Zone | text | "" | Semicolon-separated list of zone numbers to exclude from the BOM. |
| Materials to exclude | text | "" | Semicolon-separated list of material names to exclude (e.g., "C24;OSB"). |
| Grouping | dropdown | \|Posnum & dimension\| | Determines how items are grouped: "Posnum" ignores dimensions, while "Posnum & dimension" separates items by size. |
| Complementary Angle | dropdown | No | If "Yes", converts roof/wall angles to their complementary value (90 - pitch). |
| Do Sheets | dropdown | Yes | Toggle to include/exclude sheeting materials (plywood, gypsum, etc.). |
| Do Beams | dropdown | Yes | Toggle to include/exclude structural timber members. |
| Do SIPs | dropdown | Yes | Toggle to include/exclude Structural Insulated Panels. |
| Do Metalparts | dropdown | Yes | Toggle to include/exclude metal hardware and connectors. |
| Do Trusses | dropdown | Yes | Toggle to include/exclude roof trusses. |
| Dim Style Posnum | text | "" | Specific Dimension Style for the position number labels drawn on the beams (if enabled). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Refreshes the BOM table if the model geometry or properties have changed. |
| Delete | Removes the BOM script instance and the drawn table from the drawing. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies entirely on entity data and Properties Panel settings; no external XML settings file is required.

## Tips
- **Filtering**: Use the "Beam names to exclude" property to remove temporary members like webs or stiffeners from your production list.
- **Text Size**: To change the text size of the table, modify the `Dim Style` property to point to an AutoCAD dimension style with your desired text height.
- **Label Overlaps**: The script includes collision detection for part labels; if labels are too crowded, it will automatically attempt to shift them to a clear position.

## FAQ
- **Q: Why are my metal plates not showing up?**
- **A:** Check the `Do Metalparts` property in the Properties Palette and ensure it is set to "Yes".
- **Q: How do I separate items that have the same position number but different lengths?**
- **A:** Change the `Grouping` property to `|Posnum & dimension|`. This treats items with different dimensions as separate line items.
- **Q: Can I move the table after inserting it?**
- **A:** Yes, select the BOM table (it is a block) and use standard AutoCAD Move commands or grip editing to reposition it.
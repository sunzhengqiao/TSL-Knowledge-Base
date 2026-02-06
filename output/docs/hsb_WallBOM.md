# hsb_WallBOM.mcr

## Overview
Generates a detailed Bill of Materials (BOM) table and optional position number labels for timber wall assemblies directly in your shop drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | The script generates 2D output based on 3D model data, but is placed in layouts. |
| Paper Space | Yes | Links to a standard AutoCAD Viewport. |
| Shop Drawing | Yes | Links to a hsbCAD Shopdrawing View Entity (Multipage). |

## Prerequisites
- **Required Entities**: A Viewport or Shopdrawing View entity that is linked to a valid hsbCAD Element (e.g., a Wall).
- **Minimum Beam Count**: 0 (The script will generate a header even if the wall is empty).
- **Required Settings**: Dimension Styles must be configured in the drawing to control text size.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_WallBOM.mcr`

### Step 2: Configure Properties
```
Action: The Properties configuration dialog appears.
Action: Adjust settings (e.g., BOM content, Dimension Styles) and click OK.
```

### Step 3: Set Table Origin
```
Command Line: Pick a point where the bottom horizontal dim will reference to
Action: Click in the layout (Paper Space or Shopdrawing page) to set the bottom-left corner of the BOM table.
```

### Step 4: Select Source View
*(The prompt depends on the "Drawing space" property selected in Step 2)*

**Option A: Paper Space**
```
Command Line: Select the viewport from which the element is taken
Action: Click the border of the viewport displaying the wall elevation you wish to list.
```

**Option B: Shopdraw Multipage**
```
Command Line: |Select the view entity from which the module is taken|
Action: Click the view entity frame representing the wall elevation.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Drawing space** | dropdown | \|paper space\| | Select the environment: Paper Space (Viewport) or Shopdraw Multipage (View Entity). |
| **Dim Style** | dropdown | *Current* | Dimension style used for the text and dimensions inside the BOM table. |
| **Color** | number | 3 | AutoCAD color index (1-255) for the table lines and text. |
| **Materials to exclude from the BOM** | text | | Enter material names to hide, separated by a semicolon (e.g., `NAIL;GLUE`). |
| **Switch to Complementary Angle** | dropdown | No | If "Yes", calculates angles as (90 - Angle). |
| **Show Sheets in the BOM** | dropdown | Yes | Toggles the listing of sheet materials (e.g., OSB, Plywood). |
| **Show Beams in the BOM** | dropdown | Yes | Toggles the listing of timber beams (studs, plates, etc.). |
| **Dim Style Posnum** | dropdown | *Current* | Dimension style used specifically for the position number labels on the drawing. |
| **Color Posnum** | number | 3 | AutoCAD color index for the position number labels. |
| **Show Beam Posnum** | dropdown | No | If "Yes", draws position number labels (tags) on the wall beams in the view. |
| **Show Posnum Zone, 0=none** | dropdown | 0 | Filters the BOM to specific construction zones (0 = All). Enables label placement logic if set > 0. |
| **Show Label Column** | dropdown | Yes | Toggles the visibility of the "Label" column in the timber section of the table. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *Standard TSL Menu* | Erase, Update, etc. (No specific custom menu items added by this script). |

## Settings Files
- None required (Standard hsbCAD DimStyles are used).

## Tips
- **Filtering Materials**: Use the "Materials to exclude" property to remove hardware or small consumables from your cut list to keep it clean.
- **Moving the Table**: Select the BOM table and use the **Grip** at the insertion point (bottom-right of the first selection box usually) to drag the table to a new location. The table will automatically regenerate.
- **Table Size**: To change the text height or width of columns, modify the **Dim Style** settings in AutoCAD, then update the script properties to use that new Dim Style.
- **Zone Filtering**: If you only want to list studs for the left side of a complex wall, set "Show Posnum Zone" to the index number corresponding to that wall layer/zone.

## FAQ
- **Q: Why is my table empty?**
  **A:** Ensure the Viewport or View Entity you selected is actually linked to a valid hsbCAD Element (Wall) and that the "Show Beams" and "Show Sheets" options are set to "Yes".
- **Q: How do I remove specific steel parts from the wood list?**
  **A:** Type the material name (e.g., "STEEL") into the "Materials to exclude from the BOM" property.
- **Q: The text is too small/large.**
  **A:** Do not scale the script entity. Instead, create a new AutoCAD Dimension Style with the desired text height and assign it to the "Dim Style" property in the palette.
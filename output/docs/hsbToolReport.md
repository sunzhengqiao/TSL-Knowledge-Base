# hsbToolReport.mcr

## Overview
This script automatically generates a graphical schedule (table) listing all unique drill diameters and depths found within a selected element or set of beams. It creates a visual legend in 2D, distinguishing between through-drills (solid) and blind-drills (ringed), to serve as a manufacturing guide on shop drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Select a GenBeam or Element directly. |
| Paper Space | Yes | Press Enter at the prompt to select a Viewport, or select a ShopDrawView. |
| Shop Drawing | Yes | Select a ShopDrawView entity to report on that specific view. |

## Prerequisites
- **Required Entities**: A `GenBeam`, `Element`, `ShopDrawView`, or a Paper Space `Viewport`.
- **Minimum Beam Count**: 0 (The script scans whatever is contained within the selected Element or View).
- **Required Settings**: None (defaults are built-in). An optional `hsbToolReport.xml` can be used for custom color mappings.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbToolReport.mcr` from the list.

### Step 2: Configure Properties (Optional)
```
Dialog: Properties Palette
Action: Adjust settings such as Text Height or Color if needed, then click OK.
```
*Note: If running from a catalog key, this dialog may be skipped.*

### Step 3: Select Defining Entity
```
Command Line: Select a defining entity (GenBeam, Element, ShopDrawView) <Enter> to select a paperspace viewport
Action:
  - Click on a Beam, Element, or ShopDrawing view to analyze its content.
  - OR Press Enter to select a Viewport frame in Paper Space.
```

### Step 4: Place Report
```
Command Line: Insertion point
Action: Click in the drawing area where you want the top-left corner of the drill table to appear.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimstyle | dropdown | `_DimStyles` | Selects the CAD dimension style to control text font and arrow appearance. |
| Text Height | number | `U(0)` | Sets the height of the table text. `0` uses the height defined in the selected DimStyle. |
| Color | number | `0` | Sets the CAD color index for the report lines and text. `0` = ByBlock. |
| FormatDiameter | text | `@(Diameter:CU;mm:DN0)` | Format string controlling how Diameter is displayed (e.g., units and decimals). |
| FormatDepth | text | `@(Depth:CU;mm:DN0)` | Format string controlling how Depth is displayed. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Export Default Settings | Creates a `hsbToolReport.xml` file in your company settings folder containing the current color map and exclusion list. |

## Settings Files
- **Filename**: `hsbToolReport.xml`
- **Location**: `\\Company\\TSL\\Settings`
- **Purpose**: Stores color mappings for visualizing different drill sequences and maintains a list of tool names to exclude from the report. If this file is missing, the script uses internal defaults.

## Tips
- **Visual Clarity**: The script automatically draws "Solid" circles for Through Drills and "Ring" (hollow) circles for Blind Drills to help operators quickly identify hole types.
- **Scaling**: If the text appears too small in Paper Space, increase the `Text Height` property or ensure your `DimStyle` is set correctly for the viewport scale.
- **Updating the Table**: If you modify the beams (add/remove drills) after inserting the report, select the table and run `RECALC` (or modify a property) to refresh the data.

## FAQ
- **Q: Can I change the units from mm to inches in the table?**
  **A**: Yes. Modify the `FormatDiameter` and `FormatDepth` properties in the palette. Change `mm` to `inch` within the format string (e.g., `@(Diameter:CU;inch:DN2)`).
- **Q: Why are some of my drills not showing up in the list?**
  **A**: They may be listed in the exclusion list within the `hsbToolReport.xml` file. Use the "Export Default Settings" right-click option to generate the file and check the exclusion list.
# NA_BUNDLE_CUTLIST.mcr

## Overview
Generates a formatted 2D cutlist schedule on screen displaying the quantity, size, and length of timber components contained within a selected hsbCAD bundle (TSL). This allows for quick material summaries of wall panels or floor cassettes directly in the drawing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Schedule is placed at a user-selected coordinate. |
| Paper Space | Yes | Schedule can be placed directly onto layout sheets. |
| Shop Drawing | No | This script generates geometry (Text/Lines) rather than Shop Drawing entities. |

## Prerequisites
- **Required Entities**: A hsbCAD Bundle TSL already inserted in the drawing (specifically one containing a subMap named `Hsb_StackingParent`).
- **Minimum Beams**: 0 (An empty bundle will generate a header only).
- **Required Settings**:
    - At least one **DimStyle** loaded in the current drawing.
    - At least one **Painter Definition** available in the hsbCAD catalog.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `NA_BUNDLE_CUTLIST.mcr` from the file dialog.

### Step 2: Select Bundle
```
Command Line: Select a bundle TSL
Action: Click on the TSL instance (e.g., a wall or floor panel) that you want to generate a cutlist for.
```

### Step 3: Place Schedule
```
Command Line: Select a point
Action: Click in the Model or Paper Space to define the top-left insertion point of the cutlist table.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| DimStyle | dropdown | (First Available) | Sets the dimension format (e.g., metric vs imperial) and text style used for the schedule. |
| Painter Definition | dropdown | (First Available) | Filters which timber parts are included in the list. Only beams matching this painter will be displayed. |
| Text Height | number | 0 | Sets the text size for the schedule. A value of 0 lets the script calculate the height automatically based on the DimStyle. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (Standard Grips) | Select the script insertion point to use the grip to move the entire schedule to a new location. |

## Settings Files
- **None**: This script relies on standard drawing DimStyles and the hsbCAD Catalog; it does not use external XML settings files.

## Tips
- **Filtering Content**: Use the **Painter Definition** property to control what appears in the list. For example, set it to exclude sheathing or metal parts if you only want a timber cutlist.
- **Auto-Sizing**: Leave **Text Height** set to `0` to automatically scale the text size based on your selected DimStyle. This helps maintain consistency with your drawing standards.
- **Dimension Rounding**: Standard timber parts (e.g., Studs) will have their dimensions rounded UP to the nearest integer (e.g., 47mm becomes 50mm). Filler materials (like OSB) will show exact dimensions.
- **Moving the List**: If the schedule is in the way, simply select the script instance and drag the grip point to move the table to a clearer area of the drawing.

## FAQ
- **Q: Why does my list show fewer parts than I expect?**
  **A:** Check the **Painter Definition** in the properties palette. It may be filtering out specific material grades or types that are present in your bundle.
- **Q: Why is the text too small or too large?**
  **A:** Adjust the **Text Height** property. If it is set to 0, change the **DimStyle** to one with larger text settings, or manually enter a specific height (in drawing units).
- **Q: Can I use this in a layout viewport?**
  **A:** Yes, you can run this script directly in Paper Space to place the schedule onto your title block.
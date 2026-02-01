# GE_SHEET_DISPLAY_AREA.mcr

## Overview
Calculates the surface area of sheathing or cladding sheets and displays the value in square feet (SQ FT) as a text label centered on each selected sheet.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model entities (Sheets). |
| Paper Space | No | Not designed for Layouts. |
| Shop Drawing | No | Not designed for Shop Drawing generation. |

## Prerequisites
- **Required entities**: Sheet entities (e.g., wall or floor sheathing).
- **Minimum beam count**: 0.
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_SHEET_DISPLAY_AREA.mcr`

### Step 2: Select Sheeting
```
Command Line: Select sheeting(s)
Action: Click on one or more Sheet entities in your model. Press Enter or Right-click to confirm selection.
```
*Note: The text label will automatically appear centered on each selected sheet.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Color | Number | 1 | Sets the color of the area text label (AutoCAD Color Index 1-255). |
| Dimstyle | Dropdown | _DimStyles | Selects the Dimension Style used to determine the font and text height of the label. |

## Right-Click Menu Options
There are no custom right-click menu options available for this script.

## Settings Files
None.

## Tips
- **Dynamic Updates**: If you modify the geometry of the sheet (e.g., stretch or resize it), the script will automatically update the area value and reposition the text to the new center.
- **XRef Support**: This script can detect and display areas for sheets contained within external references (XRefs).
- **Text Size**: To change how large the text appears, change the `Dimstyle` property to a style with different text height settings, or modify the text height in the Dimension Style Manager in AutoCAD.

## FAQ
- **Q: What unit of measurement is used?**
  - A: The area is always calculated and displayed in Square Feet (SQ FT).
- **Q: Why did the text disappear?**
  - A: If the underlying sheet entity is deleted or becomes invalid, the script instance will erase itself.
- **Q: Can I use this on roof planes?**
  - A: Yes, as long as the roof geometry is classified as a "Sheet" entity within hsbCAD, the script will calculate its surface area.
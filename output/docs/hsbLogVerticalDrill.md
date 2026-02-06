# hsbLogVerticalDrill.mcr

## Overview
This script inserts a vertical drilling operation into Log walls (ElementLog) and automatically generates a dimension label. It is designed for creating utility holes or mechanical fasteners in timber log construction with precise annotations.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be inserted and executed in Model Space. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | This is a 3D model modification script, not a 2D detailing tool. |

## Prerequisites
- **Required Entities**: An existing `ElementLog` (Log Wall) in the drawing.
- **Minimum Beams**: None (Script interacts directly with the Log Element).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT` (or select from hsbCAD Catalog)
**Action**: Browse and select `hsbLogVerticalDrill.mcr`.

### Step 2: Select ElementLog
**Command Line**: `Select ElementLog`
**Action**: Click on the Log wall element where you want to place the drill.

### Step 3: Select Point for Drill
**Command Line**: `Select point for drill`
**Action**: Click on the face of the log wall to define the lateral (X/Y) position of the hole.

### Step 4: Configure Properties (If applicable)
**Action**: If you are not using a pre-configured catalog entry, a properties dialog will appear.
- Adjust the **Diameter**.
- Set **Start Height** and **End Height** (0 = through the entire log layer).
- Configure the **Format** string for the label.
- Click **OK** to generate the drill and label.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Diameter | Number | 50 | The diameter of the vertical drill hole (in mm). |
| Axis Offset | Number | 0 | The vertical elevation offset of the drilling axis relative to the element origin. |
| Start Height | Number | 0 | The start depth of the hole relative to the bottom of the specific log layer (0 = bottom). |
| End Height | Number | 0 | The end depth of the hole relative to the bottom of the specific log layer (0 = top). |
| Format | Text | coordDim\\P@(coordDim) | The text template for the label. Attributes like @(Diameter) can be used. Separate lines with `\P`. |
| DimStyle | Dropdown | Current | The dimension style controlling font, size, and color of the label. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *(None)* | No custom context menu items are provided. Use the Properties Palette or Grips to edit. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: No external settings files are required for this script.

## Tips
- **Grip Editing**: After insertion, use the triangle grips (`_PtG[0]`, `_PtG[1]`) to visually drag the start and end points of the drill. This automatically updates the Start Height and End Height properties.
- **Through Drilling**: To drill completely through a specific log layer, leave both **Start Height** and **End Height** as `0`.
- **Label Formatting**: If the label text appears empty or incorrect, check the **Format** property. Ensure you are using valid attribute keys (e.g., `@(Diameter)`).
- **Moving the Hole**: Drag the main insertion point (`_Pt0`) to move the entire drill and label laterally along the wall.

## FAQ
- **Q: Can I use this on standard beams?**
  **A:** No, this script is specifically designed for `ElementLog` (Log Wall) entities.
- **Q: How do I make the hole go deeper than one log?**
  **A:** This script operates on the specific log layer selected. If you need a hole through multiple logs, you must insert the script on each relevant log layer or adjust the Axis Offset significantly if the geometry allows.
- **Q: Why did my text label disappear?**
  **A:** The **Format** property might contain invalid syntax or resolve to an empty string. Reset it to the default: `coordDim\P@(coordDim)`.
- **Q: How do I change the label size?**
  **A:** Change the **DimStyle** property to a different dimension style defined in your AutoCAD drawing, or modify the text height in the selected DimStyle.
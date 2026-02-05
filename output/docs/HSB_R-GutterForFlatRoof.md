# HSB_R-GutterForFlatRoof.mcr

## Overview
This script automatically calculates and applies a drainage slope to flat roof sheets. It rotates the selected sheets to create a roof fall (pitch) and generates a visual slope indicator arrow with the percentage label.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D Sheet entities. |
| Paper Space | No | Not designed for 2D layouts or views. |
| Shop Drawing | No | Does not generate shop drawing views. |

## Prerequisites
- **Required Entities:** Flat roof `Sheet` entities.
- **Element Association:** Selected sheets must belong to a valid Element (e.g., a Roof or Wall element).
- **Settings:** None required (uses internal defaults).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_R-GutterForFlatRoof.mcr`

### Step 2: Select Sheets
```
Command Line: Select a set of sheets
Action: Click on the roof sheets you wish to slope. Press Enter to confirm selection.
```

### Step 3: Define Start Point
```
Command Line: Select start point for distribution
Action: Click a point in the model to define the high side/pivot point for the gutter slope.
```
*Note: The script will automatically calculate the direction of the fall based on the location of the sheets relative to this point.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Gutter Settings** | | | |
| Slope [%] | Number | 2 | The gradient of the roof drainage (e.g., 2%). |
| **Symbol Settings** | | | |
| Layer | Text | 0 | The CAD layer assigned to the arrow and text symbols. |
| Symbol Size | Number | 100 | The size (scale) of the directional arrow in millimeters. |
| Color Symbol | Integer | -1 | The color of the arrow lines (-1 = ByLayer). |
| Color Text | Integer | 1 | The color of the slope percentage text. |
| DimStyle | Text | _DimStyles | The Dimension Style used to determine the text font. |
| Text Size | Number | -1 | The height of the text. If set to 0 or negative, the DimStyle height is used. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add sheet | Prompts you to select additional sheets to add to the current slope calculation. |
| Remove sheet | Prompts you to select sheets to remove from the calculation. *Note: Removed sheets will remain in their last transformed position.* |

## Settings Files
- **Filename:** None
- **Location:** N/A
- **Purpose:** This script relies on user input and Properties Palette configuration; no external XML settings files are required.

## Tips
- **Updating Slope:** You can change the slope percentage at any time by selecting the script instance in the model and modifying the "Slope [%]" value in the Properties Palette. The sheets will automatically update.
- **Direction:** The script determines the slope direction by comparing the sheet center to the selected start point.
- **Undo Logic:** The script remembers the rotation it applies. If you add or remove sheets, it correctly handles the geometry of the remaining sheets without double-rotating them.

## FAQ
- **Q: The script disappeared immediately after I selected the start point.**
  A: This usually happens if no sheets were selected or if the selected sheets do not belong to a valid Element. Ensure you select Sheets that are part of a constructed Roof or Wall element.
- **Q: Can I use this on curved roofs?**
  A: This script is designed for flat roof drainage. Using it on complex curved geometries may produce unexpected results.
- **Q: How do I change the arrow size?**
  A: Select the script instance, open the Properties Palette, and adjust the "Symbol Size" value under the Symbol category.
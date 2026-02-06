# sd_MetalpartBOM.mcr

## Overview
This script automatically generates a Bill of Materials (BOM) table and position number labels for metal connection parts (plates, brackets, gussets) within a shop drawing view. It identifies metal parts attached to timber beams and creates a detailed schedule including dimensions, material, and weight, while tagging the parts in the drawing view.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script runs in the context of a layout. |
| Paper Space | Yes | Output is generated directly in the layout view. |
| Shop Drawing | Yes | Must be linked to a `ShopDrawView` entity. |

## Prerequisites
- **Required Entities**: A valid `ShopDrawView` entity and a `Beam` contained within that view.
- **Required Content**: The beam must have metal parts assigned to it via `MetalPartCollection` tools.
- **Minimum Beams**: 1 (The script scans the selected Shop Drawing View for a primary beam).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `sd_MetalpartBOM.mcr`

### Step 2: Select Shop Drawing View
```
Command Line: Select one or multiple sips to attach this tsl. alternatively select a shopdraw viewport to define it's display with shopdrawings
Action: Click on the Shop Drawing View (or SIP) where the metal parts are located.
```

### Step 3: Set Insertion Point
```
Command Line: [Point Prompt]
Action: Click in the drawing to place the origin of the BOM table and label system.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Show List** (sShowBOM) | dropdown | \|No\| | Toggles the visibility of the BOM table. Set to `|Yes|` to show the full schedule; set to `|No|` to show only the position number tags. |
| **Dimstyle** (sDimStyle) | dropdown | *Current* | Selects the Dimension Style that controls the text font and size for the table and tags. |
| **Color** (nColor) | number | 1 | Sets the AutoCAD color index for the BOM table lines and text. |
| **Color PosNum** (nColorPosNum) | number | 20 | Sets the AutoCAD color index for the position number bubbles and leader lines. |
| **Color Background** (nColorBackground) | number | 51 | Sets the background fill color for the position bubbles. Enter `-2` to make the bubbles transparent (outline only). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | No specific custom menu items are added by this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: No external settings files are required for this script.

## Tips
- **Table Sizing**: Use the triangular **Width Grip** (drag point) appearing on the table to resize the table width. Text height and row height will scale automatically to fit the new width.
- **Avoiding Overlaps**: The script automatically detects if position bubbles overlap. If they do, it shifts the bubble to the right and adds a leader line pointing to the metal part.
- **Transparent Tags**: If your position bubbles are covering important geometry, set the **Color Background** property to `-2`. This makes the bubbles transparent so you can see lines through them.
- **Display Only Tags**: If you only need to tag the parts in the view but do not need the data table (e.g., for a cleaner drawing view), set **Show List** to `|No|`.

## FAQ
- **Q: I inserted the script, but no table appears.**
  - A: By default, the **Show List** property is set to `|No|`. Select the script instance in the drawing, open the Properties palette, and change **Show List** to `|Yes|`.
  
- **Q: Why is the script listing "0" items?**
  - A: Ensure that the `ShopDrawView` you selected contains a beam that actually has metal parts assigned to it. The script specifically looks for `MetalPartCollection` entities attached to the beam.

- **Q: The text in my table is too small.**
  - A: Select the **Dimstyle** property in the palette and choose a dimension style with larger text settings, or adjust the width grip to force the text to scale up.
# GE_DimElementManual

## Overview
This script allows you to manually create construction dimensioning annotations on specific points of a timber element (such as a wall or panel) directly in the 3D model. It supports various dimension types including Delta, Ordinate, and Overall dimensions, with flexible formatting for Metric or Imperial units.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates directly on 3D Elements. |
| Paper Space | No | Not designed for 2D layout views. |
| Shop Drawing | No | Not intended for production drawings. |

## Prerequisites
- **Required Entities**: An existing Element (Wall or Panel) must be selected during script insertion.
- **Minimum Beam Count**: 0 (This script annotates Elements, not individual beams).
- **Required Settings**: None specific (uses standard CAD DimStyles available in the project).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_DimElementManual.mcr` from the list.

### Step 2: Select Element
Click on the Element (Wall/Panel) you wish to dimension.

### Step 3: Choose Orientation
```
Command Line: Dimension Orientation: [/1: Horizontal/2: Vertical/3: Custom]
Action: Type 1, 2, or 3 and press Enter.
```
*   **1**: Aligns dimensions to the Element's local X-axis.
*   **2**: Aligns dimensions to the Element's local Y-axis.
*   **3**: Allows you to define a custom angle on screen.

### Step 4: Select Dimension Points
```
Command Line: Select points to dimension
Action: Click on the model geometry to define points you want to measure.
```
*   Click as many points as needed.
*   Press **Enter** or **Esc** to finish selecting points.

### Step 5: Define Custom Direction (If Step 3 was Option 3)
```
Command Line: Select Dimline Base Reference
Action: Click a point to define the start of the dimension line axis.
```
```
Command Line: Select Dimline Direction
Action: Click a second point to define the angle/direction of the dimension line.
```

### Step 6: Place Dimension Line
```
Command Line: Select Dimline Location
Action: Click in the 3D view where you want the dimension line and text to appear.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension Type | dropdown | Ordinate | Selects the logic: **Ordinate** (stacks from baseline), **Delta** (distance between points), or **Delta + Overall**. |
| Dimstyle | dropdown | Entekra Design | Selects the CAD Dimension Style (text font, arrows) to use. |
| Dim Format | dropdown | Inches Fractional | Sets the unit format (e.g., Decimal mm, Fractional inches). |
| Precision | number | 3 | Sets the number of decimal places or denominator for fractions (0-5). |
| Text Height | number | 0 | Overrides the text height. **0** uses the Dimstyle default. |
| Text Padding | number | 0.0625 inch | Adds space around the text to prevent overlapping lines. |
| Text Offset | number | 0.3125 | Distance between the dimension line and the text label. |
| Line Color | number | 1 | CAD Color Index for dimension and extension lines. |
| Text Color | number | 5 | CAD Color Index for the dimension text. |
| Limit Extension Lines | dropdown | No | If **Yes**, extension lines are trimmed so they do not cross behind the text. |
| Extension Line Offset | number | 0.0625 | The gap between the model point and the start of the extension line. |
| View Direction | dropdown | Outside | Sets whether dimensions project to the **Outside** or **Inside** face of the element. |
| Tags | text | | Custom tags for filtering or reports (does not affect graphics). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Refreshes the script geometry after changing Properties or moving the Element. |

## Settings Files
- **Filename**: N/A
- **Location**: N/A
- **Purpose**: This script relies on standard CAD DimStyles defined in your current project rather than a specific external XML file.

## Tips
- **Minimum Points**: You must select at least 3 points; otherwise, the script instance will delete itself automatically.
- **Diagonal Dimensions**: Use orientation option **3 (Custom)** to dimension points that are not perfectly horizontal or vertical relative to the element.
- **Text Clarity**: If dimension text overlaps, increase the **Text Padding** or switch **Limit Extension Lines** to "Yes".
- **Incorrect Side**: If dimensions appear on the wrong side of the wall, change the **View Direction** property in the palette.

## FAQ
- **Q: Why did the dimension disappear after I placed it?**
  **A:** The script requires at least 3 points to function. If you selected fewer than 3 points before pressing Enter, the script erases itself.

- **Q: How do I change from Imperial to Metric units?**
  **A:** Select the dimension instance, open the Properties palette, and change the **Dim Format** option (e.g., select "Decimal" for mm).

- **Q: Can I use this on individual beams?**
  **A:** No, this script is designed specifically to attach to Elements (Walls/Panels). Use beam-specific scripts for individual timber parts.
# hsbCurveDimensions.mcr

## Overview
This script automatically dimensions a flat span (developed) curved description and generates a schedule summary showing the quantity and material details of all beams using that specific curved style.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be run in Model Space. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | This is a model annotation tool. |

## Prerequisites
- **Required Entities**: At least one `CurvedDescription` entity in the drawing.
- **Minimum Beam Count**: 0 (Script works even if no beams are assigned to the curve yet).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCurveDimensions.mcr` from the file dialog.

### Step 2: Select Curved Description
```
Command Line: Select curved description
Action: Click on one or more CurvedDescription entities in the model.
```

### Step 3: Place Schedule Text (Conditional)
*If you selected exactly ONE curve:*
```
Command Line: [Select Point]
Action: Click in the model to place the schedule text block (containing count, style, and material).
```

*If you selected MULTIPLE curves:*
```
Action: The script automatically places the schedule text at the origin of each curve. No click is required.
```

### Step 4: Configuration
The Properties Palette will open automatically upon insertion, allowing you to adjust DimStyles, Text Height, and Colors before the script finalizes the geometry.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimstyle | Dropdown | *Current* | Selects the visual standard (arrows, ticks, font) from the drawing's available dimension styles. |
| Text Height | Number | 40 | Sets the plotted height of the dimension text and schedule text (in mm). |
| Color | Number | 1 | Defines the CAD color index (1-255) for the generated dimensions and text. |
| Delta Dimensioning | Dropdown | None | Controls how intermediate dimensions (between grip points) are measured: **Parallel** (chord distance), **Perpendicular** (projected), or **None** (hidden). |
| Chain Dimensioning | Dropdown | None | Controls how the total span dimension is measured: **Parallel**, **Perpendicular**, or **None**. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add specific custom items to the right-click context menu. Use the Properties Palette to modify settings. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Plot Scale**: The `Text Height` is in model units (mm). If you plot at 1:50 and want 2.5mm high text on paper, set this value to 125mm.
- **Moving Text**: After insertion, select the script instance and drag the visible **Grip Point** (usually the text insertion point) to reposition the schedule summary without affecting the dimensions.
- **Measurement Logic**: Use **Parallel** for direct chord measurements (useful for cutting lengths) or **Perpendicular** for projected widths/heights (useful for checking wall plates or roof spans).
- **Auto-Update**: If you modify the geometry of the source `CurvedDescription` (e.g., drag its grips), the dimensions will automatically update to reflect the new shape.

## FAQ
- **Q: What does "Invalid reference" mean?**
  A: This error appears if the selected entity is not a valid `CurvedDescription` or if the entity was deleted after the script was attached. Select a valid curved beam entity.
  
- **Q: Can I dimension multiple curves at once?**
  A: Yes. During insertion, hold `Ctrl` or use a window selection to pick multiple CurvedDescriptions. The script will process all of them.

- **Q: How do I change the arrow style?**
  A: Change the `Dimstyle` property in the Properties Palette to a different style defined in your AutoCAD template (e.g., switching from "Standard" to "Architectural").
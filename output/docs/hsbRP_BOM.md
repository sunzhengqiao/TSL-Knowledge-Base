# hsbRP_BOM.mcr

## Overview
This script generates a formatted Bill of Materials (BOM) table in Model Space. It calculates and displays the total lengths of selected rooflines and the total surface areas of selected eave areas.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The BOM report is placed at a user-selected coordinate in the model. |
| Paper Space | No | Not designed for Paper Space layouts. |
| Shop Drawing | No | Not a shop drawing generation script. |

## Prerequisites
- **Required entities**: `hsbRP_Roofline` and/or `hsbRP_EaveArea` elements must exist in the drawing.
- **Minimum beam count**: 0
- **Required settings files**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbRP_BOM.mcr`

### Step 2: Configure Properties
```
Dialog: Properties
Action: Review the default settings for Unit, Decimals, Color, and Dimstyle. Click OK to proceed.
```

### Step 3: Specify Insertion Point
```
Command Line: [Implicitly asks for insertion point]
Action: Click in the Model Space to define the top-left location where the BOM table will be placed.
```

### Step 4: Select Elements
```
Command Line: Select rooflines and/or eave areas
Action: Click on the desired Roofline or Eave Area elements in your drawing. Press Enter to confirm selection and generate the report.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Unit | dropdown | mm | Sets the measurement unit for the report (Metric: mm, cm, m or Imperial: inch, feet). |
| Decimals Length | dropdown | 2 | Sets the number of decimal places for linear dimensions (Rooflines). |
| Decimals Area | dropdown | 2 | Sets the number of decimal places for surface dimensions (Eave Areas). |
| Color | number | 143 | Determines the color of the generated text (AutoCAD Color Index). |
| Dimstyle | dropdown | [Current] | Selects a Dimension Style from the drawing to control the text font, size, and appearance. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add entity | Allows you to select additional Rooflines or Eave Areas to append to the existing BOM calculation without recreating it. |

## Settings Files
None

## Tips
- **Automatic Updates**: The BOM is linked to the source elements. If you modify a Roofline length or Eave Area geometry, the BOM will automatically recalculate.
- **Positioning**: You can move the entire table by clicking and dragging the grip at the original insertion point (_Pt0).
- **Styling**: To match your office standards, change the "Dimstyle" property in the Properties palette to use your company's standard text style.
- **Unit Conversion**: Switching the "Unit" property will instantly convert all values in the report without needing to reselect elements.

## FAQ
- **Q: How do I remove an item from the list?**
  A: Currently, you must delete the BOM instance and re-run the script, selecting only the desired elements.
- **Q: Why is my text too small or large?**
  A: The text size is controlled by the "Dimstyle" property. Change this to a Dimension Style that has the text height defined according to your plotting scale.
- **Q: Can I mix Imperial and Metric units?**
  A: No, the "Unit" property applies globally to the entire report instance.
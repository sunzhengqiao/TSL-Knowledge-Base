# sd_DisplayMetalPartCollectionHandle.mcr

## Overview
Displays the Handle and Entry Name of the first Metal Part Collection found in the selected Shop Drawing View as a text label. This tool is useful for labeling or debugging metalwork assemblies in production drawings to verify the correct MetalPartCollection definition is applied.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is intended for detailing views. |
| Paper Space | Yes | Can be inserted directly into layout sheets. |
| Shop Drawing | Yes | Primary usage context for generating view labels. |

## Prerequisites
- **Required Entities**: A `ShopDrawView` and at least one `MetalPartCollectionEnt` associated with that view.
- **Minimum Beam Count**: 0 (Independent of structural beams).
- **Required Settings Files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `sd_DisplayMetalPartCollectionHandle.mcr` from the file dialog.

### Step 2: Select Shop Draw View
```
Command Line: Select ShopDrawView:
Action: Click on the boundary of the Shop Drawing View (viewport) you wish to label.
```

### Step 3: Specify Insertion Point
```
Command Line: Specify insertion point:
Action: Click in the drawing layout where you want the text label to appear.
```

### Step 4: Configure Properties (Optional)
After insertion, the Properties Palette will open. You can adjust the text appearance if needed.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Color | number | 164 | Sets the color of the text label (AutoCAD Color Index). Use -1 for "ByBlock". |
| Dimstyle | dropdown | "" | Selects the Dimension Style to control text font, height, and formatting. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | No custom context menu options are defined for this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Moving the Label**: After insertion, select the label and use the grip point to drag it to a new location without deleting it.
- **Error Indicator**: If the label displays the text **"HANX"**, it means the script could not find the required Metal Part Collection data within the selected Shop Drawing View. Ensure the view actually contains metal parts.
- **Text Styling**: For the text to look correct, ensure the selected DimStyle exists in your current drawing template.

## FAQ
- **Q: Why is my text blank?**
  A: This usually means the script found the Shop Drawing View, but no Metal Part Collection entities were found inside it.
- **Q: Can I change the font size?**
  A: Yes. The font size is controlled by the text height defined in the DimStyle selected in the Properties Palette. Change the "Dimstyle" property to a style with your desired text height.
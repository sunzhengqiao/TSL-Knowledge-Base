# hsb_ExtraElementData.mcr

## Overview
This script analyzes wall elements to calculate geometric metadata such as corner types (Left/Right), junction locations, and opening dimensions. It labels this information visually in the model and attaches invisible data attributes to the element for use in exports or production lists.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be inserted in the model where Wall Elements exist. |
| Paper Space | No | Not designed for Paper Space or layout views. |
| Shop Drawing | No | Not applicable for shop drawing generation. |

## Prerequisites
- **Required entities**: Wall Elements (`ElementWallSF`).
- **Minimum beam count**: 0 (Script operates on Wall Elements, not individual beams).
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_ExtraElementData.mcr`

### Step 2: Configure Properties
A Properties dialog appears automatically upon insertion.
**Action**: Set the desired Dimension Style, Text Color, and Line Offset. Click OK to proceed.

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the Wall Elements you wish to analyze and press Enter.
```

### Step 4: Processing
The script will automatically attach to the selected walls, draw the text labels displaying the calculated data, and populate the element attributes.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| DimStyle | dropdown | "" | Selects the dimension style (font, text size) for the labels. Choose an available style from the list or leave blank for the default style. |
| Show In Display Rep | text | "" | Limits the visibility of the labels to specific Display Representations (e.g., "Plan", "Section"). Leave empty to show labels in all views. |
| Set the Text Color | number | 171 | Determines the color of the text labels. Valid values are 0-255 (AutoCAD Color Index). |
| Offset Between Lines | number | 100 | Sets the vertical spacing between lines of text. Increase this value if the labels overlap. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are added by this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Overlapping Text**: If your wall has many openings or junctions, the text labels might overlap. Increase the **Offset Between Lines** property to space them out vertically.
- **View Clutter**: If the labels are too distracting in 3D views, type a Display Representation name (like "Plan") in the **Show In Display Rep** property. This will hide the labels unless you are viewing that specific representation.
- **Updating Data**: If you modify the wall geometry (e.g., stretch the wall or add an opening), the script will automatically recalculate the data and update the labels.
- **Export Data**: The script attaches specific attribute codes (like `CORNER`, `JUNCTION1`, `OPWIDTH1`) to the element. These can be used in lists or BIM exports even if you hide the visual text labels.

## FAQ
- Q: Why can't I see the text labels?
- A: Check the **Show In Display Rep** property. If it is set to a specific view type (e.g., "Plan"), you will only see the text when that display representation is active. If it is empty, check that the **Set the Text Color** is not set to the background color or that the wall is not on a frozen layer.
- Q: How do I change the font size?
- A: The text height is controlled by the **DimStyle** setting. Change the `sDimStyle` to a Dimension Style that has your preferred text height settings configured in AutoCAD/hsbCAD.
- Q: What does "L/R" mean in the Corner Type label?
- A: This indicates the wall has connections at both the Left and Right ends. If it shows "L", it is only connected on the Left.
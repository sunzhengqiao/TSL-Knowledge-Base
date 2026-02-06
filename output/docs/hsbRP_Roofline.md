# hsbRP_Roofline.mcr

## Overview
This script calculates, labels, and displays the 3D length and specific angles of roof edges (such as eaves, ridges, hips, and valleys) directly in the model. It generates visual markers and text labels to assist with quantification and manufacturing lists.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary working environment for inserting rooflines and visualizing dimensions. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | Not applicable. |

## Prerequisites
- **Required entities**: At least one `ERoofPlane` (Roofplane) must exist in the model.
- **Minimum beam count**: 0 (The script detects associated beams automatically but does not require them to run).
- **Required settings files**: None. The script uses standard AutoCAD dimension styles available in the drawing.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbRP_Roofline.mcr` from the list.

### Step 2: Select Roofplanes
```
Command Line: Select roofplanes
Action: Click on the Roofplane(s) in the model that define the roof edge you want to measure. Press Enter to confirm selection.
```

### Step 3: Define Startpoint
```
Command Line: Select Startpoint
Action: Click the location in 3D space where the roofline measurement should begin (e.g., the corner of the eave).
```

### Step 4: Define Endpoint
```
Command Line: Select Endpoint
Action: Click the location in 3D space where the roofline measurement should end.
```
*Note: If the start and end points are too close (less than 0.1mm apart), the script instance will be automatically erased.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | dropdown | Eave | Defines the classification of the roof edge (e.g., Hip, Valley, Ridge, Gable End). Selecting "Hip" or "Valley" enables angle calculations. |
| Type overwriting | text | | Used by automation scripts (e.g., hsbRP_Analysis) to force a specific type. If you manually change "Type", this field clears. |
| Unit | dropdown | mm | The unit of measurement displayed in the label and exported to lists (mm, cm, m, inch, feet). |
| Decimals | dropdown | 0 | Sets the precision of the displayed length (0 to 4 decimal places). |
| Dimstyle | dropdown | _DimStyles | Selects the visual style (font, size, color) for the text label based on the drawing's available dimension styles. |
| Group (seperate Level by'\') | text | | Organizes the element for BOM exports. Use backslashes (e.g., "Floor 1\Roof") to create sub-groups. |
| Show PosNum | dropdown | No | If set to "Yes", displays the script's unique Position Number (PosNum) within the text label. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Eave | Sets the roofline type to "Eave". |
| Gable End | Sets the roofline type to "Gable End". |
| Hip | Sets the roofline type to "Hip". This calculates and displays the slope and bevel angles. |
| Valley | Sets the roofline type to "Valley". This calculates and displays the slope and bevel angles. |
| Ridge | Sets the roofline type to "Ridge". |
| Rising Eave | Sets the roofline type to "Rising Eave". |
| Verfallgrat | Sets the roofline type to "Verfallgrat". |
| Opening top / bottom / left / right | Sets the roofline type to the specific opening edge. |
| Wall connection | Sets the roofline type to "Wall connection". |
| Swap description side | Flips the text label to the opposite side of the roofline vector. |

## Settings Files
- **Filename**: N/A
- **Location**: N/A
- **Purpose**: This script relies on the drawing's internal Dimension Styles (`_DimStyles`) rather than external settings files.

## Tips
- **Visualizing Angles**: Change the **Type** property to "Hip" or "Valley" to automatically calculate and display the slope and bevel angles in the label.
- **Text Positioning**: If the text label appears on the wrong side of the line or overlaps geometry, right-click the script instance and select **Swap description side**. The script also attempts to auto-detect the correct side upon insertion.
- **Grip Editing**: You can drag the Startpoint, Endpoint, or Text Position grips to adjust the geometry dynamically. The length and label will update instantly.
- **Data Export**: The calculated length and angles are stored in the element properties and can be exported to Excel or BOM lists using the "Group" parameter to filter items.

## FAQ
- **Q: Why did my label disappear after insertion?**
  **A:** The script automatically erases itself if the Startpoint and Endpoint are identical or closer than 0.1mm. Ensure you pick two distinct points in 3D space.
- **Q: Can I measure a wall plate instead of a roof edge?**
  **A:** Yes. Select the relevant Roofplanes, pick the wall start and end points, and set the **Type** to "Wall connection" in the properties.
- **Q: How do I change the units from mm to inches?**
  **A:** Select the script instance, open the Properties palette (Ctrl+1), and change the **Unit** dropdown to "inch" or "feet". The label will update immediately.
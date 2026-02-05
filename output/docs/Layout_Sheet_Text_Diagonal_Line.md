# Layout_Sheet_Text_Diagonal_Line.mcr

## Overview
Annotates paper space layouts by drawing a diagonal line and a dimension label (Width x Length) across the projected envelope of each timber sheet within a selected viewport. It is useful for quickly identifying panel sizes on floor plans or layout drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script operates in Paper Space (Layouts). |
| Paper Space | Yes | Designed to annotate Viewports containing hsbCAD Elements. |
| Shop Drawing | No | Used for layout/general arrangement drawings rather than detailed production views. |

## Prerequisites
- **Required Entities**: A Viewport in a Layout tab that is linked to a valid hsbCAD Element (e.g., a Wall or Floor) containing generated Sheets.
- **Minimum beam count**: 0 (Operates on Sheets/Elements, not specific beams).
- **Required settings files**: `hsb_settings` (must contain the `_DimStyles` list).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Layout_Sheet_Text_Diagonal_Line.mcr`

### Step 2: Select Viewport
```
Command Line: Select the viewport from which the element, and possibly active zone is taken
Action: Click on the border of the viewport in your layout that displays the element you wish to annotate.
```
*Note: The script will associate itself with this specific viewport.*

## Properties Panel Parameters

After inserting the script, select it and modify the following parameters in the AutoCAD Properties Palette (OPM) to control the annotation appearance.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dim Style | dropdown | (Empty) | Select the drafting standard for the dimension text (e.g., 'ISO-25', 'mm', 'cm'). This controls formatting (e.g., '6000' vs '6 m'). |
| Text Heigth | number | 1 | Sets the height of the dimension text in Paper Space units (usually mm). Increase for larger scale drawings. |
| Color | number | 3 | The AutoCAD color index for the dimension text. Setting this to **0** hides the text entirely. |
| Color Diagonal | number | 1 | The AutoCAD color index for the diagonal line. Setting this to **0** hides the line entirely. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | This script does not add custom items to the right-click context menu. Use the Properties Palette to modify settings. |

## Settings Files
- **Filename**: `hsb_settings`
- **Location`: `_kPathHsbCompany` or `_kPathHsbInstall`
- **Purpose`: Provides the list of available dimension styles used by the "Dim Style" property.

## Tips
- **Toggle Visibility**: You can turn off the diagonal line or the text independently by setting their respective "Color" properties to **0**.
- **Text Rotation**: The script automatically detects the sheet orientation. If the sheet is wider than it is tall, the text rotates 90 degrees to fit better.
- **Updating**: If you move or resize the viewport, use the `REGEN` command or update the script properties to force the annotations to recalculate their position.

## FAQ
- **Q: Why didn't any lines appear when I inserted the script?**
- **A**: Ensure the "Color" and "Color Diagonal" properties in the Properties Palette are not set to 0. Also, verify that the selected Viewport actually contains hsbCAD Elements with generated sheets.

- **Q: How do I change the units from millimeters to meters?**
- **A**: Change the "Dim Style" property in the Properties Palette to a style that formats dimensions as meters (e.g., select 'm' if available in your company settings).

- **Q: The text is too small to read on my plot.**
- **A**: Increase the "Text Heigth" value in the Properties Palette. This value is in Paper Space units, so 2.5 or 3.0 are common values for readable text.
# hsbLayout-ElementLevelMarker.mcr

## Overview
This script annotates the elevation level (Z-height) of a structural element directly in Paper Space. It allows you to place a level marker (Finished or Unfinished floor style) linked to the geometry displayed within a selected viewport.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | The script is intended for Layout/Sheet annotation. |
| Paper Space | Yes | The script must be run on a Layout tab containing Viewports. |
| Shop Drawing | No | This is an annotation tool for layout drawings. |

## Prerequisites
- **Required Entities**: A Viewport in Paper Space that is currently displaying a valid hsbCAD Element (e.g., a Wall or Floor).
- **Minimum beam count**: 0 (The script targets the Element associated with the viewport, not individual beams).
- **Required Settings**: None.
- **Restriction**: The script is deactivated for **Multiwalls** and will not generate output if the selected viewport contains one.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbLayout-ElementLevelMarker.mcr` from the list.
*Note: Upon first insert, the Properties Palette may open automatically to configure settings.*

### Step 2: Configure Properties (Optional)
If the Properties Palette does not open automatically, select the script instance after insertion to adjust settings (Style, Units, Text Height) before placing the marker.

### Step 3: Select Viewport
```
Command Line: |Select a viewport|
Action: Click on the border of the viewport in Paper Space that shows the element you want to annotate.
```

### Step 4: Place Marker
```
Command Line: (None specified, usually a point prompt)
Action: Click a point in Paper Space where you want the level marker leader to point.
```
*The script will automatically calculate the elevation based on the model geometry and draw the marker.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimstyle | dropdown | _DimStyles | Selects the CAD dimension style (font, arrows, color) for the text and lines. |
| Text Height | number | 0 | Defines the height of the text in Paper Space units. **0** uses the height defined in the selected Dimstyle. |
| Units | dropdown | m | Defines the unit of measurement for the level value (mm, cm, m, in, ft). |
| Decimals | number | 3 | Sets the number of decimal places for the level value (e.g., 3.000). |
| Style | dropdown | Finished Floor | Defines the symbol style. <br>**Finished Floor**: Draws an open triangle. <br>**Unfinished Floor**: Draws a filled triangle. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Properties | Opens the AutoCAD Properties Palette to adjust Marker Style, Units, and Text formatting. |
| Erase | Removes the script instance and the drawn annotation. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not use external XML settings files. Configuration is handled via the Properties Panel.

## Tips
- **Re-calculating Levels**: If the model geometry changes and the floor level moves, select the marker and use the `TSLRECALC` command (or right-click -> Recalculate if available) to update the value.
- **Text Scaling**: If you want the text size to adjust automatically when you change the Dimstyle, keep `Text Height` set to `0`.
- **Negative Values**: The script automatically prefixes positive values with `+` and negative values with `-`. Zero values are prefixed with `±`.

## FAQ
- **Q: I clicked the viewport, but nothing happened. Why?**
- **A:** The script is likely deactivated for the element type inside that viewport. Check if the element is a **Multiwall**. This script currently only works on standard single walls or floors.
- **Q: How do I change the unit from meters to millimeters?**
- **A:** Select the drawn marker, open the Properties palette (Ctrl+1), and change the `Units` dropdown from 'm' to 'mm'.
- **Q: Can I use this in Model Space?**
- **A:** No, this script is designed specifically for creating annotations on Layout Sheets (Paper Space).
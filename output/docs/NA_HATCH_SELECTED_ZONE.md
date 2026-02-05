# NA_HATCH_SELECTED_ZONE.mcr

## Overview
This script generates 2D hatching or solid fills for specific groups of timber beams (GenBeams) within a layout viewport, based on construction zones and material filters. It is used to distinguish structural layers or material types in shop drawings or presentation layouts.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script operates on Layouts. |
| Paper Space | Yes | Primary environment; requires a viewport linked to an hsbCAD Element. |
| Shop Drawing | Yes | Designed for detailing and presentation views. |

## Prerequisites
- **Required entities**: An AutoCAD Layout containing a viewport linked to a valid hsbCAD Element.
- **Minimum beam count**: 1 GenBeam within the selected element.
- **Required settings**: Valid GenBeam PainterDefinitions (in the hsbCAD catalogue) to use the Include/Exclude filters.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `NA_HATCH_SELECTED_ZONE.mcr`

### Step 2: Select Viewport
```
Command Line: Select element viewport
Action: Click on a viewport in Paper Space that displays the element you want to hatch.
```

### Step 3: Configure Properties
```
Action: With the TSL instance selected, open the Properties Palette (Ctrl+1).
Adjust the filters (Zone/Include/Exclude) and Hatch settings to define which beams to draw and how they should look.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Include filter | dropdown | None | Selects a category of beams to hatch (e.g., Studs, Plates) based on GenBeam PainterDefinitions. If "None", all beams in the zone are considered. |
| Exclude filter | dropdown | None | Removes a specific category of beams from the selection set defined by the Include filter. |
| Zone | dropdown | 0 | Specifies the construction layer (0 = main container; 1-5 = front/top; -1 to -5 = back/bottom). |
| Hatch pattern | dropdown | ANSI31 | Visual style of the fill. Set to "SOLID" to use the colour and transparency settings. |
| Hatch scale | number | 1 | Scale of the hatch pattern in Paper Space (spacing of lines). |
| Hatch angle | number | 0 | Rotation angle of the hatch pattern in degrees. |
| Hatch colour | number | -1 | Colour of the hatch. -1 uses the TSL instance colour (ByBlock). Otherwise, use AutoCAD Color Index (0-255). |
| Hatch transparency | number | 60 | Opacity percentage (0-90) used only when Pattern is set to "SOLID". |
| Merge superimposed | dropdown | No | If "Yes", combines overlapping beam profiles into a single hatch area to prevent visual clutter. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are defined for this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies on standard hsbCAD catalog PainterDefinitions but does not use an external settings XML file.

## Tips
- **Solid Fills**: To create a coloured overlay (e.g., for sheathing or concrete), set **Hatch pattern** to `SOLID` and adjust the **Hatch transparency** to see underlying geometry.
- **Clean Up Overlaps**: If you have multiple plates stacked on top of each other, set **Merge superimposed** to `Yes` to avoid double-hatching lines.
- **Zone Logic**: Use **Zone** 0 for the main frame structure. Use positive/negative zones to hatch cladding, gables, or flooring layers independently.
- **Filtering**: Use the **Include filter** to select general groups (e.g., "All Structural") and the **Exclude filter** to remove specific items (e.g., "Blocking") from that group.

## FAQ
- **Q: Why is the transparency option not changing the hatch look?**
  **A**: Transparency only applies when the **Hatch pattern** is set to `SOLID`. If you are using a pattern like ANSI31, you must change the color or scale, not the transparency.
- **Q: How do I hatch only the studs in a wall?**
  **A**: Set **Zone** to `0`, set **Include filter** to your "Studs" PainterDefinition, and ensure **Exclude filter** is `None`.
- **Q: The script asks for a viewport but I am in Model Space.**
  **A**: This script only works in Paper Space layouts. Switch to a Layout tab, create a viewport looking at your model, and run the script there.
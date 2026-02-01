# HSB_E-DrawZone.mcr

## Overview
This script automatically generates a 2D zone profile in Paper Space or Shop Drawing layouts. It calculates the shape based on projected beam shadows, specific sheet zones, or outlines, and allows for customized hatching and connection lines between different zones.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | Script will delete itself if run here. |
| Paper Space | Yes | Select a Viewport linked to an Element. |
| Shop Drawing | Yes | Select a Shopdraw View entity. |

## Prerequisites
- **Required Entities:** A Viewport (Paper Space) or a Shopdraw View (Multipage) linked to a valid hsbCAD Element.
- **Minimum Beam Count:** 0 (Can work purely with sheet data).
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-DrawZone.mcr` from the list.

### Step 2: Configure Space Type
**Action:** The Properties Palette (OPM) will appear. Select the desired working environment under the **Space** property.
- **Paper space:** Use if working in a standard 2D layout view.
- **Shopdraw multipage:** Use if working within a generated hsbCAD shop drawing.

### Step 3: Select View Entity
**Action:** Click on the drawing to select the specific view representation.
- **If Paper Space:** Click the border of the Viewport.
- **If Shopdraw:** Click the Shopdraw View entity.

### Step 4: Set Insertion Point
**Command Line:** `Specify insertion point:`
**Action:** Click in the drawing where you want the zone reference point to be located.

### Step 5: Adjust Appearance (Optional)
**Action:** Select the newly inserted script instance. Use the Properties Palette to adjust the Zone Index, Colors, and Hatch patterns. The geometry will update automatically.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Space | String | Paper space | Sets the environment (Paper space or Shopdraw multipage). |
| Zone | Integer | 0 | Determines the logic: **0** for beam union, **1-10** for specific sheet zones, **99/100** for outlines. |
| Include | String | (Empty) | Filter: Only includes beams with names containing this string. |
| Exclude | String | (Empty) | Filter: Excludes beams with names containing this string. |
| OutlineColor | Integer | 1 | AutoCAD Color Index (ACI) for the outline boundary. |
| HatchColor | Integer | -1 | AutoCAD Color Index for the hatch. **-1** matches the sheet color automatically. |
| HatchPattern | String | SOLID | The hatch pattern name (e.g., ANSI31, SOLID). |
| HatchScale | Double | 1.0 | Scale factor for the hatch pattern. |
| DrawOpenings | Yes/No | Yes | If Yes, subtracts openings (windows/doors) from the zone profile. |
| ConnectToZone | Integer | 0 | Zone index to draw connection lines towards. Set to 0 to disable. |
| ConnectDist | Double | 1000 | Maximum distance to search for vertices to connect. |
| LogWallGaps | Yes/No | No | If Yes, applies specific log wall gap calculations to the profile. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Forces an immediate update of the zone geometry based on current properties. |
| Properties | Opens the Properties Palette to edit script parameters. |

## Settings Files
No external settings files are required for this script.

## Tips
- **Visualizing Voids:** Set `Zone` to **99** or **100** to generate clean outlines of the structure excluding internal beam details.
- **Color Coding:** Set `HatchColor` to **-1** to make the hatch color match the layer or sheet color of the element automatically.
- **Filtering:** Use the `Include` property (e.g., "Wall") to generate a zone profile only for specific wall types within a complex element.
- **Troubleshooting:** If the script disappears immediately after insertion, ensure you are not in Model Space; this script only runs in Layouts.

## FAQ
- **Q: What happens if I select a Zone that has no data?**
  A: The script will default to Zone 0 or display an empty profile. Check the Output window for specific messages like "Zone reset to 0."
- **Q: Can I use this to show the footprint of the whole house?**
  A: Yes, set `Zone` to 0 and ensure the `Include`/`Exclude` filters allow all structural beams to be projected.
- **Q: My hatch looks too dense.**
  A: Increase the `HatchScale` property in the Properties Palette.
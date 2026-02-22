# hsb_ApplyInsulation

## Overview

This script automatically fills timber element cavities with 3D insulation sheets. It analyzes the gaps between structural members (studs, plates, headers) within wall or roof elements and generates correctly sized insulation bodies. Users can define primary and secondary insulation layers, apply dimensional tolerances for friction fitting, and configure hatch patterns for plan-view display.

## Script Information

| Property | Value |
|----------|-------|
| Script Type | O-Type (Object) |
| Version | 2.20 |
| Required Beams | 0 (works at the Element level) |
| Supported Elements | Walls (ElementWall), Roofs (ElementRoof) |

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Operates on 3D wall and roof elements |
| Paper Space | No | Not designed for layout views |
| Shop Drawing | No | Not a shop drawing script |

## Prerequisites

- One or more timber wall or roof elements must exist in the drawing.
- Elements must contain beams in the target insulation zone.
- Wall codes must match the filter list if filtering is active.

## Usage Steps

### Step 1: Launch the Script

Run `TSLINSERT` and select `hsb_ApplyInsulation.mcr`, or drag the script from the Tool Palette.

### Step 2: Select Elements

The command line prompts: **Select a set of elements**. Click on the wall or roof elements you want to insulate, then press Enter.

The script filters the selection by the wall code list (see "Filter by Wall Code" parameter). For each matching element, an independent script instance is created and attached. The original insertion instance is removed after distribution.

### Step 3: Adjust Parameters

Select the attached script instance (or the parent element) and modify values in the **Properties Palette** (OPM). Changes trigger automatic recalculation of insulation geometry.

### Step 4: Force Recalculation (if needed)

Right-click the script instance and select **Reapply Insulation Sheets** from the context menu. This forces a full recalculation, useful after modifying the element structure or adding/removing beams.

## Properties Panel Parameters

### Zone to Insulate

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Insulate zone | Dropdown (0-10) | 0 | Selects which construction zone to fill with insulation. Values 0-5 map to positive zones; values 6-10 map to negative zones (-1 to -5). Zone 0 is the main structural cavity. |
| Attach Insulation to Zone | Dropdown (0-10) | 10 | Sets the zone to which generated insulation sheets are assigned for BOM reporting and element grouping. |

### Main Insulation

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Insulation Name | Text | (empty) | Product name for the main insulation, used in schedules and BOMs. |
| Insulation Material | Text | Insulation | Material classification for the main insulation sheets. |
| Insulation Thickness | Number (mm) | 89 | Thickness of the main insulation. If set to 0, the script uses the full zone depth. |
| Insulation Width | Number (mm) | 1200 | Stock width of the main insulation product (for BOM reference). |
| Insulation Height | Number (mm) | 8000 | Stock height/length of the main insulation product (for BOM reference). |

### Secondary Insulation (Thinner Insulation)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Insulation Name | Text | (empty) | Product name for the thinner insulation at connection areas. |
| Insulation Material | Text | Insulation | Material classification for the secondary insulation. |
| Insulation Thickness for Connections | Number (mm) | 60 | Thickness of insulation used where full-depth members reduce the available cavity (e.g., flat studs, connectors). |
| Insulation Width | Number (mm) | 1200 | Stock width of the secondary insulation product. |
| Insulation Height | Number (mm) | 8000 | Stock height of the secondary insulation product. |

### Tolerances and Limits

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Tolerance width | Number (mm) | 0 | Reduces the width of all generated insulation sheets. Use 2-5 mm for friction fit allowance. |
| Tolerance height | Number (mm) | 0 | Reduces the height of all generated insulation sheets. |
| Minimal width/height | Number (mm) | 20 | Gaps smaller than this value in either direction are skipped (filters out thin slivers). |
| Minimal Thickness | Number (mm) | 20 | Sheets thinner than this value are not created. |
| Max Insulation Height | Number (mm) | 0 | Limits the vertical extent of insulation. Set to 0 for full available height. Automatically locked to 0 for roof elements. |

### Filtering

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Filter by Wall Code | Text | EA;EB; | Only elements whose wall code matches one of the listed codes will receive insulation. Separate multiple codes with semicolons. Leave empty to process all selected elements. |

### Display

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Display Hatch Pattern | Dropdown | Yes | Toggles the 2D hatch pattern visibility in plan views (viewed from the element's Y-axis direction). |
| Hatch Pattern | Dropdown | (system list) | Selects the hatch style (e.g., ANSI31, INSUL). |
| Hatch Scale | Number | 7.5 | Controls the density of the hatch pattern. |
| Hatch Color | Number | 51 | AutoCAD color index for the insulation hatch and display (valid range: 0-255). |
| Show Only In Disp Rep Name | Text | (empty) | Restricts hatch visibility to a specific Display Representation name. Leave empty to show in all representations. |

## How It Works

1. **Existing sheet cleanup**: On each recalculation, the script removes previously generated insulation sheets (identified by a metadata tag) from the target zone.

2. **Beam analysis**: Collects all beams in the specified zone. For wall elements, it also checks adjacent walls in the same group for beams that might overlap the insulation area.

3. **Cavity detection**: Projects beam envelopes onto the element plane and builds a combined frame profile. The gaps (openings) in this profile define the insulation areas.

4. **Opening subtraction**: Removes areas occupied by wall/window/door openings from the insulation profile.

5. **External exclusion zones**: Checks other attached TSL scripts (e.g., vents) for "noinsulation" regions and subtracts them from the insulation area.

6. **Sheet creation**: For each remaining cavity area that exceeds the minimum width/height threshold, a Sheet entity is created with the specified thickness, material, name, and color, then assigned to the target element group zone.

7. **Display**: If hatch display is enabled, the script draws hatch patterns on the insulation profiles in the plan view direction.

## Roof Element Behavior

When applied to a roof element (ElementRoof), the script adjusts its behavior:

- The **Max Insulation Height** parameter is automatically locked to 0 (full height).
- The script looks for FloorContour polylines among its linked entities to define the insulation boundary.
- The insulation area is computed as the intersection of the floor contour with the element envelope, minus the beam frame profiles.

## Tips

- **Wall code filtering**: If insulation does not appear on certain walls, verify that the wall code (visible in element properties) is listed in the "Filter by Wall Code" parameter.
- **Tolerances**: Set tolerance width and height to 2-5 mm for a realistic friction-fit representation that avoids visual overlap with studs.
- **Thin slivers**: Increase "Minimal width/height" if the model contains many tiny insulation fragments at narrow gaps. Decrease it if small cavities need to be filled.
- **Vent integration**: If you use scripts like `hsb_Vent`, their exclusion zones are automatically respected. No manual adjustment is needed.
- **Multiple zones**: To insulate different zones of the same element (e.g., zone 0 and zone 1), insert the script twice with different zone settings.
- **Catalog usage**: When launched from the Tool Palette with a catalog key, property values are loaded from the catalog automatically.

## FAQ

**Q: Why are some walls not getting insulation?**
A: Check the "Filter by Wall Code" property. The script only processes walls whose element code matches the semicolon-separated list (e.g., "EA;EB;").

**Q: The insulation overlaps with studs or is too tight. How do I fix this?**
A: Increase the "Tolerance width" or "Tolerance height" values by a few millimeters to shrink the generated sheets.

**Q: How do I limit the hatch to a specific display representation?**
A: Enter the Display Representation name in the "Show Only In Disp Rep Name" field (e.g., "Presentation").

**Q: The script says it could not find any insulation area. What happened?**
A: This occurs when the beam frame profile fills the entire element zone, leaving no gaps. Verify that the correct zone is selected and that the element contains cavities between members.

**Q: Can I use this on roof elements?**
A: Yes. For roofs, the script uses FloorContour polylines to define the insulation boundary. The "Max Insulation Height" parameter is automatically disabled for roof elements.

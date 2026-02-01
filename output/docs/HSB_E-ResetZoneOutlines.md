# HSB_E-ResetZoneOutlines.mcr

## Overview
Automatically recalculates and resets the zone outlines (2D profiles) and heights of selected timber wall or floor elements to match the current geometry of their beams and sheets. This is typically used to synchronize manufacturing data after structural modifications.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on Elements in the 3D model. |
| Paper Space | No | Not intended for 2D views or layouts. |
| Shop Drawing | No | Not for shop drawing generation. |

## Prerequisites
- **Required Entities**: At least one hsbCAD Element (Wall or Floor).
- **Minimum beam count**: 0 (Works on existing elements with or without sub-beams, though beams are needed for meaningful updates).
- **Required settings**: The TSL script `HSB_G-FilterGenBeams` must be loaded in the drawing to provide filter options for selecting specific beams or sheets.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-ResetZoneOutlines.mcr`

### Step 2: Select Elements
```
Command Line: Select element(s)
Action: Click on the Element(s) in the model you wish to update and press Enter.
```

### Step 3: Configure Properties
The script will insert and immediately open the Properties Palette (OPM). Adjust settings as needed and click **Apply** or close the palette to execute the calculation.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Try to keep opening information | dropdown | Yes | If 'Yes', existing openings (windows/doors) in the current zone are preserved. If 'No', the outline is calculated as a solid shape, effectively removing opening data. |
| Try to set the height of the zone | dropdown | Yes | If 'Yes', the script measures the physical thickness of the filtered beams and updates the element's zone height. |
| Try to set the zoneprofile | dropdown | No | If 'Yes', the 2D boundary (profile) of the element zones is redrawn based on the filtered beams (Zone 0 as convex hull, Zones 1-5 as union of sheeting). |
| Filter definition for height | dropdown | (Empty) | Select a specific filter preset (defined in HSB_G-FilterGenBeams) to determine which beams/sheets are used to calculate the height and outline. |
| Maximun area allowed for an element | number | 0 | Sets a safety limit (in m²). If the element's calculated area exceeds this value, a warning message is displayed. Set to 0 to disable the check. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific options to the right-click context menu. |

## Settings Files
This script does not use its own separate settings file but relies on:
- **Dependency**: `HSB_G-FilterGenBeams` catalog entries.
- **Purpose**: Provides the filter logic used to select which beams/sheets define the zone height and profile.

## Tips
- **Filter Accuracy**: The correct `Filter definition` is critical. If the height is calculated incorrectly, ensure your filter includes the vertical studs or structural beams and excludes items like cladding or insulation.
- **Resetting Outlines**: If you want to completely redraw the element shape based on the beams, set "Try to set the zoneprofile" to **Yes** and "Try to keep opening information" to **No**.
- **Large Elements**: Use the "Maximun area allowed for an element" setting as a quick check to identify elements that may be too large for transport or production machinery.

## FAQ
- **Q: Why did my openings disappear after running the script?**
  A: The "Try to keep opening information" parameter was likely set to "No". Change this to "Yes" and re-run to preserve cutouts for windows and doors.
- **Q: The zone height updated to the wrong value. Why?**
  A: Check the "Filter definition for height". It might be filtering only on sheets (e.g., OSB) rather than the structural studs (e.g., GenBeams), or vice versa.
- **Q: What is the difference between Zone 0 and Zones 1-5?**
  A: Zone 0 typically represents the overall outer contour (convex hull), while Zones 1-5 usually represent specific layers like sheeting profiles. This script updates both if the respective options are enabled.
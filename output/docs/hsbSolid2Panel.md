# hsbSolid2Panel.mcr

## Overview
This script converts imported 3D Solids or generic beams into intelligent hsbPanels. It automatically interprets the solid's outer contour for the panel shape and internal voids as machining tools (drills and cuts).

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Operates on 3DSolid and GenBeam entities. |
| Paper Space | No | Not supported for drawing views. |
| Shop Drawing | No | This is a modeling/conversion tool. |

## Prerequisites
- **Required entities**: 3DSolid or GenBeam.
- **Minimum beam count**: 1.
- **Required settings**: 
  - Panel Styles (SipStyles) configured in the hsbCAD Catalog.
  - `hsbPanelDrill` TSL must be present in the search path.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbSolid2Panel.mcr` from the list.

### Step 2: Configure Conversion Settings
```
Properties Palette (OPM):
Action: Set the Conversion Strategy and Max Segment Length before selecting geometry.
- Strategy: Determines how the panel is oriented (e.g., "Wall 3D" uses the solid's current orientation).
- Segment Length: Defines how accurately curved edges are smoothed (default is 50 mm).
```

### Step 3: Select Source Geometry
```
Command Line: Select entities:
Action: Click on the 3D Solid(s) or Beam(s) you wish to convert.
- You can select multiple entities at once.
```

### Step 4: Finalize
```
Command Line: [Press Enter or Space]
Action: The script processes the geometry, creates the hsbPanel, and assigns tools based on voids found in the solid.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sStrategy | String | Wall 3D | Defines the orientation method for the panel's coordinate system (Up direction and length). Options include Wall 3D, Wall WCS XY, X-Axis, and Y-Axis. |
| sStyle | String | Auto | The Panel Style (SipStyle) from the catalog to apply. "Auto" attempts to find a style matching the solid's measured thickness. |
| dSegmentToArcLength | Double | 50 mm | Tolerance for converting faceted edges (from meshes) into smooth arcs. Lower values retain more detail; higher values smooth out geometry. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Re-runs the conversion logic. Useful if you changed the Style or Segment Length property. |

## Settings Files
- **Catalog Entity**: SipStyles
- **Location**: hsbCAD Catalog
- **Purpose**: Defines material, layer, and thickness for the generated panels.

## Tips
- **Volume Check**: Ensure the 3D Solids you select have a significant volume (greater than 1mm³). Very small fragments will be ignored.
- **Auto Style**: Use the "Auto" style setting to quickly match imported architectural solids to your existing timber panel catalog based on thickness.
- **Curved Geometry**: If converted curved walls look jagged or faceted, decrease the `dSegmentToArcLength` value (e.g., to 20mm) and recalculate.
- **Drill Conversion**: Ensure cylindrical holes in the solid are closed shapes; they will be converted to parametric `hsbPanelDrill` instances if perpendicular to the panel surface.

## FAQ
- **Q: Why did the script fail to create a panel?**
  **A:** The source solid might be invalid or too small. Check that the solid has a closed contour and a volume larger than 1mm³.
- **Q: Why are my curved walls looking jagged?**
  **A:** The `dSegmentToArcLength` tolerance might be too high. Lower this value to detect arcs more accurately.
- **Q: What happens to the holes in the solid?**
  **A:** Voids are interpreted as tools. Vertical holes become parametric drills; angled holes or complex cuts become static machining tools.
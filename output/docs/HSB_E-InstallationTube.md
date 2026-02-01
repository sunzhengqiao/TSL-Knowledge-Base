# HSB_E-InstallationTube.mcr

## Overview
Generates 3D electrical or conduit tubing paths within timber wall elements. It supports automatic CNC machining (drilling/milling) for studs, visualization customization, and BOM data generation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script generates 3D geometry (Body/PLine) and modifies Element tooling. |
| Paper Space | No | Not a drawing generation script. |
| Shop Drawing | No | Does not generate 2D views or dimensions for layouts. |

## Prerequisites
- **Required Entities**: An existing Wall **Element**.
- **Minimum Beam Count**: 0 (Script functions on the element shell and associated beams).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-InstallationTube.mcr` from the catalog or file browser.

### Step 2: Select Wall Element
```
Command Line: Select element
Action: Click on the Wall Element where the installation tube should be placed.
```

### Step 3: Choose Input Mode
```
Command Line: Select option
Action: Choose one of the following from the dialog:
- Based on installation point: Use if an HSB_E-InstallationPoint exists in the wall.
- Based on element: Use to define the path independently relative to the wall.
```

### Step 4: Define Tube Path
```
Command Line: Polyline to describe tube path
Action: Draw or select a 2D Polyline in the XY plane that represents the path of the tube.
```

## Properties Panel Parameters

### Insert
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Input mode | dropdown | Based on installation point | Determines how the tube position and properties are initialized. |
| Side installation point | text | (Empty) | Read-only display of the referenced installation point side. |

### Position
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Side installation tube | dropdown | Same as installation point | Sets the side of the wall for the tube (Front, Back, or Center). |
| Tube diameter | number | 16.0 | The physical outer diameter of the tube (in mm). |
| Depth offset | number | 20.0 | Distance from the selected wall surface to the center of the tube (in mm). |

### Visualization
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Color of tube | number | 5 | AutoCAD color index for the tube visualization. |
| Line type of tube | dropdown | (Current) | Line style used if 'Tube visualization type' is set to 'Line'. |
| Tube visualization type | dropdown | Tube | Renders the path as a 3D solid 'Tube' or a 2D 'Line'. |
| Assign to layer | dropdown | Tooling | Specifies the CAD layer for the generated tube geometry. |
| Description Start | text | (Empty) | Custom text label placed at the start of the tube. |
| Description End | text | (Empty) | Custom text label placed at the end of the tube. |
| Segment Description | text | (Empty) | Custom text label for specific segments. |
| Segment description before or after length | dropdown | Before | Position of segment description relative to length dimension. |
| Color description start and end | number | -1 | Color index for start/end text. -1 uses tube color. |
| Color description | number | -1 | Color index for segment description text. |
| Text size start and end | number | -1.0 | Height of text labels at start/end (-1 uses default). |
| Text size | number | -1.0 | Height of segment description text (-1 uses default). |
| Dimension style | dropdown | (Current) | Dimension style used for length labels. |
| Show individual tube lengths | dropdown | Yes | Controls display of length labels (Yes, Yes + description, etc.). |

### Frame tooling (F)
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| (F) Tooltype frame | dropdown | No tooling | Type of CNC operation on frame studs (None, Drill, Mill). |
| (F) Filter beams with beamcode | text | (Empty) | Filter to apply tooling only to specific beam codes. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Properties | Opens the Properties Palette to edit parameters listed above. Changing properties triggers automatic recalculation of geometry and tooling. |
| Erase | Deletes the script instance and all generated tube geometry/tooling. |

## Settings Files
No specific external XML settings files are required. The script uses BeamCodes defined in the hsbCAD project for filtering tooling targets.

## Tips
- **Performance**: For complex models with many tubes, change `Tube visualization type` to **Line** to improve graphical performance.
- **Milling**: If you need a slot for the tube (e.g., to slide it in), set `(F) Tooltype frame` to **Mill**. Ensure the tube diameter is slightly larger than the physical tube for clearance.
- **Integration**: Use the **Based on installation point** mode to automatically match the wall layer and depth settings defined in your electrical installation points.
- **Labeling**: Use `Show individual tube lengths` set to **Yes rounded + description** to create clean production labels directly in the 3D model.

## FAQ
- **Q: Why are no holes appearing in my studs?**
  - A: Check the `(F) Tooltype frame` property. It is likely set to "No tooling". Change it to "Drill" or "Mill". Also, verify that the beams intersecting the tube match the filter in `(F) Filter beams with beamcode`.
- **Q: Can I change the path after inserting?**
  - A: Yes, select the tube, open the Properties Palette, and look for the graphical grip or specific coordinate fields if exposed by the script version, or delete and re-insert if the polyline logic is locked post-insertion (depends on specific script version constraints). *Note: Typically, path modification requires re-insertion or editing the grip if available.*
- **Q: What does "Depth offset" do?**
  - A: It controls how far into the wall the tube sits. A value of 0 places the center of the tube exactly on the surface (Front/Back). Increase this value to bury the tube deeper into the insulation or structure.
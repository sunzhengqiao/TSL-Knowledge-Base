# GE_FLOOR_HOLES.mcr

## Overview
This script creates standardized floor penetrations, such as holes, chases, and service openings, within floor elements. It optionally generates drilling operations for structural joists located underneath the penetration and adds text labels for manufacturing identification.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary environment for inserting floor holes. |
| Paper Space | No | Not intended for layout views directly. |
| Shop Drawing | No | Generates tooling data used in shop drawings, but runs in Model Space. |

## Prerequisites
- **Required Entities**: A Floor Element (e.g., timber floor panels/sheathing).
- **Structural Members**: Joists (specifically `DakCenterJoist` type) if drilling is required.
- **Minimum Beam Count**: 0.
- **Required Settings Files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_FLOOR_HOLES.mcr`

### Step 2: Select Floor Element
```
Command Line: Select an floor element
Action: Click on the desired floor element or sheet layer where the hole will be cut.
```

### Step 3: Select Insertion Point
```
Command Line: Select insertion point
Action: Click in the model space to define the location of the hole.
Note: The script will automatically snap to the centerline of a parallel joist if one is found nearby.
```

### Step 4: Configure Properties
**Action:** The Properties Palette (OPM) will appear automatically. Adjust the "Hole type", "Orientation", and other settings as needed. See the *Properties Panel Parameters* section below for details.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Hole type | Dropdown | 2-1"Drills Spaced at 3-3/4" | Selects the shape and dimensions of the opening (e.g., Circular, Rectangle, Ellipse, Diamond, or Text-only marks). |
| Orientaion of Hole | Dropdown | Joist Direction | Sets the alignment of the hole relative to the floor joists (Parallel or Perpendicular). |
| Additional Rotation | Number | 0 | Applies a manual rotation angle (in degrees) to fine-tune the hole's orientation. |
| Text Output | Text | TEXT | Defines the label text associated with the hole for drawings and exports (e.g., "HVAC", "VENT"). |
| Add Drill to Joist | Dropdown | Yes | If "Yes", the script searches for a joist under the hole and adds a drilling operation. If "No", only the floor sheathing is cut. |
| Drill Diameter | Number | 1.5 | Specifies the diameter (in inches) of the drill hole to be made in the underlying joist. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Properties | Opens the Properties Palette to edit Hole Type, Rotation, and Drill settings. |
| Delete | Removes the hole instance and associated tooling. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Snapping**: If you move the hole using its grip after insertion, the script will attempt to re-snap the insertion point to the nearest parallel joist.
- **Multi-Sheet Warning**: If a hole spans across multiple floor sheets (e.g., at a joint), a warning text "Move me from sheet edge..." may appear. Move the hole slightly away from the sheet boundary for optimal manufacturing.
- **Text Only Mode**: Select "Text" from the *Hole type* dropdown to place a label or mark on the floor without creating a physical cut or drill.
- **Drilling Logic**: Ensure the underlying structural beam is defined as a `DakCenterJoist` type for the automatic drilling function to work correctly.

## FAQ
- **Q: Why is the hole not drilling through the joist?**
  **A:** Check that "Add Drill to Joist" is set to "Yes". Additionally, verify that the beam underneath the hole is a `DakCenterJoist` type and runs parallel to the hole orientation logic.
  
- **Q: Can I change the shape of the hole after I insert it?**
  **A:** Yes. Select the hole in the model, open the Properties Palette, and change the "Hole type" dropdown. The geometry and tooling will update automatically.

- **Q: How do I rotate the hole to match my ductwork?**
  **A:** Set the "Orientaion of Hole" to "Joist Direction" or "Perpendicular..." as a base, then use the "Additional Rotation" parameter to type in a specific angle (e.g., 45) to align it precisely.
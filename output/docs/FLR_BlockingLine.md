# FLR_BlockingLine.mcr

## Overview
Generates blocking or solid bridging between floor joists along a user-defined path. It automatically calculates intersections, fits to roof/floor slopes, and provides options for staggering, justification, and material tagging.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Not applicable for manufacturing drawings. |

## Prerequisites
- **Required Entities**:
  - An existing ElementRoof or ElementFloor (Reference Element).
  - Floor Joists (Beams or TrussEntities) in the model space.
- **Minimum Beam Count**: 0 (Script creates new beams, does not require existing selection).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `FLR_BlockingLine.mcr`

### Step 2: Define Start Point
```
Command Line: \nSelect start point
Action: Click in the model to set the beginning of the blocking line.
```

### Step 3: Define End Point
```
Command Line: \nSelect next point
Action: Click to set the end point of the blocking line.
```

### Step 4: Select Reference Element
```
Command Line: \nSelect a reference Element
Action: Click on the floor or roof element that this blocking belongs to. This defines the working plane and elevation.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Beam type | Dropdown | First available profile | Select the timber profile (e.g., 2x4) to use for the blocking pieces. |
| All Material Loose | Dropdown | No | If "Yes", marks all generated blocking as "Loose" material for production lists. |
| Do Ends | Dropdown | Yes | If "No", skips creating blocking pieces at the very start and end of the line (useful if the line extends past the joists). |
| Minimum Length | Number | 6 inch | Blocking pieces shorter than this value will not be generated. |
| Staggered | Dropdown | No | If "Yes", alternates the vertical position of adjacent blocks for nailing or ventilation. |
| Joist to use | Dropdown | All Floor Joists | Sets whether to intersect with all joists in the model or only those belonging to the selected Element. |
| Keep Cuts Square | Dropdown | Yes | If "No", the ends of the blocking will be cut to match the slope of adjacent members (e.g., for vaulted ceilings). |
| DimStyle | Dropdown | [None] | Selects the dimension style for the annotation text label. |
| Vertical Justification | Dropdown | Center | Aligns the blocking vertically relative to the joist: Top, Center, or Bottom. |
| Lateral Justification | Dropdown | Center | Aligns the blocking laterally along the insertion line: Left, Center, or Right. |
| Blocking Gap | Number | 0 | Adds a clearance gap between the ends of the blocking and the intersecting joists. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Generate Pieces | Regenerates the blocking beams based on current properties and geometry. Use this if joists have moved or properties were changed. |

## Settings Files
No specific external settings files are required for this script. It relies on the hsbCAD catalog for profiles.

## Tips
- **Moving the Line**: Select the script instance in the model and drag the blue grip points to move the start or end of the blocking line. The blocking will update automatically.
- **Sloped Roofs**: If installing blocking on a sloped roof or ceiling, set **Keep Cuts Square** to "No" to ensure the blocking sits tight against the sloped chords.
- **Nailing Access**: Turn **Staggered** to "Yes" to offset blocks, which often provides better access for nailing or allows ventilation between bays.
- **Overshoot Correction**: If your line extends slightly beyond the outer joists and creates tiny unwanted offcuts, set **Do Ends** to "No".

## FAQ
- **Q: Why are some blocking pieces missing in the middle of the bay?**
  - **A**: Check the **Minimum Length** property. If the gap between joists is smaller than this value (e.g., tight spacing), the script will suppress that piece.
- **Q: How do I update the blocking if I move my floor joists?**
  - **A**: Select the blocking line script instance, right-click, and choose **Generate Pieces**. This will recalculate intersections based on the new joist positions.
- **Q: The blocking is floating above/below the joists.**
  - **A**: Check the **Vertical Justification** property. Ensure it is set to "Top" or "Center" depending on where you want the blocking to sit relative to the joist height.
# WallBeamcut

## Overview

WallBeamcut is a tool that creates horizontal or vertical beamcuts along the upper or lower edges of wall elements. It allows you to define rectangular cutouts at specific locations on wall frames and sheeting, with interactive visual feedback during placement.

## Usage Environment

| Item | Details |
|------|---------|
| **Script Type** | O-Type (Object/Tool) |
| **Execution Space** | Model Space |
| **Required Entities** | Wall element or items belonging to a wall element (beams/sheets) |
| **Output** | BeamCut tools applied to frame members, ElemMill tools applied to sheeting zones |

## Prerequisites

- At least one wall element must exist in the drawing
- Wall element must have valid zones with sheeting (if cutting through sheeting)
- Understanding of wall coordinate system (X = length, Y = height, Z = thickness)

## Usage Steps

1. **Launch the Tool**
   - Execute the WallBeamcut command
   - The properties dialog will appear for initial configuration

2. **Select Wall Element**
   - Click on any wall element, beam, or sheet belonging to the wall
   - The tool will automatically identify the parent wall element

3. **Position the Beamcut**
   - Click to place the beamcut location on the wall
   - During placement (jig mode), you'll see:
     - Live preview of the cut in both plan and elevation views
     - Automatic dimension lines showing position and width
     - Visual indication of intersecting floor elements (for top alignment)
     - Preview of affected beams and sheets

4. **Configure Parameters**
   - Adjust Width, Height, and Depth in the Properties Panel
   - Choose Vertical alignment (Bottom or Top)
   - Choose Side (Icon Side or Opposite Side)
   - The tool updates automatically as you change properties

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Width** | Length | 300 mm | Horizontal width of the beamcut |
| **Height** | Length | 80 mm | Vertical height of the beamcut from reference plane |
| **Depth** | Length | 0 mm | Depth of cut into wall thickness. 0 = complete through-cut (uses frame width) |
| **Vertical** | Choice | Bottom | Alignment reference: "Bottom" (from wall base) or "Top" (from top edge or floor above) |
| **Side** | Choice | Icon Side | Which face of wall to cut: "Icon Side" or "Opposite Side" |
| **Format** | Text | @(Width)x@(Height) | Display label format using formatObject syntax |

## Right-Click Menu

This tool uses grip-based editing rather than context menu commands. You can:

- **Drag the insertion point** to relocate the beamcut along the wall
- **Modify properties** in the Properties Panel for real-time updates

## Settings Files

This tool does not use external XML settings files.

## Tips

- **Depth = 0 (default)**: Creates a complete through-cut across the entire wall thickness. This is the most common use case.
- **Depth > 0**: Creates a partial-depth pocket cut. Useful for recesses or mechanical pockets.
- **Top Alignment**: The tool automatically detects floor elements above the wall and aligns to their bottom face. Works when wall and floor are in the same level group.
- **Live Preview**: When dragging the insertion point, the tool shows real-time dimensions and highlights affected beams in the elevation view.
- **Floor Element Detection**: For top-aligned cuts, the tool searches for roof/floor elements in the same house group with matching level names.
- **Sheeting Cuts**: Automatically creates sawline (ElemMill) tools for each zone's sheeting that intersects the beamcut.
- **Multiple Instances**: You can place multiple beamcuts on the same wall element.

## FAQ

**Q: Why is my beamcut not cutting through the wall completely?**
A: Check the Depth parameter. Set it to 0 for a complete through-cut, or verify it's large enough to span the wall thickness.

**Q: Can I cut from the top of the wall?**
A: Yes. Set Vertical alignment to "Top". The tool will align to the wall's top edge, or to the bottom of any floor element directly above.

**Q: How do I flip the cut to the other side of the wall?**
A: Change the Side parameter from "Icon Side" to "Opposite Side" in the Properties Panel.

**Q: The beamcut isn't showing in my elevation view. Why?**
A: The tool uses view direction hiding to avoid clutter. Beamcuts display primarily in plan view and in the wall's element elevation view (perpendicular to wall thickness).

**Q: Can I modify the beamcut after placing it?**
A: Yes. Select the tool and either:
  - Drag the insertion point grip to relocate it
  - Modify Width, Height, Depth, Alignment, or Side in Properties Panel

**Q: What happens if the wall is deleted?**
A: The beamcut tool is linked to the parent element and will be deleted automatically if the wall is removed.

**Q: How is the Height measured for Bottom vs Top alignment?**
A:
  - Bottom: Measured upward from the wall base line (ptOrg)
  - Top: Measured downward from the top edge of the wall envelope or floor element above

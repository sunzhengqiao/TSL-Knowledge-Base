# hsbPanelWallRabbet

## Overview

hsbPanelWallRabbet creates lap joints (rabbet joints) for wall-based panels, enabling panels to interlock at their edges. The tool can be inserted as a wall-based split location or as an individual split, automatically generating male and female cutting geometry for panel connections.

This tool operates in two modes: element mode (for wall-based splits) and SIP tool mode (for panel-specific joints). It supports adjustable width, depth, gap settings, and allows selection of which side (reference or opposite) receives the joint.

## Usage Environment

| Property | Value |
|----------|-------|
| Script Type | Object (O-Type) |
| Required Beams | 0 |
| CAD Space | Model Space |
| Element Association | Wall elements and SIP panels |
| Execution Loops | 2 (processes in multiple passes) |
| Version | 1.0 |

## Prerequisites

- **For Wall Mode**: An Element (wall) must exist in the model
- **For Panel Mode**: Two adjacent SIP panels that result from splitting
- The panels should be properly aligned for joint creation

## Usage Steps

### Using TSL Split Location (Recommended):

1. **Create catalog entry** with desired joint properties (Width, Depth, Gaps)
2. **Set negative gap** equal to the width to prevent exceeding panel dimensions
3. **Use execute key** to insert with the catalog name
4. **Select wall element** when prompted
5. **Click insertion point** where you want the split/joint to occur

The tool will:
- Split the wall at the specified location
- Create two panels from the original
- Automatically apply lap joint geometry to both panels
- Generate male rabbet on one panel, female socket on the other

### Using Individual Split:

1. **Start the command** and show dialog
2. **Configure properties** manually:
   - Width: Width of the lap joint
   - Depth: Depth of the rabbet cut
   - Gaps: Gap at reference side, depth gap, opposite side gap
   - Side: Choose reference side or opposite side for orientation
3. **Click OK**
4. **Select wall element**
5. **Click insertion point** for the split location

### In Panel Mode (After Wall Split):

Once the wall is split and panels are created, the tool operates in SIP mode:
- The tool becomes a persistent object attached to the two panels
- It maintains the joint geometry between the panels
- Moving the split location (via `_Pt0` grip) automatically updates both panel edges

## Properties Panel Parameters

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Width** | Length | 50mm | Width of the lap joint in the horizontal direction |
| **Depth** | Length | 30mm | Depth of the rabbet cut into the panel thickness |
| **Gap (reference side)** | Length | 0mm | Gap/clearance on the reference side of the joint |
| **Gap (Depth)** | Length | 0mm | Gap in the depth direction of the rabbet |
| **Gap (opposite side)** | Length | 5mm | Gap/clearance on the opposite side of the joint |
| **Side** | Choice | Reference side | Which side of the split receives the joint: "reference side" or "opposite side" |

### Gap Parameters Explained:

- **Reference side gap**: Creates clearance on the first panel edge
- **Depth gap**: Creates clearance in the cutting depth
- **Opposite side gap**: Creates clearance on the second panel edge
- Gaps are useful for ensuring assembly tolerances and preventing binding

## Right-Click Menu

### Join + Erase

This command joins the two connected panels back together and removes the lap joint tool.

**Usage:**
1. **Right-click** on the lap joint object
2. **Select "Join + Erase"**
3. The two panels merge into one
4. The joint tool is deleted

This is useful for undoing a split or consolidating panels.

## Settings Files

This script does not use external XML settings files. Configuration is done through properties and optional catalog entries.

## Tips

- **Catalog-Based Workflow**: For production use, create catalog entries with standardized joint dimensions to ensure consistency across the project.

- **Negative Gap Trick**: When using as a TSL split location, set a negative gap equal to the width. This prevents the joint from extending beyond potential panel size limitations.

- **Moving the Split**: After creation, you can reposition the split location by editing the `_Pt0` point. The joint geometry on both panels updates automatically.

- **Two-Pass Processing**: The tool runs in two execution loops - first to split the wall, then to apply the joint geometry. This ensures proper panel creation before tooling.

- **Visual Display**: The tool displays visual indicators (colored polylines) showing the joint profile and gap locations for verification.

- **Edge Stretching**: The tool stretches panel edges to create the joint using the `stretchEdgeTo()` method, maintaining panel integrity while creating interlocking geometry.

- **Orientation Control**: Use the "Side" property to control which panel receives the male vs. female portion of the joint.

## FAQ

**Q: What's the difference between Wall Mode and SIP Mode?**
A: Wall Mode (mode 0) operates on wall elements to create splits. Once the wall is split into panels, the tool switches to SIP Mode (mode 1) to maintain the joint geometry between the resulting panels.

**Q: Can I adjust the joint after it's created?**
A: Yes, modify the properties in the Properties Palette. The geometry will update automatically. You can also move the split location by editing the `_Pt0` grip point.

**Q: Why would I use negative gap values?**
A: When using catalog entries as split locations, a negative gap (equal to the width) ensures the joint doesn't exceed panel dimension limits that may be enforced by the wall element.

**Q: Can I remove the joint and re-join the panels?**
A: Yes, use the "Join + Erase" context menu command to merge the panels back together and remove the joint.

**Q: What happens if I move the split location after creation?**
A: The tool automatically recalculates and stretches both panel edges to maintain the joint at the new location. This is handled when you modify the `_Pt0` property.

**Q: How do I know which panel gets the male vs. female part?**
A: The "Side" property controls this. "Reference side" and "opposite side" determine the orientation. The visual display shows the joint profile to verify.

**Q: Can this tool work on roof or floor panels?**
A: The tool is specifically designed for wall-based panels, using the wall's coordinate system (vecX, vecY, vecZ) for orientation.

**Q: What if my panels are not perpendicular?**
A: The tool uses the wall element's coordinate system to define the split plane. As long as the wall is valid, the split should work correctly.

**Q: Can I create lap joints without splitting the wall?**
A: The primary workflow involves splitting. However, in SIP mode, you could potentially attach the tool to existing adjacent panels if they have compatible geometry.

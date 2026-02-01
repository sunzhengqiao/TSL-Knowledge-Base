# hsbBeamcut

## Description

**hsbBeamcut** is a tool script that creates a rectangular cut (notch) on one face of a timber beam. This script is commonly used to create pockets, grooves, or clearance cuts for other structural members, conduits, or hardware installations to pass through or seat into a beam.

The beamcut can be applied to:
- Individual beams (GenBeam)
- Wall elements (ElementWallSF) - applies to horizontal beams
- Door/window openings (OpeningSF)
- Installation points (hsbInstallationPoint TSL) - for MEP conduit routing

When linked to openings or installation points, the beamcut automatically adjusts its position and dimensions to match the referenced object.

## Script Information

| Property | Value |
|----------|-------|
| Script Type | O-Type (Object) |
| Version | 2.6 |
| Keywords | Beam, Beamcut |
| File | hsbBeamcut.mcr |

## Properties

### Geometry

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Length | PropDouble | 300 mm | Defines the length of the beamcut along the beam axis. Set to 0 for full beam length. When linked to an opening or installation, setting length to 0 locks the position to the referenced object. |
| Width | PropDouble | 30 mm | Defines the width of the beamcut (perpendicular to beam axis). Set to 0 to match complete beam width. |
| Depth | PropDouble | 30 mm | Defines the depth of the beamcut (how deep the cut goes into the beam face). |

### Alignment

| Property | Type | Default | Options | Description |
|----------|------|---------|---------|-------------|
| Offset | PropDouble | 0 mm | - | Defines the lateral offset from the beam axis. Use '+' or '-' to align to an edge, or enter a specific value for offset from center. |
| Reference Side | PropString | ECS Y | ECS Y, ECS Z, ECS -Y, ECS -Z | Defines which face of the beam receives the cut. Options are based on the beam's Element Coordinate System (ECS). When attached to a wall, this is locked to "ECS -Y" (bottom side). |

## Usage Workflow

### Inserting on a Single Beam

1. Start the hsbBeamcut command
2. A dialog appears allowing you to configure properties or select a catalog preset
3. Select a beam, wall, opening, or installation point as the reference
4. **If selecting a beam:**
   - Click to specify the insertion point
   - Click a second point to specify the direction (or press Enter to place at center)
   - If Length > 0, the second point only defines direction
   - If Length = 0, the distance between points determines the length
5. The beamcut is created on the specified face

### Inserting on Walls/Elements

1. Start the hsbBeamcut command
2. Select a wall element
3. Pick an insertion point on the wall
4. Pick a direction point (or Enter for center)
5. The beamcut is applied to horizontal beams that intersect the defined cutting zone
6. Note: Reference Side is automatically locked to bottom (ECS -Y) for walls

### Inserting on Openings or Installations

When you select multiple openings or installation points:
- The script automatically creates beamcuts at each location
- For installation points with milling settings, separate beamcuts are created for top and bottom as needed
- Length = 0 causes the beamcut to match the opening width or installation milling width

### Adjusting After Placement

- **Grips**: Drag the corner grips to interactively adjust length, width, and depth
- **Properties Palette**: Modify numeric values directly in the AutoCAD Properties Palette (OPM)
- **Double-Click**: Cycles through reference sides (rotates the cut to different beam faces)

## Context Menu Commands

Right-click on an hsbBeamcut instance to access these commands:

| Command | Description |
|---------|-------------|
| **Add Beam** | Add additional beams to receive the same beamcut. Select one or more beams when prompted. |
| **Remove Beam** | Remove beams from the beamcut. The last beam cannot be removed. |

## Special Behaviors

### Automatic Length from Reference

- When linked to an **opening**, setting Length = 0 uses the opening's width
- When linked to an **installation point**, setting Length = 0 uses the milling width defined in the installation

### Width Spanning Multiple Beams

When the beamcut is linked to multiple beams (via Add Beam), and Width = 0:
- The width automatically spans from the outermost edge of the first beam to the outermost edge of the last beam

### Full-Length Mode

Setting Length = 0 causes the beamcut to extend the full solid length of the beam.

### Grip-Based Editing

The two corner grips allow intuitive editing:
- Moving grips along the beam axis changes **Length**
- Moving grips perpendicular to the beam axis changes **Width** and **Offset**
- Moving grips toward/away from the beam face changes **Depth**

## Tips for Designers

1. **Use catalogs**: Save commonly used configurations (depth for cable routing, pipe clearances, etc.) as catalog entries for quick access.

2. **Link to installations**: For MEP coordination, attach beamcuts to hsbInstallationPoint objects so cuts automatically update when conduit positions change.

3. **Zero values**: Remember that 0 values for Length and Width mean "use full dimension" - this is useful for cuts that should always match beam dimensions.

4. **Wall mode restrictions**: When attached to a wall element, the Reference Side is locked to the bottom face. Create separate beamcuts if you need cuts on other faces.

5. **Copy support**: The beamcut can be copied to other beams while maintaining its parametric properties.

## Related Scripts

- **hsbInstallationPoint** - MEP installation points that can drive beamcut positioning
- **hsbSlot** - For through-slots in beams
- **hsbMortise** - For mortise cuts in timber joinery

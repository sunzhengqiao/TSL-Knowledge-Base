# Rothoblaas Typ F70

## Overview

This script creates **Rothoblaas post bases type F70** on one or multiple timber beams. Post bases are metal connectors used to anchor vertical posts to concrete foundations, providing a secure connection while elevating the timber above moisture.

The script generates:
- A 3D visual representation of the post base (bottom plate + sword)
- Automatic slot tooling in the beam for the sword
- Cut operation to define the post starting height
- Hardware component entries for BOM (Bill of Materials)

| Property | Value |
|----------|-------|
| Type | E-Type (Element) |
| Version | 1.0 (September 15, 2017) |
| Author | florian.wuermseer@hsbcad.com |
| Space | Model Space |
| Beams Required | 1 minimum (supports multiple selection) |
| Output | 3D hardware with hyperlink + tooling |

## Prerequisites

- At least one timber beam must exist in the model
- For automatic placement (no point selection): Beams must be vertical
- For manual placement (with point selection): Beams can be sloped but not horizontal

## Usage

### Insertion Methods

**Method 1: Automatic Placement (Vertical Beams Only)**
1. Run the script via `TSLINSERT` command
2. Configure parameters in the dialog (or use catalog preset)
3. Select one or more beams
4. Press Enter without selecting a point
5. The post base is placed at the bottom of each vertical beam, pointing downward

**Method 2: Manual Point Placement (Vertical or Sloped Beams)**
1. Run the script via `TSLINSERT` command
2. Configure parameters in the dialog
3. Select one or more beams
4. Click a point in the drawing
5. The point is projected onto each beam's X-axis to determine placement
6. This method allows upside-down placement on top of posts

### Command Prompt Sequence

| Step | Prompt | User Action |
|------|--------|-------------|
| 1 | Dialog | Configure post base parameters or select catalog preset |
| 2 | "Select Beam(s)" | Pick one or more beams (window selection supported) |
| 3 | "Select Point or <Enter> to put post base on bottom end of the beam" | Click a point OR press Enter for automatic placement |

### Behavior Notes

- Horizontal beams are always filtered out (not supported)
- Without point selection, non-vertical beams are filtered out with a message
- A report message displays how many beams were filtered and why

## Parameters

### Mounting Category

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| A - Size | Dropdown | F70_1 | F70_1, F70_2, F70_3 | Post base size selection. Determines all dimensional properties. |
| B - Cutting height | Length | 30 mm | 0 to (sword length / 2) | Height of the post above the bottom plate. Defines where the beam is cut. Maximum is half the sword length. |

### Tooling Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| C - Slot extra width | Length | 1 mm | Additional width tolerance for the slot machined in the beam. Allows for manufacturing tolerances. |
| D - Slot extra depth | Length | 1 mm | Additional depth tolerance for the slot machined in the beam. Allows for manufacturing tolerances. |

## Size Specifications

| Size | Article Number | Bottom Plate (L x W x T) | Top Plate Thickness | Sword Length | Thread Diameter | Ground Screws |
|------|---------------|--------------------------|---------------------|--------------|-----------------|---------------|
| F70_1 | TYPF700808 | 80 x 80 x 6 mm | 6 mm | 146 mm | 8 mm | 4x M6 |
| F70_2 | TYPF701010 | 100 x 100 x 6 mm | 6 mm | 194 mm | 8 mm | 4x M6 |
| F70_3 | TYPF701414 | 140 x 140 x 8 mm | 8 mm | 292 mm | 11.5 mm | 4x M8 |

## Generated Geometry

### Visual Components

The script creates a 3D body representation consisting of:

1. **Bottom Plate**: Rectangular steel plate that mounts to the foundation
2. **Sword**: Tapered vertical plate that slots into the timber beam

### Tooling Operations

The script applies two tooling operations to the associated beam:

| Tool | Purpose | Parameters |
|------|---------|------------|
| Cut | Defines the starting height of the post above the bottom plate | Located at cutting height + bottom plate thickness below insertion point |
| Slot | Creates recess for the sword | Width = top plate thickness + extra width; Depth = sword length + bottom plate thickness + extra depth |

## Generated Hardware

The script automatically generates hardware components for the Bill of Materials:

| Component | Quantity | Properties |
|-----------|----------|------------|
| Post Base | 1 | Category: Post base; Manufacturer: Rothoblaas; Material: Steel |
| Fastening Screws | 4 | Category: Post base; For ground mounting; Diameter varies by size |

**Note**: Ground screw length must be determined by structural requirements and is not specified by this script.

## Catalog Presets

The script supports catalog presets for quick configuration:
- Launch with an execute key matching a catalog name to load saved parameter sets
- If the key does not match any catalog, the configuration dialog is shown

## Tips

1. **Cutting Height Validation**: If you enter a cutting height greater than half the sword length, it is automatically corrected and a warning message is displayed in the command line.

2. **Multiple Beam Selection**: Select all posts at once to place post bases efficiently. The script creates a separate TSL instance on each selected beam.

3. **Sloped Posts**: Use point selection (Method 2) for sloped beams. The selected point is projected onto the beam's X-axis.

4. **Top Mounting**: With point selection, you can mount the post base upside-down on top of a post by selecting a point above the beam.

5. **Hardware Tracking**: Hardware components are regenerated when the size property changes.

6. **Group Assignment**: The script automatically assigns the associated beam to group 'Z'.

7. **Tolerance Adjustments**: Increase slot extra width/depth if the sword does not fit properly due to manufacturing variations.

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| "Only vertical beams possible" message | Automatic mode selected but non-vertical beams were in selection | Use point selection method OR select only vertical beams |
| "Horizontal beams not possible" message | Horizontal beams were in selection | Select only vertical or sloped beams |
| Cutting height changed unexpectedly | Value exceeded 50% of sword length | Use the corrected value or enter a smaller cutting height |
| Sword slot appears misaligned | Coordinate system issue | Verify beam orientation; use point selection for precise placement |

## Workflow Example

### Typical Use Case: Deck Post Anchors

1. Create or select your vertical deck posts (beams)
2. Launch `TSLINSERT` and select "Rothoblaas Typ F70"
3. Select F70_2 (100x100mm) size for standard 6x6 posts
4. Set cutting height to 30mm (typical for moisture clearance)
5. Window-select all deck posts
6. Press Enter for automatic placement at beam bottoms
7. Post bases are generated with slots at each post location

## Related Scripts

- **Rothoblaas Typ R**: Alternative post base design
- **Rothoblaas XYLOFON**: Sound isolation hardware
- **Hilti-Verankerung**: Hilti anchoring systems

## External Links

- [Rothoblaas TYP F Product Page](http://www.rothoblaas.com/products/fastening/brackets-and-plates/pillar-bases/typ-f) - Right-click the TSL instance to access via hyperlink

## Technical Notes

- The script uses `assignToGroups(bm0, 'Z')` to track the associated beam
- The cut tool uses `_kStretchOnToolChange` flag for dynamic updates
- Hardware components are regenerated on `_bOnDbCreated` or when the size property changes
- The TSL instance creates a hyperlink to the manufacturer's product page

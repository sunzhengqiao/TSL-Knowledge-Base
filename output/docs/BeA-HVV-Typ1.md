# BeA-HVV-Typ1

## Overview

| Property | Value |
|----------|-------|
| **Script Name** | BeA-HVV-Typ1 |
| **Type** | O (Object) |
| **Version** | 2.5 |
| **Category** | Hardware / Connectors |
| **Description** | Creates a BeA HVV Type 1 angle bracket connector for timber beam T-connections |
| **Material** | Steel, zincated (galvanized) |
| **Author** | thorsten.huck@hsbcad.com |
| **Last Updated** | 21.12.2021 |

This script automates the insertion and configuration of the **BeA HVV Type 1 angle bracket** for timber beam connections. It supports T-connections between beams, multi-sided wrapping configurations, and attachment to existing detail components.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| **Model Space** | Yes | Operates in 3D Model Space to generate solid bodies and beam cuts |
| **Paper Space** | No | Not designed for 2D layout or detailing views |
| **Shop Drawing** | Yes | Works with DetailGenBeam for shop drawing integration |
| **hsbMake** | Yes | Published for hsbMake and hsbShare |
| **hsbShare** | Yes | Display published for sharing |

## Prerequisites

- **Required entities**: Timber Beams or existing TslInst entities (specifically `DetailGenBeam`)
- **Minimum beam count**: 2 for T-connections (typically requires intersecting beams)
- **Required settings**: None - all configuration via OPM properties

## Usage Workflow

### Standard Mode (Beam Selection)

1. **Launch the script** - Run `TSLINSERT` and select `BeA-HVV-Typ1.mcr`
2. **Configure properties** - A dialog appears to pre-configure bracket size and insertion mode
3. **Select beams** - Click on timber beams; the script automatically detects T-connections
4. **Automatic placement** - Connectors are placed at all valid intersection points

### Selection Behaviors

| Selection Type | Behavior |
|----------------|----------|
| **Multiple beams** | Script detects all T-connections (perpendicular intersections) and inserts brackets at valid points |
| **Single beam** | Enters special mode attaching to that beam, reads additional beams from Creator submap |
| **TslInst (DetailGenBeam)** | Attaches to existing detail component, uses its dimensions for placement |

### Shop Drawing Mode (DetailGenBeam)

When linked to a DetailGenBeam instance:
- Reads beam properties (Y, Z dimensions, angle, zone)
- Auto-positions based on detail beam dimensions
- Assigns to correct zone in shop drawing
- Updates main detail's XML configuration file

## Properties Panel Parameters (OPM)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Side** | Integer (1-4) | 1 | Mounting face orientation: 1=Top, 2=Right, 3=Bottom, 4=Left |
| **Model** | String | First item | Bracket SKU size (format: A x B x C x D in mm) |
| **multiple Insertion** | String | Single Side | Wrapping configuration pattern |
| **hsbIntelliSnap** | Double | 20 mm | Detection tolerance for finding connecting beams |
| **Dimstyle** | String | Current | CAD dimension style for annotations |
| **Color** | Integer | 254 | Display color index (0-255) for 3D bracket body |

### Available Model Sizes (46 Standard Sizes)

The connector follows the dimension format: **Height x Length x Thickness x Width** (mm)

| Size Category | Height (A) | Length (B) | Thickness (C) | Width (D) |
|---------------|------------|------------|---------------|-----------|
| Small | 40 | 40 | 2.0 | 20-60 |
| Medium | 60-80 | 60-80 | 2.0-2.5 | 40-200 |
| Large | 100-120 | 100-120 | 2.5-3.0 | 40-120 |

Example models: `40 x 40 x 2 x 20`, `60 x 60 x 2.5 x 80`, `100 x 100 x 2.5 x 120`

### Multiple Insertion Options

| Option | Quantity | Description |
|--------|----------|-------------|
| Single Side | 1 | One connector on selected side only |
| Two opposite Sides | 2 | Connectors on opposing faces (mirrored) |
| Two neighbouring Sides | 2 | Connectors on adjacent faces (90 degree offset) |
| Three Sides | 3 | Connectors on three faces |
| Four Sides | 4 | Connectors wrapping all four faces |

## Context Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Assign to [Element/Beam]** | Switches logical assignment between male beam, female beam, or their parent Elements/Groups |
| **Update** | Forces manual recalculation; use when underlying beam geometry has changed |

## Technical Details

### Geometry Creation

- Creates L-shaped 3D solid body from polyline profile
- Extruded along width (D) dimension
- Automatic mirroring applied for opposite-side placements
- Rotation transformations for multi-side configurations

### Beam Operations

Applies a **Cut** operation to the primary beam at connection point for proper fit.

### Data Export (DXA/BOM)

| Export Field | Value |
|--------------|-------|
| Name | Script name + Model designation |
| Width | D dimension (mm) |
| Height | A dimension (mm) |
| Length | B dimension (mm) |
| Group | Assigned beam group |
| Quantity | Based on insertion mode |
| Material | Steel, zincated |

### Hardware Component

Creates a **HardWrComp** (Hardware Component) for reporting:
- **Category**: Connectors
- **Article Number**: BeA-HVV-Typ1
- **Count Type**: Amount-based counting

## Tips and Best Practices

1. **Batch Processing**: Select multiple beams at once to automatically generate brackets for all T-junctions in the selection set

2. **IntelliSnap Distance**: Adjust the `hsbIntelliSnap` property (default 20mm) if connections are not being detected:
   - Increase for looser tolerances
   - Decrease for precise matching

3. **Orientation Adjustment**: If the bracket appears on the wrong side, change the `Side` property to rotate 90 degrees around the beam axis

4. **Corner Connections**: Use `multiple Insertion` set to "Two neighbouring Sides" or "Three Sides" for columns/posts where brackets wrap around corners

5. **Element Assignment**: Use the "Assign to" context menu to control which element/beam the connector is associated with for BOM hierarchy

6. **Model Selection**: Choose appropriate size based on beam dimensions and structural requirements

## FAQ

| Question | Answer |
|----------|--------|
| **I selected beams but no brackets appeared** | Beams may not form valid T-connection within `dSnap` tolerance. Ensure secondary beam physically intersects main beam. Try increasing `dSnap` or moving beams closer together. |
| **How do I change bracket size after insertion?** | Select the script instance, open Properties Palette (Ctrl+1), choose different size from `Model` dropdown |
| **Can I use this for non-perpendicular connections?** | Script is optimized for T-connections (perpendicular beams). Results on acute/obtuse angles may be unpredictable |

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.5 | 21.12.2021 | Display published for hsbMake and hsbShare |
| 2.4 | 04.05.2017 | Hardware component added |
| 2.3 | 14.02.2013 | New assignment method (male/female dependency) |
| 2.2 | 14.12.2012 | Info-layer as default display layer |
| 2.1 | 27.05.2011 | Bugfix: color on insert |
| 2.0 | 09.12.2010 | Version compatibility bugfix |
| 1.7 | 30.11.2010 | Multiple connection support added |

## Related Scripts

- **GA.mcr** - Generic angle bracket system
- **T-Connection.mcr** - T-connection beam tool
- **DetailGenBeam** - Shop drawing beam detail system

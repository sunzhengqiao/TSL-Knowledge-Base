# HSB_R-Tube

## Overview

| Property | Value |
|----------|-------|
| **Script Name** | HSB_R-Tube |
| **Type** | Object (O) |
| **Version** | 4.26 |
| **Category** | Roof Opening / Tube Installation |
| **Description** | Adds a tube (pipe penetration) to a roof element with automatic trimmer framing |

## Summary

This TSL script creates a tube/pipe penetration through a roof element. The tube is placed at a specified insertion point and can be oriented vertically or perpendicular to the roof element. The script automatically generates trimmer beams around the tube to frame the opening, cuts openings in internal and external sheeting, and optionally creates a top sheet and hardware component for the tube.

## Usage Environment

| Environment | Supported |
|-------------|-----------|
| Model Space | Yes |
| Paper Space | No |
| Roof Elements | Yes |
| Wall Elements | No |
| Floor Elements | No |
| Purlin Elements | Yes (limited) |

## Usage Workflow

1. **Insert the TSL**: Run the `HSB_R-Tube` command
2. **Select Element**: Click on a roof element where the tube should be placed
3. **Select Position**: Click to specify the insertion point for the tube
4. **Configure Properties**: Adjust tube diameter, trimmer configuration, and other parameters in the Properties Palette (OPM)
5. **Optional Actions**: Use context menu options to copy the tube to another element or delete it

## Properties Panel Parameters

### Tube Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Opening shape | List | Round | Shape of the opening: Round or Rectangular |
| Diameter | List | 110mm | Tube diameter (110, 125, 160, 200, 250, 315, 400, 500 mm) |
| Overrule diameter | Double | 0 | Custom diameter if greater than zero |
| Opening width | Double | 100mm | Width for rectangular openings |
| Opening height | Double | 100mm | Height for rectangular openings |
| Article number | String | - | Hardware article number for the tube |
| Description | String | "PVC Buis" | Tube description text |
| Material | String | "PVC" | Tube material specification |
| Tube color | Integer | -1 | Color index for tube display |
| Offset tube above battens | Double | 0 | Extension above battens |
| Offset tube below internal sheeting | Double | 0 | Extension below internal sheeting |
| Draw tube | Yes/No | Yes | Toggle tube 3D visualization |
| Create section of tube as sheet | Yes/No | Yes | Create tube section as sheet in zone 10 |
| Create tube as beam | No/Yes | No | Create tube as beam for beam reports |

### Position Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Orientation | List | Vertical | Tube orientation: Vertical or Perpendicular to element |
| Reference | List | Inside frame | Reference position: Inside frame or Inside element |
| Angle | Angle | 0 | Rotation angle of the tube |

### Construction Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Allow rafters to split | Yes/No | Yes | Allow rafters to be split by the tube opening |
| Beamcode split rafters above tube | String | - | Beam code for split rafters above tube |
| Trimmer configuration | List | Horizontal and vertical trimmers | Options: Only top trimmer, Horizontal and vertical trimmers, Horizontal trimmers only, No trimmers |
| Apply left trimmer | Yes/No | Yes | Apply left vertical trimmer |
| Apply right trimmer | Yes/No | Yes | Apply right vertical trimmer |
| Width trimmers | Double | -1 | Custom width for trimmer beams |
| Height trimmers | Double | -1 | Custom height for trimmer beams |
| Place extra beam | Yes/No | No | Place extra beam with remaining height |
| Alignment top | List | Top | Alignment of top trimmer: Top or Bottom |
| Alignment bottom | List | Top | Alignment of bottom trimmer: Top or Bottom |
| Squared | No/Yes | No | Cut beams squared or along element slope |
| Offset vertical trimmers from tube | Double | 2mm | Gap between vertical trimmers and tube |
| Offset horizontal trimmers from tube | Double | 2mm | Gap between horizontal trimmers and tube |
| Align trimmers with tube | Yes/No | Yes | Align trimmer orientation with tube direction |

### Beam Properties Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Beam code top trimmer | String | - | Beam code for top horizontal trimmer |
| Beam code bottom trimmer | String | - | Beam code for bottom horizontal trimmer |
| Beam code left trimmer | String | - | Beam code for left vertical trimmer |
| Beam code right trimmer | String | - | Beam code for right vertical trimmer |

### Sheeting Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Create top sheet | Yes/No | Yes | Create top sheet around tube |
| Top sheet deepend | No/Yes | No | Deepen top sheet into rafters |
| Size sheet below tube | Double | 100mm | Top sheet size below tube |
| Size sheet above tube | Double | 100mm | Top sheet size above tube |
| Thickness top sheet | Double | 18mm | Top sheet thickness |
| Gap around top sheet | Double | 2mm | Gap around top sheet |
| Color top sheet | Integer | 1 | Color index for top sheet |
| Material top sheet | String | - | Material specification for top sheet |
| Label top sheet | String | - | Label text for top sheet |
| Gap around tube for sheet cut out | Double | 2mm | Gap around tube in sheet cutouts |
| Bottom gap for sheet cut out | Double | 2mm | Bottom gap for rectangular cutouts |
| Top gap for sheet cut out | Double | 2mm | Top gap for rectangular cutouts |
| Left gap for sheet cut out | Double | 2mm | Left gap for rectangular cutouts |
| Right gap for sheet cut out | Double | 2mm | Right gap for rectangular cutouts |
| Depth beamcut gap | Double | 2mm | Depth gap for beam cut |
| Height beamcut gap | Double | 2mm | Height gap for beam cut |
| Width beamcut gap | Double | 2mm | Width gap for beam cut |

### Markup and Measurement Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Visualisation zone | List | 0 | Zone index for tube visualization |
| Visualisation layer | List | Zone | Element layer (Zone, Info, Dimension, Tooling) |
| Label color | Integer | -1 | Color for tube label |
| Export label | Yes/No | Yes | Export label in drawings |
| Tube label format | String | "ø@(Diameter)" | Label format with placeholders @(Diameter), @(Width), @(Height) |
| Dimension style label | List | - | Dimension style for label |
| Text height label | Double | 0 | Custom text height (0 = use dimension style) |
| X-Offset tube label | Double | 0 | Horizontal offset for label position |
| Y-Offset tube label | Double | 0 | Vertical offset for label position |
| Subtype prefix | String | - | Prefix for dimension subtypes |

### Filter Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Filter definition beams | List | - | Filter definition using HSB_G-FilterGenBeams |

### Element Tool Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Add element tool vertical | No/Yes | No | Add vertical element milling tool |
| Add element tool perpendicular | No/Yes | No | Add perpendicular element milling tool |
| Toolindex | Integer | 1 | Tool index for CNC operations |
| Extra depth | Double | 1mm | Extra depth for element tool |

### Tilelath Cutout Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Add extra counterbattens | No/Yes | No | Add extra counter battens around tube |
| Add tilelath cutout | No/Yes | No | Add cutout for tile laths |
| Offset from tube horizontal | Double | 1mm | Horizontal offset for tile lath cutout |
| Offset from tube vertical | Double | 1mm | Vertical offset for tile lath cutout |
| Minimum distance to add counterbattens | Double | 1mm | Minimum distance threshold |

### Integrate Timbers Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Integrate timber catalog | List | - | Catalog for HSB_T-IntegrateTimber |

## Context Menu Options

| Option | Description |
|--------|-------------|
| Delete tube | Removes the tube and all associated entities from the element |
| Copy to other element | Copies the tube configuration to another roof element at a new position |

## Tips and Best Practices

1. **Orientation Selection**: Use "Vertical" orientation for vertical pipe penetrations. Use "Perpendicular to element" for penetrations that follow the roof slope angle.

2. **Trimmer Configuration**:
   - For small openings, "Only trimmer at top" may be sufficient
   - For standard penetrations, use "Horizontal and vertical trimmers" for proper framing
   - Use "No trimmers" when only the sheet cutout is needed

3. **Rectangular Openings**: When using rectangular openings, set both Opening width and Opening height to define the penetration size.

4. **Label Formatting**: The tube label supports placeholders:
   - `@(Diameter)` - Inserts the tube diameter
   - `@(Width)` - Inserts the opening width
   - `@(Height)` - Inserts the opening height
   - Use semicolons (`;`) to split labels into multiple lines

5. **Filter Integration**: Use the filter definition to control which beams are affected by the tube opening. Create filters using the `HSB_G-FilterGenBeams` TSL.

6. **CNC Output**: Enable element tools for automatic CNC milling path generation for the tube cutout.

7. **Hardware Tracking**: Set the Article number and Description for proper hardware tracking and reports.

8. **Copy Functionality**: Use "Copy to other element" to quickly replicate identical tube configurations across multiple roof elements.

## Related Scripts

- `HSB_G-FilterGenBeams` - Beam filtering definitions
- `HSB_T-IntegrateTimber` - Timber integration at connections

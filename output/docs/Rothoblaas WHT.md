# Rothoblaas WHT

## Description

The Rothoblaas WHT script inserts Rothoblaas WHT tensile anchor brackets at StickFrame Walls, panels (SIPs), or individual beams. WHT anchors are designed for high tensile loads in timber construction, commonly used for hold-down connections between wall studs and foundations or between floor levels.

This tool automatically generates the 3D anchor geometry, applies milling operations to accommodate the anchor, creates no-nail areas for sheeting, and generates a complete hardware bill of materials (BOM).

## Script Information

| Property | Value |
|----------|-------|
| **Script Type** | O (Object) |
| **Version** | 2.6 |
| **Keywords** | Anchor, Rothoblaas, Wall, Element |
| **Beams Required** | 0 (selects during insertion) |

## Available Anchor Models

The script supports the following WHT anchor types:

| Model | Height | Width | Depth | Bottom Hole Diameter |
|-------|--------|-------|-------|---------------------|
| WHT340 | 340 mm | 60 mm | 63 mm | 17 mm |
| WHT440 | 440 mm | 60 mm | 63 mm | 17 mm |
| WHT540 | 540 mm | 60 mm | 63 mm | 22 mm |
| WHT620 | 620 mm | 80 mm | 83 mm | 26 mm |
| WHT740 | 740 mm | 140 mm | 83 mm | 29 mm |

## Properties

### Type Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Type** | Selection | WHT340 | Selects the anchor model (WHT340, WHT440, WHT540, WHT620, WHT740) |
| **Interdistance** | Double | 0 mm | Distance between two anchors when placing a double anchor configuration. Set to 0 for single anchor. |
| **Reinforcement Washer** | Selection | WHTW50 | Adds a reinforcement washer to the anchor. Available washers depend on the selected anchor type. |

### Mounting Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Mounting type** | Selection | Anchor Nail LBA 4x40 | Defines if the anchor will be fixed with screws or nails (LBA 4x40, LBA 4x60, LBS 5x40, LBS 5x50) |
| **Nailing** | Selection | Full Nailing | Defines the nailing pattern: Full Nailing, Partial Nailing - Pattern 1, or Partial Nailing - Pattern 2 |
| **Anchoring to the ground** | Selection | VINYLPRO | Sets how the anchor will be fixed to the foundation (VINYLPRO, EPOPLUS, or custom fixtures from settings) |
| **Height** | Double | 0 mm | Adjusts the vertical position of the anchor relative to the wall base |

### Tooling Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Mill depth** | Double | 0 mm | Depth of the milling pocket the anchor sits in |
| **Oversize milling** | Double | 5 mm | Oversize clearance for the milling pocket |
| **No nail areas** | Yes/No | No | Creates no-nail zones on sheeting where the anchor is located (requires hsbCAM module) |

### Additional Tooling Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Oversize No nail areas per zone** | String | (empty) | Defines oversize for no-nail areas per zone, separated by semicolons (e.g., "5;10;15;20;25") |
| **Drilling plate** | Yes/No | No | Automatically drills the bottom plate when anchor passes through it (requires hsbCAM module) |
| **Oversize drill** | Double | 1 mm | Oversize for the plate drilling |

### Display Category

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| **Plan view Symbol** | Yes/No | Yes | Shows a triangular plan symbol above the anchor location |
| **Color** | Integer | 7 | Color index for the plan view symbol |
| **Elementview Format** | String | (empty) | Format string for element view labeling |

## Usage Workflow

### Inserting on Beams

1. Run the script from the TSL menu or command line
2. A dialog appears with anchor configuration options
3. Select one or more vertical beams or panels
4. Click a point to indicate which side of the beam the anchor should face
5. The anchor is automatically placed at the bottom of the beam

### Inserting on Panels (SIPs)

1. Run the script and configure options
2. Select one or more panels
3. A highlight preview shows the selected panel
4. Click to set the anchor alignment direction (for non-vertical panels)
5. Click insertion points on the panel surface
6. Press Enter to finish placing anchors on the current panel

### Double Anchor Configuration

Set the **Interdistance** property to a value greater than the anchor width to automatically create a paired anchor configuration. The script will verify the stud is wide enough to accommodate both anchors.

## Context Commands

Right-click on an inserted anchor to access these commands:

| Command | Description |
|---------|-------------|
| **Flip Z alignment** | Reverses the vertical direction of the anchor (Panel mode only) |
| **Set Z alignment** | Prompts to pick a point defining the Z direction (Panel mode only) |
| **Edit Fixing** | Opens a dialog to modify or add custom fixture definitions |
| **Remove Fixing** | Opens a dialog to remove a fixture from the settings |
| **Tag Fixture** | Tags an existing fixture definition for use with this script |

## Hardware Components Generated

The script automatically generates the following hardware items in the BOM:

- **Anchor bracket** (WHT340/440/540/620/740)
- **Nails or screws** (LBA or LBS series, quantity based on nailing pattern)
- **Ground anchoring** (VINYLPRO, EPOPLUS, or custom fixture)
- **Reinforcement washer** (if selected)

## Special Behaviors

### StickFrame Wall Integration

When placed on a beam that is part of a StickFrame wall element:
- The anchor automatically aligns to the wall coordinate system
- No-nail areas are applied to the appropriate sheeting zones
- Hardware is grouped with the element for BOM reporting
- The anchor height adjusts based on bottom plate positions

### Company-Specific Modes

The script supports special behavior modes for certain companies (BAUFRITZ, RUB) which modify:
- No-nail area generation
- Sheet cutting operations
- Element saw line creation around anchor locations

### CNC Output

The script publishes CNC contour data for hsbCNC when no-nail areas are enabled, allowing direct export to manufacturing equipment.

## Settings File

Custom fixture definitions are stored in:
- **Company path**: `[Company]\TSL\Settings\FixtureDefinition.xml`
- **Installation path**: `[hsbCAD Install]\Content\General\TSL\Settings\FixtureDefinition.xml`

The company path takes precedence if both files exist.

## Tips

- Always use vertical beams or properly oriented panels for anchor placement
- Enable "No nail areas" when sheeting will be applied over the anchor location
- Use the "Interdistance" property for high-load situations requiring paired anchors
- The plan view symbol helps identify anchor locations in 2D drawings
- Check the hardware components in hsbMake or hsbShare for accurate material lists

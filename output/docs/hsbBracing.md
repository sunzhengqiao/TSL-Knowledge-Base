# hsbBracing

Wall bracing and structural sheathing tool for timber frame construction.

## Overview

The hsbBracing script adds lateral stability elements to wall elements. It supports two distinct bracing methods:

- **Cross Brace**: Diagonal metal strap bracing forming an X-pattern between studs. The script remains as a persistent parametric object attached to the wall, generates hardware components for the bill of materials, and optionally creates hsbStudTie connectors at stud-to-plate junctions.
- **Sheet**: Structural sheathing panels (OSB, plywood) laid out in a grid pattern across the wall surface. The script creates Sheet entities and then removes itself -- the sheets persist independently.

The script validates bracing configurations against manufacturer-defined angle and length constraints from an XML product catalog, providing real-time visual feedback during placement.

## Environment

| Property | Value |
|----------|-------|
| Script Type | O-Type (Object) |
| Context | Model Space |
| Linked Entity | Wall Element |
| Required Beams | 0 |
| Grip Points | 2 (start and end of bracing span) |
| Output Visibility | Display export (DXA) enabled |
| Version | 1.5 |

## Prerequisites

- A valid wall element containing vertical studs and horizontal plates (top/bottom)
- The settings file `hsbBracing.xml` must be available in one of these locations:
  - Company path: `[CompanyPath]\TSL\Settings\`
  - Installation path: `[InstallPath]\Content\General\TSL\Settings\`
- For Cross Brace: The wall must have studs perpendicular to the wall length direction
- For gable walls: Diagonal top plates are supported (v1.3+)

## Usage

### Insertion Workflow

1. Run the script via `TSLINSERT` and select `hsbBracing.mcr`
2. **Type Selection**: A dialog appears to choose between "Cross Brace" or "Sheet"
3. **Manufacturer Selection**: Select the bracing product manufacturer from the catalog
4. **Family Selection**: Select the product family within the chosen manufacturer
5. **Model Selection**: Select the specific product model (defines dimension constraints)
6. **Wall Selection**: Click on the target wall element when prompted
7. **Point Selection** (with live preview):
   - Click the first stud location (start of bracing span)
   - Click the second stud location (end of bracing span)
   - For Cross Brace: Two diagonal straps form an X-pattern between the selected studs
   - For Sheet: Panels are laid out in a grid within the defined area

### Command Line Options During Point Selection

| Input | Action |
|-------|--------|
| Type `O` | Switch to Zone 1 (front face) |
| Type `Z` | Switch to Zone -1 (back face) |
| Type `Start` | Restart the point selection from the beginning |

### OPM Key Shortcut

You can bypass dialogs by specifying parameters in the OPM key, separated by `?`:

```
Type?Manufacturer?Family?Model
```

For example: `Cross Brace?ManufacturerBr1?metal brace?brace product1`

Catalog presets from `[CompanyPath]\tsl\catalog\` can also be referenced by name.

### Grip Point Editing (Cross Brace Only)

After placement, drag the grip points at either end of the bracing to reposition. During editing:

- Valid configurations display in **green** (color 3)
- Invalid configurations display in **red** (color 1)
- Semi-transparent previews show the minimum and maximum valid configurations
- Angle arcs and horizontal span dimensions are annotated in **cyan** (color 6)
- Angle and length annotations change to red when outside valid range, green when valid

## Parameters

### Properties Palette

| Parameter | Type | Options | Default | Description |
|-----------|------|---------|---------|-------------|
| Type | String (dropdown) | Cross Brace, Sheet | Cross Brace | Bracing method |
| Zone | String (dropdown) | 1, -1 | 1 | Wall face: front (1) or back (-1) |
| Stud Tie | String (dropdown) | No, Yes | No | Cross Brace only: add hsbStudTie connectors at stud/plate intersections |
| Manufacturer | String (dropdown) | From XML | (first available) | Bracing product manufacturer |
| Family | String (dropdown) | From XML | (first available) | Product family within manufacturer |
| Model | String (dropdown) | From XML | (first available) | Specific product with dimension constraints |

When Sheet type is selected, the Stud Tie option is hidden (read-only).

### Product Constraints (from XML Catalog)

**Cross Brace products define:**

| Constraint | Default | Description |
|------------|---------|-------------|
| WidthMin | 1800 mm | Minimum horizontal span between studs |
| WidthMax | 2700 mm | Maximum horizontal span between studs |
| AngleMin | 30 deg | Minimum diagonal angle to the horizontal plate |
| AngleMax | 60 deg | Maximum diagonal angle to the horizontal plate |
| Width | (per product) | Metal strap width |
| Thickness | (per product) | Metal strap thickness |

**Sheet products define:**

| Constraint | Default | Description |
|------------|---------|-------------|
| Width | 900 mm | Panel width (horizontal dimension) |
| Height | 400 mm | Panel height (vertical dimension) |
| Thickness | 400 mm | Panel thickness |

## Settings File

- **Filename**: `hsbBracing.xml`
- **Locations** (checked in order):
  1. `[CompanyPath]\TSL\Settings\hsbBracing.xml`
  2. `[InstallPath]\Content\General\TSL\Settings\hsbBracing.xml`
- **Persistence**: Settings are cached as a MapObject (`hsbTSL/hsbBracing`) in the drawing database. The script checks for version mismatches between the cached and file-based settings on new instance creation.

### XML Structure

The file contains two top-level sections -- `Bracing` for cross brace products and `Sheeting` for sheet products. Each follows the same hierarchy:

```
Bracing (or Sheeting)
  +-- Manufacturer[]
        +-- Manufacturer (Name)
              +-- Family[]
                    +-- Family (Name)
                          +-- Product[]
                                +-- Product (Name, Width, Thickness, WidthMin, WidthMax, AngleMin, AngleMax)
```

Cross brace products may also include a `Nail[]` sub-list with nail specifications (Diameter, Length).

## Behavior Details

### Cross Brace Mode

1. The script identifies the closest studs to each grip point
2. It finds the top and bottom plates at each stud location (using ray intersection)
3. Two diagonal straps are computed: bottom-left to top-right, and top-left to bottom-right
4. Each strap profile is clipped at the plate boundaries using Boolean profile subtraction
5. The result is displayed on the selected zone face of the wall
6. Two HardWrComp (hardware component) records are generated for the bill of materials, recording calculated strap lengths including plate depth extensions
7. When Stud Tie is enabled, four hsbStudTie instances are created at the four bracing endpoints (left-top, left-bottom, right-top, right-bottom)

### Sheet Mode

1. The script creates a 2D wall envelope profile on the selected zone face
2. Starting from the bottom of the first stud, sheets are laid out in a column-by-row grid pattern
3. Each sheet rectangle is intersected with the wall profile to determine coverage
4. Full sheets (entirely within the wall boundary) display in green
5. Partial sheets (trimmed by the wall boundary, e.g., at gable tops) display in yellow (color 40)
6. Sheet entities are created with the specified thickness and assigned to the wall's element group
7. The script instance erases itself after sheet creation -- sheets remain as independent entities

### Stud Tie Integration

When enabled for Cross Brace type:

- Four hsbStudTie instances are created and tracked via internal Map keys: `tslLeftTop`, `tslLeftBottom`, `tslRightTop`, `tslRightBottom`
- Changing the Zone property updates the zone on all associated stud ties
- Disabling Stud Tie removes all associated tie instances
- Dragging a grip point removes and recreates the ties on that side

## Visual Feedback

| Color | Meaning |
|-------|---------|
| Green (3) | Valid bracing or full sheet within constraints |
| Red (1) | Invalid configuration (angle or length outside limits) |
| Cyan (6) | Dimension annotations (angle arcs, length lines) |
| Yellow (40) | Partial sheets trimmed by wall boundary |
| Light green, transparent | Min/max valid range previews during grip editing |

## Tips

- Cross bracing angle constraints (typically 30-60 degrees) ensure effective lateral load transfer per manufacturer specifications
- The script automatically finds the closest valid stud at each grip point, so precise clicking is not required
- If no valid stud combination exists for the selected span, the script displays an error and does not create the bracing
- For Sheet type, sheets are created as real Sheet entities and the script removes itself. To modify sheets afterward, edit them directly.
- Verify that your `hsbBracing.xml` contains the correct product data for your project's bracing requirements

## Troubleshooting

| Symptom | Cause | Solution |
|---------|-------|----------|
| No bracing created | Wall bay dimensions outside product constraints | Select a product with wider min/max range, or choose studs closer together |
| "Bracing not possible" message | No valid angle/length combination found in that direction | Try selecting studs in the other direction, or use a different product model |
| Missing manufacturer options | Settings file not found | Verify `hsbBracing.xml` exists in the Settings folder |
| Version mismatch warning | Cached settings differ from file on disk | Acknowledge the notice; the drawing uses its cached version |
| Red display after grip drag | Current configuration exceeds product constraints | Drag grip point until display turns green |

## Version History

| Version | Date | Description |
|---------|------|-------------|
| 1.5 | 2023-05-10 | Standard display published for share and make |
| 1.4 | 2022-03-31 | Support side/zone changing during jig mode |
| 1.3 | 2022-03-31 | Support gable walls (diagonal top plates) |
| 1.2 | 2022-03-28 | Implement sheeting type |
| 1.1 | 2022-03-28 | Fix angle calculation in jig mode |
| 1.0 | 2022-03-07 | Initial version |

## Related Scripts

- **hsbStudTie**: Automatically created when Stud Tie is enabled. Connects studs to top/bottom plates at bracing endpoints.
- **hsbDebugController**: Optional. If the debug controller contains an entry for "hsbBracing", verbose debug output is enabled.

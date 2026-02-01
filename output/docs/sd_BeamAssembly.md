# sd_BeamAssembly

## Description

**sd_BeamAssembly** is a Shop Drawing TSL script that generates dimension requests for beam assembly views in hsbCAD. This script is designed to work with the shop drawing generation engine, creating automatic dimensioning for beams and their connected tools (such as metal parts and other TSL instances) across multiple standard views: Front, Left, and Top.

The script collects all entities connected to a beam (including metal part collections and TSL tools with volume), calculates extreme points for each view direction, and creates dimension request points that the shop drawing engine uses to generate proper dimensioning.

## Script Type

| Property | Value |
|----------|-------|
| Type | E (Element-based) |
| Beams Required | 1 |
| Grip Points | 0 |
| Environment | Paper Space / Shop Drawing |

## Properties

This script does not expose any user-configurable properties in the Properties Palette (OPM). All parameters are internally calculated based on the associated beam geometry and connected tools.

### Internal Variables

| Variable | Type | Description |
|----------|------|-------------|
| `bReportViews` | Boolean | Debug flag for view reporting (default: false) |
| `bReportOptions` | Boolean | Debug flag for options reporting (default: false) |
| `dEps` | Double | Tolerance value for volume checks (0.001 mm) |

## Usage Workflow

### Insertion

1. Run the script from the TSL menu or command line
2. Select a beam when prompted with "Select beam"
3. Click a point near the tool area when prompted with "Select point near tool"
4. The script attaches to the selected beam

### Automatic Execution

This script is primarily designed to be called automatically by the hsbCAD Shop Drawing Engine:

- When generating shop drawings, the engine passes the beam via the `_Entity` array
- The script then processes the beam and all its connected tools
- Dimension requests are generated for three standard views

### View Generation

The script automatically creates dimension requests for three orthogonal views based on the beam's local coordinate system:

| View | X-Axis | Y-Axis | Description |
|------|--------|--------|-------------|
| Front View | Beam X | -Beam Y | Primary elevation view |
| Left View | Beam Y | Beam Z | Side profile view |
| Top View | Beam Z | Beam X | Plan view from above |

### Dimension Request Processing

For each view, the script:

1. Collects all connected entities (metal parts, TSL tools with volume)
2. Calculates extreme vertices in X and Y directions of the view
3. Creates `DimRequestPoint` objects with:
   - Parent key grouping: "Dim sd_BeamAssembly"
   - Stereotype: "Extremes"
   - Cumulative text formatting
4. Adds dimension requests to the shop drawing engine collector

## Context Commands

This script does not define any context menu commands. It operates automatically when attached to a beam and is processed by the shop drawing generation system.

## Technical Notes

### Entity Detection

The script recognizes and includes the following entity types in dimension calculations:

- **MetalPartCollectionEnt**: Hardware and metal connector collections
- **TslInst**: TSL instances that have a real body with volume greater than the tolerance threshold

### Multipage Support

The script stores extreme point data (`ptMin`, `ptMax`) to a multipage map when a valid collector entity exists. This allows other shop drawing scripts to access the beam boundary information for coordinated layout.

### Dependencies

- Requires a valid beam entity (either from direct selection or via `_Entity` array from shop drawing engine)
- Works in conjunction with the hsbCAD Shop Drawing Engine
- May interact with other `sd_*` scripts for coordinated dimensioning

## Error Handling

If no valid beam is found:
- Displays message: "No beam found. Instance erased!"
- Automatically erases the script instance

## Related Scripts

- Other `sd_*` prefix scripts for shop drawing generation
- Shop drawing controller scripts that manage the generation process
- Dimension TSL scripts that process the generated `DimRequest` objects

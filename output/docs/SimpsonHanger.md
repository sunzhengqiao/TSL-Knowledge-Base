# SimpsonHanger

Automatically selects and places Simpson Strong-Tie joist hangers based on joist and carrying beam configurations.

## Overview

The SimpsonHanger script is a hardware insertion tool for placing Simpson Strong-Tie joist hangers in timber frame floor and roof assemblies. It automatically matches the appropriate hanger model to your joist dimensions and connection type (square, angled, or sloped), and provides options for web stiffeners when required.

**Script Type:** O-Type (Object)

**Version:** 4.12

**Prerequisite:** The `HangerList.mcr` script must be run in the drawing first to populate the available hanger catalog.

## Properties

The following properties appear in the AutoCAD Properties Palette when a SimpsonHanger instance is selected:

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Execution Mode | String (Dropdown) | Standard | Controls hanger selection method. **Standard** automatically selects hangers based on joist profile. **Manual** allows selection from all dimensionally compatible hangers. |
| Posnum | Double | -1 | Read-only position number assigned to the hanger instance. |
| General notes | String | (empty) | Free-form notes field for the connection. |
| Web Stiffener | String (Dropdown) | No | Enables web stiffener blocks for I-joists. Options: **No**, **Yes**. Automatically set in Standard mode based on hanger requirements. |
| Backer Block | String (Dropdown) | None | Adds blocking behind the carrying beam. Options: **None**, **Single**, **Double**. (Feature partially implemented) |
| Hanger Color | Integer | 6 | Display color for the hanger body (1-256). |
| Hanger Model | String (Dropdown) | (varies) | The selected Simpson hanger model number (e.g., HUCQ1.81/11-SDS, HUC310, IUS). List is filtered based on joist dimensions and connection type. |
| Joist End Gap | Double | 0 | Gap between joist end and carrying beam face. Automatically set to 3/16" for certain hanger types. |
| Face Nails | String | (from catalog) | Number and type of nails required on the header face flange. |
| Top Nails | String | (from catalog) | Number and type of nails required on top-mount tabs. |
| Joist Nails | String | (from catalog) | Number and type of nails required through joist sides. |
| Face Nails Min | String | (from catalog) | Minimum face nails for reduced capacity. |
| Top Nails Min | String | (from catalog) | Minimum top nails for reduced capacity. |
| Joist Nails Min | String | (from catalog) | Minimum joist nails for reduced capacity. |

## Supported Hanger Types

The script supports multiple Simpson hanger families:

- **IUS Series** - Top-flange I-joist hangers
- **HUCQ Series** - Heavy concealed-flange hangers (HUCQ1.81/11-SDS, HUCQ1.81/9-SDS, HUCQ410-SDS, HUCQ412-SDS)
- **HUC Series** - Standard concealed-flange hangers (HUC310, HUC310-2, HUC210-2, HUC28-2)
- **LSSU Series** - Skewed/sloped hangers for non-perpendicular connections

## Connection Types

The script automatically detects and handles three connection geometries:

| Connection Type | Detection | Behavior |
|-----------------|-----------|----------|
| **Square** | Joist perpendicular to header in plan | Standard hanger placement |
| **Angled** | Joist at angle to header in plan | Selects skew-compatible hangers |
| **Sloped** | Joist not horizontal (roof rafters) | Selects slope-adjustable hangers like LSSU |

## Usage Workflow

### Initial Setup

1. Run the `HangerList.mcr` script in your drawing to load the Simpson hanger catalog. This only needs to be done once per drawing session.

### Inserting Hangers

1. **Start the script** by running `SimpsonHanger.mcr`

2. **Select joists** when prompted: "Select Joists, all must be parallel"
   - Select one or more parallel joists
   - The script automatically detects doubled, tripled, or quad joists based on spacing

3. **Select carrying beams** when prompted: "Select Carrying Beams"
   - Select the header or beam(s) that support the joists

4. **Automatic placement**: The script creates a hanger instance at each joist-to-header connection where a T-connection exists

### After Insertion

1. **Select any hanger** to view and modify its properties in the Properties Palette

2. **Change the hanger model** using the Hanger Model dropdown if an alternative is preferred

3. **Enable web stiffeners** if required for I-joist installations

4. **Review nailing requirements** displayed in the properties

## Context Menu Commands

Right-click on a SimpsonHanger instance to access:

| Command | Description |
|---------|-------------|
| Update Hanger List | Refreshes the hanger catalog by re-running HangerList.mcr. Use this after modifying hanger definitions or if the catalog appears incomplete. |

## Execution Modes

### Standard Mode

- Automatically filters hangers based on the joist extrusion profile name
- Matches profiles like "TJI", "BCI" to manufacturer-specific hanger listings
- Automatically sets Web Stiffener requirement based on catalog data
- Best for production workflows with consistent joist specifications

### Manual Mode

- Activated automatically when:
  - No profile-specific hangers are found
  - Multiple joist types are detected in a selection
  - Width tolerance is exceeded
- Shows all hangers that dimensionally fit the joist (width and height)
- Hanger displays in color 12 (gray) instead of the specified color to indicate manual selection

## I-Joist Support

For engineered I-joists (TJI, BCI profiles):

- Script automatically detects I-joist profiles by name
- Web stiffener dimensions are calculated based on joist depth
- Stiffener thickness varies by joist series (0.5" to 1.5")
- Stiffeners are created as separate beam entities grouped with the joist

## Multiple Joist Configurations

The script handles multi-ply joists automatically:

| Configuration | Behavior |
|---------------|----------|
| Single joist | Standard single-width hanger |
| Double joist | Selects double-width hanger, calculates combined width |
| Triple joist | Selects triple-width hanger |
| Quad joist | Selects quad-width hanger |

Joists are considered "sistered" when spaced less than 1/4" apart.

## Output Data

The script stores the following data for downstream processes (labeling, BOM):

- `stPartNumber` / `stModel` - Hanger model number
- `ptCenter` - Connection centerpoint
- `stNotes` - User notes
- Nailing specifications (Face, Top, Joist - both standard and minimum)
- `stWeb` - Web stiffener status

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| "Failed to retrieve hanger data" | HangerList.mcr not run | Run HangerList.mcr first |
| Hanger self-erases | Not enough beams selected | Ensure at least 2 beams (joist + header) are associated |
| "No Hardware Available" | No matching hanger in catalog | Use Manual mode or check joist dimensions |
| "Width tolerance exceeded" | Joists too far apart to be treated as multi-ply | Treat as separate single hangers |
| Switches to Manual Mode | Mixed joist profiles detected | Verify all selected joists are the same type |

## Technical Notes

- Units: Script operates in inches internally
- Width tolerance for multi-ply detection: 1/64" (0.015625")
- The script cuts the joist end to the header face, accounting for the specified end gap
- Hanger geometry is generated parametrically based on type codes (TT=top tabs, TF=top flange, F=face mount, S=skew)
- Web stiffeners are created as independent Beam entities linked via the script's Map

## Related Scripts

- `HangerList.mcr` - Prerequisite script that loads the hanger catalog
- `hsb_ElementBOM` - Bill of materials integration

## Version History

- V4.12 (September 2018) - Revised BOM data, added BCI header tolerance
- V4.10 (September 2018) - Integration with hsb_ElementBOM
- V4.0 (April 2013) - Customized for RMLH
- V0.0 (July 2007) - Initial release

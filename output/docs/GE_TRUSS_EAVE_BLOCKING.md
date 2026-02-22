# GE_TRUSS_EAVE_BLOCKING - Truss Eave Blocking Generator

## Overview

The GE_TRUSS_EAVE_BLOCKING script automatically generates eave blocking members between trusses or rafters along a wall element. Blocking is placed at the top plate level of a wall where roof trusses or rafters bear, providing structural support and fire stopping at the eave line.

The script analyzes the spacing between selected trusses/rafters, sorts them along the wall direction, and creates correctly sized blocking members with material and grade properties drawn from the hsbCAD lumber inventory.

This is a "run once" tool: after generating blocking beams, the script instance erases itself from the model. The produced blocking members persist as standard hsbCAD beams of type Panel Eave Perimeter.

## Usage Environment

| Property | Value |
|----------|-------|
| Script Type | O (Object) |
| Environment | Model Space |
| Required Beams | 0 (selected during insertion) |
| Paper Space | Not applicable |
| Shop Drawing | Not applicable |
| Version | 1.3 |
| Author | David Rueda (dr@hsb-cad.com) |

## Prerequisites

1. **Wall Element** -- An existing ElementWall must be present in the model where blocking will be placed.
2. **Trusses or Rafters** -- At least two truss entities or rafter beams must exist and be positioned over the wall.
3. **Lumber Inventory** -- The hsbCAD lumber inventory must contain at least one lumber item with valid Name, WIDTH, HEIGHT, HSB_MATERIAL, and HSB_GRADE fields.
4. **Required DLL** -- `hsbFramingDefaults.Inventory.dll` must be available at `{Installation Path}\Utilities\hsbFramingDefaultsEditor\`.

## Step-by-Step Usage Guide

### Step 1: Launch the Script

1. Run the `TSLINSERT` command or open the TSL script browser.
2. Select `GE_TRUSS_EAVE_BLOCKING.mcr`.
3. The script loads the lumber inventory from the framing defaults DLL and prepares for entity selection.

### Step 2: Select Beams and/or Trusses

1. The command line displays: **"Select beams and/or trusses"**.
2. Select truss entities (TrussEntity) and/or rafter beams that span over the target wall.
3. Both individual beams (type Rafter, or beams with X-axis parallel to World Z) and complete TrussEntity objects are accepted in the same selection set.
4. Press Enter to confirm. At least two items are required; otherwise the script cancels.

### Step 3: Select Wall Element

1. The command line displays: **"Select wall"**.
2. Click on the ElementWall where blocking should be placed.
3. If no wall is selected, the script cancels.

### Step 4: Configure Properties

On first insertion (when no catalog key exists), a properties dialog is displayed automatically. You can also modify settings at any time through the AutoCAD Properties Panel before the script finalizes:

- **Lumber item** -- Choose the blocking lumber profile from a dropdown populated by the inventory.
- **Blocking color** -- Set the AutoCAD color index for generated blocking members.
- **Minimum block length** -- Set the threshold below which blocking pieces are not created.

### Step 5: Blocking Generation

The script performs the following automatically:

1. Retrieves material, grade, width, and height from the selected lumber item.
2. Validates that all four values are present and non-zero. If any are missing, an error message is displayed and the script cancels.
3. Extracts the wall coordinate system (origin, X/Y/Z vectors), length, height, and width.
4. Collects 3D bodies from each selected truss entity (by combining all member real bodies transformed to model space) and from each rafter beam (using envelope bodies).
5. Sorts all collected bodies along the wall X-axis direction.
6. Filters bodies to keep only those whose center point falls within the wall extent, plus the nearest bodies outside each end if they are close enough to form blocking of minimum length.
7. For each adjacent pair of bodies on the wall, calculates the start and end points using the extreme vertices of each body and creates a blocking beam spanning the gap.
8. Each blocking beam is created with the selected lumber dimensions, material, grade, color, label "Blocking", and beam type Panel Eave Perimeter.
9. Blocking gaps shorter than the minimum block length are skipped.
10. The script instance erases itself after all blocking is created.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Lumber item | Dropdown (PropString) | First inventory item | Lumber profile for blocking. Options come from the hsbCAD lumber inventory and include dimensions, material, and grade. |
| Blocking color | Integer (PropInt) | 32 | AutoCAD color index (ACI) for the blocking members. Valid range: -1 (ByLayer) to 255. Out-of-range values are reset to -1. |
| Minimum block length | Length (PropDouble) | 75 mm / 3 in | Blocking pieces shorter than this threshold are not created. Prevents impractically small filler pieces. |

## Settings and External Dependencies

This script does not use standalone XML settings files. Instead it relies on the hsbCAD lumber inventory system:

| Item | Value |
|------|-------|
| DLL Path | `{Install}\Utilities\hsbFramingDefaultsEditor\hsbFramingDefaults.Inventory.dll` |
| Namespace.Class | `hsbSoft.FramingDefaults.Inventory.Interfaces.InventoryAccessInTSL` |
| Method | `GetLumberItems` |
| Input Parameters | CompanyPath, StickFramePath, SystemUnits (0=mm, 3=inch), InstallationPath |

Each lumber item in the inventory must provide these properties: NAME, WIDTH, HEIGHT, HSB_MATERIAL, HSB_GRADE.

To add or modify lumber options, open the hsbCAD Framing Defaults Editor and navigate to the Inventory section.

## Vertical and Depth Positioning

- **Vertical**: Blocking center is placed at wall base height plus half the blocking member height (top of the wall top plate).
- **Depth**: The script determines whether the trusses are on the inner or outer face of the wall by comparing the truss center to the wall origin along the wall Z-axis. Blocking is then aligned to the corresponding face offset by half its width.

## Tips and Best Practices

1. **Select all trusses along the wall** to ensure complete blocking coverage. The script sorts them automatically.
2. **Verify inventory data** before running. The error "Data incomplete" means the selected lumber item is missing one or more required fields (Material, Grade, Width, Height).
3. **Adjust minimum block length** to avoid creating very short pieces that are difficult to install.
4. **Mixed selection** is supported: you can include both individual rafter beams and complete truss entities in one selection set.
5. **Re-run to modify**: since blocking members become independent beams after creation, delete them and re-run the script to change parameters.
6. **Color coding**: use distinct ACI values for blocking to visually distinguish them in complex framing models.
7. **One wall per run**: only the first selected wall is used. Run the script separately for each wall that needs eave blocking.

## Frequently Asked Questions

**Q: No blocking is created. Why?**
A: Verify that (a) at least two trusses/rafters were selected, (b) a wall element was selected, (c) the truss/rafter center points fall within the wall extent along its X-axis, and (d) the spacing between adjacent trusses exceeds the minimum block length.

**Q: I receive a "Data incomplete" error.**
A: The chosen lumber item is missing required inventory properties. The error message lists the current values for Material, Grade, Width, and Height. Open the Framing Defaults Editor and ensure all fields have valid non-zero entries.

**Q: Can I edit the blocking after creation?**
A: Yes. Generated blocking members are standard hsbCAD beams (type Panel Eave Perimeter, label "Blocking"). Edit them with any standard beam tool. To regenerate, delete the existing blocking and re-run the script.

**Q: Where is the blocking placed vertically?**
A: At the top of the wall -- the beam center sits at wall base height plus half the blocking height.

**Q: Does the script support both metric and imperial units?**
A: Yes. The script detects your system units automatically and passes the correct unit code (mm or inch) to the inventory DLL. The default minimum block length adapts accordingly (75 mm or 3 inches).

**Q: What happens to the script instance after it runs?**
A: It erases itself. The blocking beams remain as independent entities in the model.

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.3 | 2013-11-03 | David Rueda | Added StickFrame path to map input when calling DLL |
| 1.2 | 2012-07-28 | David Rueda | Added description; fixed bug where not all trusses were included (replaced body `+` operator with `Body.combine()`) |
| 1.1 | 2012-04-11 | David Rueda | Added thumbnail |
| 1.0 | 2012-03-23 | David Rueda | Initial release |

---

*Script: GE_TRUSS_EAVE_BLOCKING.mcr | Version 1.3 | Last Updated: November 2013 | Author: David Rueda (dr@hsb-cad.com)*

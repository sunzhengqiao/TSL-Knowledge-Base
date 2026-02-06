# TieDown.mcr

## Overview
Inserts a structural tie-down screw (hardware connector) to anchor roof trusses to wall top plates for wind uplift resistance. It supports batch processing by automatically placing screws at intersections between Wall and Truss elements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D intersection calculations. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | Not applicable. |

## Prerequisites
- **Required Entities:** Wall elements (`ElementWallSF`) and Truss elements (`TrussEntity`). Alternatively, individual Wall and Truss beams can be selected.
- **Minimum Beam Count:** 2 (One Wall Top Plate beam and one Truss Bottom Chord beam).
- **Required Settings:** `ScrewCatalog.xml` must exist in the Company or Install settings path.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `TieDown.mcr`.

### Step 2: Select Manufacturer
A dialog appears listing available manufacturers from the Screw Catalog.
```
Action: Click on a Manufacturer (e.g., Simpson, Mitek) and click OK.
Note: If only one manufacturer exists in the catalog, this step may be skipped automatically.
```

### Step 3: Select Product Family
A dialog appears listing product families (e.g., "StudLok") for the chosen manufacturer.
```
Action: Click on a Family and click OK.
```

### Step 4: Select Elements
The command line prompts for entity selection.
```
Command Line: Select wall(s) and truss(es)
Action: Click the Wall element and then the Truss element, or select both using a window selection. Press Enter to confirm.
```
*Note: If Elements are not detected, the script will fall back to prompting you to select individual beams ("Select Truss beam", then "Select Wall beam").*

### Step 5: Adjust Parameters (Optional)
After insertion, select the generated screw instance.
```
Action: Open the Properties Palette (Ctrl+1). Change the "Length" or "Is Angled" properties as needed.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Painter | dropdown | \<Disabled\> | Applies a specific visual style or filter based on project Painter definitions. |
| Is Angled | dropdown | No | Sets the installation orientation. Select "Yes" for an angled screw or "No" for perpendicular installation. |
| Manufacturer | dropdown | (From Catalog) | The brand of the hardware (e.g., Simpson). Changing this resets the Family and Length. |
| Family | dropdown | (From Catalog) | The specific product model (e.g., StudLok). Changing this resets the Length. |
| Length | number | 0 | The length of the screw in millimeters. Select from valid catalog entries. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Standard Options | Standard hsbCAD context options apply (Erase, Copy, Properties, etc.). No custom script-specific menu items are defined. |

## Settings Files
- **Filename**: `ScrewCatalog.xml`
- **Location**: `_kPathHsbCompany\TSL\Settings` or `_kPathHsbInstall\Content\General\TSL\Settings`
- **Purpose**: Defines the database of Manufacturers, Product Families, available Lengths, and geometric dimensions (diameters, head sizes) required to generate the 3D screw body.

## Tips
- **Batch Processing:** To insert multiple screws at once, select the entire Wall element and the entire Truss element during the selection prompt. The script will calculate valid intersections and create an instance for each location.
- **Validation:** The script automatically checks if the Truss is perpendicular to the Wall. If the geometry is invalid (e.g., parallel or no intersection), no screw will be created at that location.
- **Quick Command:** You can preset parameters via the command line using tokens, e.g., `TieDown.mcr?ManufacturerName?FamilyName`.
- **Visuals:** The script generates a 3D cylinder body representing the screw. Use this to check for clashes with other connectors or studs in the wall.

## FAQ
- **Q: The script deletes itself immediately after I select the elements. Why?**
  - A: This usually happens in "Batch Mode". When you select Elements, the main script acts as a "manager"—it spawns individual screw scripts at the valid intersections and then erases itself. Check the intersections; the screws should be there.
- **Q: I get an error "Could not find manufacturer data."**
  - A: The `ScrewCatalog.xml` file is missing from your settings folders, or it is empty. Contact your hsbCAD administrator.
- **Q: Can I use this on non-standard roofs?**
  - A: The script requires the Truss and Wall to be roughly perpendicular and their Z-axes (Top of Wall / Bottom of Truss) to align reasonably well. Complex geometries may require manual beam selection or individual placement.
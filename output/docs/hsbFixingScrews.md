# hsbFixingScrews.mcr

## Overview
Automates the insertion of structural fixing screws or nails into timber elements (GenBeams) based on a configurable manufacturer catalog. It calculates positions for distribution, inclination, and offset, creating both the physical drill holes and the hardware BOM entries.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D beam geometry. |
| Paper Space | No | Not intended for shop drawings or layouts. |
| Shop Drawing | No | Geometry manipulation happens in the model. |

## Prerequisites
- **Required Entities**: At least one `GenBeam` (Timber Beam) or Wall element.
- **Minimum Beam Count**: 1 (supports secondary beams for through-drilling).
- **Required Settings**: `ScrewCatalog.xml` must be present in the Company or Install 'Settings' folder.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbFixingScrews.mcr`

### Step 2: Select Element
```
Command Line: Select Beam:
Action: Click on the timber beam or wall element where you want to apply the screws.
```

### Step 3: Configure Properties
```
Action: Press Ctrl+1 to open the Properties Palette if not already visible.
Action: Select the Manufacturer, Family, and Product from the dropdown menus.
Action: Adjust Alignment, Angle, and Distribution settings as required.
```
*Note: The script will automatically update the geometry and BOM as you change properties.*

## Properties Panel Parameters

### Component Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Manufacturer | dropdown | --- | Select the screw brand (e.g., SFS, Rothoblaas). Populated from catalog. |
| Family | dropdown | --- | Select the product series (e.g., Self-tapping screw). Filters based on Manufacturer. |
| Product | dropdown | --- | Select specific size/model (e.g., 8x200mm). Determines geometry and Article Number. |

### Alignment Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Alignment | dropdown | +X | Defines which face of the beam the screws are placed on (+X, -X, +Y, -Y, +Z, -Z). |
| Angle | number | 30 | Inclination angle of the screw in degrees (0 is parallel to the beam axis). |
| Offset from Plate | number | 13 | Distance from the beam face to the screw head. Use to account for steel plate thickness (mm). |

### Distribution Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Mode of Distribution | dropdown | Even | `Even`: Divides space by max distance. `Fixed`: Uses exact spacing. |
| Start Distance | number | 0 | Setback distance from the start of the beam to the first screw (mm). |
| End Distance | number | 0 | Setback distance from the end of the beam to the last screw (mm). |
| Distance Between | number | 500 | In 'Even' mode: Max spacing. In 'Fixed' mode: Exact spacing. Negative value = Exact count of screws. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| generate Single Instances | Replaces the single parametric script with multiple independent scripts, one for each screw position. This allows for individual manipulation of screws later. |

## Settings Files
- **Filename**: `ScrewCatalog.xml`
- **Location**: Company or Install 'Settings' folder
- **Purpose**: Provides the hierarchical data (Manufacturer > Family > Product), including screw dimensions (diameter/length) and Article Numbers used for the BOM.

## Tips
- **Specifying Screw Count**: To place exactly 10 screws evenly, set "Mode of Distribution" to `Fixed` and "Distance Between" to `-10`.
- **Steel Plate Connections**: Use the "Offset from Plate" property to shift the screw head away from the timber face, simulating the thickness of a connecting steel plate.
- **Angle Calculation**: The "Angle" property rotates the screw around the distribution axis. For diagonal bracing, ensure the Alignment face corresponds to the direction of the force.
- **Visualization**: If screws are not visible, check your 3D display settings or verify that the Product selection in the catalog has valid geometry data.

## FAQ
- **Q: Why did the script disappear immediately after insertion?**
  A: The script could not find `ScrewCatalog.xml` or the file is empty/corrupted. Check your hsbCAD Settings folder and ensure the XML file exists and contains valid Manufacturer data.
  
- **Q: What does "distribution outside the genbeam" mean?**
  A: The calculated screw positions fall beyond the physical length of the beam. Increase the "Start Distance" and "End Distance", or decrease the "Distance Between" value.
  
- **Q: Can I use this for through-drilling two beams?**
  A: Yes. If you select a secondary beam (or the script detects a connected beam) and the screw length is sufficient, it will generate drill holes in both beams.
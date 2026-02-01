# HSB_G-DxfOutput.mcr

## Overview
This script exports the geometry of selected timber beams, sheets, or elements to individual DXF files for manufacturing or further detailing. It supports both 2D profiles (suitable for CNC machines) and 3D bodies, with customizable filtering and file naming options.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model entities. |
| Paper Space | No | Not intended for layout views. |
| Shop Drawing | No | This is a model export utility. |

## Prerequisites
- **Required Entities:** Elements, GenBeams, or Sheets must exist in the model.
- **Minimum Beam Count:** 0 (You can select elements containing multiple beams).
- **Required Settings Files:**
  - `HSB_G-ContentFormat` (Recommended: for dynamic file naming).
  - `HSB_G-FilterGenBeams` (Recommended: for saving and reusing filter sets).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse and select `HSB_G-DxfOutput.mcr`

### Step 2: Configure Properties (Optional)
Upon insertion, a properties dialog may appear if no default catalog entry is found.
- **Action:** Adjust settings such as output folder, DXF version, or filtering criteria if necessary. Click **OK** to proceed.

### Step 3: Select Entities
You will be prompted on the command line to select the objects to export.
```
Command Line: Select a set of elements or <ENTER> to select genbeams.
Action: Click on Elements (walls/floors) OR press ENTER to select individual beams.
```
*If you pressed ENTER:*
```
Command Line: Select genbeams
Action: Click individual beams or sheets. Press ENTER to finish selection.
```

### Step 4: Execute Export
1. The script instance is now inserted into your model.
2. Select the script instance (the TSL icon).
3. **Right-click** to open the context menu.
4. Select **Write to dxf**.
5. The script will process the selection, generate the files, and then erase itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Selection** | | | |
| Filter definition beams | dropdown | | Select a pre-defined filter set from the catalog. |
| Filter type | dropdown | \|Include\| | Determines if the filter criteria includes or excludes matching items. |
| Filter beams with beamcode | text | | Filter by BeamCode (e.g., ST, PL). |
| Filter beams and sheets with name | text | | Filter by the entity name. |
| Filter beams and sheets with label | text | | Filter by the entity label. |
| Filter beams and sheets with material | text | | Filter by material grade (e.g., C24). |
| Filter beams and sheets with hsbID | text | | Filter by the internal hsbCAD ID. |
| Filter zones | text | | Filter by building zone. |
| Max amount of points to analyse | number | 6 | Limits the complexity of exported holes. Increase this if round tools are missing. |
| **Output** | | | |
| Dxf version | dropdown | Current | Sets the DXF file format version (2000, 2004, 2007, 2010). |
| Section from | dropdown | \|Entity X\| | Sets the projection direction (Entity/Element/World X/Y/Z). |
| Export body | dropdown | \|No\| | If "No", exports 2D polylines. If "Yes", exports 3D solids. |
| File name | text | @(Position number) | Name for the output file. Use `@(...)` for dynamic tags. |
| File in Dwg path | dropdown | \|Yes\| | Saves files in the current DWG folder if "Yes". |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Write to dxf | Generates the DXF files based on the current properties and selection. The script instance deletes itself after successful export. |

## Settings Files
- **Filename**: `HSB_G-ContentFormat`
- **Location**: Catalog (Company or Install)
- **Purpose**: Defines how to automatically generate file names using entity data (e.g., `@(Material)`, `@(Length)`).

- **Filename**: `HSB_G-FilterGenBeams`
- **Location**: Catalog (Company or Install)
- **Purpose**: Stores complex filtering rules that can be selected in the "Filter definition beams" property.

## Tips
- **Missing Holes in Output:** If circular drill holes or complex shapes are not appearing in the DXF, increase the **Max amount of points to analyse** property (e.g., set to 20 or 50).
- **Batch Export:** Selecting an **Element** (like a wall) allows you to use filters to export only specific beams inside it (e.g., only studs). Selecting **GenBeams** directly exports exactly what you clicked, ignoring filters.
- **File Naming:** Use the `HSB_G-ContentFormat` macro to create detailed file names like `Project-Wall1-C24.dxf` automatically without typing it manually.

## FAQ
- **Q: Why did I get an error about "Beams could not be filtered"?**
  A: You selected a "Filter definition beams" entry, but the required helper script `HSB_G-FilterGenBeams` is not loaded in your drawing. Load it via the TSL Catalog browser or clear the filter property.

- **Q: Can I export 3D solids for 5-axis machining?**
  A: Yes. Set the **Export body** property to `\|Yes\|` and ensure the **Section from** alignment is correct for your machine's coordinate system.

- **Q: Where are my DXF files saved?**
  A: By default, they are saved in the same folder as your current DWG file. To change this, set **File in Dwg path** to `\|No\|` and manually specify a path in the File name property (or check if your IT administrator has set a default output path).
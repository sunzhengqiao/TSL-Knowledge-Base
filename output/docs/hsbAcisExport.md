# hsbAcisExport.mcr

## Overview
This script exports selected 3D solid entities (beams, sheets, or custom TSL geometry) to external SAT or STL files. It is designed for data interchange with other CAD software or for preparing models for 3D printing, supporting both visual (BREP) and calculated solid (CSG) export modes.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script runs in the 3D model to export solid geometry. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities:** GenBeams, Elements, or TSL instances with solid geometry (e.g., `klhDisplay`).
- **Minimum Beam Count:** 0 (You can export single solids or groups).
- **Required Settings:** None strictly required, though the script interacts specifically with `klhDisplay` or `klhCoating` TSLs if present to ensure grain/coating details are exported.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbAcisExport.mcr` from the list.

### Step 2: Configure Properties
**Action:** The Properties Palette (OPM) will appear. Configure the following before proceeding:
- **File Name:** Enter the desired name (e.g., `ProjectExport`). You can use format expressions like `@(Name:D"")` to name files based on entity properties.
- **Mode:** Choose **BREP** for quick visual export or **CSG** for precise geometric reconstruction including tooling.
- **Format:** Choose **SAT** for CAD interchange or **STL** for 3D printing.

### Step 3: Select Entities
```
Command Line: Select entities
Action: Click on the beams, sheets, or solids in the model you wish to export. Press Enter when selection is complete.
```

### Step 4: Execution
The script will process the geometry, generate the file in the current drawing's directory, and automatically delete the script instance from the model.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| File Name | Text | dwgName() | Defines the output file name. Supports dynamic tokens (e.g., `@(Name:D"")`) to create individual files per selected entity. Invalid characters are replaced automatically. |
| Mode | Dropdown | BREP | **BREP:** Exports the boundary representation (visible surface).<br>**CSG:** Exports Constructive Solid Geometry (reconstructs the body including all tools/machinings). |
| Format | Dropdown | SAT | **SAT:** ACIS Solid file (precise NURBS geometry).<br>**STL:** Standard Tesselation Language (triangulated mesh for 3D printing). |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| Standard Recalculate | Recalculates the script logic if parameters are changed manually. |

## Settings Files
- No specific external settings files are required. The script uses standard hsbCAD catalogs and defaults.

## Tips
- **Batch Exporting:** Use the `@(Name:D"")` syntax in the **File Name** field. This ensures that if you select 10 different beams, the script creates 10 separate files named after each beam, rather than overwriting a single file.
- **CSG Mode:** Use CSG mode if the visual representation in hsbCAD shows simplifications, but you need the full machining detail in the export (e.g., for CNC verification).
- **KLH Elements:** If you are using `klhDisplay` or `klhCoating` scripts, this tool automatically detects them and forces the generation of grain/coating solids for the export, ensuring they appear in the SAT/STL file.

## FAQ
- **Q: Where is the exported file saved?**
  - **A:** The file is saved in the same folder as your current CAD drawing (DWG).
- **Q: Why did the script disappear after I ran it?**
  - **A:** This is a utility script designed to perform a task (export) and then clean up after itself. It does not remain as a persistent object in the drawing.
- **Q: What is the difference between SAT and STL?**
  - **A:** SAT is a vector-based format used for CAD editing (preserves curves and precise faces). STL is a mesh format made of triangles, used primarily for 3D printing and visualization.
- **Q: Can I export only specific tools or subtractions?**
  - **A:** The script exports the final composite body of the selected elements. Use CSG mode to ensure all tools are mathematically included in that body.
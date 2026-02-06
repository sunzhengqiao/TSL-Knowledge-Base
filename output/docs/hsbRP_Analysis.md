# hsbRP_Analysis.mcr

## Overview
Analyzes ERoofPlane entities to calculate roof geometry, including rooflines (hips, valleys, ridges), eave areas, and main roof surfaces. It generates a detailed graphical report table with quantities and previews, while also creating 3D visualization geometry.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary working environment. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | This is a model analysis tool. |

## Prerequisites
- **Required entities**: `ERoofPlane` (Roofplanes) must exist in the model.
- **Minimum beam count**: 0.
- **Required settings**: Valid `_DimStyles` and `_HatchPatterns` must be loaded in the drawing.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbRP_Analysis.mcr`

### Step 2: Configuration
A dialog will appear allowing you to configure units, decimals, colors, and grouping for the analysis. Adjust these settings to match your project standards and click OK.

### Step 3: Select Roof Geometry
```
Command Line: Select roofplanes and (optional) hsbRPxx-Tsl's to delete
Action: Click on the Roofplane entities you wish to analyze. You may also select existing hsbRP analysis instances to delete and replace them. Press Enter to confirm.
```

### Step 4: View Results
The script will generate 3D geometry for rooflines and areas, place a report table at the origin (0,0,0), and group the elements in the BOM according to your settings.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Group analysis BOM** | Text | | Organizes the report table in the BOM/Project browser. Use `\` to separate levels (e.g., `Reporting\Roof`). |
| **Unit** | Dropdown | | Sets the measurement unit for the report (mm, cm, m, inch, feet). |
| **Decimals** | Dropdown | 0 | Precision for linear dimensions (lengths). |
| **Decimals Area** | Dropdown | 0 | Precision for surface areas. |
| **Color of table** | Number | 143 | AutoCAD color index for the report table lines and text. |
| **Dimstyle** | Dropdown | | Dimension style used for the main graphical previews. |
| **Dimstyle Shopdrawing** | Dropdown | | Dimension style used for detail views in the table. |
| **Group Roofline** | Text | | Group path for the generated 3D roofline entities. |
| **Color** (Roofline) | Number | 9 | Color for 3D roofline geometry. |
| **Group Eave Area** | Text | | Group path for the generated 3D eave area entities. |
| **Color** (Eave) | Number | 93 | Color for 3D eave area geometry. |
| **Material** | Text | | Material name assigned to the generated elements. |
| **Hatch pattern** (Eave) | Dropdown | None | Hatch pattern for eave areas in the table and 3D model. |
| **Hatch scale** (Eave) | Number | 30 | Scale factor for the eave hatch pattern. |
| **Group Roof area** | Text | | Group path for the generated 3D main roof surface entities. |
| **Color** (Roof) | Number | 7 | Color for 3D roof surface geometry. |
| **Hatch pattern** (Roof) | Dropdown | None | Hatch pattern for main roof areas. |
| **Hatch scale** (Roof) | Number | 30 | Scale factor for the roof hatch pattern. |

## Right-Click Menu Options
*Standard context menu options apply. This script does not add specific custom right-click commands; updates are handled via properties or geometry dependencies.*

## Settings Files
- **Filename**: `_DimStyles`, `_HatchPatterns`
- **Location**: Defined in your hsbCAD configuration (Company or Install path).
- **Purpose**: Provides the visual styles and patterns required for the report table and hatched surfaces.

## Tips
- **Organization**: Use the Group properties (e.g., `5. Reporting\Roof`) to keep the generated analysis separate from your structural elements in the Project Browser.
- **Updating Analysis**: If you modify the slope or shape of your Roofplanes using grips, the script will automatically detect the change and update the report and geometry.
- **Cleanup**: You can select previous analysis instances (hsbRPxx-Tsl's) during the selection prompt to automatically remove them before generating the new analysis.

## FAQ
- **Q: Where does the report table appear?**
  A: The report table is generated at the absolute model coordinate origin (0,0,0). You may need to zoom extents or pan to find it.
- **Q: How do I change the units after insertion?**
  A: Select the script instance in the model, open the Properties Palette (Ctrl+1), and change the "Unit" property. The table will update automatically.
- **Q: Why are my hatches not displaying?**
  A: Ensure the "Hatch pattern" is set to something other than "None" and that the pattern is actually loaded in your current drawing.
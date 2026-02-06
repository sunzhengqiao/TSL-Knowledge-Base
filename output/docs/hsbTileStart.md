# hsbTileStart.mcr

## Overview
This script initiates the roof tiling (roofscaping) workflow. It attaches tile data to roof planes, manages tile catalogs for grids and ridges, and triggers the generation of ridge, hip, and verge details or material exports.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Requires 3D Roof Planes (ERoofPlane). |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: ERoofPlane (Roof Planes) must exist in the model.
- **Minimum Beam Count**: N/A
- **Required Settings**: `groups.xml` must exist in the Company Export catalogue (`_kPathHsbCompany\Export\catalogue\`) or the General content folder (`_kPathHsbInstall\Content\General\`).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbTileStart.mcr`

### Step 2: Choose Operation Mode
```
Command Line: Type <D> for dialog, <E> for export, <Enter> attach roof data
Action: Press Enter to proceed with standard tiling, type 'D' to open settings first, or type 'E' to generate a report only.
```

### Step 3: Select Roof Planes
```
Command Line: Select roofplane(s)
Action: Click on the Roof Planes you wish to apply tiling to and press Enter.
```
*Note: The script will automatically clean up previous tiling data on the selected planes and restart internally to apply the new data.*

### Step 4: Configure Tile Settings (Optional)
Once the script attaches to the roof, select the script instance and open the **Properties Palette**.
- Select the appropriate **TileGrid Catalog** for the main roof field.
- Adjust other settings like Ridge or Verge creation if needed.

### Step 5: Finalize Generation
```
Action: Double-click the text "Adjust vertical tiling and double click" displayed near the roof.
```
*This calculates quantities and creates the Ridge, Hip, and Verge elements if the properties are enabled.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Create verge tiles | dropdown | No | Determines if verge (gable end) tiles are created. Set to "After adjusting tile grid" to generate them on double-click. |
| Create ridge tiles | dropdown | No | Determines if ridge and hip tiles are created. Set to "After adjusting tile grid" to generate them on double-click. |
| Use TileGrid catalog | dropdown | | Selects the catalog defining dimensions and layout rules for the main roof field tiles. |
| Use TileHipRidge catalog | dropdown | | Selects the catalog defining geometry and properties for ridge, hip, and valley tiles. |
| Exporter Group | dropdown | | Specifies the configuration group (from groups.xml) for exporting tile data to reports (e.g., Excel). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| TslDoubleClick | Triggered by double-clicking the text "Adjust vertical tiling and double click". This finalizes the tile layout, creates ridge/verge details (if enabled), and calculates hardware quantities. |

## Settings Files
- **Filename**: `groups.xml`
- **Location**: `_kPathHsbCompany\Export\catalogue\` or `_kPathHsbInstall\Content\General\hsbCompany\Export\catalogue\`
- **Purpose**: Provides the list of available Exporter Groups used in the Properties Panel for generating material lists.

## Tips
- **Export Mode**: If you only need a material list and do not want to generate 3D tile geometry, type `E` at the initial command prompt.
- **Cleanup**: When you select new roof planes, the script automatically removes old tile data from them, ensuring a fresh start.
- **Workflow**: Ensure you select your catalogs in the Properties palette *before* double-clicking the text to finalize the geometry.

## FAQ
- **Q: Why did my script instance disappear after double-clicking?**
  - A: This is normal behavior. Once the script generates the final Tile Grid and details, the `hsbTileStart` instance erases itself, leaving the generated tile elements behind.
- **Q: What happens if I see an error about "Exporter Group"?**
  - A: The script cannot find `groups.xml`. Please check with your CAD Manager to ensure the Export catalogue is correctly configured in your hsbCAD environment.
- **Q: Can I generate the roof tiling without the ridge and verge tiles?**
  - A: Yes. Set the "Create ridge tiles" and "Create verge tiles" properties to "No" in the Properties palette before double-clicking to finalize.
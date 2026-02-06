# hsbElementInsulation.mcr

## Overview
Automatically calculates and generates insulation materials (such as batts, wool, or rigid boards) within wall or roof elements. It fills voids defined by structural zones, allowing for both physical 3D representation and material take-off (BOM) data generation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script interacts with hsbCAD Elements (Walls/Roofs) and creates GenBeams. |
| Paper Space | No | This script operates on 3D model entities only. |
| Shop Drawing | No | Not intended for 2D drawing generation. |

## Prerequisites
- **Required Entities:** An existing Element (ElementWall or ElementRoof) with defined structural zones.
- **Minimum Beams:** N/A (Requires an Element, not individual beams).
- **Required Settings:** 
  - `hsbLooseMaterialsUI.dll` (Optional, required for the "Edit Inventory" catalog dialog).
  - XML Configuration file (Optional, used for Import/Export of settings).

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse and select `hsbElementInsulation.mcr`.

### Step 2: Select Element
```
Command Line: Select Element:
Action: Click on the desired Wall or Roof element in the model.
```

### Step 3: Overwrite Check (Conditional)
If an insulation instance already exists in the same zone on the selected element:
```
Command Line: Are you sure to overwrite existing settings? [No/Yes]
Action: Type "Yes" to replace the existing insulation or "No" to cancel.
```

### Step 4: Configure Properties
After insertion, the TSL instance is selected. Open the **Properties Palette** (Ctrl+1) to configure dimensions, materials, and behavior.

### Step 5: Modify Geometry (Optional)
Right-click the TSL instance to access context menu options for fine-tuning:
- Select **"Add Area"** to include specific voids (select closed polylines).
- Select **"Subtract Area"** to exclude areas (select closed polylines representing obstacles).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **General** | | | |
| Catalog | dropdown | *Empty* | Select a preset configuration from the hsbLooseMaterials database (if available). |
| Manufacturer | text | *Empty* | Name of the insulation manufacturer. |
| Description | text | *Empty* | Descriptive name for the insulation type (e.g., "Mineral Wool 100mm"). |
| Material | text | *Empty* | Material classification code. |
| ArticleNumber | text | *Empty* | Unique SKU or part number for BOMs. |
| Group | text | *Empty* | Hardware group name for sorting in reports. |
| R-value | text | *Empty* | Thermal resistance value (e.g., 3.5). |
| **Geometry** | | | |
| Zone | number | 2 | The structural zone index to fill (typically Zone 2 is the main cavity between studs). |
| Offset Left/Right | number | 0.0 | Horizontal offset (mm) relative to the element's center. |
| Offset Bottom/Top | number | 0.0 | Vertical offset (mm) relative to the element's bottom. |
| Max Height | number | 0.0 | Limits vertical fill; 0 means fill to top of element. |
| Sides | number | 0 | Which sides to generate (0=All, 1=Left, 2=Right). |
| Fixed Thickness | number | 0.0 | Forces a specific thickness (mm); 0 uses the full zone width. |
| Thickness variable | dropdown | Default | Strategy for varying widths: "Default" (Flexible) or "Rigid". |
| Gap | number | 0.0 | Shrinkage gap (mm) around the perimeter of the insulation. |
| **Visualization** | | | |
| Write to model | dropdown | No | **Yes**: Creates physical 3D bodies. **No**: Calculates virtual data/BOM only. |
| ColorLayer | dropdown | *Empty* | The CAD layer assigned to the insulation bodies. |
| Transparency | number | 80 | Visibility level (0=Opaque, 90=Transparent). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Edit Insulation in Place** | Triggers a recalculation/refresh of the insulation geometry. |
| **Add Area** | Allows you to select closed polylines to add additional volume to the insulation. |
| **Subtract Area** | Allows you to select closed polylines to create holes or exclusions in the insulation. |
| **Edit Inventory** | Opens a dialog to select insulation products from the database (requires `hsbLooseMaterialsUI.dll`). |
| **Erase Insulation Sheeting** | Removes the generated 3D insulation bodies and deletes the TSL instance. |
| **Database on / off** | Toggles the connection to the inventory database. |
| **Import Settings** | Loads configuration settings from an external XML file. |
| **Export Settings** | Saves the current configuration to an external XML file for reuse. |

## Settings Files
- **Filename**: `hsbLooseMaterialsUI.dll`
- **Location**: `_kPathHsbInstall\Utilities\hsbLooseMaterials\`
- **Purpose**: Provides the "Edit Inventory" dialog interface for selecting products from a catalog.

- **Filename**: `hsbElementInsulation.xml`
- **Location**: `_kPathHsbCompany\General\TslData\hsbElementInsulation\`
- **Purpose**: Stores settings exported via the "Export Settings" menu for future import.

## Tips
- **Virtual vs. Physical:** Use "Write to model" = **No** if you only need insulation quantities in your BOM but do not want to clutter the 3D model with extra bodies.
- **Zone Selection:** If insulation appears outside the studs or is missing, check the **Zone** number. Usually, Zone 1 is the internal finish/lining, Zone 2 is the framing cavity, and Zone 3 is the external sheathing.
- **Partial Fill:** Use **Max Height** to prevent insulation from filling triangular gable ends if your wall has a pitched roof.
- **Updating:** If you modify the wall (e.g., move a stud), select the insulation TSL instance and choose **Edit Insulation in Place** (or simply change a property) to regenerate the insulation to fit the new wall geometry.

## FAQ
- **Q: Why don't I see the insulation in my 3D view?**
  - **A:** Check the "Write to model" property in the palette. It defaults to "No". Set it to "Yes" and regenerate.
- **Q: How do I handle a window or opening that isn't being automatically detected?**
  - **A:** Use the **Subtract Area** right-click option. Draw a polyline around the opening, select the menu item, and pick the polyline to cut that volume out.
- **Q: Can I use this without a material database?**
  - **A:** Yes. Right-click and select **Database off**. You can then manually type Manufacturer, Description, and Article numbers in the Properties Palette.
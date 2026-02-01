# HSB_E-BeamToSheet

## Overview
Converts structural timber Beams into Sheet entities (panels), preserving geometry and tooling while updating material and zone properties. It is typically used to generate sheeting layers or CLT panels from structural frame designs.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary environment for generating 3D sheet entities. |
| Paper Space | No | Not applicable for this script. |
| Shop Drawing | No | This script operates on model entities, not drawing views. |

## Prerequisites
- **Required Entities**: At least one Element or Beam must exist in the model.
- **Minimum Beams**: 1.
- **Required Settings**: `HSB-BeamToSheetCatalogue.xml` (located in the `hsbCompany\Abbund` folder) is required when selecting Elements to map Beam Codes to properties.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-BeamToSheet.mcr`

### Step 2: Selection Method
```
Command Line: Select one or more elements |<Right click to select beams>|
Action: 
- Click on an Element (Wall/Roof) to process all beams inside it based on the Catalog.
- OR Right-click to switch to manual beam selection mode.
```

### Step 3: Configure (Optional - Manual Mode)
```
Command Line: Select beams
Action: Select the specific beams you wish to convert.
Note: If properties (Zone/Color/Material) need to be set manually, ensure they are configured in the Properties Palette before selection or via the dialog if prompted.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Assign to zone | Number | 1 | Assigns the generated sheet to a specific construction layer (Zone) for reporting and layer management. Range: 0-10. |
| Color | Number | -1 | Sets the display color of the sheet (AutoCAD Color Index). Use -1 to inherit the color from the original beam. |
| Material | Text | (Empty) | Specifies the stock material name (e.g., 'OSB', 'PLYWOOD'). If left blank, it inherits the beam's material. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No specific custom context menu options are defined for this script. |

## Settings Files
- **Filename**: `HSB-BeamToSheetCatalogue.xml`
- **Location**: `_kPathHsbCompany\Abbund`
- **Purpose**: Maps Beam Codes to specific Zone, Color, and Material settings when using Element selection mode. This allows for batch processing of structural elements with predefined sheeting standards.

## Tips
- **Batch Processing**: Use the Element selection method (Step 2) to convert entire walls or roofs at once using the XML catalog settings.
- **Custom Selection**: Use the Right-click method (Step 2) to convert only specific beams. In this mode, use the Properties Palette to define the Zone, Color, and Material before running the script.
- **Roof Logic**: When processing Roof elements in Zone 4 or 5, the script automatically overrides the material to 'TENGEL' (Zone 4) or 'PANLAT' (Zone 5) if no specific material is provided.
- **Tooling Transfer**: The script automatically transfers valid cuts and drill holes from the original beam to the new sheet.

## FAQ
- **Q: I selected an Element, but no sheets were created.**
  A: Check the Beam Codes of the beams within that Element. If the codes are not found in the `HSB-BeamToSheetCatalogue.xml` file, those beams will be skipped.
- **Q: How do I change the material for specific beams?**
  A: Use the manual beam selection mode (Right-click at the first prompt) and set the 'Material' property in the Properties Palette before confirming the selection.
- **Q: The script reports "No catalog found!". What do I do?**
  A: Ensure that your `hsbCompany` path variable is configured correctly and the `HSB-BeamToSheetCatalogue.xml` file exists in the `Abbund` subfolder. Alternatively, use manual beam selection mode which does not require the catalog.
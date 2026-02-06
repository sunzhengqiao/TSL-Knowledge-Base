# hsbGenBeamDensity.mcr

## Overview
This script automatically assigns physical density values (e.g., kg/m³) to timber beams and sheets based on their material properties. It uses an external lookup table (XML) to populate a specific Property Set field, facilitating accurate weight calculations and BIM data export.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D structural elements (Beams, Sheets, Panels). |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Not applicable for 2D drawings. |

## Prerequisites
- **Required Entities**: GenBeam, Element, Sheet, or Structural Insulated Panels (Sip).
- **Minimum Beam Count**: 1 (or an Element containing at least one beam).
- **Required Settings**: 
  - The configuration file `hsbGenBeamDensityConfig.xml` must exist in your `hsbCompany\Abbund\` folder.
  - A Property Set Definition (with a numeric property) must exist in your drawing to store the density data.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbGenBeamDensity.mcr` from the list.

### Step 2: Configure Properties
```
Properties Palette: Set Property Set Name and Property Name Density
Action: 
1. Ensure "Property Set Name" matches the Property Set Definition in your drawing (Default: hsbDensity).
2. Ensure "Property Name Density" matches the specific field label within that set (Default: Density).
3. Close the palette to proceed.
```

### Step 3: Select Entities
```
Command Line: Select entities
Action: 
- Click on a single Beam, an Element (to process all beams inside), or multiple Sheets/Sips.
- Press Enter to confirm selection.
```

### Step 4: Review Processing
The script will automatically:
1. Read the material assigned to each selected entity.
2. Look up the material in the configuration XML file.
3. Write the density value to the entity's properties.
4. Report any missing materials to the command line.

### Step 5: Completion
The script instance deletes itself automatically after processing. The density data is now attached to your elements.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Property Set Name | text | hsbDensity | The name of the Property Set Definition that will be attached to the entities to store the density. |
| Property Name Density | text | Density | The exact field name (attribute) within the Property Set where the numeric value will be written. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are defined for this script. |

## Settings Files
- **Filename**: `hsbGenBeamDensityConfig.xml`
- **Location**: `hsbCompany\Abbund\`
- **Purpose**: Contains the mapping database. It lists Material Names (e.g., "C24", "GL24h") alongside their corresponding Density values. If a material in your model is not in this list, the script cannot assign a density to it.

## Tips
- **Verify Property Sets**: Before running the script, use AutoCAD's `PROPERTIES` command to check if your target beams already have the Property Set defined. If the script fails to find the set, it will abort.
- **Material Spelling**: Ensure the Material names assigned to your beams (in the General properties) exactly match the keys in the XML file. The check is case-insensitive, but spelling must be precise (e.g., "Spruce" vs. "Spruce ").
- **Batch Processing**: You can select multiple entities or a whole Element (wall/roof) at once to speed up the process.

## FAQ
- **Q: The script reports "invalid Property Set Name" and stops. What is wrong?**
  **A:** The name you entered in the "Property Set Name" parameter does not exist in the current drawing's Property Set Definitions. Check the drawing settings or correct the spelling in the script properties.
- **Q: The command line says a material was "not found" in the XML path. How do I fix this?**
  **A:** Your model uses a material that is not defined in `hsbGenBeamDensityConfig.xml`. You must edit that XML file (usually located in your company folder) to add the missing material and its density value.
- **Q: Can I run this on a single beam?**
  **A:** Yes. If you select a single GenBeam, the script processes only that beam. If you select an Element, it processes all beams inside that element.
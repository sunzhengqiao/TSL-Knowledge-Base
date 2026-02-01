# HSB_E-ColorBeams

## Overview
This script automates the assignment of visual colors and production zones (Element Groups) to beams based on their specific Beam Codes. It reads a mapping from an external XML catalog to apply consistent styling and sorting data across selected structural elements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates on 3D model elements (Walls, Floors, Roofs). |
| Paper Space | No | Not designed for 2D layout or drawing views. |
| Shop Drawing | No | Not applicable within shop drawing contexts. |

## Prerequisites
- **Required Entities**: Structural Elements (Walls, Floors, or Roofs) containing beams.
- **Minimum Beam Count**: 0 (An element can be selected even if it is currently empty).
- **Required Settings**: 
  - `HSB-ColorBeamsCatalogue.xml` must exist in the `hsbCompany\Abbund` folder.

## Usage Steps

### Step 1: Launch Script
Execute the command `TSLINSERT` in the AutoCAD command line and select `HSB_E-ColorBeams.mcr` from the file dialog.

### Step 2: Select Elements
```
Command Line: Select a set of elements
Action: Click on the structural Elements (Walls, Floors, Roofs) you wish to process and press Enter.
```
*Note: The script will scan all beams contained within the selected elements.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script has no editable parameters in the Properties Palette. All logic is derived from the external XML catalog. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | No custom context menu options are added by this script. |

## Settings Files
- **Filename**: `HSB-ColorBeamsCatalogue.xml`
- **Location**: `_kPathHsbCompany\Abbund` (Your company hsbCAD folder)
- **Purpose**: Defines the rules for mapping specific Beam Codes to:
  - **AutoCAD Color Index**: Determines the visual color of the beam in the model.
  - **Zone Index**: Assigns the beam to a specific production group/element group number.

## Tips
- **Visual Verification**: Use this script to visually distinguish different beam types (e.g., Wall Studs vs. Plates) by assigning them different colors in the catalog.
- **Pre-Processing**: Run this script before generating lists or exports to ensure beams are correctly sorted into their production zones.
- **Updating Rules**: To change which codes get which colors, do not edit the script; instead, open and modify the `HSB-ColorBeamsCatalogue.xml` file in a text editor.

## FAQ
- **Q: I ran the script, but the beams didn't change color.**
  - A: Check if the Beam Codes in your model match exactly (including case sensitivity) with the codes defined in the `HSB-ColorBeamsCatalogue.xml`.
- **Q: Where can I find the XML file?**
  - A: It is located in your company's hsbCAD installation path, typically inside a subfolder named `Abbund`.
- **Q: Does this change the geometry of the beams?**
  - A: No, it only modifies visual properties (Color) and data attributes (Element Group/Zone).
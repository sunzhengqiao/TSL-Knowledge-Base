# HSB_G-BeamToSheetCatalogueProps.mcr

## Overview
This script serves as a property manager for beam-to-sheet configurations. It allows users to define connection codes, materials, and visual properties via the Properties Palette, either by selecting from a catalogue or entering manual values.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script runs here but typically erases itself immediately after execution, leaving only property definitions. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: None.
- **Minimum Beam Count**: 0.
- **Required Settings Files**: `HSB-BeamToSheetCatalogue.xml` (Must be located in `_kPathHsbCompany\Abbund`).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `HSB_G-BeamToSheetCatalogueProps.mcr`.

### Step 2: Execution & Property Initialization
```
Command Line: (Script executes automatically)
Action: The script will initialize and immediately erase the graphical instance. 
Note: This is normal behavior. The script is designed to create property definitions in the background without remaining as a visible object in the drawing.
```

### Step 3: Configure Properties (Via OPM)
```
Action: Select the relevant element (if this script is embedded) or interact via the parent script context. 
Action: Open the Properties Palette (Ctrl+1) to modify parameters.
Note: The available fields (Text vs. Dropdown) depend on the script's internal "Execution Mode".
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Beam code** (`sEntryName`) | Text/Dropdown | "" | The identifier for the beam-to-sheet configuration. In "Select" mode, this is a dropdown list populated from the XML catalogue. In "Add/Edit" modes, this is a text field. |
| **Zone index** (`nZoneIndex`) | Dropdown | 0 | Classifies the element into a logical zone (0-10). Used for filtering or structural organization. |
| **Color index** (`nColorIndex`) | Integer | -1 | Sets the visual color of the sheet elements (-1 = ByLayer). |
| **Material** (`sMaterial`) | Text | "" | Specifies the material grade for the sheeting (e.g., OSB, Plywood). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add specific custom items to the right-click context menu. |

## Settings Files
- **Filename**: `HSB-BeamToSheetCatalogue.xml`
- **Location**: `_kPathHsbCompany\Abbund`
- **Purpose**: Stores the list of predefined Beam codes. The script reads this file to populate the dropdown options for the **Beam code** parameter when in "Select from Catalogue" mode.

## Tips
- **Script Behavior**: Do not be alarmed if the script disappears immediately after insertion. This is intended; it functions as a "property definition" script rather than a geometry generator.
- **Mode Dependency**: The interface for the **Beam code** property changes based on the "Mode" passed from the calling script. If the dropdown is empty, check if the XML file exists in the correct company folder.
- **Integration**: This script is typically used as a dependency for `HSB_G-BeamToSheet.mcr` to handle catalogue data.

## FAQ
- **Q: Why did the script vanish immediately after I ran it?**
- **A:** This script erases its own instance upon insertion (`_bOnInsert`) because it is a utility script designed only to expose properties to the Properties Palette or to other scripts, not to create visible geometry.
  
- **Q: The "Beam code" dropdown is empty. How do I fix it?**
- **A:** Ensure the file `HSB-BeamToSheetCatalogue.xml` exists in your hsbCAD company folder under the `Abbund` subdirectory. The script requires this file to populate the list.

- **Q: Can I manually type a beam code?**
- **A:** Yes, but only if the script is running in "Add" (Mode 1) or "Edit" (Mode 3) mode. If it is in "Select from Catalogue" (Mode 2) mode, you must choose from the dropdown.
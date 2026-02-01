# HSB_G-ColorBeamsCatalogueProps.mcr

## Overview
This utility script manages a catalogue of beam definitions, associating specific Beam Codes with construction Zones and visual Colors. It allows you to Add, Select, or Edit these catalogue entries via the AutoCAD Properties Palette, saving the data to an external XML file.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates as a utility command within the 3D model environment. |
| Paper Space | No | Not intended for layout or detailing views. |
| Shop Drawing | No | Not intended for manufacturing outputs. |

## Prerequisites
- **Required Entities:** None (This is a command/utility script).
- **Minimum Beam Count:** 0.
- **Required Settings:** The file `HSB-ColorBeamsCatalogue.xml` must exist in your company folder structure (`...\Abbund\`).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `HSB_G-ColorBeamsCatalogueProps.mcr` from the file dialog and click **Open**.

### Step 2: Configure Properties
The script will run immediately upon insertion (the visual insertion marker will disappear, acting as a background command).
Action: Press `Ctrl+1` to open the **Properties Palette** if not already open. The script's parameters will be displayed here.

### Step 3: Define or Select Entry
Depending on the current mode (determined by the script context), you will see different input options:
- **Select Mode:** Choose a "Beam code" from the dropdown list to view its assigned Zone and Color.
- **Add Mode:** Type a new "Beam code", then select the Zone index and Color index to create a new catalogue entry.
- **Edit Mode:** The "Beam code" is locked. Modify the "Zone index" or "Color index" to update the existing catalogue entry.

### Step 4: Apply Changes
Action: Modify values in the Properties Palette. The script will automatically update the XML file with the new data upon recalculation.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Beam code** | Dropdown / Text | Blank | The unique identifier for the beam entry. In Select mode, this is a dropdown list of existing XML keys. In Add/Edit mode, this is a text input. |
| **Zone index** | Dropdown | 0 | Assigns the beam to a specific construction zone (values 0 through 10). |
| **Color index** | Number | -1 | The AutoCAD Color Index (ACI) assigned to the beam (e.g., 1=Red, 5=Blue, -1=ByLayer). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not define custom right-click context menu items. All interaction is via the Properties Palette. |

## Settings Files
- **Filename**: `HSB-ColorBeamsCatalogue.xml`
- **Location**: `_kPathHsbCompany\Abbund\`
- **Purpose**: Stores the database of Beam Codes and their corresponding Zone and Color Index settings.

## Tips
- **Identifying Mode:** If you cannot type in the "Beam code" field, you are in **Select** mode. If you can type a name, you are in **Add** or **Edit** mode.
- **Color Index:** Use standard AutoCAD color numbers (1-255). Enter `-1` to set the color to "ByLayer".
- **Zone Grouping:** Use the "Zone index" to logically group beams for reports or filtering, even if they share the same visual color.

## FAQ
- **Q: The script disappeared immediately after I inserted it. Is it working?**
  - A: Yes. This is a utility script that erases its graphical representation (`eraseInstance`) after insertion to act as a background command. Configure settings using the Properties Palette (`Ctrl+1`).
- **Q: Where is the catalogue data saved?**
  - A: Data is saved to `HSB-ColorBeamsCatalogue.xml` located in your company `Abbund` folder.
- **Q: How do I add a new color definition?**
  - A: Ensure the script is in "Add" mode (often set by a calling script). Enter a new unique name in "Beam code" and define the Zone and Color.
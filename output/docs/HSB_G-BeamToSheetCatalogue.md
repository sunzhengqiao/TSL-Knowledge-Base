# HSB_G-BeamToSheetCatalogue.mcr

## Overview
This script acts as a visual manager for a catalogue that maps Beam Codes to manufacturing properties (Zone, Color, and Material). It reads data from an XML file and displays it as a formatted table in the model, allowing you to add, edit, or remove entries directly from the drawing.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | User must select a point to insert the table. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Settings File**: `HSB-BeamToSheetCatalogue.xml` must exist in your company `Abbund` folder (e.g., `\\hsbCompany\Abbund`).
- **Dependency Script**: `HSB_G-BeamToSheetCatalogueProps.mcr` must be available to handle input dialogs.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `HSB_G-BeamToSheetCatalogue.mcr`.

### Step 2: Select Insertion Point
```
Command Line: Select a position
Action: Click in the Model Space where you want the catalogue table to appear.
```

### Step 3: Initial Configuration
Action: An initial dialog may appear depending on your setup. You can proceed to configure the catalogue properties or view the existing table immediately.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Text size | Number | 50 mm | Controls the height of the text in the table. Row height and column width are calculated automatically based on this value. |
| Dimension style | Dropdown | _DimStyles | Determines the font and visual style used for the text in the table. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add an entry | Opens a dialog to input a new Beam Code name, Zone, Color, and Material. This adds a new mapping to the XML file. |
| Edit an entry | Opens a dialog to select an existing entry from the list, then allows you to modify its properties (Zone, Color, Material). |
| Remove an entry | Opens a dialog to select an existing entry, then permanently deletes it from the XML catalogue. |

## Settings Files
- **Filename**: `HSB-BeamToSheetCatalogue.xml`
- **Location**: `_kPathHsbCompany\Abbund` (Usually your company's installation folder)
- **Purpose**: Stores the actual catalogue data linking Beam Codes to specific manufacturing properties.

## Tips
- **Scaling**: If the table is hard to read, select the script instance and change the **Text size** property in the Properties Palette. The table layout will adjust automatically.
- **Relocating**: You can move the table by using standard AutoCAD move commands or grip editing the insertion point.
- **Duplicate Names**: The system prevents duplicate Beam Code keys. If you try to add a name that already exists, you will receive a warning and must use the "Edit an entry" option instead.

## FAQ
- **Q: What happens if I try to add an entry with a name that already exists?**
- **A:** The script will report a warning: "The catalogue already contains an entry with this key." The update will be cancelled. You must use the "Edit an entry" context menu option to modify the existing record.

- **Q: How is the Zone calculated if I enter a specific number?**
- **A:** The script automatically handles Zone logic. If a specific calculation is required (e.g., input greater than 5), the script adjusts the value internally.

- **Q: Does this script change my beams?**
- **A:** No. This script only manages the data catalogue (the list of settings). Other scripts or export processes would use this catalogue to apply properties to beams.
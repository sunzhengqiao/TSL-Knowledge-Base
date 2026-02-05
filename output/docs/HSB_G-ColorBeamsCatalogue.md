# HSB_G-ColorBeamsCatalogue

## Overview
This script acts as a visual manager for a catalogue that maps beam codes to production zones and colors. It is typically used to configure data for manufacturing exports (e.g., for Abbund machinery) and displays the current catalogue as a table in the model.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script inserts a visual table at a selected point. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities:** None (Stand-alone script).
- **Minimum Beam Count:** 0.
- **Required Settings:**
    - `HSB-ColorBeamsCatalogue.xml` (The data file storing the beam mappings).
    - `HSB_G-ColorBeamsCatalogueProps` (Internal property handler).

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse and select `HSB_G-ColorBeamsCatalogue.mcr`.

### Step 2: Select Insertion Point
```
Command Line: Select a position
Action: Click anywhere in the Model Space to place the catalogue table.
```
*Note: Upon insertion, the Properties Palette will open, allowing you to adjust text size or dimension style before finalizing.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Text size | Number | 50 (mm) | Controls the height of the text in the table. Increasing this value scales up the entire table layout. |
| Dimension style | Dropdown | _DimStyles | Selects the graphical style (font, arrows, etc.) used for the text in the table headers and content. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add an entry | Opens a dialog to input a new Beam Code, Zone, and Color. This adds a new row to the catalogue. |
| Edit an entry | Prompts you to select an existing entry from a list, then allows you to modify its Zone and Color values. |
| Remove an entry | Prompts you to select an existing entry from a list and permanently deletes it from the catalogue. |

## Settings Files
- **Filename**: `HSB-ColorBeamsCatalogue.xml`
- **Location**: `_kPathHsbCompany\Abbund` (Typically located in your company's hsbCAD installation folder).
- **Purpose**: This XML file acts as the database. It stores the link between Beam Codes, Zones, and Colors. Changes made via the Right-Click menu are written directly to this file.

## Tips
- **Dynamic Resizing:** You can change the `Text size` property in the Properties Palette at any time. The table geometry will automatically recalculate and redraw to fit the new text size.
- **Immediate Updates:** Any changes you make (Add/Edit/Remove) via the right-click menu are instantly saved to the XML file and the visual table is updated immediately.
- **Duplicate Names:** The script prevents you from adding a Beam Code that already exists. If you need to change an existing code, use the "Edit an entry" option instead.

## FAQ
- **Q: I tried to add a new entry, but it told me the key already exists. What do I do?**
  **A:** This means the Beam Code you are trying to add is already in the catalogue. Cancel the current action and use the "Edit an entry" option to modify the existing entry.
- **Q: Where is my data saved?**
  **A:** Data is saved in the `HSB-ColorBeamsCatalogue.xml` file located in your company's Abbund folder. This ensures the catalogue is consistent across your project team.
- **Q: Can I change the font of the table?**
  **A:** Yes. Select the script instance, open the Properties Palette, and change the `Dimension style` to a style that uses your preferred font.
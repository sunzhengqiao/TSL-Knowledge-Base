# HSB_W-OpeningInformation.mcr

## Overview
This script automates the annotation of openings (windows, doors) directly on 2D layout views (Paper Space). It displays dimensions, descriptions, material information, and visual markers based on the 3D model data, ensuring drawings match the current design state.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | The script is intended for Layout tabs (Paper Space). |
| Paper Space | Yes | Select a viewport to link the annotation to the 3D element. |
| Shop Drawing | No | This is a general annotation script, not a manufacturing layout generator. |

## Prerequisites
- **Required Entities:** A viewport on a Layout tab that is linked to a valid hsbCAD Element (Wall or Roof).
- **Minimum Beam Count:** 0 (Depends on the Element linked to the viewport).
- **Required Settings:** None specific, though a Dimension Style must exist in the drawing for text formatting.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_W-OpeningInformation.mcr` from the file dialog.

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the viewport in Paper Space that displays the wall or roof containing the openings you wish to annotate.
```
*(Note: The script automatically detects the element projected within that viewport.)*

### Step 3: Configure Settings
The Properties Palette (OPM) will appear immediately after insertion. Adjust the "Information" and "Layout" settings as desired.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Information** | dropdown | \|Description\| | Selects what data is shown: Description only, Description & Header material, Description & Size (WxH), or None. |
| **Custom text** | text | (empty) | Adds an extra manual note below the opening info (e.g., "See detail A"). |
| **Dimension style** | dropdown | (Current) | Selects the CAD dimension style to control font and arrow formatting for the labels. |
| **Text height** | number | 0 | Sets the height of the text. Use `0` to use the height defined in the Dimension Style. |
| **Dimension opening beams** | dropdown | \|Yes\| | **Yes:** Calculates size based on the gap to the nearest beams (Rough Opening). **No:** Uses the catalog/nominal size. |
| **With cross** | dropdown | \|Yes\| | Draws diagonal cross lines inside the opening to indicate a void/window. |
| **With frame** | dropdown | \|Yes\| | Draws the outline/frame of the opening. |
| **Color cross** | number | -1 | Sets the color of the diagonal cross lines (-1 = ByLayer). |
| **Color description** | number | -1 | Sets the color of the text labels (-1 = ByLayer). |
| **Color frame** | number | -1 | Sets the color of the opening outline (-1 = ByLayer). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Refreshes the annotations to reflect changes in the 3D model or updated properties. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies on standard AutoCAD/hsbCAD Dimension Styles and Element properties, not external XML files.

## Tips
- **Rough Openings vs. Catalog Sizes:** If you need to dimension the actual space for the carpenter (clearance including gaps), set **Dimension opening beams** to `|Yes|`. This projects rays to find the nearest beam edge. If you need the nominal window/door size, set it to `|No|`.
- **Text Layout:** If you select "Description & Size", the script automatically pushes the "Custom text" further down to prevent overlapping with the dimensions.
- **Roof Openings:** This script automatically skips "OpeningRoof" types and focuses on vertical wall openings.
- **Visibility:** If annotations disappear, check if the linked Element was deleted or if the Viewport was rotated/moved significantly.

## FAQ
- **Q: Why does the script ask me to select a viewport?**
  A: The script needs to know which 3D model (Element) to read data from and how to transform those 3D coordinates into the correct position on your 2D drawing sheet.
- **Q: My text is too small. How do I fix it without changing every script?**
  A: Set **Text height** to `0` in the script properties. The script will then adopt the text size defined in your selected **Dimension style**, allowing you to control all text globally via CAD standards.
- **Q: Can I use this on a roof plan?**
  A: The script primarily targets Wall elements. While it might work on some roofs, it specifically skips "OpeningRoof" entities and is optimized for vertical wall views.
# HSB_S-InsertDetailNames.mcr

## Overview
Automatically inserts detail name labels onto timber elements in the 3D model based on manufacturing codes assigned to their connection edges. It cleans up old labels and applies a specific visual style to the new annotations.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates exclusively in the 3D model environment. |
| Paper Space | No | Not intended for layout views or 2D drawings. |
| Shop Drawing | No | Not intended for use within hsbShop Drawing layouts. |

## Prerequisites
- **Required Entities**: Timber Elements (Walls, Beams, or Panels) that have Single Input Point (SIP) data containing detail codes.
- **Minimum Beam Count**: 0 (Requires Element selection, not just beams).
- **Required Settings**:
  - The script file `HSB_E-DetailName.mcr` must be present in the TSL search path.
  - Valid Catalog entries (e.g., "Standard75") must exist within `HSB_E-DetailName` to define text styles and sizes.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_S-InsertDetailNames.mcr` from the file list.

### Step 2: Select Catalog Configuration
```
Dialog Box: Select Catalog details
Action: Use the dropdown to choose the visual style (Catalog) for the labels (e.g., 'Standard75', 'LargeText').
Action: Click OK to confirm.
```
*(Note: This step may be skipped if an Execute Key preset is used by the administrator.)*

### Step 3: Select Elements
```
Command Line: Select one or more elements
Action: Click on the timber elements or walls you wish to annotate.
Action: Press Enter to complete the selection.
```
*(The script will now process the elements, remove any existing detail labels on them, and insert the new ones based on the edge codes.)*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Catalog details | dropdown | First available catalog | Selects the visual configuration for the detail labels. This determines the text height, style, and layer used by the annotation script. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script uses a "fire-and-forget" method. It erases itself after running, so no right-click menu options are available on the script instance. |

## Settings Files
- **Filename**: Defined in `HSB_E-DetailName.mcr` catalogs
- **Location**: hsbCAD Company or Install path
- **Purpose**: Stores the graphical properties (Text Height, Layer, Color) for the different label styles available in the dropdown.

## Tips
- **Automatic Cleanup**: You do not need to manually delete old detail names before running this script. It automatically removes previous labels attached to the selected elements.
- **Source Data**: Ensure your elements have valid "Detail Codes" assigned to their edges in the Element or Manufacturing properties. If no codes are present, no labels will be generated.
- **Modifying Labels**: Since the main script deletes itself after running, select the individual `HSB_E-DetailName` text objects in the model if you need to move or change a specific label.

## FAQ
- **Q: Why did the script disappear after I selected the elements?**
  **A:** This is normal behavior. The script is designed as an installer tool; it places the labels and then removes itself from the drawing to prevent clutter.
- **Q: I ran the script, but no text appeared.**
  **A:** Check if the selected elements have "Detail Codes" defined in their edge properties (SIP data). The script only creates labels where codes exist.
- **Q: How do I change the text size?**
  **A:** Re-run the `HSB_S-InsertDetailNames` script and select a different "Catalog details" option (e.g., one with larger text defined in its properties).
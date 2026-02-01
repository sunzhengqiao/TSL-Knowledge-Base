# GE_PLOT_ASSEMBLIES_LIST_LABELS_HATCH.mcr

## Overview
This script generates automated assembly lists, labels, and hatching for wall elements in Elevation views, while providing specialized dimensioning tools for Plan views. It processes wall connections and openings to create detailed production annotations directly in Paper Space.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script operates exclusively in Paper Space. |
| Paper Space | Yes | Requires a Viewport displaying a Wall Element. |
| Shop Drawing | No | This is a general detailing script for layouts. |

## Prerequisites
- **Required Entities:** A Wall Element (containing structural beams) visible through a viewport.
- **Minimum Beam Count:** 1
- **Required Settings Files:**
  - `_kPathHsbWallDetail\OpeningSFCat.dat` (Used for opening descriptions and styling)

## Usage Steps

### Step 1: Launch Script
```
Command Line: TSLINSERT
Action: Browse and select GE_PLOT_ASSEMBLIES_LIST_LABELS_HATCH.mcr
```

### Step 2: Select Viewport
```
Command Line: Select Viewport:
Action: Click on a viewport in the layout that displays the wall you wish to annotate.
```

### Step 3: Select View Type
```
Command Line: Select View Type [0=Elevation, 1=Plan]:
Action: Type 0 and press Enter for Elevation (Labels/Lists) or Type 1 for Plan (Dimensions).
```

### Step 4: Define Insertion Point (Elevation Only)
*If you selected Elevation (0):*
```
Command Line: Specify insertion point:
Action: Click in the Paper Space to place the Assembly List and Labels.
```
*If you selected Plan (1):* The script automatically calculates the insertion point based on the Viewport center.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| View type | Int | 0 | Toggles between Elevation mode (0) and Plan mode (1). |
| Display Labels | Bool | True | Shows assembly labels on the drawing. |
| Display List | Bool | True | Generates the assembly list table. |
| Display Hatch | Bool | True | Hatches the assemblies with the defined pattern. |
| Display Dims | Bool | False | Enables dimension lines (primarily for Plan views). |
| Display Cumulative Dims | Bool | False | Shows chain dimensions along the wall. |
| Display Delta Dims | Bool | False | Shows individual dimension segments. |
| Dimension openings to | String | Headers | Sets if dimensions measure the Header only or the Full Assembly. |
| DimStyle | String | hsb-vp-inch | The dimension style to use for drawing dimensions. |
| Hatch Pattern | String | DOTS | The hatch pattern applied to assemblies (e.g., SOLID, DOTS). |
| Hatch Scale | Double | 1.0 | Scale factor for the hatch pattern. |
| Offset List | Double | Variable | Distance offset for the Assembly List table. |
| Offset Label | Double | Variable | Distance offset for Labels from the wall. |

## Right-Click Menu Options
*Note: This script primarily relies on the Properties Palette (OPM) for modifications rather than custom context menu entries.*

## Settings Files
- **Filename**: `OpeningSFCat.dat`
- **Location**: `hsbWallDetail` folder in your company or installation path.
- **Purpose**: Defines descriptions and classifications for openings (combining width, height, type, and style).

## Tips
- **Switching Modes:** You can switch between Plan and Elevation modes instantly via the Properties Palette without re-running the script. The script will adjust visible components (dims vs. labels) automatically.
- **Stacked Openings:** In Elevation mode, if openings are stacked (e.g., a window above a door), the script handles labeling intelligently. In Plan mode, dimension points filter out stacked openings to prevent overlapping dimensions.
- **Dimension Reference:** If you find your dimensions are too short or long in Plan view, change the "Dimension openings to" property from "Headers" to "Full Assemblies" to see how it affects the measurement points.
- **Empty Assemblies:** If a wall has no specific assemblies (like lintels/jacks), the dimension lines in Plan view will automatically pull closer to the main wall element to maintain readability.

## FAQ
- **Q: I selected a viewport but nothing happened.**
- **A:** Ensure the viewport contains a valid Wall Element with beams. The script will exit silently if no element is detected.
- **Q: Why can't I see labels in Plan view?**
- **A:** By default, the "Display Labels" property is disabled when View Type is set to Plan (1). You can manually enable it in the Properties Palette, but Plan view is optimized for Dimensions.
- **Q: How do I change the hatch style?**
- **A:** Select the script instance in the drawing and change the "Hatch Pattern" property in the Properties Palette to any standard AutoCAD pattern name (e.g., ANSI31, SOLID).
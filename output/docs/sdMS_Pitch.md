# sdMS_Pitch.mcr

## Overview
This script creates a roof pitch symbol (a right-angled triangle with dimensions and an angle arc) directly in Model Space. It links to a specific Shop Drawing (Multipage) element to visualize the slope relative to the drawing configuration.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary space for the script. |
| Paper Space | No | |
| Shop Drawing | Yes | Requires a Multipage entity with generated shop drawing data. |

## Prerequisites
- **Required Entities**: An existing `HSBCAD_MULTIPAGE` entity in the drawing.
- **Minimum Beams**: 0
- **Required Settings**: The selected Multipage entity must have been processed for shop drawings (it must contain `mpShopdrawData`).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `sdMS_Pitch.mcr` from the list.

### Step 2: Select Multipage
```
Command Line: |Select multipage|
Action: Click on the Multipage entity (Shop Drawing container) in the Model Space that you wish to associate the pitch symbol with.
```

### Step 3: Configure Properties
After insertion, select the newly created pitch symbol and adjust its parameters in the Properties Palette (OPM) to fit your plotting scale and standards.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Display** | | | |
| Color | Integer | 7 | Defines the color of the pitch symbol lines and text (AutoCAD Color Index). |
| Text Height | Double | 0 | Overrides the text height. If set to 0, the height defined in the Dimstyle is used. |
| Dimstyle | String | _DimStyles | Selects the Dimension Style to use for formatting text and arrows. |
| **General** | | | |
| Base Length | Double | 2 | Defines the nominal base length (run) of the triangle. |
| Scale Factor | Double | 100 | The scale factor (e.g., 1:100). Used to calculate the actual physical size of the symbol in Model Space. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | No custom context menu options are defined for this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Sizing the Symbol**: The physical size of the symbol in Model Space is calculated as `Base Length * Scale Factor`. If the symbol appears too small on your layout, ensure the `Scale Factor` matches your viewport plot scale (e.g., set to 50 for a 1:50 plot).
- **Text Readability**: If the angle text is too small or large, use the `Text Height` property to override it manually, or ensure the selected `Dimstyle` is configured correctly for your scale.
- **Data Dependency**: Ensure the Multipage entity you select has up-to-date shop drawing data. If the pitch symbol shows incorrect angles, try regenerating the shop drawing for that Multipage.

## FAQ
- **Q: Why does the prompt fail when I select a beam?**
  - A: This script specifically requires a `HSBCAD_MULTIPAGE` entity (the container for shop drawings), not an individual beam.
- **Q: The symbol is tiny. How do I fix it?**
  - A: Check the `Scale Factor` property in the Properties palette. It likely defaults to 100. If you are working at a 1:50 scale, change this value to 50.
# hsbViewDimension.mcr

## Overview
Automates the creation and management of dimension lines in Paper Space (Layouts) for hsbCAD viewports. It allows detailed annotation of timber elements like beams, panels, and openings with automatic collision management and style standardization.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed for Paper Space annotations. |
| Paper Space | Yes | Selects Viewports, Sections, or Shopdrawing Viewports. |
| Shop Drawing | Yes | Optimized for production drawings and detailing. |

## Prerequisites
- **Required Entities**: A Viewport, Section, or Shopdrawing Viewport must exist in the Layout.
- **Visible Elements**: The selected view must contain visible timber elements (Beams, Panels, etc.) to dimension.
- **Required Settings**: A valid AutoCAD DimStyle (e.g., "Standard") must exist in the drawing.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbViewDimension.mcr` from the list.

### Step 2: Select Location
```
Command Line: |Pick point near dimline|
Action: Click in Paper Space inside or near the Viewport/Section you wish to dimension.
```
The script will automatically detect the view boundaries and place the dimension line based on the current default properties.

### Step 3: Adjust Properties (Optional)
After insertion, select the dimension instance and open the **Properties Palette** (Ctrl+1) to change the dimension style, text height, or filter specific elements (e.g., change from Beam to Opening).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Catalog | dropdown | `_Default` | Selects a predefined configuration preset to standardize dimension settings. |
| Sequence | number | 0 | Determines the stacking order (priority) to prevent overlapping text with other dimensions. Higher values push the dimension further out. |
| TextHeight | number | 2.5 | Sets the height of the dimension text in mm. |
| DimStyle | string | Standard | The AutoCAD Dimension Style used for arrows, text font, and color. |
| ChainMode | dropdown | Continuous | Arranges successive dimensions: `Continuous`, `Baseline`, `Offset`, or `Individual`. |
| DeltaMode | dropdown | Off | Controls dimension logic: `Off` (Total length), `Chain` (Incremental spacing), or `Individual` (Incremental spacing). |
| Reference | dropdown | byElement | `byElement` auto-calculates points; `byUser` allows manual selection of reference points. |
| Type | dropdown | Beam | Filters the entity type to dimension (e.g., Beam, Opening, Panel, TSL). |
| SubType | dropdown | All | Further filters the selected Type (e.g., specific wall functions or opening types). |
| Layer | text | [Empty] | Assigns the dimension geometry to a specific CAD layer. |
| ShowAllViews | dropdown | No | If `Yes`, applies the dimensioning logic to all similar views in the layout. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Set Location | Invokes a jig to interactively drag the dimension line to a new position while maintaining its connection to the model. |
| Swap Delta/Chain | Toggles the dimension text between showing total run length (Chain) and individual segment spacing (Delta). |
| Reset locations of all elements | Clears all manually moved dimension lines and reverts them to their automatically calculated positions. |

## Settings Files
- **Catalog Data**: Uses internal catalogs (`_Default` or `_LastInserted`) to store property presets.
- **Location**: Defined by the `sCatalog` property mapping within the hsbCAD environment.

## Tips
- **Avoid Overlapping**: Increase the `Sequence` value if your dimension text overlaps with other annotations or dimensions. This pushes the dimension line outward automatically.
- **Stud Spacing**: Use the `Swap Delta/Chain` right-click option to quickly toggle between overall wall length and individual stud spacing measurements.
- **Layer Control**: Leave the `Layer` property empty to use the current layer, or specify a layer (e.g., "D-ANNO-DIMS") to isolate dimensions for plotting.

## FAQ
- **Q: No dimensions appeared when I inserted the script.**
  - **A:** Check the `Type` property in the Properties Palette. If set to "Opening" but there are no openings in the view, nothing will generate. Ensure the view contains the type of elements selected.
- **Q: The dimension text is too small to read.**
  - **A:** Increase the `TextHeight` property in the Properties Palette.
- **Q: I cannot see the dimension line after moving it.**
  - **A:** It may have been moved into an area restricted by `ViewProtect` or another dimension. Try the "Reset locations of all elements" right-click option to start over.
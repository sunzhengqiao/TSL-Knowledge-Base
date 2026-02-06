# sd_ABeamcutDE.mcr

## Overview
This script is an automated shopdrawing utility that generates dimension lines and visual markers for beam cuts and seat connections. It executes within the hsbCAD Shopdraw engine to apply specific detailing rules to layouts.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script does not run in the 3D model. |
| Paper Space | Yes | It is executed automatically during layout generation. |
| Shop Drawing | Yes | Specifically designed for the hsbCAD Shopdraw engine and Multipage Styles. |

## Prerequisites
- **Required Entities**: GenBeam (Timber beams).
- **Minimum Beam Count**: 1.
- **Required Settings**: A configured Multipage Style with this script added to the **Execution Map** (Ruleset).

## Usage Steps

### Step 1: Configure Multipage Style
Since this script is executed automatically by the engine, it must be assigned to a style first.
1. Open the hsbCAD **Shopdrawing Configuration**.
2. Select or create a **Multipage Style**.
3. Navigate to the **Execution Map** (Ruleset) settings.
4. Add `sd_ABeamcutDE.mcr` to the list of scripts to be executed.

### Step 2: Generate Layouts
```
Command Line: SHOPDRAW (or SDGENERATE)
Action: Select the desired Multipage Style and elements/beams to generate the drawing.
```
The script will automatically run and add dimensions to the relevant views based on the configuration.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not expose properties to the Properties Palette. It relies on internal engine configuration. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not add specific items to the Entity context menu. |

## Settings Files
- **Filename**: Multipage Style Configuration (`.sty` or internal database)
- **Location**: hsbCAD Shopdrawing Styles
- **Purpose**: Determines which beams are processed and how the dimensions are applied (e.g., matching by beam Name or Information attributes).

## Tips
- **Filtering**: Ensure the "Name" or "Information" filters in your Multipage Style Execution Map correctly match the beams you intend to detail. If the dimensions do not appear, check that the beam attributes match the script execution rules.
- **View Orientation**: The script may only place dimensions in specific views (e.g., Top, Side) depending on how the `vecViews` are handled internally.

## FAQ
- **Q: Why are no dimensions appearing on my drawing?**
  **A:** Verify that `sd_ABeamcutDE.mcr` is actually listed in the Execution Map of the Multipage Style used to generate the drawing. Also, ensure the filter criteria (like "Name") match your beams.

- **Q: Can I run this script manually on a single beam?**
  **A:** No, this script is designed exclusively for batch processing by the Shopdraw engine and cannot be inserted manually via `TSLINSERT` to perform its function.
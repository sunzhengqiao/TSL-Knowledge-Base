# hsbCLTWall.mcr

## Overview
This script automatically generates Cross Laminated Timber (CLT) panels from selected StickFrame walls (ElementWallSF). It determines the panel geometry based on the wall structure, handles cutouts for openings, and assigns specific CLT styles based on material names or wall thickness.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script runs in the 3D model environment. |
| Paper Space | No | Not supported for layout generation. |
| Shop Drawing | No | Does not generate 2D drawing views directly. |

## Prerequisites
- **Required Entities**: `ElementWallSF` (StickFrame Wall / HRB-Wand) must exist in the model.
- **Minimum Beam Count**: At least 1 beam in the wall (though typically a complete wall frame is required).
- **Required Settings**: Valid `SipStyle` entries must exist in the catalog.
  - Ideally, the material name of the wall's structural beams should match a Style name.
  - Alternatively, a Style with a thickness matching the wall's **Zone 0** must exist.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLTWall.mcr` from the file browser.

### Step 2: Select Wall Elements
```
Command Line: Select wall elements
Action: Click on the desired StickFrame Wall in the drawing window.
```
*Note: The script will attach to the wall. If you select a wall that already has this script attached, it will be skipped to prevent errors.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not expose specific user-editable parameters in the Properties Palette. It operates automatically based on wall and beam properties. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | No custom context menu items are added by this script. |

## Settings Files
- **Catalog**: `SipStyle`
- **Location**: Defined in your hsbCAD Company or Installation path.
- **Purpose**: This catalog provides the definitions (thickness, material name, etc.) used to generate the CLT panels. The script searches this catalog to find the best match for the wall geometry.

## Tips
- **Using `KEEPBEAM`**: If you want an opening (like a window or door) cut out of the CLT panel but want to keep the symbolic beam in the drawing, assign the beam code **`KEEPBEAM`** to the beams defining that opening.
- **Using `CLT` Code**: Assign the beam code **`CLT`** to beams if you wish to generate a separate, additional panel at that specific location.
- **Style Matching**: The script first tries to find a style matching the structural beam's material name. If the thickness of that style does not match the wall's Zone 0 thickness, or if no material match is found, it searches for *any* style that matches the Zone 0 thickness exactly.
- **Debugging**: If a panel is not generated, check the command line for errors regarding missing styles or thickness mismatches.

## FAQ
- **Q: Why did the script delete itself immediately after running?**
  - A: This usually happens if no matching style is found in the `SipStyle` catalog for the wall's thickness or material, or if the wall contains 0 beams.
- **Q: How can I control the thickness of the generated panel?**
  - A: The thickness is determined by the wall's **Zone 0** properties. Ensure your wall definition has the correct core layer thickness, and that a matching `SipStyle` exists in the catalog.
- **Q: What happens to the original wall beams?**
  - A: By default, standard structural beams are deleted after the panel is generated. Only beams with the code `KEEPBEAM` or `-` are preserved.
# hsb_SIP-SetSizeConvention.mcr

## Overview
This script automatically detects and corrects rectangular beams within a SIP (Structural Insulated Panel) element that have their width and height swapped. It ensures that the longer dimension of the beam always acts as the vertical height, fixing geometric errors caused by incorrect data import or generation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates on Element entities found in the 3D model. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Does not generate 2D drawings. |

## Prerequisites
- **Required Entities**: An Element (e.g., a wall or panel) containing GenBeams.
- **Minimum Beam Count**: 1 (The element must contain at least one beam to process).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Navigate to the location of `hsb_SIP-SetSizeConvention.mcr` and select it.

### Step 2: Select Element
```
Command Line: 
Select Element
```
**Action**: Click on the Element (Wall/Panel) in the model that contains the beams you wish to correct.

### Step 3: Completion
The script will immediately scan the selected element. It will swap the width and height dimensions and rotate any rectangular beams where the width was greater than the height. The script instance will automatically delete itself upon completion.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script has no editable properties in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | No custom context menu options are available for this script. |

## Settings Files
- None required.

## Tips
- **Undo Capability**: Since the script deletes itself after running, you cannot simply delete it to undo changes. Use the standard AutoCAD `UNDO` command if the results are not as expected.
- **Rectangular Only**: The script only affects beams with a "Rectangular" extrusion profile. Custom profiles (e.g., I-joists, glulam specific shapes) are skipped.
- **Import Cleanup**: This tool is particularly useful after importing data from other software where studs or plates might have been defined as "flat" (e.g., 200mm wide x 45mm high) instead of "upright" (45mm wide x 200mm high).

## FAQ
- **Q: The script ran, but my beams look the same. Why?**
  - A: The beams may already have the correct orientation (Height > Width), or they might use a non-rectangular profile which the script ignores.
- **Q: Can I use this on a single beam instead of a whole element?**
  - A: No, this script requires selecting an entire Element (which acts as a container). All beams within that selected element will be processed.
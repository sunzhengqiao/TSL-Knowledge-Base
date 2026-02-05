# OpeningBrace.mcr

## Overview
Automatically inserts a horizontal brace beam (sill plate) below openings in stick frame walls. It aligns the brace between king studs, stretches intermediate cripple studs, and synchronizes production modules to ensure consistency.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates on 3D Stick Frame Wall elements. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: Stick Frame Wall (`ElementWallSF`) containing at least one `Opening` (door or window).
- **Wall Structure**: The wall must have valid King Studs (vertical beams flanking the opening) and a Bottom Plate (horizontal beam below the opening).
- **Dependencies**: Requires `mtfBraceOpening`.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `OpeningBrace.mcr`

### Step 2: Select Stick Frame Walls
```
Command Line: |Select SF Walls|
Action: Click on the Stick Frame Wall entity that contains the opening(s) you wish to brace.
```
*Note: You can select multiple walls at once. Press Enter to confirm your selection.*

### Step 3: Automatic Processing
Once selected, the script performs the following actions automatically without further prompts:
1. Scans the selected wall for openings.
2. Identifies the King Studs (left/right) and the Bottom Plate for each opening.
3. Deletes any existing beams named "BRACE" in the target area.
4. Creates a new "BRACE" beam (GenBeam) spanning between the King Studs at the top edge of the Bottom Plate.
5. Stretches any vertical cripple studs located between the King Studs up to the new brace.
6. Synchronizes production modules (if King Studs are in different modules, it merges them into the Left Stud's module).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script runs automatically upon insertion and does not expose user-editable parameters in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | No custom context menu items are added by this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script uses hardcoded defaults for material ('CLS') and grade ('C16'). It does not rely on external XML settings files.

## Tips
- **Preventing Duplicates**: The script automatically deletes existing beams named "BRACE" before generating new ones. You can safely re-run the script to update the brace if the wall geometry changes.
- **Module Grouping**: This script is useful for ensuring that beams around an opening are grouped into the same production module. If the Left and Right King Studs are in different modules, the script will force the Right module to match the Left module.
- **Wall Integrity**: If the script fails to find a brace, check that your Bottom Plate actually runs underneath the opening midpoint.

## FAQ
- **Q: What does "Stick frame wall not found" mean?**
  - **A:** You likely selected a generic wall or a polyline. You must select the specific hsbCAD `ElementWallSF` entity (Stick Frame Wall).
- **Q: The script reported "Bottom Plate not found". Why?**
  - **A:** The script looks for a horizontal beam directly below the midpoint of the opening. Ensure your wall has a plate defined at the correct height, or that the opening height is not set too low.
- **Q: Can I change the material of the brace?**
  - **A:** The script sets the material to "CLS" and Grade to "C16" by default. While you can change these manually in the Properties Palette after creation, re-running the script will reset them to these defaults.
- **Q: Does this work for multiple openings in one wall?**
  - **A:** Yes, the script iterates through all openings found in the selected Wall entity and processes each one individually.
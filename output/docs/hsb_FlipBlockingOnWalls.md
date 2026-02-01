# hsb_FlipBlockingOnWalls.mcr

## Overview
This script modifies the orientation and position of solid blocking members within a selected wall element. It rotates each piece of blocking 90 degrees and staggers their placement along the wall to create an alternating pattern.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be run in the 3D model. |
| Paper Space | No | Not applicable for 2D drawings. |
| Shop Drawing | No | Not intended for production drawings. |

## Prerequisites
- **Required Entities:** An existing Wall Element containing Solid Blocking beams (type `_kSFBlocking`).
- **Minimum Beam Count:** At least one piece of solid blocking within the element to see a change.
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse to the script location and select `hsb_FlipBlockingOnWalls.mcr`.

### Step 2: Select Wall Element
```
Command Line: Please select a Element
Action: Click on the wall element that contains the blocking you wish to flip.
```
**Note:** Select the entire wall element, not the individual blocking beams.

### Step 3: Automatic Processing
Once the element is selected, the script will automatically:
1. Identify all solid blocking beams within the wall.
2. Rotate every piece 90 degrees.
3. Shift them alternately left and right (relative to the wall axis).

The script instance will disappear immediately after processing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script runs immediately and does not expose editable parameters in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not remain in the drawing and has no context menu options. |

## Settings Files
- **Filename:** None
- **Location:** N/A
- **Purpose:** N/A

## Tips
- **Undoing Changes:** Since the script deletes itself immediately after running, use the standard AutoCAD `Undo` command (Ctrl+Z) to revert the changes if the result is not desired.
- **Beam Type:** Only "Solid Blocking" (`_kSFBlocking`) is affected. Other beam types like studs or headers will remain unchanged.
- **Staggering:** The script automatically alternates the shift direction for each subsequent piece of blocking along the wall.

## FAQ
- **Q: I ran the script but nothing happened. Why?**
  A: Ensure you selected an element that actually contains Solid Blocking beams. If the element contains no blocking, or only other types of framing, the script will finish without making visible changes.

- **Q: How do I run the script again on the same wall?**
  A: Simply launch the script again via `TSLINSERT` and select the element. You can re-run it as many times as needed (though running it twice effectively restores the original orientation and shifts them again).

- **Q: Can I adjust the amount of rotation?**
  A: No, the script is hardcoded to rotate exactly 90 degrees and shift by 50% of the beam depth.
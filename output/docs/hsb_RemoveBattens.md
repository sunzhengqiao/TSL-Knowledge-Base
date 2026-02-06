# hsb_RemoveBattens.mcr

## Overview
This script removes short battens from selected wall elements to clean up the model. It automatically deletes battens that are shorter than a specified length, ensuring only usable timber remains for manufacturing and detailing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used on 3D wall elements containing vertical sheeting zones. |
| Paper Space | No | Not applicable for 2D drawings. |
| Shop Drawing | No | Not intended for generating shop drawings. |

## Prerequisites
- **Required Entities**: `ElementWall` with `GenBeam` battens assigned.
- **Minimum Beam Count**: 0.
- **Required Settings**: Wall elements must contain a zone with the distribution code **'HSB-PL09'** (Vertical sheets).

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Browse and select `hsb_RemoveBattens.mcr`.

### Step 2: Configure Parameters (Optional)
1.  Before proceeding, open the **Properties Palette** (Ctrl+1).
2.  Adjust the `Minimum length of batten` or `Remove battens at sheet splits` settings if the defaults do not suit your current project requirements.

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the desired wall elements or use a window selection to choose multiple elements. Press Enter to confirm.
```

### Step 4: Execution
1.  The script processes the selected elements.
2.  It identifies battens in 'HSB-PL09' zones that are shorter than the minimum length.
3.  The script deletes the identified battens and automatically removes itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Minimum length of batten | Number | 600.0 | Defines the threshold length (in mm). Any batten shorter than this value will be removed. |
| Remove battens at sheet splits | Dropdown | No | If set to 'Yes', the script checks if short battens at sheet joints are redundant (overlapping structural members in adjacent zones) and removes them. If 'No', only the length threshold is used. |

## Right-Click Menu Options
*This script does not add specific options to the entity right-click menu.*

## Settings Files
*No external settings files are required for this script.*

## Tips
- **Self-Deleting Script**: This script is a utility tool; it will automatically erase itself from the model after it finishes running. To run it again with different settings, you must insert it fresh.
- **Zone Specific**: The script only targets zones with the code 'HSB-PL09'. Ensure your wall elements are correctly zoned if the script seems to have no effect.
- **Conservative Threshold**: If you are unsure, start with a lower `Minimum length of batten` (e.g., 300mm) to ensure you don't delete pieces that might be useful for fixing, then increase the value in subsequent runs if necessary.
- **Split Logic**: Use the `Remove battens at sheet splits` option only if your adjacent zones (e.g., structural studs) provide sufficient backing behind the sheet joints. This prevents large gaps in nailing support.

## FAQ
- **Q: Why did the script disappear immediately after running?**
  - A: This is intended behavior. `hsb_RemoveBattens.mcr` is designed as a "cleanup" utility that executes once and deletes itself to keep the drawing clean.
- **Q: The script didn't remove any battens, but I can see short ones.**
  - A: Check that the battens are inside a zone with the distribution code **'HSB-PL09'**. Also, verify that the `Minimum length of batten` property is set lower than the length of the battens you want to remove.
- **Q: What happens if I select an element that isn't a wall?**
  - A: The script will skip the entity and continue processing other valid elements in your selection set.
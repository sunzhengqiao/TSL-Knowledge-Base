# hsb_SIP-HeaderConfiguration.mcr

## Overview
This script automatically configures the framing around openings in SIP (Structural Insulated Panel) walls. It resizes trimmer and king studs to match the full thickness of the SIP panel and splits top/bottom plates to accommodate the modified studs.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D wall elements. |
| Paper Space | No | Not applicable for 2D layouts or sheet views. |
| Shop Drawing | No | Does not generate views or dimensions. |

## Prerequisites
- **Required Entities**: `ElementWall` containing `Beam`, `Sip`, and `Opening` entities.
- **Minimum Beams**: The selected wall element must contain beams (studs/plates) and SIPs to be processed.
- **Required Settings**: None.
- **Wall Setup**: Walls must use standard hsbCAD beam naming conventions (e.g., `_kTrimmerStud`, `_kSFTopPlate`) for correct identification.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or via a custom toolbar icon mapped to this script) → Select `hsb_SIP-HeaderConfiguration.mcr`.

### Step 2: Select Wall Elements
```
Command Line: Select one or More Elements
Action: Click on the wall elements (ElementWall) that contain the openings you wish to configure. Press Enter to confirm selection.
```

### Step 3: Execution
- The script will automatically analyze the selected elements.
- It identifies openings and the adjacent stud banks (specifically groups of 2 or more studs on the left side of an opening).
- It resizes the studs to the SIP thickness and splits the top/bottom plates.
- The script instance will erase itself automatically after processing.

## Properties Panel Parameters
This script does not expose any user-editable properties in the AutoCAD Properties Palette. All logic is based on the geometry of the selected elements.

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Re-runs the configuration logic on the originally selected elements. Use this if the wall geometry changes or if you need to re-apply the framing adjustments. |

## Settings Files
None required.

## Tips
- **Stud Banks**: The script specifically looks for "banks" of studs (groups of 2 or more) adjacent to openings. Single isolated studs may not be processed.
- **Plate Splitting**: The script automatically splits top and bottom plates where they intersect the resized studs. Ensure your wall cleanup routine accounts for these split entities.
- **Non-Destructive Warning**: This script modifies beam widths and splits beam topology. It is recommended to run this on a copy of the design or verify the results before generating production drawings.

## FAQ
- **Q: Why were some studs not resized?**
  **A:** The script logic specifically targets continuous groups of 2 or more studs on the left side of an opening. Single trimmer/king studs or studs on the right side may be skipped depending on the specific wall logic.
- **Q: Can I undo the changes?**
  **A:** Yes, use the standard AutoCAD `UNDO` command immediately after running the script if the results are not as expected.
- **Q: Does this work on standard timber framing or only SIPs?**
  **A:** This script is designed specifically for SIP walls (`Sip` entities) as it calculates stud width based on the SIP panel thickness.
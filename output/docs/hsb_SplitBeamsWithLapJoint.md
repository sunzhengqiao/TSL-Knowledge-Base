# hsb_SplitBeamsWithLapJoint.mcr

## Overview
Automatically splits long timber beams into shorter, transportable segments connected by a stepped lap joint. This tool is useful for breaking down structural members that exceed maximum transport lengths into pieces that can be reassembled on site.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the 3D model. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | Not applicable to 2D drawings. |

## Prerequisites
- **Required Entities**: Elements containing Beams.
- **Minimum Beam Count**: At least 1 beam within the selected elements must exceed the maximum length setting.
- **Required Settings**: None (uses internal script logic).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SplitBeamsWithLapJoint.mcr`

### Step 2: Select Elements
```
Command Line: Select a set of elements
Action: Click on the Elements (or groups) in the model that contain the beams you wish to split. Press Enter to confirm selection.
```

### Step 3: Verify Configuration
After selection, the script will process the beams. If the split logic needs adjustment, select the newly created script instance (or the beams if properties are inherited) and check the Properties Palette (OPM) to ensure `dMaxLength` and `dMinLength` are correct, then recalculate if necessary.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Maximum length | Number | 5200 mm | The target maximum length for individual beam segments. Beams longer than this will be split. |
| Minimum length | Number | 500 mm | The smallest allowable length for the last segment of a beam. Prevents the creation of tiny scrap pieces. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No specific custom context menu options are defined for this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Minimum Length**: Ensure the `Minimum length` property is set higher than 300mm. The script creates a 2-step lap joint with a total engagement depth of 300mm; if the remaining piece is shorter than this, the joint cannot be created correctly.
- **Visual Check**: After running the script, visually inspect the split locations to ensure the lap joints do not interfere with other connections or hardware (like bolts or hinges).
- **Material Handling**: This script is ideal for preparing elements for transport. Use the `Maximum length` setting to match your truck or container capacity.

## FAQ
- **Q: Why didn't my beam split?**
  **A:** Check if the beam length actually exceeds the `Maximum length` setting in the Properties Palette.
- **Q: Can I customize the shape of the lap joint?**
  **A:** No, the joint geometry is hardcoded to a 2-step profile with a 150mm step depth.
- **Q: What happens if my beam is exactly 5250mm long and Max Length is 5200mm?**
  **A:** The script will attempt to split it. It will calculate a split point that ensures the last piece is longer than the `Minimum length` (e.g., 500mm). The split location will be adjusted to accommodate the lap joint geometry.
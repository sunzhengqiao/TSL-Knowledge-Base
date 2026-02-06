# hsb_SplitBlockingBeams.mcr

## Overview
This script splits continuous "dummy" blocking beams (e.g., dwangs) within an element into individual segments. It automatically calculates the valid spaces around openings and intersecting beams to create the necessary blocking pieces.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in 3D Model Space. |
| Paper Space | No | Not supported for detailing views. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: An existing Element (Wall, Floor, or Roof) containing beams.
- **Setup**: The element must contain beams with the specific "Beam code to split" (default is "D") that represent the rough blocking layout.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SplitBlockingBeams.mcr`

### Step 2: Configure Properties (Optional)
```
Action: Before selecting elements, open the Properties Palette (Ctrl+1).
Adjust the "Beam code to split" or "Name of blockings" if your project uses different standards than the default.
```

### Step 3: Select Elements
```
Command Line: Please select Elements
Action: Click on the Wall, Floor, or Roof elements that contain the blocking beams you want to split.
Action: Press Enter to confirm selection.
```

### Step 4: Processing
```
Action: The script will automatically:
1. Identify the beams matching the split code.
2. Calculate cutouts for openings and other structural beams.
3. Create new individual blocking beams.
4. Erase the original rough beams.
5. Remove itself from the drawing.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Beam code to split | Text | D | The code of the existing beams in the element that should be replaced by split segments (e.g., 'D', 'BLOCK'). |
| Name of blockings | Text | BLOCKING | The name assigned to the newly created individual blocking beams for reporting and listing. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom right-click menu options are available for this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies on internal logic and Property Palette inputs; no external settings file is required.

## Tips
- **Minimum Length**: The script ignores blocking segments shorter than 50mm to prevent creating very small, unusable pieces.
- **Beam Code 'B'**: Beams with code 'B' are treated as obstacles (holes) rather than blocking, ensuring they are not accidentally cut or deleted.
- **One-Time Run**: The script instance automatically erases itself after running. Use the AutoCAD `UNDO` command if you need to revert the changes.
- **Openings**: The script automatically detects openings in the element and ensures no blocking is generated inside the void of the opening.

## FAQ
- **Q: The script ran, but no new beams appeared.**
  A: Ensure the element you selected actually contains beams with the specific "Beam code to split" (default is 'D'). If the beams have a different code, update the property in the palette before running.
- **Q: Why are some small gaps not filled with blocking?**
  A: Any calculated segment shorter than 50mm is automatically discarded.
- **Q: Can I use this on curved walls?**
  A: Yes, the script uses the element's coordinate system and profile analysis, making it suitable for complex geometries.
# hsb_CleanupBlocking.mcr

## Overview
This script automatically detects and adjusts blocking beams within wall elements to resolve geometric overlaps with angled top plates. It ensures that blocking fits correctly against angled surfaces (such as those found in vaulted ceilings or roof pitch changes).

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the model environment. |
| Paper Space | No | Not supported in layouts or viewports. |
| Shop Drawing | No | Not intended for shop drawing creation. |

## Prerequisites
- **Required Entities**: Wall Elements (`ElementWallSF`).
- **Minimum Beams**: None, but the selected walls must contain both Blocking beams (`_kSFBlocking`) and Angled Top Plates.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
```
Command Line: TSLINSERT
Action: Browse to and select the file hsb_CleanupBlocking.mcr.
```

### Step 2: Select Wall Elements
```
Command Line: Select one or More Elements
Action: Click on the wall elements in the drawing that contain the blocking you wish to adjust.
```

### Step 3: Execute
```
Action: Press Enter or Right-Click to confirm selection.
Note: The script will automatically process the walls, adjust the blocking geometry where overlaps are detected, and then finish.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script runs transiently and does not expose parameters in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not add specific options to the entity right-click menu. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Batch Processing**: You can select multiple wall elements in a single selection to process an entire floor or section at once.
- **Intersection Threshold**: The script only modifies blocking if the overlap area with the top plate is greater than 5 mm². Small incidental touches may be ignored.
- **Model Space Only**: Ensure you are working in Model Space; attempting to run this in a Paper Space viewport will not function as intended.
- **Transient Tool**: This script does not leave a permanent script object attached to the wall after it finishes; it is a "run once" cleanup tool.

## FAQ
- **Q: Why did some of my blocking not change?**
  **A:** The script only modifies blocking beams where the geometric intersection with an angled top plate is significant (area > 5mm²). If the overlap is very minor, the script preserves the original geometry.
- **Q: Can I use this on individual beams?**
  **A:** No, this tool is designed to work specifically on hsbCAD Wall Elements. It searches inside the element for the relevant blocking and top plates.
- **Q: Does this script work for roof planes?**
  **A:** It is designed for Wall Elements that contain angled top plates (e.g., a wall with an attic truss or a rake wall). It does not generate new roof geometry but cleans up the framing inside the wall.
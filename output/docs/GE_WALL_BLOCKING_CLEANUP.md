# GE_WALL_BLOCKING_CLEANUP

## Overview
Automatically stretches wall blocking beams to fit perfectly against angled top plates (e.g., for vaulted ceilings) within selected wall elements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D wall elements in the model. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required entities**: hsbCAD Wall Elements (`ElementWallSF`) containing both Blocking beams and Angled Top Plate beams.
- **Minimum beam count**: 0 (Script will run but produce no changes if relevant beams are missing).
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Navigate to the location of `GE_WALL_BLOCKING_CLEANUP.mcr`.
3.  Select the file and click **Open**.

### Step 2: Select Wall Elements
```
Command Line: Select one or More Elements
Action: Click on the wall elements in the drawing that contain the blocking you wish to adjust. Press Enter when finished.
```
*Note: The script will automatically process the selected elements. It calculates the intersection between the blocking and the angled top plates and adjusts the blocking height and angle to fit tight against the plate.*

## Properties Panel Parameters
This script does not expose any parameters in the Properties Palette.

## Right-Click Menu Options
This script does not add specific options to the right-click context menu.

## Settings Files
No external settings files are used by this script.

## Tips
- **Proximity Matters**: The script stretches blocking based on geometric intersections. Ensure the blocking is generated relatively close to the angled top plate before running this script.
- **Vaulted Ceilings**: This tool is particularly useful after generating walls with vaulted or pitched roof configurations where standard rectangular blocking would leave gaps at the top.
- **Transient Operation**: This script functions as a "command" rather than a permanent smart object. Once executed, it modifies the geometry and finishes; it does not remain attached to the wall for future updates.

## FAQ
- **Q: Why didn't my blocking change?**
  **A:** Ensure the selected wall elements contain beams classified as "Angled Top Plates" (Left or Right) and "Blocking". If the top plate is flat (horizontal), the script will not make any changes.
- **Q: Can I use this on floor elements?**
  **A:** No, this script is specifically designed for Wall Elements (`ElementWallSF`).
- **Q: Do I need to select individual blocking beams?**
  **A:** No, simply select the entire Wall Element. The script will automatically find and process all relevant blocking beams inside it.
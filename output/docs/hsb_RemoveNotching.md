# hsb_RemoveNotching

## Overview
Automatically detects and removes notches (specifically SeatCut and OpenSeatCut) from selected timber elements where they intersect with other beams within the same element, effectively "healing" the geometry by stretching the beams to fill the voids.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model elements. |
| Paper Space | No | Not designed for 2D layouts. |
| Shop Drawing | No | Does not process views or dimensions. |

## Prerequisites
- **Required Entities**: Elements (containing Beams).
- **Minimum Beam Count**: 1 (functionality relies on intersections between multiple beams).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse to and select `hsb_RemoveNotching.mcr`.

### Step 2: Select Elements
```
Command Line: Please select Elements
Action: Select one or more Element entities in the model that contain intersecting beams you wish to heal. Press Enter to confirm.
```

### Step 3: Automatic Processing
Action: The script will automatically process the selection, stretching beams, removing the notches, and deleting `hsbT-Connection` scripts. The script instance will then remove itself from the drawing.

## Properties Panel Parameters
This script has no editable Properties Panel parameters. All processing is performed automatically based on the geometry selected.

## Right-Click Menu Options
None. This script does not add options to the context menu.

## Settings Files
None. This script operates independently of external settings files.

## Tips
- **Same Element Only**: This script only heals intersections between beams that belong to the **same Element**. It will not process intersections between different Elements.
- **Cleanup**: The script automatically removes any `hsbT-Connection` scripts associated with the processed beams, ensuring your drawing stays clean of invalid connections.
- **Fire and Forget**: Once you select the elements, the script runs and then deletes itself. You do not need to manually remove the script instance afterwards.

## FAQ
- **Q: What types of notches are removed?**
  A: The script specifically targets and removes 'SeatCut' and 'OpenSeatCut' machining operations.
- **Q: Why did the script disappear after I ran it?**
  A: This is intended behavior. The script is designed as a single-use utility; it modifies the geometry and then erases its own instance from the drawing.
- **Q: The script didn't change anything. Why?**
  A: Ensure the beams are in the same Element and that the notches are specifically 'SeatCut' or 'OpenSeatCut'. The script also checks for a significant intersection area (>25mm²) before acting.
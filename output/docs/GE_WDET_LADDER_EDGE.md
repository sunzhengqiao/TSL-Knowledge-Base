# GE_WDET_LADDER_EDGE.mcr

## Overview
Generates horizontal blocking (ladder framing) between two existing vertical studs within a wall element. This is typically used to reinforce wall edges, provide nailing backing for stair stringers, or frame around floor openings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in 3D Model Space. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | Not intended for 2D detailing views. |

## Prerequisites
- **Required Entities**: An existing Wall Element (`ElementWallSF`) containing at least two vertical studs.
- **Minimum Beam Count**: 2 vertical studs (the bounding studs for the blocking).
- **Required Settings**: None. Uses default catalog or properties if available.

## Usage Steps

### Step 1: Launch Script
Command: Run the script via your custom toolbar, macro, or the `TSLINSERT` command selecting `GE_WDET_LADDER_EDGE.mcr`.

### Step 2: Select Wall Element
```
Command Line: Select an element
Action: Click on the wall (Element) where you want to add the ladder framing.
```

### Step 3: Select Insertion Point
```
Command Line: Select an insertion point
Action: Click a point in the empty space between the two vertical studs where you want the blocking to run. 
Note: The script detects the immediate left and right studs based on this click location.
```

## Properties Panel Parameters
*Note: These parameters must be set *before* running the script, as the script instance deletes itself upon completion.*

### Placement Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Start Offset | Number | 600 mm (24") | The vertical distance from the bottom plate/reference point to the center of the first blocking piece. Set to 0 to align tight against the bottom. |
| End Offset | Number | 0 mm (0") | The distance from the top of the studs to the top of the blocking run. Use this to create a clearance gap at the top. |
| Spacing | Number | 600 mm (24") | The on-center vertical distance between consecutive blocking pieces. |

### Material Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Material | Text | SPF | The material code assigned to the generated blocking beams (e.g., SPF, SYP). |
| Grade | Text | #2 | The structural grade code assigned to the generated blocking beams. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script is non-persistent. Once executed, the script logic instance is removed, leaving only the generated beams. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: Script relies on internal defaults and OPM properties; no external settings file is required.

## Tips
- **Stud Selection**: Ensure you click precisely between the two studs you intend to use as boundaries. The script looks for the closest vertical studs to the left and right of your insertion point.
- **Visual Feedback**: After running, the two bounding studs will change color (usually to Yellow) to indicate they are part of this specific detail.
- **Cleanup**: If there is already horizontal blocking in the selected bay, this script will automatically detect and erase it before generating the new ladder framing.
- **Non-Persistent**: Since the script deletes itself after running, you cannot double-click the result later to change the spacing or offsets. You must delete the beams and re-run the script with new settings.

## FAQ
- **Q: Why do I get the error "Cannot find a connecting stud"?**
  A: The script could not locate two vertical studs immediately to the left and right of your insertion point. Ensure you are clicking inside the wall bounds and within a reasonable distance of the studs (less than 10m).
- **Q: Can I edit the spacing after I have created the blocking?**
  A: No. This script generates static geometry and then removes itself from the drawing. To change the spacing, delete the generated blocking beams and run the script again.
- **Q: What happens to the existing blocking between the studs?**
  A: The script creates a "collision body" in the bay and automatically erases any existing horizontal blocking beams in that space before adding the new ones.
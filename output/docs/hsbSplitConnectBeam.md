# hsbSplitConnectBeam.mcr

## Overview
This script allows you to split a single beam into two segments or connect two adjacent beams with a specific gap and cut orientation. It is ideal for creating butt-joint splices, making space for steel connection plates, or managing expansion gaps in timber frames.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates on 3D beam entities. |
| Paper Space | No | Not applicable for 2D drawings. |
| Shop Drawing | No | This is a modeling tool, not a detailing tool. |

## Prerequisites
- **Required entities**: At least one hsbCAD Beam.
- **Minimum beam count**: 1 (to split) or 2 (to connect).
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Run the command `TSLINSERT` and select `hsbSplitConnectBeam.mcr` from the list.

### Step 2: Select Beams
```
Command Line: Select beam(s)
Action: Click on the beam you wish to split, or select multiple beams to connect them.
```

### Step 3: Define Split Location (Single Beam Mode)
*If you selected only one beam, you will be prompted to define the cut location.*

```
Command Line: Select split point
Action: Click a point along the length of the beam where you want the split to occur.
```

*Note: If your construction plane is not vertical relative to the World Coordinate System (WCS), you may see an additional prompt:*

```
Command Line: Select second point
Action: Click a second point to define the vertical plane for the cut.
```

*The beam will automatically split into two separate entities, and a new tool instance will be created at the split location.*

### Step 4: Connection Established (Multi-Beam Mode)
*If you selected two or more beams, the script will automatically search for a second beam that is parallel and aligned with the first one. It will create the connection at the midpoint between the closest ends.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| (A) Gap | Number | 0 | Defines the distance between the two beam ends. Use this to create space for a steel plate or gusset. |
| (B) Stagger Offset | Number | 0 | Offsets the cut location along the beam axis. This is useful for staggering joints in a row of parallel joists (e.g., every second joint shifts slightly). Note: This value resets to 0 after applying the offset. |
| (C) Orientation | Dropdown | Perpendicular | Determines the angle of the cut face. <br>• **Perpendicular**: Cuts square to the beam axis.<br>• **Plumb**: Creates a vertical cut (useful for sloped rafters).<br>• **Horizontal**: Creates a flat level cut. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| ../Join beams | Removes the gap/tool and merges the two beam segments back into a single, continuous beam. |

## Settings Files
- None.

## Tips
- **Joining Beams Quickly**: You can double-click the tool instance in the model to trigger the "Join beams" action instantly.
- **Moving the Split**: Select the tool instance and drag the grip (the insertion point) along the beam axis to move the split location. The beams will stretch automatically to accommodate the move.
- **Visualizing the Gap**: After insertion, the tool draws a circle and line to indicate the center of the connection, making it easy to see where the split occurs.

## FAQ
- **Q: Why did the tool disappear after I selected the beams?**
  **A**: This usually happens if you selected only one beam but did not provide a valid split point, or if you selected multiple beams but the script could not find a second beam that was parallel and aligned correctly.
  
- **Q: Can I use this on non-parallel beams?**
  **A**: No, the script requires beams to be parallel to create a valid connection. If the beams are not parallel, the tool will delete itself.

- **Q: How do I undo a split?**
  **A**: Right-click the tool instance and select "Join beams", or simply double-click the tool. This will merge the segments and remove the tool.
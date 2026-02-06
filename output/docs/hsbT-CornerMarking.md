# hsbT-CornerMarking.mcr

## Overview
This script creates production marker lines on a beam to visually indicate the exact intersection area where a connecting beam meets it (T-connection). It is useful for guiding assembly or verifying fit for cross-beams or joists.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates directly on 3D beam objects. |
| Paper Space | No | Not applicable for 2D layouts or drawings. |
| Shop Drawing | No | Not designed for shop drawing contexts. |

## Prerequisites
- **Required Entities**: Two `GenBeam` elements.
- **Minimum Beam Count**: 2
- **Required Settings**: None.
- **Geometry Requirement**: The two selected beams must physically intersect in the 3D model.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Navigate to the script location and select `hsbT-CornerMarking.mcr`.

### Step 2: Select Marking Beam
```
Command Line: Select marking beams
Action: Click on the intersecting beam (e.g., the cross-beam or joist) that defines the connection area.
```

### Step 3: Select Target Beam
```
Command Line: Select beams to be marked
Action: Click on the main beam (e.g., the wall or post) where you want the corner marks to appear.
```

### Step 4: Adjust Properties (Optional)
1.  Select the newly created script instance in the model.
2.  Open the **Properties Palette** (Ctrl+1).
3.  Modify the **Marker Length** if the default lines are too long or too short.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| |Marker Length| | Number | 30 | Defines the length of the marker line segments. If the intersection edge is long, this creates 'ticks' starting from the corners. If the intersection is short, it may create a continuous line. |

## Right-Click Menu Options
This script does not add custom items to the right-click context menu. Standard hsbCAD options (e.g., Catalog, Save) apply.

## Settings Files
No external settings files or XML dependencies are required for this script.

## Tips
- **Continuous Lines vs. Ticks**: The script automatically determines the drawing style. If the length of the intersection edge is shorter than twice the Marker Length, it draws a continuous line. If it is longer, it draws two "ticks" starting from the corners inward.
- **Visualizing Assembly**: Use these marks on the shop floor to quickly identify where intersecting timbers should be placed without needing to measure.
- **Dynamic Updates**: If you move the beams after inserting the script, the marker lines will update automatically to match the new intersection geometry.

## FAQ
- **Q: I selected the beams, but no lines appeared.**
  A: Ensure the two beams actually touch or overlap in the 3D model. The script calculates geometry based on physical intersections. Check that you selected the correct "Marking Beam" (the cross piece) and "Beam to be marked" (the main piece).
- **Q: How do I make the corner marks longer?**
  A: Select the script instance and increase the **Marker Length** value in the Properties Palette. If you increase it enough, the two separate ticks will merge into a single continuous line.
- **Q: Can I use this to mark multiple beams at once?**
  A: The current workflow prompts for a single target beam. To mark multiple beams, you must run the script again for each pair or use the copy/paste functionality if the geometry is identical.
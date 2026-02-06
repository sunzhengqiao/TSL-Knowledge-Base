# hsb_IntegrateToolings

## Overview
This script integrates the volume of specific "tool" beams into multiple target beams, creating machining cuts (voids or slots) wherever they intersect. It allows you to use standard beam geometry to define complex cut shapes and apply them to structural members automatically.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script is designed for 3D model processing only. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This operates on the 3D model, not drawing views. |

## Prerequisites
- **Required Entities**: At least one "Tool" beam (to define the cut) and at least one target beam (to receive the cut).
- **Minimum Beam Count**: 2 (1 target, 1 tool).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT` → Select `hsb_IntegrateToolings.mcr`

### Step 2: Select Target Beams
```
Command Line: Select beams
Action: Click on the beams you want to machine (cut). Press Enter to confirm selection.
```
*These are the structural beams that will have material removed.*

### Step 3: Select Tool Beams
```
Command Line: Select tools
Action: Click on the beams that will act as the cutting tools. Press Enter to confirm selection.
```
*The script will create a separate instance for each tool selected, applying its shape to all target beams selected in Step 2.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Modify section for CnC | Dropdown | No | Determines if the tool projects infinitely through the target beam (Yes) or cuts strictly the volume of the tool beam (No). Also changes the visualization color of the tool (Red for No, White for Yes). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add beams | Allows you to select additional target beams to apply the current tool cut to. |
| Remove beams | Allows you to select target beams to remove the tool cut from. |

## Settings Files
None. This script does not rely on external XML settings files.

## Tips
- **Visualization:** The tool beam is visualized with a centerline. If the line is **Red**, the "Modify section for CnC" is set to "No" (strict volume cut). If it is **White**, it is set to "Yes" (projection cut).
- **Dynamic Updates:** If you move or rotate the tool beam using standard AutoCAD grips or commands, the cut on the target beams will update automatically.
- **Through-Cuts:** Use the "Modify section for CnC" = "Yes" option if you want a tool to cut completely through a beam profile, regardless of the tool's actual length in that direction.

## FAQ
- **Q: What happens if I delete the tool beam?**
  - A: The script instance detects that the tool beam is no longer valid and erases itself automatically, removing the cuts.
- **Q: Can I use one tool to cut multiple different beams?**
  - A: Yes. During insertion, select all the beams you want to cut as "Target Beams," then select your "Tool." The script will apply that tool to all selected targets.
- **Q: What is the difference between "No" and "Yes" for Modify section for CnC?**
  - A: **No** acts like a physical cookie cutter—only the volume where the tool physically exists is removed. **Yes** acts like an infinite laser—the tool projects through the target beam in its free local directions, useful for drilling through-holes or slots that go past the tool's length.
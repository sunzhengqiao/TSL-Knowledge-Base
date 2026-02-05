# LapJoint.mcr

## Overview
Automates the creation of a lap joint (cross joint) between two intersecting timber beams. It generates a pocket cut in the female beam and a corresponding notch on the male beam.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates in 3D model space. |
| Paper Space | No | Not supported for 2D layouts. |
| Shop Drawing | No | Does not generate 2D views directly. |

## Prerequisites
- **Required entities**: 2 GenBeams (structural timber beams).
- **Minimum beam count**: 2 (must intersect physically and cannot be parallel).
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `LapJoint.mcr` from the file browser.

### Step 2: Select Male Beam
```
Command Line: Select male beam
Action: Click the beam that you want to notch (the end will be cut to fit into the other beam).
```

### Step 3: Select Female Beam
```
Command Line: Select female beam
Action: Click the intersecting beam that you want to create the pocket (slot) in.
```

### Step 4: Configure Properties (If applicable)
```
Action: If you are not inserting from a predefined catalog entry, the Properties Palette will appear.
Adjust settings such as Axis Offset or Gaps if necessary, then press OK.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Axis Offset | Number | 0 | Moves the entire joint assembly vertically relative to the male beam's axis. Use to center the joint or align it to the top/bottom. |
| Max. Female Depth | Number | 110 | Limits the maximum depth of the pocket cut in the female beam. If the joint is deeper than this, the script automatically adjusts the Axis Offset. Set to 0 to disable. |
| Male (Gap) | Number | 0 | Adds clearance (gap) to the width of the male beam notch to ensure it fits easily into the pocket. |
| Female (Gap) | Number | 0 | Adds clearance (gap) to the width of the female beam pocket. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Swap Sides | Swaps the roles of the two beams. The Male beam becomes the Female beam (receives the pocket) and the Female beam becomes the Male beam (receives the notch). This can also be triggered by double-clicking the script instance. |

## Settings Files
- No specific settings files are required for this script.

## Tips
- **Visual Adjustment**: After insertion, select the script and drag the **Grip Point** (square handle at the intersection) to visually adjust the vertical position of the joint.
- **Prevent Deep Cuts**: Use the **Max. Female Depth** property if you are worried about structural integrity. The script will automatically shift the joint up or down to keep the cut within the safe limit.
- **Parallel Beams**: The script does not support parallel beams. If selected by mistake, the script will delete itself.
- **Gap Tolerance**: Add a small value (e.g., 1-2mm) to the Gap properties if you need to account for painting thickness or easier assembly.

## FAQ
- **Q: I selected the wrong beam as the "Male" beam. Do I need to delete and start over?**
  - A: No. Simply double-click the script instance or right-click and select "Swap Sides" to invert the roles of the beams.
- **Q: Why did the joint move automatically after I changed the beam size?**
  - A: If you have a value set for "Max. Female Depth," the script automatically adjusts the "Axis Offset" to ensure the pocket does not cut too deep into the beam.
- **Q: The script disappeared after I selected the beams.**
  - A: This usually happens if the beams are parallel or do not physically intersect in 3D space. Check your geometry and try again.
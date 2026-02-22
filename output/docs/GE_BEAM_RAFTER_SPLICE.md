# GE_BEAM_RAFTER_SPLICE

## Overview
Splits one or more selected timber beams (typically rafters) at a user-defined midpoint, creating two overlapping segments that represent a splice joint. The lower segment is automatically offset sideways by the beam depth so both halves are visible and ready for connection detailing.

| Property | Value |
|----------|-------|
| Script Type | O (Object, self-erasing command) |
| Version | 1.3 (2012-05-15) |
| Author | David Rueda |
| Beams Required | 0 (user selects during execution) |

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Run in the 3D model environment. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | Modelling tool only. |

## Prerequisites
- At least one existing timber beam (GenBeam) in the model.
- The splice midpoint must be far enough from both beam ends to fit the full overlap length.

## Usage Steps

### Step 1 -- Launch Script
Command: `TSLINSERT` then select `GE_BEAM_RAFTER_SPLICE.mcr`.

### Step 2 -- Select Beams
```
Prompt: Select beam(s) to splice
Action: Click on one or more beams. Press Enter to confirm the selection.
        Multiple beams can be selected for batch processing.
```

### Step 3 -- Pick Splice Midpoint
```
Prompt: Select splice midpoint
Action: Click a point along the beam length where the centre of the overlap
        should be. The point is projected onto the beam axis automatically.
```

### Step 4 -- Indicate Offset Direction
```
Prompt: Offset direction for new beams
Action: Click a point to the side of the beam. This tells the script which
        direction the lower splice piece should be displaced.
```

### Step 5 -- Enter Overlap Length
```
Prompt: Set splice overlap <2'-0''>
Action: Type the overlap length (e.g. 600 for 600 mm, or 24 for 24 inches)
        and press Enter. Press Enter without typing to accept the default
        value of 610 mm (2'-0").
```

After confirming, the script processes each selected beam, splits it, offsets the lower piece, and then removes itself from the drawing.

## Properties Panel Parameters
This script does not create persistent OPM properties. All input is collected through command-line prompts during insertion.

## Right-Click Menu Options
None. The script executes once and erases itself.

## Settings Files
None required.

## How It Works
1. The splice midpoint is projected perpendicularly onto the beam axis.
2. Two cut planes are placed at midpoint +/- half the overlap length.
3. The beam is split into two pieces at these planes.
4. The script compares the Z-height of each piece's centre point to determine which one is lower.
5. The lower piece is moved sideways (perpendicular to the beam axis) by a distance equal to the beam depth.
6. When multiple beams are selected, the operation repeats for each beam using the same midpoint, direction, and overlap length.

## Tips
- The default overlap of 610 mm (2'-0") is a common dimension for rafter splice joints.
- If the overlap extends beyond the beam ends, the script reports "ERROR: There is no room for splice on selected point" and skips that beam while continuing to process any remaining beams.
- The offset direction click only needs to indicate the general side; the script resolves it to the beam's local Y-axis.
- The displacement distance equals the beam depth, not the beam width.
- Use the standard AutoCAD `UNDO` command to revert all changes if needed.

## FAQ
**Q: Why did I get "ERROR: There is no room for splice on selected point"?**
A: The overlap length exceeds the available beam length from the chosen midpoint. Pick a point closer to the beam centre, or enter a smaller overlap value.

**Q: The script disappeared after running. Is that normal?**
A: Yes. This is a one-shot command script. After splitting the beams it erases itself. The resulting beam segments remain in the model.

**Q: Can I splice multiple beams at once?**
A: Yes. Select all target beams in Step 2. They will all be split at the same projected midpoint with the same overlap and offset direction.

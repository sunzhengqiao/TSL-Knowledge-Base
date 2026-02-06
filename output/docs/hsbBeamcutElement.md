# hsbBeamcutElement.mcr

## Overview
This script automatically applies volumetric cuts (beamcuts) to structural timber beams based on the geometry of a selected "tooling" beam. It allows you to define complex cut shapes (like notches or recesses) using a template beam and apply them to intersecting beams with optional dimensional gaps.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script is designed for 3D model manipulation. |
| Paper Space | No | Not applicable for detailing views. |
| Shop Drawing | No | This is a 3D modeling tool, not a 2D annotation tool. |

## Prerequisites
- **Required Entities**: 
  - At least one "Tooling Beam" (a standard GenBeam used to define the cut shape).
  - Target structural beams (GenBeam) to receive the cut.
- **Minimum Beam Count**: 1 (the tooling beam).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT`
**Action**: Browse and select `hsbBeamcutElement.mcr`, then click Open.

### Step 2: Configure Properties
**Action**: The Properties dialog appears automatically upon insertion.
- **Orientation**: Choose how target beams are selected.
  - `All`: Cuts all beams intersecting the tool.
  - `bySelection`: Allows you to manually pick specific beams.
  - `Parallel` / `Not parallel`: Filters based on beam direction.
  - `perpendicular` / `Not perpendicular`: Filters based on angle.
- **Gap**: Define a clearance value (default is 2mm).
**Action**: Click OK to proceed.

### Step 3: Select Tooling Beam
```
Command Line: |Select tooling beams|
Action: Click on the beam that defines the shape of the cut (the "tool"). Press Enter to confirm.
```

### Step 4: Select Target Beams (Conditional)
*This step depends on the "Orientation" setting and whether the tooling beam belongs to an Element.*

**Scenario A: Orientation set to 'bySelection'**
```
Command Line: |Select beams to be milled|
Action: Click the specific beams you want to cut. Press Enter to confirm.
```

**Scenario B: Tooling beam is loose (not in an Element) and Orientation is NOT 'bySelection'**
```
Command Line: |Select element or beams to be milled|
Action: Select the host Element or specific beams to define the scope of the operation.
```

*If the tooling beam is part of an Element and Orientation is not 'bySelection', the script automatically processes the relevant beams within that Element.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Orientation | dropdown | All | Specifies which beams to cut based on their relationship to the tooling beam. Options include All, bySelection, Parallel, Not parallel, perpendicular, Not perpendicular. |
| Gap | number | 2 | Defines an additional clearance around the cut in all directions (mm). Useful for ensuring loose fits for steel plates or tolerances. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add Beams | Prompts you to select additional beams to be added to the milling list. (Also available by Double-Clicking the script instance). |
| Remove Beams | Prompts you to select beams currently in the list to remove them from the milling operation. |

## Settings Files
- No specific settings files are required for this script.

## Tips
- **Use "bySelection" for precision**: If you are working in a congested area and only want to cut specific beams, set Orientation to `bySelection` to avoid accidental cuts.
- **Splitting Tool Beams**: If you split the tooling beam using standard hsbCAD splitting functions, the script will automatically clone itself to the new segments.
- **Visualizing Cuts**: The script draws axis lines to indicate the range of the cut.
- **Auto-Deletion**: If the script calculates that no beams intersect the tooling volume, it will automatically delete itself to keep the drawing clean.

## FAQ

**Q: What happens if I change the size of the tooling beam after insertion?**
**A:** The script is dynamic. Stretching or modifying the tooling beam using AutoCAD grips will trigger an update, recalculating the cut size and intersections immediately.

**Q: Why did the script instance disappear after I moved the tooling beam?**
**A:** The script automatically purges itself if it finds no beams intersecting the tooling volume. If you moved the tool away from the target beams, the script detected "nothing to cut" and removed itself.

**Q: Can I use this to create a recess for a steel plate?**
**A:** Yes. Draw a beam representing the steel plate dimensions as your "Tooling Beam". Set the `Gap` property to 0 (or a small tolerance if needed) and apply the script. This will carve the exact shape out of the surrounding timber.

**Q: The 'Orientation' filter isn't working as expected.**
**A:** Ensure your tooling beam is part of an Element. If the tooling beam is a "loose" beam (no Element association), the script forces a manual selection workflow or requires you to select the Element context first.
# hsbPurgeBeamcuts

## Overview
Removes obsolete machining definitions (beamcuts) from selected beams, sheets, or panels. This utility cleans up "ghost" cuts that remain referenced to an element but no longer physically intersect it.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required. The script checks 3D intersections. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | This script operates on 3D model elements only. |

## Prerequisites
- **Required Entities**: At least one GenBeam, Sheet, or Panel entity.
- **Minimum Beam Count**: 1 (You must select an element to process).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Navigate to the script location and select `hsbPurgeBeamcuts.mcr`.
3. Click **Open**.

### Step 2: Select Elements
```
Command Line: Select beam(s), sheet(s) or panel(s)
Action: Click on the beams, sheets, or panels you wish to clean.
```
*Note: You can select multiple elements at once. Press **Enter** to confirm your selection.*

### Step 3: Review Results
The script will immediately process the selection.
- The command line will display a report indicating how many tools were checked and how many invalid connections were removed.
- The script instance will automatically erase itself from the drawing upon completion.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script is a transient utility. It runs once and erases itself; therefore, there are no editable properties in the Properties Panel. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | No context menu options are available. The script does not remain in the drawing to be selected. |

## Settings Files
No external settings files are used by this script.

## Tips
- **Post-Edit Cleanup**: Use this script after significant model modifications, such as moving walls or deleting adjacent elements, to ensure your production data does not contain cuts that no longer exist.
- **Selection Efficiency**: You can window select a large group of elements to process multiple beams at the same time.
- **Undo**: If you accidentally remove cuts you wanted to keep, you can use the standard AutoCAD `UNDO` command immediately after running the script.

## FAQ
- **Q: Where did the script go after I used it?**
  - A: This script is designed to be a "run-and-done" utility. It automatically erases itself from the drawing after finishing its task to keep your drawing clean.

- **Q: Does this script delete the actual beam or panel?**
  - A: No. It only removes the *machining links* (cuts) that are no longer valid. It does not delete the structural elements themselves.

- **Q: Why do I have "ghost" cuts?**
  - A: This often happens if you move a beam that was previously cut by another element, or if you delete a wall that had a window cutout. The machining definition remains linked to the beam even if the geometry causing the cut is gone.
# GE_BEAM_RIDGE_SPLICE.mcr

## Overview
This script automates the creation of ridge splices for timber beams. It cuts selected beams at a specified midpoint to create an overlapping joint and adds reinforcement flanges (side beams) to the splice area.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D beam geometry |
| Paper Space | No | Not applicable |
| Shop Drawing | No | Not applicable |

## Prerequisites
- **Required Entities**: At least one Timber Beam (GenBeam) in the model.
- **Minimum Beam Count**: 1.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
1. Run the command `TSLINSERT`.
2. Browse to and select `GE_BEAM_RIDGE_SPLICE.mcr`.
3. Click **Open**.

### Step 2: Select Beams
```
Command Line: Select beam(s) to splice
Action: Click on the beam(s) you wish to modify. You can select multiple beams.
```
*Press Enter to confirm selection.*

### Step 3: Define Splice Location
```
Command Line: Select splice midpoint
Action: Click in the drawing to specify the center point of the splice along the beam.
```
*Ensure the point is located sufficiently far from the beam ends to allow for the overlap.*

### Step 4: Set Overlap Distance
```
Command Line: Set splice overlap <2'-0">
Action: Type a numeric value for the overlap length and press Enter.
```
*If you leave this blank or enter a non-numeric value, the script defaults to **2'-0" (610mm)**.*

## Properties Panel Parameters
There are no editable properties in the AutoCAD Properties Palette for this script. All inputs are collected via the command line during insertion.

## Right-Click Menu Options
No specific right-click menu options are provided by this script instance. The script runs once and erases itself upon completion.

## Settings Files
No external settings files are used by this script.

## Tips
- **Default Overlap**: If you frequently use the same overlap length, you can simply press Enter at the prompt to accept the default (2'-0").
- **Beam Length**: Ensure the beam is long enough to accommodate the splice. If the selected midpoint is too close to the end of the beam, the script will report an error: "There is no room for splicing beam on selected point."
- **Multiple Beams**: You can select multiple beams in Step 2 to apply the same splice configuration to all of them simultaneously.
- **Z-Aware**: The script correctly handles sloped (ridge) beams by determining the high and low points based on World Z coordinates.

## FAQ
- **Q: What happens if I enter a negative number for the overlap?**
  - A: The script will detect this, report "Length must be positive value," and erase the instance without making changes.

- **Q: Can I undo the splice?**
  - A: Yes, use the standard AutoCAD `UNDO` command immediately after running the script to revert the beam changes.

- **Q: Why did my beam not get spliced?**
  - A: Check the command line for errors. The most common reason is that the selected midpoint was too close to the end of the beam, leaving no room for the overlap.
# RafterCutEnd.mcr

## Overview
Creates a complex stepped or bird's-mouth style cut at the end of a rafter or beam. This script generates two distinct horizontal cuts connected by a sloped surface, useful for seating rafters on top plates or creating specific notches.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be run in the 3D model to modify beam geometry. |
| Paper Space | No | Not designed for 2D drawings or viewports. |
| Shop Drawing | No | Does not generate 2D views or dimensions. |

## Prerequisites
- **Required Entities**: At least one `GenBeam` (General Beam) present in the model.
- **Minimum Beam Count**: 1.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT`
**Action**: Browse to the script location and select `RafterCutEnd.mcr`.

### Step 2: Configure Cut Parameters
**Action**: A dialog or property palette appears upon insertion. Enter the dimensions for the cut:
- **Main Depth**: The vertical depth of the first cut from the top of the beam.
- **Main Length**: The horizontal length of the first cut.
- **Second Depth**: The vertical depth of the second (seat) cut.
- **Second Length**: The additional horizontal extension of the second cut.
Confirm the values to proceed.

### Step 3: Select Beams
```
Command Line: Select one or more beams
```
**Action**: Click on the beam(s) you wish to modify in the 3D model. Press `Enter` to confirm selection.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Main Depth | Number | 50 mm | Vertical depth of the primary cut measured from the top surface. |
| Main Length | Number | 200 mm | Horizontal distance of the primary cut from the beam end. |
| Second Depth | Number | 10 mm | Vertical depth of the secondary cut (seat height). |
| Second Length | Number | 100 mm | Additional horizontal length of the secondary cut. |

## Right-Click Menu Options
None. The script does not add custom items to the context menu.

## Settings Files
None. This script operates independently of external XML or settings files.

## Tips
- **Modify Existing Cuts**: You can change the dimensions at any time by selecting the script instance in the model and updating the values in the **Properties (OPM)** palette.
- **Remove Cuts**: Setting a Depth value to `0` will skip that specific cut, allowing you to create simple notches or just a sloped cut.
- **Visual Reference**: The script draws 3D crosshairs at the intersection of the first depth and length to help visualize the corner point.

## FAQ
- **Q: Can I move the cut to the other end of the beam?**
  A: No. Moving the script instance via grips has no effect; the script automatically snaps the cut geometry to the beam's start face. To cut the other end, you must use a different tool or script designed for that purpose.
- **Q: How do I create a simple 90-degree cut?**
  A: Set the "Second Depth" and "Second Length" to `0`. This will generate only the first perpendicular cut.
- **Q: Why did my beam disappear?**
  A: The script generates a cutting operation. If the cut dimensions exceed the size of the beam, the beam geometry might be completely removed. Check the dimensions in the Properties panel and reduce them to fit within the beam's physical size.
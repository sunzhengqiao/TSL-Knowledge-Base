# HVAC-P.mcr

## Overview
This script connects two parallel HVAC or duct beams, either merging them if they have identical profiles or creating a reduction transition piece between different sizes. It also allows splitting a single beam into two segments at a specific point.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script manipulates 3D beam geometry. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required entities:** GenBeam (representing HVAC ducts).
- **Minimum beam count:** 1 (to split) or 2 (to connect).
- **Required settings files:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HVAC-P.mcr`

### Step 2: Select Beams
```
Command Line: |Select 2 beam(s) to connect or 1 beam to split|
Action: Select either 1 or 2 beams in the model.
```

### Step 3: Define Split Location (Conditional)
*This step only appears if you selected 1 beam in Step 2.*
```
Command Line: |Select split location|
Action: Click on the selected beam to define the exact point where the beam should be divided.
```

### Step 4: Automatic Processing
- **If connecting 2 beams:** The script checks if they are parallel and aligned. If the profiles are different, it generates a 3D transition body. If they are identical, it prepares a join function.
- **If splitting 1 beam:** The script cuts the beam at the selected point and manages the resulting segments.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script has no user-editable properties in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Join | Merges the two connected beams into a single entity and removes this script. Only available if the beams have identical dimensions. Can also be triggered by double-clicking the connection. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Alignment Tolerance:** Ensure the two beams you want to connect are parallel and roughly in line. If the offset is too large, the script will display an error ("beams are not in line") and erase itself.
- **Modifying Connections:** You can use AutoCAD grips to stretch or move the connected beams. The script will automatically recalculate and resize the reduction piece to fit the new geometry.
- **Splitting:** Use this script as a quick way to break a long duct run into two separate segments without manually trimming.

## FAQ
- **Q: Why did the script disappear immediately after I selected the beams?**
  - A: The beams likely failed the validation check. Ensure they are parallel. Check the command line for specific errors such as "HVAC-P: beams are not in line" or "beams are not parallel."
- **Q: How do I remove the transition piece and make the beams one single duct?**
  - A: You must change the beam profiles to be identical (same width and height). Once identical, right-click the connection and select "Join" to merge them.
- **Q: Can I change the angle of the reduction?**
  - A: The reduction geometry is automatically calculated based on the difference in size between the two beams and their positions. To change the taper angle, adjust the size of the beam profiles or the distance between them.
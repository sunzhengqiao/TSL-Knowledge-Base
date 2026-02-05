# HSB_T-SetBeamUcs.mcr

## Overview
This script re-defines the local coordinate system (UCS) orientation of selected beams based on three points picked in 3D space. It is typically used to correct the orientation of imported beams or to ensure the correct local faces (Top/Side) are aligned for machining and material mapping.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in 3D Model Space. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required entities**: At least one existing Beam.
- **Minimum beam count**: 1.
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_T-SetBeamUcs.mcr`

### Step 2: Select Beams
```
Command Line: Select beam(s)
Action: Click on the beam(s) you wish to reorient and press Enter.
```

### Step 3: Define Origin
```
Command Line: Select base point
Action: Pick a point in 3D space to serve as the Origin (0,0,0) for the new local system.
Note: This defines the reference point for the axes calculation.
```

### Step 4: Define X-Axis
```
Command Line: Select point for X-axis
Action: Pick a second point. The vector from the Origin to this point defines the new Local X-Axis (usually the length direction).
```

### Step 5: Choose Axis Definition Method
```
Command Line: <Enter> to select point for Y-Axis | <Z> to select Z-axis
Action: Make a choice on the command line:
- Press Enter to define the Y-Axis (Cross-section/Depth).
- Type Z and press Enter to define the Z-Axis (Top/Width).
```

### Step 6A: Define Y-Axis (If you pressed Enter)
```
Command Line: Select point for Y-axis
Action: Pick a point. This defines the Local Y-Axis. The Z-Axis will be calculated automatically.
```

### Step 6B: Define Z-Axis (If you typed Z)
```
Command Line: Select point for Z-axis
Action: Pick a point. This defines the Local Z-Axis. The Y-Axis will be calculated automatically.
```

### Step 7: Completion
The script will automatically replace the original beams with new entities having the calculated orientation. The script instance then erases itself.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not expose any parameters to the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script has no custom context menu options. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Reorientation vs. Movement**: This script changes the *orientation* of the beam's local axes (rolling/pitching the profile) rather than moving the beam in world space.
- **Defining "Top"**: If you specifically need to tell the system which face is the "Top" face, use the **<Z>** option in Step 5. This is common for correcting beams where the top is rotated 90 degrees.
- **Right-Hand Rule**: The script calculates the third axis automatically using the Right-Hand Rule.
- **Entity Replacement**: The script technically deletes the old beam and creates a new one. Ensure your update/rename rules are active if you rely on specific element names persisting.

## FAQ
- **Q: Why did my beam change names or lose specific data?**
  **A:** The script works by deleting the original beam and creating a new one with the correct orientation. Most standard attributes (Material, Layer) are copied, but custom internal links or IDs might need to be reassigned depending on your hsbCAD configuration.
- **Q: Can I use this to straighten a crooked beam?**
  **A:** No. This script changes the local coordinate system (rotation of the cross-section), not the geometry (centerline) of the beam.
- **Q: What happens if I only select one point for the X-axis?**
  **A:** The script requires a valid definition of at least two axes to calculate the orientation. If the process is aborted before the Y or Z axis is defined, no changes will be made.
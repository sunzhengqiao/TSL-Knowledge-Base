# DoveTail.mcr

## Overview
This script creates a dovetail connection (tenon and mortise) between two parallel structural beams. It supports both automatic connection generation for multiple intersections and manual placement for specific beam pairs, reverting to a simple cut if dimensions are insufficient.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script works only in the 3D Model environment. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | This is a modeling tool, not a detailing tool. |

## Prerequisites
- **Required Entities:** Two Structural Beams (`GenBeam`).
- **Minimum Beam Count:** 2 beams.
- **Required Settings:** None required.
- **Geometry Constraint:** Beams must be parallel to each other.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `DoveTail.mcr`

### Step 2: Select Beams
```
Command Line: Select beams:
Action: Click on the desired beam(s). You have two modes:
  • Mode A (Launcher): Select 1 beam. The script will auto-detect all intersecting beams, create connections for them, and then delete itself.
  • Mode B (Direct): Select 2 beams. The script will create a connection specifically between these two beams.
```

### Step 3: Position Connection (If applicable)
```
Command Line: Specify insertion point:
Action: Click to place the connection reference point. By default, this is usually at the intersection of the beams.
```

### Step 4: Adjust Parameters
```
Action: Select the inserted script instance and open the Properties Palette (Ctrl+1). Adjust dimensions (X, Y, Z) and Angle (Alfa) to define the dovetail geometry.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **dOffset** | Double | 0.0 | Moves the connection point along the beam axis. |
| **XWidth** | Double | Variable | The horizontal width of the dovetail tenon. |
| **YHeight** | Double | Variable | The vertical height of the dovetail tenon. |
| **ZDepth** | Double | Variable | The depth of the cut/penetration into the material. |
| **Alfa** | Double | Variable | The angle of the dovetail sides (slope). |

### Behavior Note
If **XWidth**, **YHeight**, or **ZDepth** are set to zero or are too small, the script automatically switches from a Dovetail connection to a simple Cut/Stretch plane.

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Recalculate** | Updates the connection geometry based on current beam positions and property values. |
| **Erase** | Deletes the script instance. Note: If the "Launcher" mode was used, the instance may erase itself automatically after processing. |

## Settings Files
- **Filename:** None.
- **Location:** N/A.
- **Purpose:** This script uses hardcoded logic and does not require external XML settings files.

## Tips
- **Batch Processing:** To apply dovetails to all intersections along a long beam, select only that single beam during insertion. The script will handle the rest automatically.
- **Switching to Cut:** If you want a simple butt joint instead of a dovetail, set the **XWidth** to `0` in the properties.
- **Keyholes:** The script automatically adds a keyhole to the female part of the dovetail if the vertical relative position of the beams requires it.
- **Moving the Joint:** Use the grip point (`_Pt0`) to drag the connection along the beam. It will stop automatically when it reaches the end of the beam overlap.

## FAQ
- **Q: I selected one beam and the script disappeared. Why?**
  A: This is normal behavior for "Launcher Mode." The script detected valid intersections, created the actual connection scripts for them, and deleted the temporary launcher instance.
- **Q: Why does the tool say "Only parallel connection supported"?**
  A: The geometric calculations for a dovetail in this script require the beams to be parallel. Non-parallel connections are not supported.
- **Q: How do I change a dovetail back to a straight cut?**
  A: In the Properties Palette, set the **XWidth**, **YHeight**, or **ZDepth** to `0`. The tool will update to a simple cut plane.
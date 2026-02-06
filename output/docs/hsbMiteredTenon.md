# hsbMiteredTenon.mcr

## Overview
This script automates the creation of timber tenon joints (mortise and tenon) for connecting two beams. It supports both mitred and parallel connections, allowing users to define geometry, offsets, and machining tolerances for precise wood-to-wood joints.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D beam entities. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: 
  - 2 Beams (existing), OR
  - 1 Beam (which the script will split into two segments at the insertion point).
- **Minimum Beam Count**: 1 (Script will split it) or 2.
- **Required Settings**: None specific (uses standard hsbCAD settings).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbMiteredTenon.mcr` from the file dialog.

### Step 2: Select Beams
```
Command Line: Select 1 or 2 beam(s)
Action: Click on the beams you wish to connect.
```
- **Option A**: Select two existing beams that intersect or meet.
- **Option B**: Select a single beam that you want to split and join.

### Step 3: Define Split Point (If only 1 beam selected)
```
Command Line: Select insertion point for the tenon connection.
Action: Click on the selected beam where you want the joint to occur.
```
*Note: The script will automatically split the single beam into two segments at this location.*

### Step 4: Configure Parameters
The Properties Palette will appear automatically. Adjust the dimensions, orientation, and tolerances as needed. The joint updates in real-time.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Geometry** | | | |
| Width | Number | 0 | The width (thickness) of the tenon tongue. |
| Depth | Number | 0 | The length of the tenon (penetration depth into the female beam). |
| Shape | Dropdown | Rectangular | Profile of the tenon corners: Rectangular, Round, or Rounded. |
| **Alignment** | | | |
| Offset 1 | Number | 0 | Setback distance from the start of the tenon. |
| Offset 2 | Number | 0 | Setback distance from the end of the tenon. |
| Offset from Axis | Number | 0 | Additional translation of the tenon along the joint axis. |
| Orientation | Dropdown | Parellel to female beam | Sets the tenon rotation relative to the female beam (Parallel or Perpendicular). |
| **Tolerance** | | | |
| Left | Number | 0 | Clearance (play) added to the left side of the mortise. |
| Right | Number | 0 | Clearance (play) added to the right side of the mortise. |
| Tolerance on depth | Number | 0 | Gap added to the depth of the mortise (prevents bottoming out). |
| Gap on length | Number | 0 | Tolerance added to the length of the cut (accounts for saw kerf). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Side | Swaps the roles of the two beams. The beam containing the tenon becomes the mortise beam, and vice versa. |

## Settings Files
- **Filename**: None specified.
- **Location**: N/A
- **Purpose**: This script relies on manual entry via the Properties Palette; no external settings file is required.

## Tips
- **Splitting Beams**: If you need to create a joint in the middle of a long continuous beam, select only that single beam during insertion. The script will prompt you to pick a split point.
- **Orientation**: Use the **Orientation** property if the tenon is being cut in the wrong direction relative to the grain or layout.
- **Tolerances**: If the joint is too tight for physical assembly, increase the **Tolerance on depth** or **Left/Right** values to create necessary clearance.
- **Visualizing**: The script draws display lines in the model to show exactly where the tenon starts and ends.

## FAQ
- **Q: Why did the script disappear after I inserted it?**
  A: The script requires two beams to intersect properly to create a valid tenon. If the beams do not overlap correctly or if the resulting tenon dimensions are invalid (e.g., negative length), the script will self-destruct. Ensure your beams intersect with sufficient volume.
  
- **Q: The tenon is on the wrong beam. How do I fix it without deleting and redoing it?**
  A: Right-click on the script instance in the model (or select the script entity) and choose **Flip Side** from the context menu. You can also double-click the script to trigger this action.

- **Q: Can I use this on non-90 degree connections?**
  A: Yes, the script is designed to handle both parallel (in-line) and mitred (angled) connections. It automatically calculates the intersection geometry.
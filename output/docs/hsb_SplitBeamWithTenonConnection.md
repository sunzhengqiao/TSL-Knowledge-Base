# hsb_SplitBeamWithTenonConnection.mcr

## Overview
This script splits a selected beam into two segments and creates a Tenon and Mortice connection between them. It also configures angled cuts and automatically places drill holes for fasteners.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the 3D model. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This script modifies the physical beam model, not drawings. |

## Prerequisites
- **Required Entities**: At least one `GenBeam` (General Beam) must exist in the model.
- **Minimum Beam Count**: 1.
- **Required Settings**: None required (defaults are built-in).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SplitBeamWithTenonConnection.mcr` from the list.

### Step 2: Configure Parameters (Optional)
*If a catalog preset is not selected, a dialog may appear allowing you to pre-configure dimensions before selecting the beam.*

### Step 3: Select Beam
```
Command Line: Pick a beam
Action: Click on the beam you wish to split and connect.
```

### Step 4: Select Split Point
```
Command Line: Pick a point
Action: Click along the length of the selected beam where you want the split/Tenon connection to occur.
```

### Step 5: Modify Properties (Post-Insertion)
*After insertion, select the script instance (usually visible as coordinate axes near the cut) to edit dimensions in the Properties Palette.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Tenon** | | | |
| Tenon height | Number | 100.0 | Height of the tenon projection. |
| Tenon width | Number | 50.0 | Width of the tenon projection. |
| Tenon Offset | Number | 0.0 | Adjusts the position of the tenon. |
| **Mortice** | | | |
| Mortice height | Number | 100.0 | Height of the mortice slot. |
| Mortice width | Number | 50.0 | Width of the mortice slot. |
| Offset | Number | 30.0 | Depth offset of the mortice cut. |
| **General** | | | |
| Angle | Number | 10.0 | The angle of the cut on the beam ends. |
| Flip side | Dropdown | No | Swaps the Tenon and Mortice to the opposite beam segments. |
| **Drill distribution** | | | |
| Diameter | Number | 16.0 | Diameter of the drill holes. Set to 0 to disable holes. |
| Distance from edge | Number | 72.0 | Offset of the first drill row from the beam edge. |
| Horizontal distance between holes | Number | 36.0 | Spacing between drill holes along the X-axis. |
| Vertical distance between holes | Number | 36.0 | Spacing between drill holes along the Y-axis. |
| Pressing distance | Number | 1.5 | Adjustment for pressing/fitting tolerance. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *Standard hsbCAD Options* | This script does not add specific custom items to the right-click menu. Use the Properties Palette for modifications. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies on built-in properties and does not require external settings files.

## Tips
- **Editing**: You can change the dimensions of the Tenon and Mortice at any time by selecting the inserted script element and modifying the numbers in the Properties Palette.
- **Swapping Sides**: If the Tenon is on the wrong half of the beam, change the "Flip side" property to "Yes".
- **Removing Drills**: If you do not want drill holes, simply set the "Diameter" property to `0`.
- **Split Location**: Ensure you click exactly on the beam centerline or within its profile projection to ensure the split logic works correctly.

## FAQ
- **Q: The script disappeared after I ran it.**
  A: This likely means you canceled the beam selection or the split point was invalid (outside the beam). Run the script again and ensure you select the beam properly.
- **Q: Can I use this on curved beams?**
  A: This script is designed for standard linear beams. Results on heavily curved beams may be unpredictable.
- **Q: How do I reset the connection to the default?**
  A: Delete the script instance and the split beams, then restore the original single beam from your backup or undo history.
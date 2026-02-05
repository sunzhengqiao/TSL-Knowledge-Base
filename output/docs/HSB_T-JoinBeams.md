# HSB_T-JoinBeams.mcr

## Overview
This script merges multiple collinear timber beams into a single continuous structural entity. It is designed to resolve fragmented modeling or combine segmented beams into one piece for manufacturing and structural analysis.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates directly on Beam entities in the 3D model. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | This script modifies the model geometry, not the drawing views. |

## Prerequisites
- **Required Entities:** At least 2 Beam entities.
- **Minimum Beam Count:** 2.
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Navigate to the folder containing `HSB_T-JoinBeams.mcr` and select it.

### Step 2: Select Beams
```
Command Line: Select beams to join
Action: Click on the beams you wish to merge. They should be aligned in a straight line.
```
*Note: Press Enter to confirm your selection after picking the beams.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not expose any user-editable properties in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| StretchToExtremes | Select this option after insertion to stretch the main beam to the furthest ends of the selected group. This action physically modifies the main beam and deletes the other beams in the selection. |

## Settings Files
- **Filename:** None.
- **Location:** N/A.
- **Purpose:** This script does not rely on external XML settings files.

## Tips
- **Alignment:** Ensure the beams you select are reasonably aligned on the same centerline. If the offset between beams exceeds the internal tolerance (approx. 1mm), the script will not join them.
- **Orientation:** The script checks vector directions. Ensure the beams are intended to be collinear (in a straight line) rather than just parallel.
- **Order of Selection:** The script typically processes beams based on their position in space. Using the "StretchToExtremes" right-click option forces the geometry of the primary beam to update to the total length of the group.

## FAQ
- **Q: Why did my beams fail to join?**
  **A:** The beams may be offset laterally by more than 1mm, or they might not be perfectly collinear (straight). Check their alignment in the 3D view.
- **Q: What is the difference between the default action and "StretchToExtremes"?**
  **A:** The default action logically merges the database entries of the beams. "StretchToExtremes" physically cuts the main beam to the new total length and erases the other beams from the model.
- **Q: Can I join beams with different cross-sections?**
  **A:** This script is designed for collinear beams. While it may handle geometric joins, manufacturing requirements usually require identical cross-sections for a continuous member. Verify the resulting beam properties after joining.
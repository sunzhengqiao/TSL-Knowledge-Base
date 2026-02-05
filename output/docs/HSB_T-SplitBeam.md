# HSB_T-SplitBeam.mcr

## Overview
This script splits a single existing timber beam into two separate entities based on a user-defined cut line. It permanently replaces the original beam with two new segments that match the cut orientation specified by the user.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the only supported environment. |
| Paper Space | No | Script uses 3D input commands (`getBeam` and `getPoint`). |
| Shop Drawing | No | This is a model modification tool only. |

## Prerequisites
- **Required Entities**: One existing `GenBeam` (Structural Beam) must be present in the model.
- **Minimum Beam Count**: 1
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse and select `HSB_T-SplitBeam.mcr`.

### Step 2: Select Beam
```
Command Line: Select a beam
Action: Click on the timber beam you wish to split.
```

### Step 3: Define Cut Start Point
```
Command Line: Split from
Action: Click a point in 3D space to define the start of the cut line. This typically lies on the beam surface or centerline where the split should begin.
```

### Step 4: Define Cut Direction (End Point)
```
Command Line: Split to
Action: Click a second point to define the direction and angle of the cut. The vector from the "Split from" point to this point determines the angle of the cut faces on the new beams.
```

## Properties Panel Parameters
*This script does not expose editable parameters in the Properties Palette (OPM). It executes immediately based on command line input.*

## Right-Click Menu Options
*This script runs once upon insertion and erases itself; therefore, there are no right-click context menu options available.*

## Settings Files
None.

## Tips
- **Creating Angled Cuts**: The "Split to" point dictates the cut angle. If you want a square (90-degree) cut, click perpendicular to the beam's length. If you click diagonally, the resulting beams will have angled/plumb cut faces.
- **Vector Flexibility**: You do not need to worry about clicking in the exact direction of the beam's axis. The script automatically detects if you defined the cut vector backwards and corrects the orientation accordingly.
- **Data Safety**: The script deletes the original beam and creates two new ones. This permanently changes the entity ID of the beam, which may affect linked lists or production data if run on already processed elements.

## FAQ
- **Q: What happens if I cancel the operation while setting the second point?**
  - **A:** The script will abort and display an "Invalid split location" warning. The original beam will remain unchanged in the model.
- **Q: Can I use this to cut a beam into three pieces at once?**
  - **A:** No, this script specifically splits one beam into exactly two segments. To create three pieces, you must run the script twice on the resulting segments.
- **Q: Does the script remain in the drawing after I use it?**
  - **A:** No. This is a "run-once" utility script. It performs the split and then erases itself from the model database.
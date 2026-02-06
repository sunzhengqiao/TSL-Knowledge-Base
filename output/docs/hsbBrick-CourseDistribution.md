# hsbBrick-CourseDistribution

## Overview
This script calculates the vertical distribution of brick courses on selected walls. It determines the optimal mortar joint thickness required to fit whole bricks (or cut bricks) within the wall height and generates sub-scripts to handle the horizontal layout.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script runs in the 3D model. |
| Paper Space | No | Not applicable for layouts. |
| Shop Drawing | No | Not applicable for manufacturing views. |

## Prerequisites
- **Required Entities**: At least one `ElementWall` (Wall).
- **Minimum Beams**: 0
- **Required Settings**: `hsbBrickFamilyDefinitions.xml` (If missing, the script creates a default family).

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT` → Select `hsbBrick-CourseDistribution.mcr`

### Step 2: Select Walls
```
Command Line: Select element(s)
Action: Click on the Wall(s) you wish to apply brick coursing to and press Enter.
```

### Step 3: Configure Settings (Optional)
*If you insert the script via a catalog entry with a predefined key, this step is skipped.*

A dialog may appear prompting you to define:
- **Family**: The brick type (e.g., M50).
- **Zone**: The vertical alignment zone.

Click **OK** to confirm.

### Step 4: Verify Calculation
After insertion, the script automatically calculates the `Course Joint` thickness. You can view this result in the Properties Palette.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Family | dropdown | First in list | Selects the brick type (dimensions loaded from XML). Changing this updates the brick height used for calculations. |
| Zone | dropdown | 0 | Defines the vertical alignment zone (-5 to 5). Use this to coordinate coursing across different building storeys. |
| Minimum | number | 9.0 mm | The minimum allowable thickness for the horizontal mortar joint. |
| Maximum | number | 15.0 mm | The maximum allowable thickness for the horizontal mortar joint. |
| calculated | number | 0.0 mm | **(Read-Only)** The actual calculated joint thickness derived from the wall height and brick size. |
| Minimum (Butt) | number | 9.0 mm | The minimum allowable width for the vertical mortar joint (passed to sub-scripts). |
| Maximum (Butt) | number | 15.0 mm | The maximum allowable width for the vertical mortar joint (passed to sub-scripts). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| RecalcKey | Recalculates the brick distribution and joint sizes. Useful if wall geometry has changed manually. |

## Settings Files
- **Filename**: `hsbBrickFamilyDefinitions.xml`
- **Location**: `Company\TSL\Settings` or `Install\TSL\Settings`
- **Purpose**: Defines brick dimensions (height/width/length) and visual settings (color/DimStyle). If this file is missing, the script creates a default "M50" brick (188x88x48).

## Tips
- **Adjusting Joints**: If the calculated joint (displayed as "calculated" in properties) is outside your Min/Max range, the script defaults to the Minimum value and cuts the last brick to fit the wall height.
- **Reference Origin**: The script calculates a reference point based on the selected walls. You can grip-edit this point (usually visible as a circle or grip near the origin) to shift the entire vertical alignment without moving the walls.
- **Sub-Scripts**: This script acts as a manager. It automatically spawns `hsbBrick-BrickDistributionExterior` or `hsbBrick-BrickDistributionInterior` instances to handle the actual brick generation.

## FAQ
- **Q: The calculated joint shows 0.0, what is wrong?**
  A: Ensure you have selected a valid **Family** in the properties palette that contains a height definition. Also, ensure the selected Wall has a valid height.
- **Q: Can I force the brick to start at a specific height?**
  A: Yes, adjust the **Zone** parameter or use the grip edit on the script's reference point to shift the vertical alignment.
- **Q: What happens if my wall is too short for a full brick?**
  A: The script will calculate the joint size. If that size is smaller than your defined Minimum, it will use the Minimum joint size and the brick in that course will be cut (ripped) to fit.
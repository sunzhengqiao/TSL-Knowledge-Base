# RayRafter.mcr

## Overview
Rotates rafters in plan view by a specified angle and automatically adjusts their vertical position and bottom cut to align with the roof surface.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates in the 3D model environment. |
| Paper Space | No | Not supported for layout generation. |
| Shop Drawing | No | Not a shop drawing generation script. |

## Prerequisites
- **Required Entities**: Beams (Rafters) and/or Roofplanes (`ERoofPlane`).
- **Minimum Beam Count**: 1 (or Roofplanes containing rafters).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `RayRafter.mcr`

### Step 2: Configure Properties
A dialog will appear automatically upon insertion. Set the **Angle**, **Name**, and **Color** as desired. Click OK to proceed.

### Step 3: Select Rafters or Roofplanes
```
Command Line: Select rafters, <Enter> to align first and last rafters by roofplane selection
Action: Select the specific rafter beams you wish to rotate.
```

**OR**

```
Command Line: Select roofplane(s)
Action: Press <Enter> without selecting beams. Then, select the Roofplane entities. The script will automatically process the first and last rafters perpendicular to the X-axis on the selected planes.
```

### Step 4: Processing
The script calculates the rotation direction based on the roof geometry (hip/valley), applies the rotation and vertical adjustment, adds the bottom cut, and then erases itself.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Angle | Number | 22.5 | Defines the positive rotation angle (magnitude). The script automatically calculates the direction (sign) based on the hip or valley connection. |
| Name | Text | "" | Defines the Name for the processed rafters. An empty string means the name will not change. |
| Color | Number | -1 | Sets the color of the beam. Enter -1 to keep the original beam color. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script erases itself after execution and does not retain context menu options. |

## Settings Files
- **Filename**: None detected.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Roofplane Shortcut**: If you need to rotate the outermost jack rafters on a roof, simply press Enter at the first prompt and select the Roofplane. The script automatically identifies the correct first and last rafters.
- **Automatic Direction**: You do not need to worry about negative angles for the left side vs. the right side of the roof. The script detects the geometry and applies the rotation in the correct direction automatically.
- **Visual Identification**: Use the **Color** property (e.g., set to Red) to visually distinguish the rotated rafters from standard structural members.

## FAQ
- **Q: Can I edit the angle after the script has run?**
  - A: No. Once the script finishes, it erases itself from the drawing history. To change the angle, you must undo the command or delete the modified beams and run the script again.
- **Q: Why did nothing happen when I ran the script?**
  - A: Ensure the rafters you selected are associated with a valid Roofplane. The script silently skips any beams that do not belong to a Roofplane entity. Also, check the command line for the error "RayRafter: no valid rafters selected."
- **Q: Does this work on purlins?**
  - A: The script is designed for rafters (Beams) within a Roofplane. It may work on other beams if they are part of a valid Roofplane collection, but it is intended for rafters.
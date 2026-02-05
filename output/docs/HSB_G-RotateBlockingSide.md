# HSB_G-RotateBlockingSide.mcr

## Overview
This script manages the placement and orientation of blocking timber (noggins) within a structural element. It allows you to flip the blocking to the opposite side of a reference beam and automatically stretches intersecting beams to fit the new geometry.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D beams and elements. |
| Paper Space | No | Not applicable for 2D drawings. |
| Shop Drawing | No | Not applicable for shop drawing generation. |

## Prerequisites
- **Required Entities**: The script must be attached to 1 GenBeam (the blocking) and 1 Element (the parent structure).
- **Insertion Method**: This script is typically not run manually. It is designed to be inserted automatically by the script `HSB_G-SplitWithBlocking`. Attempting to insert it manually via `TSLINSERT` will result in the instance being automatically deleted unless specific Map flags are set.
- **Required Settings**: None.

## Usage Steps

### Step 1: Generate the Blocking
Since this script is a sub-component, you generally launch it by running the parent script.
1.  Run `HSB_G-SplitWithBlocking` to generate the initial blocking elements.
2.  The `HSB_G-RotateBlockingSide` instance is automatically attached to the created blocking beam.

### Step 2: Adjust Blocking Orientation
If the generated blocking is on the wrong side of the beam:
1.  Select the **Blocking Beam** in the model.
2.  **Right-click** to open the context menu.
3.  Select **Flip side**.
    *   *Alternative*: **Double-click** the blocking beam to achieve the same result.
4.  The script will move the blocking to the opposite face of the reference beam and rotate it 180 degrees.

### Step 3: Resize Blocking (Optional)
If the blocking dimensions need adjustment:
1.  Select the **Blocking Beam**.
2.  Open the **Properties Palette** (Ctrl + 1).
3.  Modify **Blocking length**, **Blocking width**, or **Blocking height**.
4.  The geometry updates immediately, and intersecting beams are stretched to fit.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Blocking length | Number | 100 mm | The longitudinal length of the blocking timber (noggin). |
| Blocking width | Number | 25 mm | The thickness of the blocking (depth relative to the beam). |
| Blocking height | Number | 25 mm | The vertical height of the blocking. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip side | Moves the insertion point of the blocking across the reference beam and inverts the Y-axis vector. This effectively toggles the blocking between the left and right sides of the beam while regenerating connections. |

## Settings Files
- None.

## Tips
- **Quick Access**: Use the **Double-Click** feature to rapidly flip blocking sides without navigating the right-click menu.
- **Auto-Stretching**: When you flip the side or change dimensions, the script automatically identifies and stretches any beams in the parent element that intersect with the blocking. You do not need to manually trim these beams.
- **Error Handling**: If you accidentally insert this script manually without the proper parent context, it will display a message "TSL can only get inserted through HSB_G-SplitWithBlocking!" and delete itself to prevent errors.

## FAQ
- **Q: Why does the script disappear when I try to insert it?**
  - A: This script is a child script designed to be called programmatically. It checks its origin upon insertion and deletes itself if it was not created by `HSB_G-SplitWithBlocking`.
- **Q: What happens if I set the Blocking Width to 0?**
  - A: The script includes a validation rule. If any dimension (Length, Width, or Height) is 0 or negative, it resets that specific value to a safe default (100mm for length, 25mm for others) and displays a notice in the command line.
- **Q: Does this work on curved beams?**
  - A: The script calculates orientation based on the Y-vector of the selected beams. It is primarily designed for standard rectangular blocking within elements.
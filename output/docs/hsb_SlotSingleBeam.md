# hsb_SlotSingleBeam.mcr

## Overview
Creates a rectangular slot (housing or dado) cut into a single beam. This script is used to define material removal for connections, such as receiving a cross-member or a steel plate, based on a specified depth, thickness, and height.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates in 3D model space. |
| Paper Space | No | Not designed for 2D layouts or viewports. |
| Shop Drawing | No | This is a model generation script, not a detailing script. |

## Prerequisites
- **Required Entities**: At least one Beam (GenBeam) must exist in the model.
- **Minimum Beam Count**: 1
- **Required Settings**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SlotSingleBeam.mcr` from the file list.

### Step 2: Select Beam
```
Command Line: Select Beam:
Action: Click on the beam in the model where you want the slot to be applied.
```

### Step 3: Define Position
```
Command Line: Give point:
Action: Click on the face or surface of the selected beam to set the center location of the slot.
```
*Note: This point acts as the center of the slot's length.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Depth | number | 100 | The length of the slot along the beam axis. **Note:** The actual cut length will be double this value (200 mm) because the insertion point is the center of the slot. |
| Thickness | number | 20 | The width of the slot (penetration depth into the material). |
| Height | number | 50 | The vertical height of the slot opening on the beam's face. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add specific custom items to the right-click context menu. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Center Point Logic:** The script places the insertion point at the *center* of the slot's length. If you enter a Depth of 100, the slot extends 100 units forward and 100 units backward from the point you clicked.
- **Visual Feedback:** Upon insertion, a visual reference line indicates the full length of the slot.
- **Easy Adjustments:** You can select the generated slot entity and modify the dimensions directly in the AutoCAD Properties Palette (OPM) without re-running the script.
- **Moving the Slot:** Use standard AutoCAD Move or Grip Edit commands to relocate the slot along or across the beam after insertion.

## FAQ
- **Q: Why is the slot longer than the value I entered for Depth?**
- A: The script uses the "Depth" value as a radius from the center point. The physical length of the slot is calculated as `Depth * 2`.

- **Q: The slot disappeared or looks inverted. What happened?**
- A: Ensure that the Depth, Thickness, and Height values in the Properties Palette are positive numbers. Zero or negative values can cause geometric errors.

- **Q: Can I use this on curved beams?**
- A: This script is designed for standard beams. While it may function on simple curved beams, results may vary depending on the complexity of the curvature.
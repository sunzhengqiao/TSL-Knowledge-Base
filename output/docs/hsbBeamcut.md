# hsbBeamcut.mcr

## Overview
This script creates a configurable volumetric cut (such as a notch, slot, or recess) on a specific face of a timber beam, wall, or element. It allows for precise material removal using either fixed property dimensions or dynamic on-screen point input.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script creates 3D geometry and modifies beam bodies. |
| Paper Space | No | Not intended for 2D drawing generation. |
| Shop Drawing | No | This is a modeling/CAM script. |

## Prerequisites
- **Required entities**: GenBeam, ElementWallSF, OpeningSF, or TslInst (Electrical Installations/Doors).
- **Minimum beam count**: 0 (Can be attached to walls or installations).
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT` → Select `hsbBeamcut.mcr` from the list.

### Step 2: Select Reference Item
```
Command Line: Select reference item (Beam, Walls, E-Installations or Doors)
Action: Click on the beam, wall, or installation object where you want to apply the cut.
```

### Step 3: Define Dimensions and Position
*The prompts depend on the **Length** property setting (default is 300mm).*

**Scenario A: If Length is set to a specific value (> 0)**
```
Command Line: Insertion Point
Action: Click on the face of the beam to place the center of the cut.

Command Line: Specify direction <Enter> to insert at center
Action: Move your mouse to rotate the cut, then click to set direction, or press Enter to align it to the center axis.
```

**Scenario B: If Length is set to 0 or dynamic**
```
Command Line: Pick point to specify length by points, <Enter> to insert full length
Action: Click the start point for the cut on the beam face.

Command Line: Pick second point
Action: Click the end point to define the exact length visually.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Length** | Number | 300 mm | Defines the longitudinal size of the cut along the beam axis. Set to `0` to cut the full length of the beam or installation. |
| **Width** | Number | 30 mm | Defines the lateral size across the beam face. Set to `0` to cut the complete width/height of the face. |
| **Depth** | Number | 30 mm | Defines how deep the cut penetrates into the material from the reference face. |
| **Offset** | Number | 0 mm | Shifts the cut laterally from the beam's center axis. Enter `+` or `-` to quickly align the cut flush to the top/bottom or side edges. |
| **Reference Side** | Dropdown | ECS Y | Selects which face of the beam the cut is applied to relative to the Element Coordinate System (Options: ECS Y, ECS Z, ECS -Y, ECS -Z). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Add Beam** | Recalculates the script and adds the selected beam to the list of elements affected by this cut. |
| **Remove Beam** | Recalculates the script and removes the selected beam from the list of affected elements. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies on standard Properties and Catalog inputs; no external settings file is required.

## Tips
- **Quick Alignment**: Instead of calculating the exact offset distance, type `+` or `-` in the Offset field to instantly align the cut to the outer edges of the beam.
- **Full Face Cuts**: Setting Width or Length to `0` is useful for creating dado slots that span the entire available dimension of the material.
- **Graphical Editing**: After insertion, you can select the cut in the model and drag the blue **Grip Points** to visually adjust the Length, Width, and Offset without opening the Properties panel.

## FAQ
- **Q: Why is my cut not going through the entire beam?**
  **A**: Ensure the **Width** or **Length** properties are set to `0`, or check that the **Depth** is sufficient to penetrate the material thickness.
- **Q: Can I use this to cut a hole for a pipe?**
  **A**: This script creates a rectangular cut (notch/slot). For circular holes, you would need a different script (e.g., `hsbCylinder`).
- **Q: How do I flip the cut to the other side of the beam?**
  **A**: Change the **Reference Side** property in the dropdown menu (e.g., from "ECS Y" to "ECS -Y").
# hsbTenon.mcr

## Overview
This script creates mortise (through hole) or housing (slot) joints to connect two beams or a beam and a panel. It supports various geometric configurations, dimensional tolerances, and rotation adjustments to accommodate traditional timber framing joinery.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D geometry manipulation. |
| Paper Space | No | Script does not support 2D layout entities. |
| Shop Drawing | No | Designed for 3D model generation only. |

## Prerequisites
- **Required entities**: At least two structural entities (GenBeams or Elements).
- **Minimum beam count**: 2 (One Male beam/reference, one Female beam/receiver).
- **Required settings**: None specific (uses internal defaults).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbTenon.mcr` from the file list.

### Step 2: Select Male Beams
```
Command Line: Select Male Beam(s)
Action: Click on the beam(s) that will insert into the joint (e.g., the purlin or joist). Press Enter to confirm selection.
```

### Step 3: Select Female Element
```
Command Line: Select Female Element
Action: Click on the main beam or panel that will receive the cut (e.g., the rafter or top plate).
```

### Step 4: Adjust Joint Configuration
```
Action: The initial cut is generated based on the intersection.
- Open the Properties Palette (Ctrl+1) to adjust dimensions (Width, Depth, Offsets).
- Right-click the script instance in the model to access alignment options (Flip, Rotate, Join).
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sConnection | dropdown | T-Connection | Defines the relationship: **T-Connection** (perpendicular) or **End-End** (collinear/end-to-end). |
| sType | dropdown | Mortise, not round | Select joint style: **Mortise** (through hole) or **House** (slot/groove). Options include corner radii and relief cuts. |
| dYOffsetA | number | 0 mm | Offsets the start of the cut along the beam length (positive direction). |
| dYOffsetB | number | 0 mm | Offsets the end of the cut along the beam length (negative direction). |
| dXWidth | number | 45 mm | The width of the cut. Ideally matches the width of the mating timber plus clearance. |
| dZDepth | number | 28 mm | The depth of the cut perpendicular to the beam face. |
| dExplicitRadius | number | 0 mm | Custom corner radius used only when `sType` is set to "Mortise, explicit radius". |
| dGapLength | number | 0 mm | Extra length clearance for glue expansion or easier assembly. |
| dGapWidth | number | 0 mm | Extra width clearance for assembly tolerance. |
| dGapDepth | number | 0 mm | Extra depth clearance to ensure the mating part fits fully. |
| dOffsetX | number | 0 mm | Lateral shift of the cut center relative to the beam axis. |
| dRotation | number | 0 degrees | Rotates the cut profile around the insertion axis. Useful for skewed connections. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Direction | Inverts the cut direction along the beam axis (swaps the positive/negative Y offset logic). |
| Join | Prompts you to select additional Male beams to add to the current joint configuration. |
| Set vertical/plumb/horizontal alignment | Automatically calculates and applies a rotation to align the cut with World Z or Workplane axes. |
| Rotate | Allows manual rotation of the cut profile via dynamic input. |

## Settings Files
No specific external settings files are required for this script.

## Tips
- **Grip Editing**: If the cut is aligned parallel to the beam, you can click and drag the graphical grip in the CAD viewport to slide the joint along the beam.
- **Tolerances**: Use the **Gap** properties (Length, Width, Depth) if you need extra room for glue or easier assembly on site.
- **Troubleshooting Orientation**: If the cut is not facing the correct side of the beam, use the **Flip Direction** option in the right-click menu.

## FAQ
- **Q: How do I create a mortise with rounded corners?**
  A: Change the `sType` property in the Properties Palette to "Mortise, round" or "Mortise, rounded".
- **Q: The joint is not cutting deep enough.**
  A: Increase the `dZDepth` value in the Properties Palette.
- **Q: Can I connect a beam to a wall panel?**
  A: Yes. Select the beam as the "Male" entity and the wall panel (Element) as the "Female" entity during the insertion steps.
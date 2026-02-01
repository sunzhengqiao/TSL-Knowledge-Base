# Chamfer.mcr

## Overview
Applies a decorative or functional easing (chamfer or round) to the edges of a timber beam along a specific length. It supports Round, 45-degree bevel, or 90-degree notch profiles.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates directly on 3D beam objects. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Does not generate shop drawing views or dimensions. |

## Prerequisites
- **Required Entities**: One (1) `GenBeam` (Timber Beam).
- **Minimum Beam Count**: 1.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Chamfer.mcr` from the catalog.

### Step 2: Select Beam
```
Command Line: Select beam
Action: Click on the timber beam you wish to modify.
```

### Step 3: Select Location
```
Command Line: Select Location
Action: Click a point on the beam where the chamfer should be centered.
```

### Step 4: Define Start and End
```
Command Line: Select Start and End of chamfer
Action: You have two options:
   A. Click two distinct points on the beam to define exactly where the chamfer starts and ends.
   B. Click only one point or press Enter to use the default "Chamfer Length" centered on the Location picked in Step 3.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Chamfer Type** | Dropdown | Round | Select the profile shape: `Round` (eased edge), `45` (beveled), or `90` (square notch). |
| **Chamfer Depth** | Number | 0.5 inch | The distance the cut removes from the corner of the beam (material thickness removed). |
| **Chamfer Length** | Number | 6 inch | The distance along the beam axis that the chamfer covers. |
| **Neg Y Pos Z** | Dropdown | No | Set to `Yes` to apply the chamfer to the corner at Negative Y / Positive Z. |
| **Neg Y Neg Z** | Dropdown | No | Set to `Yes` to apply the chamfer to the corner at Negative Y / Negative Z. |
| **Pos Y Pos Z** | Dropdown | No | Set to `Yes` to apply the chamfer to the corner at Positive Y / Positive Z. |
| **Pos Y Neg Z** | Dropdown | No | Set to `Yes` to apply the chamfer to the corner at Positive Y / Negative Z. |

## Right-Click Menu Options
This script uses standard hsbCAD interactions. Modifications are primarily handled via the **Properties Palette** and **Grip Edits**.

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Grip Editing**: After insertion, select the script instance to see grips. Drag the **Start** and **End** grips to visually stretch the chamfer length along the beam.
- **Center Point**: Drag the central **Location** grip to move the entire chamfer along the beam without changing its length.
- **Corner Selection**: By default, no corners are selected (set to `No`). You must change the specific corner properties (e.g., `Pos Y Pos Z`) to `Yes` to see the visual result.
- **Symmetric Chamfering**: If you want to ease all four corners of a beam, set all four "Neg/Pos Y/Z" properties to `Yes`.

## FAQ
- **Q: Why don't I see a chamfer immediately after insertion?**
  - **A:** By default, the specific corner properties are set to "No". Go to the Properties Palette and toggle the relevant corners (e.g., `Pos Y Pos Z`) to "Yes" to activate the machining on that edge.

- **Q: Can I change the length after I have placed it?**
  - **A:** Yes. You can either type a new value in the "Chamfer Length" property, or select the object in the model and drag the square Start/End grips to the desired length.

- **Q: What does "Neg Y Pos Z" mean?**
  - **A:** These refer to the beam's local coordinate system. `Y` is usually the width, and `Z` is the height. You may need to toggle the different options to see which corner corresponds to which property, or check the beam's local axis direction if unsure.
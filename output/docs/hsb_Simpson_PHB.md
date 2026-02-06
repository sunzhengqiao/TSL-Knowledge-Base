# hsb_Simpson_PHB.mcr

## Overview
This script generates the 3D model and CNC machining for a Simpson Strong-Tie PHB column base (Post Base). It connects a timber column to a concrete foundation by creating the necessary metal hardware representation, cutting a slot in the timber, and drilling bolt holes.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used for detailing connections in 3D. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Not applicable for production drawings. |

## Prerequisites
- **Required Entities**: GenBeam (Timber Column).
- **Minimum Beam Count**: 1.
- **Required Settings Files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_Simpson_PHB.mcr` from the list.

### Step 2: Select Timber Column
```
Command Line: Select a beam
Action: Click on the timber column (GenBeam) where you want to install the post base.
```

### Step 3: Specify Insertion Point
```
Command Line: Select insertion point
Action: Click on the face of the beam to define the location of the column base.
```

### Step 4: Configure Properties (Optional)
After insertion, the Properties Palette (OPM) opens automatically (or press `Ctrl+1`). Adjust the Type, Alignment, or Drill Depth if necessary. The 3D model and machining will update immediately.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | dropdown | PHB75 | Selects the Simpson Strong-Tie catalog model (PHB75 or PHB120). This determines the dimensions of the hardware. |
| Alignment | dropdown | Side 1 | Determines how the column base flange is positioned relative to the timber face.<br>• **Side 1 / Side 2**: Offsets the flange to the edge of the timber.<br>• **Full Depth**: Cuts a slot through the center of the timber. |
| Drill Depth | number | 80.0 | Defines the depth of the bolt holes drilled into the timber column (in mm). Enter `0` to drill completely through the beam (through-bolting). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Update | Recalculates the script geometry if parameters are changed via the Properties Palette. |
| Move | Allows you to drag the insertion point to reposition the hardware on the beam. |

## Settings Files
- **Filename**: None.
- **Location**: N/A.
- **Purpose**: The script uses internal dimension arrays for the PHB75 and PHB120 catalogs.

## Tips
- Set **Drill Depth** to `0` to ensure the holes go all the way through the timber column for through-bolting applications.
- Use the **Full Depth** alignment option if you need the vertical flange to sit in a centered groove within the timber.

## FAQ
- **Q: Why don't I see the metal plate after inserting?**
  - A: Ensure you are in a 3D visual style (e.g., Conceptual or Realistic) in Model Space.
- **Q: How do I change the bracket size after inserting?**
  - A: Select the script instance, open the Properties Palette (Ctrl+1), and change the **Type** from PHB75 to PHB120.
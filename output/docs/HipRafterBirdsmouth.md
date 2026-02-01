# HipRafterBirdsmouth.mcr

## Overview
This script automates the creation of a birdsmouth joint on a hip rafter. It calculates the necessary cuts based on the intersection of two selected plates or eaves rafters, handling both standard and acute roof angles.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment to cut beam geometry. |
| Paper Space | No | Not applicable for 2D drawings. |
| Shop Drawing | No | Not applicable for shop drawing generation. |

## Prerequisites
- **Required entities**: At least 3 beams (2 plates/eaves beams and 1 hip rafter).
- **Minimum beam count**: 3
- **Required settings**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HipRafterBirdsmouth.mcr`

### Step 2: Select Plates
```
Command Line: Select plates
Action: Click on the two plates (or eaves rafters) that form the corner intersection.
Note: You must select at least 2 beams, and they must not be parallel to each other.
```

### Step 3: Select Hip Rafter
```
Command Line: Select hip rafter
Action: Click on the hip rafter beam that needs to be notched (birdsmouthed) to sit on the plates.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Minimal Tooling Y | Dropdown | No | Determines if the cutting tool width matches the beam width exactly.<br>**No**: Tool is 10x wider (ensures clean through-cut).<br>**Yes**: Tool is restricted to beam width (prevents interference with adjacent beams). |
| Minimal Tooling Z | Dropdown | No | Determines if the cutting tool height matches the beam height exactly.<br>**No**: Tool is 10x taller (ensures full depth).<br>**Yes**: Tool is restricted to beam height. |
| Relief | Dropdown | not rounded | Defines the corner treatment for the birdsmouth (useful for acute angles). Options include: `not rounded`, `rounded`, `relief`, `rounded with small diameter`, `relief with small diameter`, and `relief K1`. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | This script does not add custom items to the right-click context menu. Modifications are made via the Properties Panel. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Acute Angles**: If the angle between your plates is less than 90°, the script automatically switches to "ParHouse" logic. In this mode, the `Relief` parameter is critical to prevent creating a sharp, weak point inside the birdsmouth.
- **Interference Detection**: If the birdsmouth cut is interfering with other nearby beams, change `Minimal Tooling Y` or `Minimal Tooling Z` to "Yes". This restricts the cut volume to the exact dimensions of the hip rafter.
- **Visual Markers**: The script draws a profile and circle marker on the reference plane to indicate exactly where the cut is applied.

## FAQ
- **Q: I received an "Invalid selection" notice. Why?**
- **A:** Ensure you selected at least two beams in the first step, and that those two beams are not parallel. They must form a corner.
- **Q: What is the difference between "rounded" and "relief" in the properties?**
- **A:** "Rounded" applies a curved fillet to the internal corner of the cut. "Relief" typically applies a straight chamfer or specific material removal to ease the corner.
- **Q: Why does the cut extend so far beyond my beam?**
- **A:** By default, `Minimal Tooling Y` and `Z` are set to "No", which creates a large virtual tool (10x size) to ensure the cut goes completely through the material. Change these to "Yes" to limit the cut to the beam's boundary.
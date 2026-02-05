# HSB_T-SingleMark.mcr

## Overview
This script creates a visual marker line on a selected timber beam to indicate a specific alignment point, material thickness, or reference edge (e.g., for stone cladding installation).

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates within the 3D model. |
| Paper Space | No | Not designed for 2D layout sheets. |
| Shop Drawing | No | Does not generate shop drawing details. |

## Prerequisites
- **Required Entities**: A single `GenBeam` (Timber Beam) must exist in the model.
- **Minimum Beam Count**: 1
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_T-SingleMark.mcr` from the catalog or script browser.

### Step 2: Select Beam
```
Command Line: Select GenBeam
Action: Click on the timber beam in the model where you want to place the mark.
```

### Step 3: Select Location
```
Command Line: Specify Point
Action: Click on the beam surface or in 3D space to define the insertion location for the marker.
```

### Step 4: Configure Offset (Optional)
After insertion, select the created mark and adjust the "Marble diameter" property in the Properties Palette to set the correct offset distance.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Marble diameter | Number | 5 (mm) | The offset distance used to position the marker line relative to the selected point. Despite the name, this controls the linear distance/offset of the mark. |

## Right-Click Menu Options
None available.

## Settings Files
None used.

## Tips
- **Cladding Reference**: Use this script to visualize where stone or marble cladding will sit on the beam by setting the "Marble diameter" to the thickness of the material.
- **Dynamic Adjustment**: You can change the offset distance anytime after insertion by selecting the entity and modifying the value in the Properties Palette (OPM).

## FAQ
- **Q: Why is the property called "Marble diameter"?**
  **A:** The script was likely designed for marking stone cladding thicknesses. While named "diameter," the parameter functions as a linear offset value to position the mark correctly on the timber.
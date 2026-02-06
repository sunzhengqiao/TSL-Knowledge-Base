# hsbOpeningHalfCut.mcr

## Overview
This script automatically creates two half-cut saw cuts on the sill beam located directly below a selected opening. It is typically used to create a recess or rebate, allowing floor materials (like laminate or wood flooring) to run underneath door thresholds or window sills.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script modifies 3D geometry and requires an Element with an Opening. |
| Paper Space | No | This is a model generation script. |
| Shop Drawing | No | This script operates on the 3D model, not 2D drawings. |

## Prerequisites
- **Required Entities**: An `Element` containing an `Opening` entity.
- **Minimum Beams**: At least one horizontal beam (sill) must intersect the opening area.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbOpeningHalfCut.mcr`

### Step 2: Select Opening
```
Command Line: Select opening
Action: Click on the desired Opening entity in your 3D model.
```

### Step 3: Insertion Point
```
Command Line: [Point Selection]
Action: Click anywhere in the drawing area to finalize the script insertion.
```

### Step 4: Verify Cuts
The script will automatically detect the horizontal sill beam below the opening and apply two saw cuts. You will see square cyan grips indicating the cut boundaries.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Depth | Number | 10 | Sets the vertical depth of the saw cut measured downwards from the top surface of the beam. Increase this value if the floor material is thicker. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (Standard Items) | No custom options are added to the right-click menu. Use the Properties Palette to adjust parameters. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Adjusting Width**: Select the script instance and drag the square **cyan grips** to adjust the left and right positions of the saw cuts.
- **Dynamic Updates**: If you move the Opening or the Sill beam, the cuts will automatically recalculate to follow the geometry.
- **Troubleshooting**: If the script disappears after insertion, it likely could not find a valid horizontal beam intersecting the opening midpoint. Ensure your sill beam is properly aligned with the opening.

## FAQ
- **Q: Why did the script disappear immediately after I inserted it?**
  A: The script requires a horizontal beam (sill) to intersect directly with the opening area. If no beam is found, or if the opening position is invalid relative to the element origin, the script deletes itself automatically.
  
- **Q: How do I make the cut deeper into the beam?**
  A: Select the script, open the **Properties (OPM)** palette, and increase the **Depth** value.

- **Q: Can I use this on vertical beams?**
  A: No, this script is designed specifically to find horizontal beams (sills) located below an opening.
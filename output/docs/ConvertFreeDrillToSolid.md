# ConvertFreeDrillToSolid.mcr

## Overview
This script converts symbolic "hsbcad Free Drill" entities into physical 3D solid cylinders. It is used for visualizing the exact volume of drill holes (including counterbores) for interference checking or concrete coordination.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script generates 3D solids in the model. |
| Paper Space | No | This script is not intended for layout views. |
| Shop Drawing | No | This script does not generate 2D drawings. |

## Prerequisites
- **Required Entities:** `HSB_EFREE_DRILL` (hsbcad Free Drill).
- **Linked GenBeam:** The selected Free Drill entities must be linked to a GenBeam. The script requires this link to detect the correct drill diameter and depth.
- **Minimum beam count:** 0 (The script operates on drill entities directly, not by selecting beams).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `ConvertFreeDrillToSolid.mcr`

### Step 2: Select Free Drills
```
Command Line: Select free drills
Action: Select the Free Drill entities you wish to convert and press Enter.
```

### Step 3: Automatic Processing
The script will automatically loop through your selection.
- If a drill is linked to a beam, it creates a 3D Solid cylinder representing the main bore.
- If the drill has sinkholes (counterbores), additional solid cylinders are created for them.
- If a drill is not linked to a beam, a notice is displayed on the command line, and that specific drill is skipped.

### Step 4: Completion
Once processed, the script instance automatically deletes itself from the drawing, leaving only the newly created 3D Solids.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| *None* | | | This script does not expose parameters in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add specific options to the right-click context menu. |

## Settings Files
- **None**: This script does not rely on external XML settings files.

## Tips
- **Interference Checking:** After creating the solids, you can use the standard AutoCAD `INTERFERE` command to check for clashes between these drill volumes and other objects (like reinforcement or ductwork).
- **Cleanup:** The script deletes itself after running. If you need to update the holes after changing the beam or drill properties, simply insert the script again.
- **Sinkholes:** The script automatically detects and creates separate solids for counterbores (sinkholes) if they exist in the Free Drill definition.

## FAQ
- **Q: Why did the script skip some of my selected drills?**
  **A:** The Free Drills must be linked to a GenBeam to calculate the diameter. If a drill is floating without a link, the script cannot detect the dimensions and will skip it with a command line notice.
- **Can I edit the resulting solids using the script?**
  **A:** No. The script creates static standard AutoCAD 3D Solids and then removes itself. To change the geometry, modify the original Free Drill entity and run the script again.
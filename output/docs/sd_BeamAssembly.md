# sd_BeamAssembly.mcr

## Overview
This script automatically calculates and generates dimension requests for a beam assembly, including the main timber beam and any connected hardware or tools. It is used to prepare precise geometric boundaries for Front, Left, and Top views within the Shop Drawing generation process.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used to insert and assign the script to a specific beam. |
| Paper Space | No | The script runs during the generation calculation, not directly in layout view. |
| Shop Drawing | Yes | This is the primary context; it interacts with the Shop Drawing Engine to define view extents. |

## Prerequisites
- **Required Entities**: A single structural Beam.
- **Minimum Beam Count**: 1.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `sd_BeamAssembly.mcr` from the list.

### Step 2: Select Beam
```
Command Line: Select beam:
Action: Click on the structural timber beam in the model that you wish to detail.
```

### Step 3: Select Reference Point
```
Command Line: Select point near tool:
Action: Click a point in the model space near the assembly (e.g., to the left of the beam). 
Note: This point determines the origin for sorting dimensions, effectively setting the reading direction (Left-to-Right vs. Right-to-Left).
```

### Step 4: Completion
The script instance is attached to the beam. It will automatically calculate dimension requests when the Shop Drawing generation process is executed.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| _Beam0 | Entity | null | The target structural beam to be detailed. Change this to apply the script to a different beam. |
| _Pt0 | Point | 0,0,0 | The reference point used to sort dimension points. Moving this point changes the order in which dimensions are displayed in the drawing. |

## Right-Click Menu Options
No custom context menu options are defined for this script. Modifications are made via the Properties Palette.

## Settings Files
No external settings files are required for this script.

## Tips
- **Control Dimension Direction**: The location of the `_Pt0` (Reference Point) relative to the beam controls the "reading direction" of the dimensions. If you want dimensions to read from left to right, place the reference point to the left of the beam assembly.
- **Connected Tools**: The script automatically detects and includes connected MetalParts and TSL instances in the dimension calculation, provided they have physical volume.
- **Troubleshooting**: If the script instance disappears from the model, it usually means the target beam was deleted or became invalid.

## FAQ
- **Q: Why are some of my connected tools not being dimensioned?**
  **A:** The script filters out tools that do not have a significant physical volume (realBody volume check). Ensure your tools have 3D geometry.
- **Q: Can I change which beam is being detailed after inserting the script?**
  **A:** Yes. Select the script instance in Model Space, open the Properties Palette (Ctrl+1), and click the `_Beam0` field to select a different beam.
- **Q: How do I reverse the order of the dimensions on the drawing?**
  **A:** Select the script instance and change the `_Pt0` (Reference Point) property in the Properties Palette to the opposite side of the beam assembly.
# hsb_RevolutionMillTool

## Overview
Applies a cylindrical milling operation (RevolutionMill) to a timber beam using a specific tool index from your CNC machine library. It automatically adjusts the mill diameter based on the selected tool and includes a standard saw cut at the insertion point.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model to modify beam geometry. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This is a model generation tool, not a drawing detailer. |

## Prerequisites
- **Required Entities**: One `GenBeam` (Timber Beam).
- **Minimum Beam Count**: 1.
- **Required Settings**: A valid CNC Machine Library containing definitions for Tool Index 0 (and optionally 1).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_RevolutionMillTool.mcr`

### Step 2: Select Target Beam
```
Command Line: Select beam:
Action: Click on the timber beam you wish to apply the machining to.
```

### Step 3: Define Location
```
Command Line: Give insertion point:
Action: Click on the beam where the center of the revolution mill should be located.
```

### Step 4: Define Orientation
```
Command Line: Give X-direction / Give Y-direction / Give Z-direction:
Action: Click to define the orientation of the tool axis (usually aligning the tool axis with the beam or a specific angle).
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Mill index | dropdown | 0 | Selects the CNC tool bit (Index 0 or 1) from the machine library to define the mill diameter and profile. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *(None specific)* | This script does not add custom items to the right-click menu. Use standard grips or Properties to edit. |

## Settings Files
- **Filename**: *(None)*
- **Location**: N/A
- **Purpose**: This script relies on the global hsbCAD CNC Machine Configuration for tool definitions, rather than a specific local settings file.

## Tips
- **Grip Editing**: After insertion, select the script element and use the blue square grip to drag the mill to a new position along the beam.
- **Reorienting**: Use the rotation handle (usually the circular arrow grip appearing near the insertion point) to change the direction of the mill bit.
- **Tool Index**: Ensure your CNC administrator has configured Tool Index 0 (or 1) in the machine settings with the correct diameter for your design intent.

## FAQ
- **Q: I changed the Mill Index, but nothing happened visually.**
  A: The geometry updates only if the diameter defined in Tool Index 1 differs from Tool Index 0. If they are identical in the machine database, the visual size will not change.
- **Q: What is the extra Cut object added by this script?**
  A: The script automatically adds a planar "Cut" at the insertion point, likely intended as a trimming cut or a start/stop cut for the milling path.
- **Q: Can I use Index 2 or higher?**
  A: The script interface currently restricts selection to Index 0 or 1. Use 0 for the primary tool.
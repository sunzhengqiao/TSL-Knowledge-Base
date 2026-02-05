# HSB_P-Electrical.mcr

## Overview
This script automates the creation of electrical socket box penetrations and vertical wire chases (slots) in timber wall elements. It calculates vertical positions relative to the finished floor level and generates cylindrical holes, rectangular recesses, and cable routing grooves.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be inserted in 3D model space to modify wall geometry. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: A Wall Element (`ElementWall`) must exist in the drawing.
- **Minimum Beam Count**: 0 (The script extracts beams from the selected wall element automatically).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT`
**Action:** Browse and select `HSB_P-Electrical.mcr`.

### Step 2: Select Wall
```
Command Line: Select a wall
Action: Click on the desired Wall Element in the model.
```

### Step 3: Set Insertion Point
```
Command Line: (Pick point prompt)
Action: Click on the face of the wall to define the horizontal location and alignment for the electrical installation.
```

### Step 4: Configure Properties (Optional)
**Action:** Select the inserted script instance and open the **Properties Palette** (Ctrl+1). Adjust dimensions, heights, and quantities as needed.

## Properties Panel Parameters

### General Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Height finished floor | number | 190 mm | Vertical offset from the bottom of the wall element to the finished floor surface. Acts as the Z=0 reference for heights. |
| Height soleplate | number | 38 mm | Height of the bottom wall plate (soleplate). Used to refine the structural reference point. |

### Installation
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Quantity | dropdown | 1 | Number of socket boxes to create horizontally (1 to 4). |
| Height from finished floor | text | 1100 | Vertical position(s) of the sockets. Separate multiple heights with a semicolon (e.g., `300;1100;1500`). |
| Diameter | number | 69 mm | Diameter of the main drill hole for the electrical box. |
| Depth | number | 50 mm | Depth of the main drill hole. |
| Offset between installations | number | 71 mm | Center-to-center distance between sockets when Quantity is greater than 1. |
| Installation types | text | | Metadata for the installation type. Set via the Right-Click menu. |

### Extra Mill
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Width extra mill | number | 40 mm | Horizontal width of the rectangular recess around the hole. |
| Height extra mill | number | 40 mm | Vertical height of the rectangular recess around the hole. |
| Depth extra mill | number | 50 mm | Depth of the rectangular recess (often used for plasterboard clearance). |

### Wire Chase
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Side wire chase | dropdown | Aligned | Side of the wire chase relative to the insertion point (Left, Right, or Aligned). |
| Direction wire chase | dropdown | Up | Vertical direction of the wire chase (Up, Down, or Up and down). |
| Width wire chase | number | 30 mm | Width of the vertical groove for wires. |
| Depth wire chase | number | 30 mm | Depth of the vertical groove for wires. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Set installation types | Opens a selection dialog to choose specific installation type metadata for the generated points. |

## Settings Files
- **None**: This script does not rely on external settings files (XML/INI).

## Tips
- **Multiple Heights**: You can create multiple rows of sockets in a single operation by entering semicolon-separated values in the **Height from finished floor** property (e.g., `300; 1200`).
- **Floor Offset**: If your sockets appear too low or too high, check the **Height finished floor** value. The script measures height up from the bottom of the wall element, so this offset is critical for accuracy relative to the actual floor finish.
- **Wire Chase Alignment**: The **Side wire chase** option determines where the vertical groove is cut. "Aligned" centers it relative to the socket holes, while "Left" or "Right" offsets it based on your view direction during insertion.

## FAQ
- **Q: Why are my socket holes cutting through the bottom plate?**
  **A:** Check your **Height finished floor** and **Height soleplate** settings. If the wall element includes the bottom plate in its geometry, ensure the "Height finished floor" accounts for the plate thickness and flooring material.

- **Q: How can I create sockets for both a kitchen counter and a standard wall height at the same time?**
  **A:** Use the **Height from finished floor** property. Enter both heights separated by a semicolon, for example: `1050; 1300` (assuming a standard backslash height and a higher outlet).

- **Q: The wire chase isn't going all the way to the top or bottom of the wall.**
  **A:** Change the **Direction wire chase** property to `Up and down`. This forces the groove to span the full height of the wall panel.
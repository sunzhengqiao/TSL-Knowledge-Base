# HSB_P-InstallationPoint.mcr

## Overview
This script allows you to insert electrical installation boxes (outlets, switches) and vertical wire chases into timber wall elements. It automatically generates the necessary CNC cuts/milling and visual data for production and shop drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be inserted on a Wall Element in the model. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | Not applicable. |

## Prerequisites
- **Required Entities**: A Wall Element (`ElementWall`) must exist in the drawing.
- **Minimum Beams**: 0 (Operates on the Element/Panel level).
- **Required Settings**: The script `HSB_P-AssignInstallationType.mcr` must be available in the TSL search path to assign specific electrical types.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT`
**Action**: Browse the catalog and select `HSB_P-InstallationPoint.mcr`.

### Step 2: Select Wall
```
Command Line: Select a wall
Action: Click on the Wall Element where you want to place the installation.
```

### Step 3: Define Insertion Point
```
Command Line: [Point prompt]
Action: Click on the wall to define the location of the first installation box.
```

### Step 4: Configure Properties (Optional)
- If you insert the script without an "Execute Key" (preset), a configuration dialog will appear automatically.
- You can also change settings later via the Properties Palette (Ctrl+1).

### Step 5: Assign Electrical Types (Optional)
- Right-click the script instance and select **Set installation types**.
- This opens a dialog to define specific types (e.g., "Switch", "Socket") for each box.

## Properties Panel Parameters

### General settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Height finished floor | Number | 190 mm | The elevation of the finished floor. Installation heights are measured from this level. |
| Height soleplate | Number | 38 mm | The height of the wall's bottom plate. |
| Sub type | Text | | A user-defined label to differentiate points (e.g., for filtering in dimension lines). |

### Installation
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Quantity | Text | 1 | Number of boxes. Use semicolons for different quantities per height (e.g., "1;2"). |
| Height from finished floor | Text | 1100 | Vertical position of the box. Use semicolons for multiple rows (e.g., "300;1200"). |
| Tag | Text | Type1 | Label displayed in drawings (e.g., "S1", "P1"). |
| Diameter | Number | 69 mm | Diameter of the hole for the back-box. |
| Depth | Number | 50 mm | Depth of the box machining into the wall. |
| Offset between installations | Number | 71 mm | Center-to-center distance for multiple boxes on the same row. |
| Installation types | Text | | (Read-only) Summary of assigned electrical types. Updated via the Right-Click menu. |

### Extra mill
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Width extra mill | Number | 40 mm | Additional milling width around the box. |
| Height extra mill | Number | 40 mm | Additional milling height around the box. |
| Depth extra mill | Number | 50 mm | Additional milling depth around the box. |

### Wire chase
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Side wire chase | Dropdown | Left | Side of the wire chase relative to the box (Left, Right, or Aligned). |
| Direction wire chase | Dropdown | Up | Direction of the vertical chase (Up, Down, or Up and down). |
| Maximum height wire chase | Number | 0 mm | Limits the vertical length. 0 allows the chase to go to the top/bottom of the wall. |
| Width wire chase | Number | 30 mm | Width of the vertical chase cut. |
| Depth wire chase | Number | 30 mm | Depth of the vertical chase cut. |

### Display
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension style | Text | _DimStyles | The visual style used for dimensions in the drawing. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Set installation types | Opens a dialog to assign specific electrical types (e.g., Switch, Data, Plug) to the generated installation points. |

## Settings Files
- **Dependency**: `HSB_P-AssignInstallationType.mcr`
- **Location**: TSL Script Path
- **Purpose**: Provides the dialog interface and logic for assigning detailed electrical types to the points created by this script.

## Tips
- **Multiple Rows**: To create multiple rows of outlets at different heights, use semicolons in the **Height** and **Quantity** fields (e.g., Height: `300;1200`, Quantity: `2;1`).
- **Reference Level**: Remember that the **Height from finished floor** is relative to the **Height finished floor** parameter, not the absolute bottom of the wall structure.
- **Moving Points**: You can move the entire group of installations by using the grip edit point on the script instance.
- **Visualization**: The script updates plan and elevation views automatically. Ensure your "Dim Style" matches your project standards.

## FAQ
- **Q: How do I place two sockets next to each other at the same height?**
  A: Set **Quantity** to `2` and adjust the **Offset between installations** to the desired distance.
- **Q: Why didn't my wire chase go all the way to the top?**
  A: Check the **Maximum height wire chase** setting. If it is set to `0`, it should go to the top. If set to a specific value, it will stop at that height relative to the origin.
- **Q: The hole seems too low/high compared to my floor.**
  A: Check the **Height finished floor** parameter. If you have floor finishes, this value needs to be accurate so the calculations start from the correct Z-level.
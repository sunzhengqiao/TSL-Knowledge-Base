# hsb_SetLeftAndRightStudModule.mcr

## Overview
This script automatically identifies the outermost studs (leftmost and rightmost) of selected wall elements and assigns them a unique module name and a specific color. It is used to visually distinguish or flag boundary studs for filtering in exports, CNC lists, or quality control.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary environment for selecting wall elements. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: Valid Wall Elements (`ElementWall`) containing beams.
- **Minimum Beam Count**: The selected wall must contain at least two beams perpendicular to the wall's local X-axis to define a "Left" and "Right" stud.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse and select `hsb_SetLeftAndRightStudModule.mcr`

### Step 2: Configure Properties
```
Dialog: Properties Palette / Dynamic Dialog
Action: Set the 'Module Color' to the desired AutoCAD Color Index (e.g., 32).
Note: This determines the color of the boundary studs.
```

### Step 3: Select Wall Elements
```
Command Line: Select one or More Elements
Action: Click on the wall elements in the model you wish to process. You can select multiple walls.
```

### Step 4: Execute
```
Action: Press Enter or Right-click to finish selection.
Result: The script identifies the first and last studs of the selected walls, applies the unique module name and color, and then erases itself from the model.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Module Color | Number (0-255) | 32 | The AutoCAD Color Index applied to the left and right boundary studs. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add persistent right-click menu items as it auto-erases after execution. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Safe Re-running**: You can run this script multiple times on the same elements. If a boundary stud already has a module name assigned, the script will skip it and preserve the existing name. It only modifies studs with empty module fields.
- **Visualization**: Use the color setting (default is 32) to quickly verify which studs have been flagged by the script in your 3D model.
- **Self-Cleaning**: The script instance automatically removes itself from the drawing after processing. Do not look for it in the model after the command finishes.

## FAQ
- **Q: Why didn't the script change the color of my end studs?**
  - **A:** The script only processes beams that are perpendicular to the wall's local X-axis. Ensure your studs are oriented correctly. Additionally, if a beam already has a "Module" name assigned, it will be skipped.
- **Q: Can I change the color after I have run the script?**
  - **A:** No, because the script instance deletes itself immediately after running. You must set the desired color in the properties dialog *before* selecting the elements during the command execution.
- **Q: What happens if I select a wall with only one stud?**
  - **A:** The script requires at least two perpendicular beams to identify a "Left" and "Right" boundary. If a wall has fewer than two valid beams, it will be skipped without modification.
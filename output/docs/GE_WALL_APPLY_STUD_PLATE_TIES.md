# GE_WALL_APPLY_STUD_PLATE_TIES

## Overview
Automates the application of metal stud plate ties (hurricane straps) to wall elements. It allows users to configure distribution frequency (e.g., every stud vs. every second stud), vertical alignment (top/bottom), and wall side placement for hardware.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D wall elements. |
| Paper Space | No | Not designed for 2D layout or detailing views. |
| Shop Drawing | No | Does not generate shop drawing views. |

## Prerequisites
- **Required Entities**: At least one `ElementWall`.
- **Minimum Beam Count**: 1 (ElementWall).
- **Required Settings**: `ITWApplyStudTies.dll` must be present in the `Utilities\TslCustomSettings` folder.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_WALL_APPLY_STUD_PLATE_TIES.mcr` from the file dialog.

### Step 2: Select Wall
```
Command Line: Select wall(s)
Action: Click on the ElementWall(s) in the model where you want to apply ties. Press Enter to confirm selection.
```

### Step 3: Configure Settings (Dialog)
Upon selection, a configuration dialog (powered by the external plugin) will appear.
```
Action: Set the desired Distribution, Alignment, and Side preferences in the dialog. Click OK to generate the hardware.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Apply to | dropdown | Every stud | Determines how frequently ties are applied. Options: Every stud, Every second stud, Every third stud, Remove hardware. |
| Stud end | dropdown | Both | Sets the vertical position of the tie relative to the wall plates. Options: Top, Bottom, Both. |
| Wall side to apply hardware | dropdown | Same as icon | Determines which face of the wall the hardware is applied to. Options: Same as icon, Opposite to icon. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *Standard Options* | No custom context menu items are added. Use the Properties Palette to modify settings and recalculate. |

## Settings Files
- **Filename**: `ITWApplyStudTies.dll`
- **Location**: `Utilities\TslCustomSettings`
- **Purpose**: Provides the calculation logic and the initial configuration dialog for placing stud plate ties.

## Tips
- **Removing Hardware**: To delete all generated ties without deleting the script instance, change the **Apply to** property to `Remove hardware`.
- **Side Selection**: If the hardware appears on the wrong side of the wall (e.g., inside instead of outside), use the **Wall side to apply hardware** property to flip it.
- **Updates**: Modifying properties in the Properties Palette will automatically trigger the .NET logic to update the hardware placement.

## FAQ
- **Q: How do I delete the ties I just created?**
- **A:** Select the script instance (or the wall), open the Properties Palette, and change the "Apply to" parameter to "Remove hardware".
- **Q: The script does not seem to run or shows an error.**
- **A:** Ensure that `ITWApplyStudTies.dll` exists in your `hsbCAD\Utilities\TslCustomSettings` directory. This script relies entirely on this external file for its logic.
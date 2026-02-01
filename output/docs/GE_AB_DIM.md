# GE_AB_DIM.mcr

## Overview
This script is an automated component that generates individual dimension annotations for anchor points or connection details on timber elements. It handles the visual display of offset distances, leader lines, and includes tools to align or stagger multiple labels to ensure drawings remain clear.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script runs in the 3D model environment. |
| Paper Space | No | Not designed for use in Layouts. |
| Shop Drawing | No | Not a shop drawing output script. |

## Prerequisites
- **Required entities**: A single Timber Element (`Element`).
- **Parent Automation**: This script is designed to be instantiated automatically by a parent script (e.g., `GE_AB_DIMS`). It cannot be manually inserted.
- **Required Settings**: The instance requires specific Map data provided by the parent script, including `LocationPoint` (anchor location), `ReferencePoint` (measurement origin), and `ReferenceDirection` (measurement axis).

## Usage Steps

### Step 1: Automated Generation
This script is executed automatically by a parent macro. You cannot insert it manually using the `TSLINSERT` command. If you attempt to run it directly, it will display an error message and delete itself.

### Step 2: Adjust Position (Grip Edit)
```
Action: Select the generated dimension annotation in the model.
Command Line: N/A
Action: Click and drag the blue square **Grip Point** at the end of the leader line.
Result: Moves the text label to a new location. This location is saved automatically.
```

### Step 3: Organize Multiple Dimensions
```
Action: Right-click on a dimension instance.
Action: Select "Align Siblings" or "Stagger Siblings" from the context menu.
Result: 
- "Align Siblings": Moves all related dimension texts to the same height/position as the selected one.
- "Stagger Siblings": Alternates the position of related dimensions up and down to prevent overlapping text.
```

## Properties Panel Parameters

This script does not expose any user-editable parameters in the AutoCAD Properties Palette (OPM). All configuration is handled via the parent script's Map data.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| *N/A* | *N/A* | *N/A* | *Configuration is automated via the parent script.* |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Align Siblings** | Aligns the grip point of all sibling dimension instances to match the current instance's text position. Useful for creating a straight row of dimensions. |
| **Stagger Siblings** | Offsets the grip points of sibling instances alternately along the element axis. Useful for preventing text overlap when anchors are close together. |
| **WriteMapToDxx** | (Debug Only) Exports the current instance's internal data to a `.dxx` file in `C:\Temp\DebugMaps`. Used for troubleshooting. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not use external settings files. All settings are passed via the internal instance Map.

## Tips
- **Visibility Control**: Dimensions will automatically hide if the parent script determines they are not in the current view region (`ImInRegion` = 0) or if manually set to hide.
- **Visual Warnings**: If an anchor point becomes an "orphan" (e.g., the associated geometry is missing), the dimension will display in **Red**.
- **Text Rotation**: The script automatically detects if the element is vertical (`IsVertical`) and rotates the text 90 degrees for readability.
- **Grip Persistence**: Moving the grip point saves the position relative to the element, ensuring the dimension stays in the user-defined location during plan updates.

## FAQ
- **Q: Why did the script disappear immediately after I tried to insert it?**
  A: This script is a "child" component intended for automation only. It checks if it was inserted manually; if so, it erases itself. Please use the parent macro to generate these dimensions.
- **Q: How do I change the numerical value shown in the text?**
  A: The value is calculated based on the `ReferencePoint` and `ReferenceDirection` provided by the parent script. You cannot edit the text directly, but you can move the text label using the grip.
- **Q: What happens if I move the anchor point on the beam?**
  A: The dimension line start point (`_Pt0`) is linked to the `LocationPoint`. If the beam geometry or anchor updates, the script will recalculate and move the dimension line accordingly.
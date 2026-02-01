# FLR_HOLD_DOWN.mcr

## Overview
This script inserts a Simpson Strong-Tie hold-down connector (such as a hurricane tie) onto a beam or truss. It allows for detailed configuration of the hardware model, positioning, and installation method for both 3D modeling and shop drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in 3D model space to attach to beams. |
| Paper Space | No | Not supported for layout generation. |
| Shop Drawing | Yes | Generates 2D profiles if "Shop Installed" is set to Yes. |

## Prerequisites
- **Required Entities**: A single Beam or TrussEntity.
- **Minimum Beam Count**: 1 (You must select a beam to attach the hold-down).
- **Required Settings Files**: `holdowns.dxx` must exist in the `..\Abbund\` folder within your hsbCompany directory to provide the 3D connector geometry.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Browse and select `FLR_HOLD_DOWN.mcr`.

### Step 2: Select Host Entity
```
Command Line: Select beam or truss entity to attach to
Action: Click on the Beam or Truss bottom chord where you want the hold-down placed.
```

### Step 3: Define Reference Point
```
Command Line: Select end point of the beam
Action: Click near the end of the selected beam. This determines which end the "End Offset" is measured from.
```

### Step 4: Configure Properties
1.  After insertion, the script instance is selected.
2.  Open the **Properties Palette** (Ctrl+1).
3.  Adjust parameters like **Hold Down** model, **Beam side**, and **Offsets** as needed.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Hold Down | dropdown | DTT2Z-SDS2.5 SIMPSON | Select the specific model of the hold-down hardware (e.g., DTT2Z, HDU4, HDU8). |
| Beam side | dropdown | Left | Determines which side of the beam centerline the connector is attached to. Options: Left, Right. |
| Shop Installed | dropdown | Yes | If "Yes", includes the connector in shop drawings. If "No", it is treated as loose hardware for field installation. |
| End Offset | number | 6" (U(6)) | The distance from the selected beam end point to the center of the hold-down. |
| Center Offset | number | 0" (U(0)) | The vertical offset of the connector relative to the beam's vertical center. |

## Right-Click Menu Options
This script does not add custom items to the right-click context menu. Editing is done via the Properties Palette or using grips.

| Menu Item | Description |
|-----------|-------------|
| Properties | Opens the AutoCAD Properties palette to modify connector parameters. |
| Move Grip | Select the script instance and drag the square grip to slide the connector along the beam. |

## Settings Files
- **Filename**: `holdowns.dxx`
- **Location**: `_kPathHsbCompany\Abbund\`
- **Purpose**: Contains the 3D body definitions for the different hold-down types. Without this file, the script cannot generate the visible geometry.

## Tips
- **Grip Editing**: Instead of calculating exact offset numbers, select the hold-down and drag the blue grip along the beam to slide it to the desired position quickly.
- **Shop Drawings**: If the hold-down does not appear in your 2D shop drawings, check the **Shop Installed** property. It must be set to "Yes" to generate the 2D shadow/profile.
- **BOM Output**: The script automatically generates hardware components for the Bill of Materials based on the selected hold-down model, including the required fasteners.

## FAQ
- **Q: Why did the script disappear immediately after running?**
  A: This usually happens if you did not select a valid Beam or TrussEntity, or if the settings file `holdowns.dxx` is missing from your company folder.
- **Q: How do I switch the connector to the other side of the wall?**
  A: Select the connector, open the Properties (Ctrl+1), and change **Beam side** from "Left" to "Right".
- **Q: Can I use this on regular lines or polylines?**
  A: No, you must select a valid hsbCAD Beam or Truss Entity.
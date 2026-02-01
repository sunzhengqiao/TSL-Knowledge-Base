# hsb_Anchor.mcr

## Overview
Generates a parametric steel anchor plate with a stiffener flange, typically used to connect timber beams to concrete foundations. It allows users to define dimensions and assign manufacturer codes for hardware lists and CNC exports.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary working environment. |
| Paper Space | No | Script generates 3D geometry only. |
| Shop Drawing | No | Not a shop drawing layout script. |

## Prerequisites
- **Required Entities**: At least one Timber Beam (`GenBeam`) must exist in the model.
- **Minimum Beam Count**: 1
- **Required Settings**: None (script is self-contained).

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Browse and select `hsb_Anchor.mcr`.

### Step 2: Pick a Point
```
Command Line: Pick a Point
Action: Click in the Model Space to define the insertion origin (bottom corner) of the anchor.
```

### Step 3: Select a Beam
```
Command Line: Select a Beam
Action: Click on a timber beam. The anchor will orient itself based on this beam's coordinate system.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Thickness | Number | 2 mm | The material gauge of the steel plate. |
| Width | Number | 36 mm | The horizontal width of the anchor plate (along the beam axis). |
| Length | Number | 100 mm | The vertical height of the anchor plate. |
| Quantity | Number | 1 | Number of anchors for BOM/export lists. Does not create multiple visual copies. |
| Show in Disp Rep | Text | [Empty] | Filters visibility based on the current Display Representation name. |
| Model Type | Dropdown | SP90 | Manufacturer code (e.g., SP90, SP240, SPU90). Selecting a code sets the label only; dimensions must be set manually. |
| Other Anchor Type | Text | **Other Type** | Enter a custom model name if "Other Model Type" is selected in the dropdown above. |

## Right-Click Menu Options
No custom context menu options are defined for this script.

## Settings Files
No external settings files are required.

## Tips
- **Manual Dimensioning**: Selecting a "Model Type" (e.g., SP90) does not automatically resize the anchor. You must manually enter the correct Width, Length, and Thickness to match the physical product.
- **Beam Dependency**: The anchor is linked to the selected beam. If you delete the beam, the anchor will also be removed.
- **Orientation**: If you move or rotate the reference beam using AutoCAD grips, the anchor will update its rotation to match. However, the insertion point remains fixed in world space; it does not translate with the beam automatically.
- **BOM Export**: The Quantity parameter affects the data in `U_QUANTITY` for exports but only draws one object visually.

## FAQ
- **Q: Why did the anchor disappear after I deleted a beam?**
  A: The script requires a valid beam to exist for orientation. Deleting the associated beam causes the script to erase itself.
- **Q: I changed the Model Type to SP240, but the size didn't change.**
  A: The Model Type property is for labeling/export purposes only. You must manually adjust the Width (`dWi`) and Length (`dLe`) properties to match the dimensions of an SP240 anchor.
- **Q: How do I hide the anchor in specific views?**
  A: Enter the name of the Display Representation (e.g., "Presentation") into the "Show in Disp Rep" property. The anchor will only be visible when that Display Representation is active.
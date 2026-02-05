# HSB_G-Truck.mcr

## Overview
This script creates a 3D bounding box representing a truck's cargo space. It is used to visualize and verify if timber packages or stacks fit within transport dimensions.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script is inserted directly into the 3D model. |
| Paper Space | No | Not intended for 2D layout sheets. |
| Shop Drawing | No | Not intended for manufacturing views. |

## Prerequisites
- **Required entities:** None.
- **Minimum beam count:** 0.
- **Required settings files:** None.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse and select `HSB_G-Truck.mcr`.

### Step 2: Configure Dimensions
If you are not using a pre-configured catalog entry, a dialog or property prompt will appear:
1. Review the default dimensions (Length: 21000mm, Width: 2200mm, Height: 3000mm).
2. Adjust the values if your truck has different loading specifications.

### Step 3: Place Truck
```
Command Line: |Select a position|
Action: Click in the Model Space to set the insertion point (usually the rear-left corner or center of the truck bed).
```
*Note: The script will generate the 3D volume immediately after clicking.*

### Step 4: Adjust Dimensions (Post-Insertion)
1. Select the inserted Truck object in the drawing.
2. Open the **Properties Palette** (Ctrl+1).
3. Modify the **Length**, **Width**, or **Height** values.
4. The 3D box will automatically update to reflect the new dimensions.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Length | Number | 21000 mm | The usable cargo length of the truck trailer. |
| Width | Number | 2200 mm | The internal width of the truck trailer. |
| Height | Number | 3000 mm | The maximum vertical stacking height allowed (respecting road limits). |

## Right-Click Menu Options
No specific custom options are added to the right-click menu. Standard AutoCAD/hsbCAD options (Move, Rotate, Copy, Erase) apply.

## Settings Files
No external settings files are required for this script.

## Tips
- **Yard Layout:** Use this script when planning production yard layouts to ensure stacks of timber do not exceed the size of the transport trucks.
- **Visual Check:** Use the 3D visual to simulate how pallets will be loaded.
- **Unit Independence:** The script automatically handles unit conversions; ensure your working units in CAD are set correctly (usually Millimeters for timber construction).

## FAQ
- **Q: Can I change the truck size after I have placed it?**
  A: Yes. Select the object and change the dimensions in the Properties Palette.
- **Q: Does this script generate manufacturing data?**
  A: No, this is purely a visual aid (Body entity) for layout planning and checking.
- **Q: The box is too small/big for my truck.**
  A: Modify the `Length`, `Width`, and `Height` properties in the Properties Palette to match your specific truck model.
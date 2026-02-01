# hsb_FireWallAdjust.mcr

## Overview
Automates the detailing of fire-rated timber walls by inserting metal plates between wall layers and creating OSB fire-stops around openings and wall perimeters. It also adjusts stud and jack positions to accommodate the specified sheathing thickness.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D wall elements in the model. |
| Paper Space | No | Not intended for layout or annotation in 2D drawings. |
| Shop Drawing | No | Generates physical geometry, not drawing views. |

## Prerequisites
- **Required entities**: Wall Elements (`ElementWallSF`).
- **Minimum beam count**: 1.
- **Required settings**: The script `hsb_MetalPlate` must be present in your TSL search path.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_FireWallAdjust.mcr`

### Step 2: Select Elements
```
Command Line: Select a set of elements
Action: Click on the wall elements you wish to detail and press Enter.
```

### Step 3: Configure Parameters (Optional)
A dialog may appear upon first insertion. You can also adjust parameters later via the Properties Palette. Select the inserted script instance in the model to modify fire-stop thickness or plate spacing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Code FireWalla | Text | AA;B; | A list of Element Codes (separated by semicolons) that identify which walls to process. Only walls matching these codes will be modified. |
| Offset From Bottom | Number | 400 mm | The vertical distance from the bottom of the wall to the center of the first metal plate. |
| Centers Spacing | Number | 500 mm | The vertical spacing (center-to-center) between metal plates along the height of the wall. |
| OSB Thickness | Number | 9 mm | The thickness of the OSB fire-stop sheets. This also controls the gap size created between studs/jacks to fit the OSB. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | No specific context menu items are added by this script. |

## Settings Files
- **Dependency**: `hsb_MetalPlate.mcr`
  - **Location**: TSL Script Folder
  - **Purpose**: This script is called by `hsb_FireWallAdjust` to generate the metal plate geometry within the wall cavity.

## Tips
- **Filtering Walls**: If the script seems to do nothing after insertion, check the **Code FireWalla** property. Ensure the Element Codes assigned to your walls (in the Element Catalog) are listed in this string (e.g., "FW1;FW2;").
- **Geometry Shift**: Changing the **OSB Thickness** will physically move the studs, jacks, and transoms to create a gap. Ensure this does not cause clashes with other structural elements.
- **Fire Regulations**: Verify that the **Offset From Bottom** and **Centers Spacing** values comply with your local fire engineering requirements for cavity barriers.

## FAQ
- **Q: Why did the script only modify some of the walls I selected?**
  A: Check the **Code FireWalla** property. The script filters the selection based on this list. You must add the specific Element Code of the ignored walls to the list.
- **Q: My studs have moved after running the script. Is this normal?**
  A: Yes. The script automatically offsets the wall studs to create a cavity for the OSB fire-stops based on the **OSB Thickness** parameter.
- **Q: Where do the metal plates appear?**
  A: The script inserts `hsb_MetalPlate` instances between the front and back layers of the wall (e.g., between double studs) at the vertical intervals defined by the offset and spacing settings.
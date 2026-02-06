# Rothoblaas Typ F70.mcr

## Overview
This script inserts and configures Rothoblaas F70 post bases onto timber beams, including the necessary geometric cuts and slots for installation. It is used to attach timber posts to foundations using the specific F70 adjustable column base hardware.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the 3D model. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | Not a drawing generation script. |

## Prerequisites
- **Required Entities**: Timber Beams (GenBeam).
- **Minimum Beam Count**: 1.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Rothoblaas Typ F70.mcr`

### Step 2: Configure Parameters (If prompted)
```
Action: A dialog may appear to select the Size.
Options: Select from F70_1, F70_2, or F70_3.
Action: Click OK to confirm.
```
*(Note: If loaded from a catalog with predefined settings, this step may be skipped.)*

### Step 3: Select Beams
```
Command Line: Select Beam(s)
Action: Click on the timber beam(s) where you want to install the post base.
Action: Press Enter to finish selection.
```

### Step 4: Define Insertion Point
```
Command Line: Select Point |or <Enter> to put post base on bottom end of the beam|
Action:
Option A (Automatic): Press Enter. The script will place the base at the bottom center of the beam. (Note: Only vertical beams are accepted in this mode).
Option B (Manual): Click a point in the model to define the exact location of the post base along the beam.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| A - Size | dropdown | F70_1 | Selects the model variant of the Rothoblaas F70 post base (determines dimensions and hardware list). Options: F70_1, F70_2, F70_3. |
| B - Cutting height | number | 30 | Defines the starting height of the post over the bottom plate of the post base. (Unit: mm) |
| C - Slot extra width | number | 1 | Adds tolerance (extra width) to the slot cut into the timber. (Unit: mm) |
| D - Slot extra depth | number | 1 | Adds tolerance (extra depth) to the slot cut into the timber. (Unit: mm) |

## Right-Click Menu Options
None specified.

## Settings Files
None required.

## Tips
- **Vertical Beams**: If you press **Enter** instead of selecting a point, the script will automatically filter out and ignore any beams that are not perfectly vertical.
- **Sloped Beams**: If you need to attach a post base to a sloped or rafter beam, you must manually select a point on the beam (Step 4, Option B).
- **Cutting Height Limit**: The script automatically limits the "Cutting height" to a maximum of 50% of the hardware's top plate length. If you enter a value that is too high, the script will automatically correct it to the maximum allowed value.

## FAQ
- **Q: Why did the script ignore some of the beams I selected?**
  **A:** The script automatically filters beams based on your input method. If you pressed "Enter" (Automatic mode), it removes non-vertical beams. If you selected a point (Manual mode), it removes horizontal beams.
- **Q: Why did my "Cutting height" value change after I entered it?**
  **A:** The value you entered likely exceeded the maximum structural limit (50% of the hardware length). The script automatically corrected this to the maximum safe value to prevent errors.
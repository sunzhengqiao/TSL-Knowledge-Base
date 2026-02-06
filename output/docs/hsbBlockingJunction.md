# hsbBlockingJunction

## Overview
Automatically generates vertical blocking (noggings) at wall junctions or intersections. This script is used to close wall cavities or provide additional nailing surfaces by placing timber between selected beams.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script only works in Model Space. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: `ElementWallSF` (Wall) or `GenBeam` (Beams).
- **Minimum Beam Count**: 2 beams (when using manual beam selection).
- **Required Settings**: None required; all settings are managed via script properties.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbBlockingJunction.mcr`

### Step 2: Select Elements or Beams
```
Command Line: Select elements <Enter> to select pair of outer beams
Action: You have two options:
```
1. **Automatic (Element Mode)**: Select one or more Wall elements (`ElementWallSF`). The script will automatically scan the wall and create blockings at junctions.
2. **Manual (Beam Mode)**: Press **Enter**. The prompt will change to ask for beams.

### Step 3: Select Beams (Manual Mode Only)
If you pressed Enter in Step 2:
```
Command Line: Select a pair of outer beams
Action: Select at least two beams that belong to the same wall element.
```
*Note: If you select beams from different elements, the script will fail and erase itself.*

### Step 4: Configure Properties
Once the beams or elements are selected, the **Properties Palette** will appear. Adjust the parameters (Length, Distribution Mode, Offsets) as needed. The blockings will generate automatically based on these settings.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Length | number | 300 | Defines the length of the blocking beams (mm). |
| Mode | dropdown | Center Offset | Defines how blockings are distributed vertically. Options: Center Offset, Interdistance, Quantity. |
| Value | number | 0 | The specific value for the selected Mode (e.g., distance from center, gap between blockings, or number of blockings). |
| Offset Top | number | 479 | Distance from the top boundary to the top edge of the highest blocking (mm). |
| Offset Bottom | number | 479 | Distance from the bottom boundary to the bottom edge of the lowest blocking (mm). |
| Dimstyle | dropdown | (Current) | The CAD dimension style used for preview dimensions. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Erase Blockings | Deletes all generated blocking beams and removes the script instance from the drawing. |
| Change Distribution to [Mode] | Quickly switches the Distribution Mode (e.g., to Interdistance or Quantity) and recalculates the layout. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not use external settings files; all configuration is done via the Properties Palette.

## Tips
- **Grip Editing**: After insertion, select the script instance and drag the **square grip** on the dimension line to dynamically adjust the spacing (Value).
- **Mode Behavior**:
    - **Interdistance**: The script calculates spacing as `Gap + Length`.
    - **Center Offset**: Places blockings symmetrically around the wall's centerline based on the Value.
- **Same Element Rule**: When manually selecting beams, ensure they are all part of the same timber element. Mixing elements will cause the script to exit.

## FAQ
- **Q: Why did the script disappear immediately after I selected beams?**
  - A: This usually happens if you selected fewer than 2 beams, or if the selected beams belong to different elements. Ensure all beams are part of the same wall element.
- **Q: Can I change the spacing after inserting without opening the properties?**
  - A: Yes, select the script instance in the model and use the square grip to slide the blockings up/down or adjust spacing interactively.
- **Q: What does "Interdistance" mode actually do?**
  - A: It creates a repeating pattern of blockings where the "Value" represents the gap between the blockings. The script adds the blockings length to this value to determine the center-to-center spacing.
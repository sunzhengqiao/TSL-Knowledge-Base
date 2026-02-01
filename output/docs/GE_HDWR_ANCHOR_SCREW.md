# GE_HDWR_ANCHOR_SCREW

## Overview
This script generates 3D geometry for anchor screw hardware, including the rod, square washers, and hex nuts. It is designed exclusively for automated insertion by other hardware systems or scripts and supports specific sizing variations.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Generates 3D solid bodies for hardware. |
| Paper Space | No | Not designed for 2D layout. |
| Shop Drawing | No | Not designed for shop drawing views. |

## Prerequisites
- **Parent Script/System**: This script cannot be run manually. It must be inserted by a parent script or hardware system.
- **Element Association**: Usually linked to a timber element; if that element is deleted, the screw will also be removed.

## Usage Steps

### Step 1: Launch Script
**Note:** This script cannot be launched manually via the command line.
- If you attempt to run `TSLINSERT` and select this file, a warning message will display stating: *"This TSL has not yet a manual insertion defined. It can be inserted only by other script."*
- The instance will erase itself immediately.

### Step 2: Modifying Existing Instances
Since instances are created automatically by the system, you interact with them through the Properties Palette.
1.  Select the Anchor Screw instance in the drawing.
2.  Open the **Properties Palette** (Ctrl+1).
3.  Locate the `Anchor type` parameter.
4.  Select the desired size from the dropdown list (e.g., "1/2 Screw Anchor").
5.  The 3D geometry will automatically update to reflect the new size.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Anchor type | dropdown | 1/2 Screw Anchor | Selects the size of the hardware. Options include: 1/2 Screw Anchor, 5/8 Screw Anchor, and 7/8 Screw Anchor. |

## Right-Click Menu Options
None. This script does not add custom options to the right-click context menu.

## Settings Files
None. This script does not use external XML settings files; configuration is handled via internal mapping and properties.

## Tips
- **Automatic Cleanup:** If this screw is attached to a timber element (beam), deleting the timber element will automatically delete the screw.
- **Read-Only Behavior:** Depending on how the parent script inserted this hardware, the `Anchor type` property may be locked (Read-Only) to prevent changes to a calculated specification.

## FAQ
- **Q: Why does the script disappear immediately when I try to insert it?**
  - A: This is a "sub-component" script intended to be called by other scripts, not used independently. The script detects manual insertion and erases itself to prevent errors.
- **Q: Can I hide the washers and nuts?**
  - A: This depends on the instructions provided by the parent script that inserted the hardware. Some configurations may generate only the rod, while others generate the full assembly.
- **Q: How do I change the screw size?**
  - A: Select the screw in the model and change the "Anchor type" in the AutoCAD Properties Palette.
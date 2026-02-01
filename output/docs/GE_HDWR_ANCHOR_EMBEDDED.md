# GE_HDWR_ANCHOR_EMBEDDED.mcr

## Overview
This script generates a 3D model of an embedded threaded rod anchor assembly, including the rod, hex nuts, and square washers. It is designed primarily as a sub-component to be inserted automatically by other scripts (such as foundation or wall generation tools) rather than being manually inserted by the user.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Generates 3D geometry for hardware representation. |
| Paper Space | No | Not designed for 2D layout or detailing. |
| Shop Drawing | No | Does not generate shop drawing views. |

## Prerequisites
- **Required Entities**: None (geometry is generated internally based on coordinates).
- **Minimum Beam Count**: 0.
- **Required Settings**: None.
- **Note**: This script is intended to be called programmatically by a parent script or hardware manager.

## Usage Steps

### Step 1: Script Execution
**Command:** Run via parent script or attempt `TSLINSERT`
- **Action:** The script is typically launched automatically by a master script (e.g., a foundation tool) when an anchor point is calculated.
- **Result:** If executed correctly with proper input data (coordinates and type), the anchor geometry is drawn.

### Step 2: Manual Insertion Attempt (Blocked)
If you attempt to run this script manually:
- **Command Line:** `TSLINSERT` -> Select `GE_HDWR_ANCHOR_EMBEDDED.mcr`
- **Command Line Message:** "This TSL has not yet a manual insertion defined. It can be inserted only by other script. Instance will be erased"
- **Action:** The script detects it was not called by a parent system and deletes the instance immediately. You must use a parent script to insert this component.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Anchor type** | Dropdown | 1/2 Embedded Anchor | Selects the commercial size of the threaded rod anchor. Options include 1/2", 5/8", and 7/8" diameters. |

*Note: Depending on how the script was inserted, the "Anchor type" property may be Read-Only.*

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| *None* | No custom context menu items are defined for this script. |

## Settings Files
- **Filename**: None.
- **Location**: N/A.
- **Purpose**: All configuration is handled via script properties or input maps from parent scripts.

## Tips
- **Automated Use**: Do not try to insert this script manually. Ensure your main generation tool (e.g., a floor or wall plugin) is configured to call this TSL.
- **Modifying Size**: To change the anchor size after insertion, select the object in the model and change the "Anchor type" dropdown in the Properties palette (AutoCAD Object Properties Manager).
- **Read-Only Status**: If the "Anchor type" dropdown is grayed out, it means the anchor was inserted by a directive system (`InsertedByDirective` flag). You must adjust the settings in the parent script or manager to change the size.
- **Visibility**: Some instances may hide the top nut and washer (controlled by internal flags) depending on the specific construction requirements defined by the calling script.

## FAQ
- **Q: Why does the script disappear immediately after I try to insert it?**
  - A: This script does not support manual insertion. It requires coordinate data and configuration passed from a parent script. The erase functionality is intentional to prevent "dumb" placement.

- **Q: Can I change the anchor size manually?**
  - A: Yes, provided the property is not locked. Select the anchor object and look for the "Anchor type" property in the Properties palette. If it is locked (Read-Only), the size is controlled by the macro that inserted it.

- **Q: What happens if I delete the timber element this anchor is attached to?**
  - A: The script establishes an element dependency if an element is provided during insertion. If the linked element is deleted, the anchor instance will also be removed.
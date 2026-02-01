# GE_HDWR_ANCHOR_ADHESIVE.mcr

## Overview
This script generates 3D geometry for adhesive anchor assemblies, including a threaded rod, hex nut, and square washer. It is designed to function as a sub-component automatically inserted by parent connection scripts (such as column bases or hold-downs) rather than being inserted manually by the user.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Generates 3D Bodies and PLines for the anchor hardware. |
| Paper Space | No | Not applicable for 2D detailing views. |
| Shop Drawing | No | Used for 3D model representation only. |

## Prerequisites
- **Required entities**: None (typically receives insertion coordinates from a parent script).
- **Minimum beam count**: 0.
- **Required settings**: None.

## Usage Steps

### Step 1: Understand Script Context
This script does not support standard manual insertion. It is intended to be called automatically by other hardware scripts to create anchor details.

### Step 2: Manual Insertion Behavior (If Attempted)
If you attempt to run this script directly via the command line:
```
Command: TSLINSERT
Select file: GE_HDWR_ANCHOR_ADHESIVE.mcr
Result: Error message displays: "This TSL has not yet a manual insertion defined. It can be inserted only by other script. Instance will be erased."
Action: The instance is automatically deleted.
```

### Step 3: Usage via Parent Script
1.  Run a parent hardware script (e.g., a Column Base connection) that utilizes adhesive anchors.
2.  The parent script passes the anchor type, position, and orientation vectors to this script.
3.  The anchor assembly (Rod, Nut, Washer) is generated automatically at the calculated coordinates.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Anchor type | dropdown | 1/2 Adhesive Anchor | Selects the nominal diameter of the adhesive anchor. Options include 1/2", 5/8", and 7/8". Note: This property may be read-only if inserted by a parent script directive. |

## Right-Click Menu Options
No custom context menu options are defined for this script.

## Settings Files
No external settings files are required for this script.

## Tips
- **Read-Only Properties**: If the `Anchor type` property appears greyed out or uneditable, it is because the script was inserted by a parent system directive to prevent configuration errors.
- **Element Dependency**: If the script detects it is associated with a specific timber element, deleting that timber element will automatically delete this anchor instance as well.
- **Geometry Visibility**: Depending on the configuration passed from the parent script, the Washer and Nut geometry may be hidden, showing only the threaded rod.

## FAQ
- **Q: Can I insert this anchor separately for a specific detail?**
  A: No, this script currently blocks manual insertion. You must use the parent connection tool that manages the overall assembly to generate this anchor.
- **Q: Why did the anchor disappear when I deleted the beam?**
  A: The script establishes a dependency link to the host element. Removing the host element triggers the automatic deletion of the attached hardware.
- **Q: How do I change the anchor size?**
  A: If the property is not locked, select the anchor instance and change the "Anchor type" in the Properties Palette. If it is locked, you must modify the settings in the parent connection script that inserted it.
# GE_HDWR_STRAP_TSA.mcr

## Overview
This script generates 3D geometry for Simpson Strong-Tie TSA (Truss Strap Anchor) hardware, creating a steel strap with a specific nail hole pattern. It is designed strictly for automatic insertion by other TSL scripts (such as wall or truss generators) and cannot be manually placed by the user.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the intended environment for generating 3D hardware bodies. |
| Paper Space | No | Not supported for 2D layout. |
| Shop Drawing | No | Does not generate 2D shop drawings directly. |

## Prerequisites
- **Required Entities:** None (Geometry is generated based on internal calculations and coordinate mapping).
- **Minimum Beam Count:** 0.
- **Required Settings:** None.
- **Additional Info:** This script relies on internal data mapping (`_Map`) provided by a parent script to determine its location, rotation, and initial type. It generally requires an associated Element (e.g., a wall plate or beam) to attach to.

## Usage Steps

### Step 1: Attempt to Launch Script
**Command:** `TSLINSERT` → Select `GE_HDWR_STRAP_TSA.mcr`

### Step 2: Observe Behavior
```
Command Line: GE_HDWR_STRAP_TSA: This TSL has not yet a manual insertion defined. It can be inserted only by other script. Instance will be erased
```
**Action:** The script detects it is being run manually. It will display the warning above, and the script instance will immediately delete itself from the drawing.

**Note:** This script is intended to be executed automatically by a parent script (e.g., a "Generate Wall" or "Place Hardware" macro) that calculates the position and passes the necessary data to this script.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Anchor type | Dropdown | TSA18 | Selects the Simpson Strong-Tie model number. <br>• **TSA18**: 18" long strap.<br>• **TSA24**: 24" long strap. <br>Changing this updates the strap length and the number of nail holes. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Move | Standard grip action to translate the strap along the X/Y plane. |
| Rotate | Standard grip action to rotate the strap around its insertion point. |
| *Custom Options* | None. The script uses standard AutoCAD/hsbCAD manipulation tools. |

## Settings Files
- **None.** This script operates entirely based on internal logic and Properties Palette inputs; it does not require external XML or configuration files.

## Tips
- **Do Not Run Manually:** Because this script requires orientation vectors and origin points from a parent script, manual insertion will always fail. Use the specific wall or framing tool designed to place this strap.
- **Modifying Hardware:** You can change the length of the strap after it is placed by a parent script. Select the strap in the model, open the **Properties Palette**, and change "Anchor type" from TSA18 to TSA24.
- **Host Dependency:** The script attempts to link itself to a host element. If you delete the architectural element (e.g., the top plate) the strap is attached to, the script will automatically delete itself to prevent orphaned geometry.

## FAQ
- **Q: Why does the strap disappear immediately after I try to insert it?**
  - A: This script is a "sub-script" or "component" script meant to be called by other software routines. It lacks the user prompts (like "Select a point") required for manual insertion, so it erases itself to prevent errors.
- **Q: Can I switch from an 18-inch strap to a 24-inch strap?**
  - A: Yes. Select the strap in the 3D model, press `Ctrl+1` to open the Properties Palette, and change the "Anchor type" property to TSA24.
- **Q: How do I rotate the strap to align with my beam?**
  - A: Use the standard **Rotate** grip or command. Since the script is usually inserted by a smarter parent tool, it should already be aligned correctly. If not, ensure your UCS or parent tool inputs are correct.
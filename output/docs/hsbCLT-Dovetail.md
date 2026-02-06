# hsbCLT-Dovetail.mcr

## Overview
This script creates a dovetail or butterfly spline connection between two panels to mechanically interlock them. It is designed for CLT (Cross Laminated Timber) or timber panels to generate strong, glue-free joinery or mechanical connections within the 3D model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on ElementWall and Sip entities in 3D. |
| Paper Space | No | Not intended for 2D layout or detailing views. |
| Shop Drawing | No | Machining data is generated in the model, not directly in drawings. |

## Prerequisites
- **Required Entities**: Must be applied to an `ElementWall` (CLT Panel).
- **Minimum Beam Count**: None (script detects internal Sips/Beams within the wall).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT` (or `TSL` depending on environment)
**Action:** Browse the script list and select `hsbCLT-Dovetail.mcr`.

### Step 2: Select Element
**Command Line:** `Select Element:`
**Action:** Click on the `ElementWall` (Panel) where you want the dovetail connection to occur.

### Step 3: Define Insertion Point
**Command Line:** `Specify insertion point:`
**Action:** Click on the face of the selected wall at the location where the panel should be split and connected.
*Note: This point determines where the internal sub-elements (Sips) are split.*

### Step 4: Adjust Configuration
**Action:** Once placed, select the script instance in the model. Open the **Properties Palette** (Ctrl+1) to adjust dimensions (Width, Depth, Gap) or select the connection type (Dovetail vs. Butterfly Spline).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| (A) Width | Number | 50 | Defines the depth of the lap joint seen from the reference side (0 = 50% of thickness). |
| (B) Depth | Number | 28 | Defines the width of the lap joint of the main panel. |
| (C) Angle | Number | 0 | Defines the taper angle (draft) of the dovetail sides. |
| (D) Gap X | Number | 1 | Defines the clearance gap in depth for glue tolerance. |
| (E) Axis Offset X | Number | 0 | Defines horizontal offset of the tool profile from the insertion point. |
| (F) Bottom Offset | Number | 0 | Defines vertical offset (0 = complete through). Shifts the joint up from the bottom. |
| (G) Connection Type | Dropdown | Dovetail | Select between "Dovetail" (standard tenon) or "Butterfly Spline" (double-tapered key). |
| (H) Chamfer (Ref Side) | Number | 0 | Adds a bevel (chamfer) to the edges on the Reference Side (Side 0). |
| (I) Chamfer (Opp Side) | Number | 0 | Adds a bevel (chamfer) to the edges on the Opposite Side (Side 1). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Side | Inverts the side of the element the connection is applied to (Front/Back). Also triggered by Double-Clicking the script. |
| Flip Direction | Toggles the direction/orientation of the dovetail along the joint axis. |

## Settings Files
- **Filename**: None used.

## Tips
- **Double-Click to Flip:** You can quickly toggle the connection side by double-clicking the script instance in the model, rather than using the Right-Click menu.
- **Gap for Glue:** If you plan to glue the joint, ensure the (D) Gap X is set to at least 1mm or 2mm to allow for glue squeeze-out and proper adhesion.
- **Butterfly Mode:** Use the "Butterfly Spline" mode in the Connection Type property if you are creating a separate key piece insert rather than a direct edge-to-edge joint.

## FAQ
- **Q: Why did my panel disappear?**
  **A:** The script automatically splits the internal Sips (sub-elements) of the ElementWall at the insertion point. If the visual representation changes, check if the Sips were split correctly. You can Undo (Ctrl+Z) and try a different insertion point if needed.
- **Q: Can I use this on a single solid beam?**
  **A:** No, this script is designed specifically for `ElementWall` entities that contain internal `Sip` or `GenBeam` structures. It relies on splitting these internal sub-elements to create the joint.
- **Q: What does "0 = 50% of thickness" mean for Width (A)?**
  **A:** If you set the (A) Width property to 0, the script will automatically calculate the depth of the joint to be exactly half the thickness of the panel, creating a balanced center connection.
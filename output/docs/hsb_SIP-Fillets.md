# hsb_SIP-Fillets.mcr

## Overview
This script automates the creation of structural fillets (wedge cuts) at the intersections of roof panels (specifically SIPs or CLT). It processes selected roof planes to modify the geometry of the underlying beams, ensuring they fit together seamlessly with a specific joint width.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be run in the model where the roof planes exist. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | This is a detailing/modeling script. |

## Prerequisites
- **Required Entities:** `ERoofPlane` entities that contain valid `Element` and `Beam` objects.
- **Minimum Configuration:** At least two Roof Planes that physically intersect (e.g., at a hip or valley).
- **Geometry Requirements:** The Roof Elements must contain structural beams that run generally parallel to the intersection line.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse to and select `hsb_SIP-Fillets.mcr`

### Step 2: Select Roof Elements
```
Command Line: Select a set of roof elements
Action: Click on the Roof Planes (ERoofPlane) you wish to process. You can select multiple planes. Press Enter to confirm selection.
```

### Step 3: Automatic Processing
Once the selection is confirmed, the script will automatically:
1.  Analyze intersections between the selected roofs.
2.  Identify the beams closest to these intersections.
3.  Move the beams and adjust their width.
4.  Apply the planar cuts.
5.  **Delete itself** from the drawing (the geometry changes remain, but the script instance is removed).

## Properties Panel Parameters
This script does not expose any editable parameters in the AutoCAD Properties Palette.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | No user-editable properties available. |

## Right-Click Menu Options
This script does not add any specific options to the entity right-click context menu.

| Menu Item | Description |
|-----------|-------------|
| N/A | No context menu items added. |

## Settings Files
This script does not use any external settings files (XML/INI). All logic is contained within the script.

## Tips
- **Self-Cleaning Script:** The script is designed to run once and delete itself. Do not be alarmed if the script object disappears from the model after processing; the cuts and beam modifications are permanent.
- **Hardcoded Width:** The script currently uses a fixed internal value of **140mm** for the fillet width. If you require a different width, the script code must be modified by a developer.
- **Beam Direction:** Ensure that the beams within your roof elements are oriented correctly relative to the intersection. The script looks for beams parallel to the intersection line.

## FAQ
- **Q: Why did the script disappear after I ran it?**
  **A:** This is normal behavior. The script executes its logic, applies the geometry changes, and then automatically erases its instance to keep the drawing clean.
- **Q: The script ran, but no cuts appeared on my roof.**
  **A:** Ensure that the selected Roof Planes physically overlap (intersect) and that they contain valid Beams inside the Element structure. If the roofs are disjoint or lack beams, no cuts are generated.
- **Q: Can I change the 140mm fillet width?**
  **A:** Not through the interface. This value is hardcoded within the script logic. Contact your CAD administrator if this value needs to be adjusted for different standards.
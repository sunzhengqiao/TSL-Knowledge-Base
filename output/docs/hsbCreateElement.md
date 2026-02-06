# hsbCreateElement.mcr

## Overview
This script creates a structural production element (Roof or Floor) by assembling selected loose entities (beams, panels, sheets) into a single unit. It automatically calculates the element's 3D contour, defines zone thickness, and organizes the component under specific Building and Floor groups.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates exclusively in 3D Model Space to create ElementRoof entities. |
| Paper Space | No | Not applicable for 3D element creation. |
| Shop Drawing | No | This script is for modeling, not generating 2D views. |

## Prerequisites
- **Required Entities**: At least one loose GenBeam, Sheet, Panel, Collection, or Truss.
- **Assignment Status**: Entities must not currently be assigned to another existing element (they must be "loose").
- **Project Structure**: Building and Floor groups should be defined in the project browser to correctly organize the new element.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCreateElement.mcr`
*Alternatively, run the script from your custom toolbar or ribbon.*

### Step 2: Select Entities
```
Command Line: Select entities (GenBeam, Sheet, Panel, Collection, Truss):
Action: Click on the beams, panels, or sheets you want to include in the new element. Press Enter to confirm selection.
```
*Note: The script filters out entities that are already part of another element.*

### Step 3: Define Element Geometry (Interactive Preview)
A preview of the element appears. You can now adjust the orientation and contour using keyboard options:
```
Command Line: [Rectangle/Polygon/Rotate/Swap] <Enter to confirm>:
Action:
- Rotate: Press 'R' to rotate the element orientation.
- Swap: Press 'S' to flip the direction.
- Rectangle: Press 'Rec' to manually draw a rectangular contour.
- Polygon: Press 'Pol' to manually draw a polygon contour.
```
*Move your mouse to position the element origin. Press **Enter** or **Space** when satisfied.*

### Step 4: Finalize Creation
The script generates the element number, calculates zones, assigns the selected beams to the new element, and executes any specified plugin scripts.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **House Group** | String | Undefined | The specific building or project phase (e.g., "MainHouse") for the element. |
| **Floor Group** | String | Undefined | The level or story (e.g., "GroundFloor", "Roof") where the element resides. |
| **Element Number** | String | (Auto) | The unique name or ID for the element. Supports format variables. |
| **Contour Mode** | Enum | Default | Method for calculating the outer boundary. Options: Default, Bounding Shadow, Purge Contour, Draw Rectangle. |
| **Reference Plane** | Enum | Default | Defines vertical alignment relative to selected entities (e.g., by Panel, Default lowest Z). |
| **Element Thickness** | Double | 0 mm | The structural depth (dZ) of the element used for zone calculations. |
| **Exclusive Assignment** | Boolean | Yes | If "Yes", selected beams belong only to this element. If "No", they can be shared (e.g., with walls). |
| **Plugin Scripts** | String | Empty | List of additional TSL scripts to run automatically after creation (e.g., sheathing tools). |

## Right-Click Menu Options
*Note: These options appear as command line keywords during the insertion Jig phase.*

| Menu Item | Description |
|-----------|-------------|
| **Rectangle** | Switches to manual mode to define the element contour by drawing a rectangle. |
| **Polygon** | Switches to manual mode to define the element contour by drawing a custom polygon. |
| **Rotate** | Rotates the element coordinate system 90 degrees. |
| **Swap** | Flips the local Y-axis direction of the element. |

## Settings Files
No specific external settings files (XML) are required for this script. It relies on the current hsbCAD Project defaults and Group structure.

## Tips
- **Manual Contours**: If the automatic shadow calculation picks up unwanted geometry (like overhangs you want to exclude), set the **Contour Mode** to "Draw Rectangle" or "Polygon" to manually define exactly where the element starts and ends.
- **Loose Entities Only**: If the script seems to "ignore" beams you selected, check if they are already part of another element. Use the "Remove from Element" function first if you want to move them.
- **Automation**: Use the **Plugin Scripts** property to automatically run post-processing tasks. For example, add a sheathing script to this list so sheathing is generated immediately after the roof element is created.

## FAQ
- **Q: Why did my element create with a thickness of 0?**
  A: The script defaults to 0 if no thickness is detected or set. Ensure you enter a valid value in the **Element Thickness** property (in the Properties Palette) before or immediately after running the script.
- **Q: Can I include beams from different floors?**
  A: While the script allows selecting entities from various locations, they are grouped under a single **Floor Group** assignment. It is best practice to create elements per floor for organizational clarity.
- **Q: What happens if I select a Truss?**
  A: The script accepts Trusses. It will calculate the bounding geometry and include the truss within the element zones, provided the truss is not already assigned to another element.
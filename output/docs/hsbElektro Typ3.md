# hsbElektro Typ3.mcr Documentation

## Overview
This script is used to insert electrical installations (such as sockets, switches, and antennas) into timber wall elements. It automatically creates the necessary 3D machining (drills or slots) for the boxes and wire chases within the studs, while applying protective "no-nail" zones to the wall surface to prevent fasteners from damaging the cables.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary usage for inserting boxes and defining wire chases. |
| Paper Space | Yes | Generates 2D symbols and dimensions in layout views. |
| Shop Drawing | No | This is a detailing/modeling script, not a shop drawing generator. |

## Prerequisites
- **Required Entities**: An existing timber wall Element must be present in the model.
- **Minimum Beam Count**: The wall should contain structural studs (GenBeams) to receive the machining. If no studs are found at the insertion point, the 2D symbol will still be generated, but no 3D machining will occur.
- **Required Settings**: A valid TSL Catalog (XML) is recommended to quickly load standard electrical configurations, though manual selection is also possible.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or run from your hsbCAD toolbar/menu).
Select `hsbElektro Typ3.mcr` from the file list.

### Step 2: Select Wall Element
```
Command Line: Select Element:
Action: Click on the desired wall element in Model Space where you want to place the electrical installation.
```
*Note: If no element is selected, the script will abort and erase the instance.*

### Step 3: Define Insertion Point
```
Command Line: Select insertion point:
Action: Click on the wall face or elevation view to set the location of the electrical box.
```
*Tip: The script projects this point onto the wall outline to determine the exact placement.*

### Step 4: Configuration (Optional)
- If a specific catalog key was not pre-selected, a dialog box may appear asking you to select the specific electrical types (e.g., "Steckdose", "Ausschalter").
- Make your selections and confirm to generate the geometry.
- Alternatively, you can accept the defaults and modify properties later via the Properties Palette.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **dElevation** | Number | 400 | Installation height of the box measured from the floor reference (in mm). |
| **sAlignment** | Dropdown | Horizontal | Defines how multiple boxes (s0-s4) are arranged relative to each other. Choose between "Horizontal" (side-by-side) or "Vertical" (stacked). |
| **s0** - **s4** | Dropdown | [Empty] | Defines the electrical type for up to 5 positions. Options include sockets, switches, antennas, etc. Changing this updates the 2D symbol and the BOM article. |
| **dDiam** | Number | 68 | Diameter or width of the cutout required for the electrical box (in mm). |
| **dDepthInst** | Number | 68 | Depth of the electrical box penetration into the timber (in mm). |
| **sMillAlignment** | Dropdown | Bottom | Determines the routing direction of the wire chase (groove). Options: Bottom, Top, Both, Kabelführung versetzen (Offset conduit), or None. |
| **dMillWidth** | Number | 60 | Width of the wire chase slot (in mm). |
| **dMillDepth** | Number | 30 | Depth of the wire chase slot (in mm). |
| **sShape** | Dropdown | Drill | The shape of the machining for the box cutout. Options: Drill (cylindrical), Slotted Hole, or Rectangular. |
| **sWPTool** | Dropdown | Milling | The CNC operation type. Options: Milling, Drill, or None. |
| **nToolIndex** | Number | 1 | The CNC tool number assigned to this machining operation. |
| **sElementTooling** | Dropdown | Yes | Toggles the application of protective "No-Nail" zones on the element surface. Set to "No" to disable protection. |
| **nZoneTooling** | Number | 0 | Specifies the material layer (zone) where the "No-Nail" zones are applied (0 = outer surface). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Recalculate** | Forces the script to re-run and update all geometry and machining based on the current property values. |

## Settings Files
- **Filename**: `TSL Catalog` (varies by company configuration)
- **Location**: Defined in your hsbCAD configuration (Company or Install path).
- **Purpose**: Stores predefined lists of electrical types and default dimensions to speed up the insertion process.

## Tips
- **Adjusting Height**: Use the `dElevation` property in the Properties Palette to quickly move the socket up or down without re-inserting the script.
- **Multiple Boxes**: Use properties `s0` through `s4` to add multiple boxes in a single cluster. Ensure `sAlignment` is set correctly (Horizontal vs Vertical) to arrange them as desired.
- **No-Nail Zones**: If the wire chase is not appearing on the element surface, check that `sElementTooling` is set to "Yes" and that `sMillAlignment` is not set to "None".
- **Plan Views**: The script automatically generates the correct 2D symbols in your layout views; ensure your DimStyles are set up correctly for dimensions to display properly.

## FAQ
- **Q: Why is there no hole in my stud?**
  - A: Ensure the insertion point actually intersects with a structural stud (GenBeam). If the script only touches the cladding or empty space, 3D machining will not be generated.
- **Q: How do I change the symbol displayed in the plan view?**
  - A: Change the `s0` (or s1-s2) property to select a different electrical device type (e.g., change from "Steckdose" to "Antenne").
- **Q: The wire chase is going the wrong way.**
  - A: Modify the `sMillAlignment` property. Switching between "Bottom", "Top", or "Both" changes where the groove starts and ends relative to the insertion point.
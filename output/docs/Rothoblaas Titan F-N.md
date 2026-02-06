# Rothoblaas Titan F-N.mcr

## Overview
Generates 3D models, CNC machining data, and BOM information for Rothoblaas TITAN F/N angle brackets used to anchor timber walls or panels to concrete foundations.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Creates 3D steel bodies, machining, and hardware lists. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required entities**: Beams or Sip (Structural Insulated Panel) elements.
- **Minimum beam count**: 1.
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Rothoblaas Titan F-N.mcr`

### Step 2: Configure Anchor Properties
```
Dialog: AutoCAD Properties Palette (OPM)
Action: Configure the anchor settings before selecting geometry.
- Select the specific Model (Type).
- Choose Reinforcement Washer (Yes/No) if applicable.
- Set Mounting type (Nails or Screws) and Anchoring method.
- Adjust Mill depth/oversize if recessing is required.
```

### Step 3: Select Beams or Panels
```
Command Line: Select beam(s) or panel(s)
Action: Click on the horizontal timber elements or panels to receive the anchor.
Note: The script automatically filters out beams that are not perfectly horizontal.
```

### Step 4: Define Placement Side
```
Command Line: Select point on beam side
Action: For each beam selected, click on the specific face (side) where the bracket should be mounted.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| A - Type | dropdown | Titan N - TCN 200 | Selects the specific product model (Titan N or F variants), determining dimensions and hole patterns. |
| B - Reinforcement Washer | dropdown | No | Adds a steel reinforcement plate (TCW) between the bracket and timber. Only valid for Titan N - TCN 200/240. |
| C - Mounting type | dropdown | Anchor Nail LBA 4x60 | Selects the fastener for attaching the bracket to the timber (Nails vs. Round head screws). |
| D - Anchoring to the ground | dropdown | Expansion anchor | Defines the anchor type for the concrete connection (Expansion, Screw, or Chemical dowel). |
| E - Screw Diameter | dropdown | 12.0 | Diameter of the concrete anchor bolt (M12 or M16). |
| F - Mill depth | number | 0.0 | Depth of the recess (milling) cut into the timber surface for the bracket. |
| G - Oversize milling | number | 5.0 | Additional clearance added to the milling pocket dimensions. |
| H - No nail areas | dropdown | No | Adds protected zones around the bracket for automated nailing machines (requires hsbCAM). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Properties | Opens the Properties Palette to edit parameters (Type, Washer, Tooling, etc.). |
| Erase | Removes the script instance and associated geometry. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not use external settings files; all configurations are stored in script properties.

## Tips
- **Horizontal Beams Only**: The script automatically ignores vertical or sloped beams. Ensure your wall bottom plates are horizontal.
- **Height Constraints**: Ensure your timber height is sufficient. Titan N requires a minimum height of 140mm. Titan F requires at least 60mm.
- **Washer Compatibility**: The "Reinforcement Washer" option is only active for Titan N - TCN 200 and TCN 240 models. It will be ignored if you select a Titan F model.
- **Recessing**: If you set "Mill depth" greater than 0, the bracket will be embedded into the timber. Ensure "Oversize milling" allows enough clearance for easy installation.

## FAQ
- **Q: Why did the script delete itself immediately after I placed it?**
  **A:** The beam height is likely too small for the selected anchor model. Check the error message on the command line (e.g., "Bottom beam's section height is to small") and switch to a smaller anchor type if necessary.
- **Q: Why were some of my beams ignored when I selected them?**
  **A:** The script filters the selection to keep only perfectly horizontal beams (perpendicular to the Z-axis). Non-horizontal beams are automatically removed from the selection set.
- **Q: I selected "Yes" for the Reinforcement Washer, but I don't see it in the model.**
  **A:** Washers are only supported for Titan N - TCN 200 and Titan N - TCN 240. If you selected a Titan F model or Titan N - TTN 240, the washer option is disabled by the script logic.
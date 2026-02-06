# CLT Dovetail G-Connection (hsbCLT-Dovetail-G.mcr)

## Overview
This script generates a dovetail joint or butterfly spline connection (G-Connection) between CLT or timber panels. It creates a perpendicular, interlocking assembly, offering options for direct panel-to-panel machining or hardware-based butterfly spline connections.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used for generating 3D joinery and machining operations. |
| Paper Space | No | Not applicable for 2D drawing generation. |
| Shop Drawing | No | Machining is visible in Model Space only. |

## Prerequisites
- **Required Entities**: Two sets of structural panels (Sip or GenBeam entities).
- **Minimum Count**: At least one Male panel and one Female panel.
- **Configuration**: Panels should generally be perpendicular (e.g., wall-to-floor) to form a valid connection.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select the script file `hsbCLT-Dovetail-G.mcr` from the file browser.

### Step 2: Select Male Panels
```
Command Line: Select male panel(s)
Action: Click on the panel(s) that will receive the "male" part of the joint (the tenon or the primary side). Press Enter to confirm.
```

### Step 3: Select Female Panels
```
Command Line: Select female panel(s)
Action: Click on the panel(s) that will receive the "female" part of the joint (the slot or receiving side). Press Enter to confirm.
```

### Step 4: Adjust Connection
Action: The script will automatically generate the joint based on default settings. You can now select the generated element to modify dimensions via the Properties palette or right-click to flip the direction.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| (A) Width | Number | 50 mm | Defines the width/depth of the lap joint seen from the reference side. Set to 0 for 50% of panel thickness. |
| (B) Depth | Number | 20 mm | Defines the depth of the cut perpendicular to the panel surface. |
| (C) Angle | Number | 0 deg | Defines the taper of the dovetail. Use 0 for a simple rectangular lap joint; increase for a mechanical lock. |
| (D) Gap | Number | 0 mm | Defines the clearance in the depth of the joint to accommodate glue or swelling. |
| (E) Axis Offset X | Number | 0 mm | Shifts the centerline of the joint horizontally along the panel's length. |
| (F) Bottom Offset | Number | 0 mm | Defines a bottom stop for the cut. Set to 0 for a through-cut; increase to make it a blind joint. |
| (G) Open Tool Side | Dropdown | bottom | Controls how the tool extends if panels have different heights (Options: bottom, top, Both). |
| (H) Connection Type | Dropdown | Dovetail | Switches between a solid Dovetail joint or a Butterfly Spline (uses hardware). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Direction | Swaps the Male and Female panel assignments, effectively reversing the machining direction of the joint. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies entirely on OPM properties and does not require external settings files.

## Tips
- **Quick Fix**: If the machining is applied to the wrong side of the panels, select the script instance and choose "Flip Direction" from the right-click menu instead of deleting and re-starting.
- **Butterfly Mode**: When using the "Butterfly Spline" mode, the script automatically generates hardware data for the "X-fix L" connector. Ensure your BOM lists are configured to read this hardware.
- **Simple Lap Joints**: For non-locking connections, set the Angle (C) to 0. This creates a simple straight slot instead of a dovetail.

## FAQ
- **Q: Why did my script disappear after selection?**
  A: This usually happens if the selected panels are parallel to each other. The script requires panels to meet at an angle (typically 90 degrees) to calculate the joint vector.
  
- **Q: How do I include the X-fix L connector in my reports?**
  A: Change the "Connection Type" property to "Butterfly Spline". The script will create the necessary hardware component linked to the instance.

- **Q: Can I use this on curved walls?**
  A: The script is designed for linear intersections. It filters for parallel normals within a selection set, so complex curved geometries may result in invalid selection sets.
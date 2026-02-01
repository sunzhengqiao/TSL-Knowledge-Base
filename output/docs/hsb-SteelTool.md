# hsb-SteelTool.mcr

## Overview
This script automates the creation of machining operations (such as drilling, notching, swaging, and dimpling) for connections between two structural beams. It is typically used for light gauge steel or timber-to-steel connections to prepare beams for assembly.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be inserted in the 3D model. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This is a model generation tool, not a drawing annotation tool. |

## Prerequisites
- **Required Entities**: Two `GenBeam` entities (beams) existing in the model.
- **Minimum Beam Count**: 2 (One Male, One Female).
- **Required Settings**: The Male beam must belong to a valid hsbCAD Element.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb-SteelTool.mcr`

### Step 2: Select the Male Beam
```
Command Line: Select the male beam
Action: Click on the primary beam (usually the beam being cut or modified to receive the other).
```

### Step 3: Select the Female Beam
```
Command Line: Select the famale beam
Action: Click on the secondary beam (the intersecting beam).
```

### Step 4: Configure Properties
After selection, the script validates the beams and Element. If successful, the **Properties Palette** will display the "hsb-SteelTool Properties" dialog. Adjust tooling options (holes, notches, etc.) and click **Apply** or **OK** to generate the geometry.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Use properties from catalog | dropdown | Manual | Select a predefined configuration from the catalog if available. |
| Properties (Seperator) | - | - | Visual separator for the tooling section. |
| Service hole | Option | - | If enabled, creates a service hole on the selected beam. |
| Web notch | Option | - | If enabled, creates a notch in the web of the beam. |
| Lip notch | Option | - | If enabled, cuts the lip (flange edge) of the section. |
| Web hole | Option | - | If enabled, creates a specific hole in the web. |
| Dimple | Option | - | If enabled, creates a dimple depression. |
| Swage | Option | - | If enabled, creates a swage (indentation) in the beam. |
| End Chamfer | Option | - | If enabled, applies a chamfer to the beam end. |
| Flat end length | Number | - | Defines the length of the flat portion at the end of the beam before cuts. |
| Zones for applying no nail areas | Text | - | Integer string defining zones for no-nail areas. |
| Text size | Number | - | Adjusts the size of visualization text/labels. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Re-runs the script logic to update machining based on current property values or beam geometry changes. |
| Erase | Removes the script instance and the associated machining. |

## Settings Files
- **Filename**: Catalog files (XML structure, specific name depends on `sCatName` mapping).
- **Location**: Company or hsbCAD Install path.
- **Purpose**: Stores predefined sets of properties (tool codes and dimensions) to standardize connections.

## Tips
- **Angle Handling**: If beams are connected at an angle (not 90°), the script automatically increases the gap for Web Notches and Lip Cuts (multiplies gap by 3) to ensure fit.
- **Duplicate Handling**: If you run the script on the same two beams again, it will automatically erase the old instance to prevent conflicts.
- **Element Validation**: Ensure the first beam (Male) is part of an Element. If you see "No valid element found," check your beam structure.
- **CNC Data**: This script maps tool attributes to the CNC Export object, ensuring machining data is available for production.

## FAQ
- Q: I got the error "Two beams are required!"
- A: The script instance has lost its link to one or both beams (perhaps one was deleted). Erase the instance and re-run the command.
- Q: What is the difference between Male and Female beams?
- A: In this context, the Male beam is usually the primary member (the one you select first) that receives the machining or features to accommodate the Female (second) beam.
- Q: Can I apply tools to both beams?
- A: Yes, depending on the specific property configuration (Tool Codes), tools can be applied to the Male beam only, the Female beam only, or both.
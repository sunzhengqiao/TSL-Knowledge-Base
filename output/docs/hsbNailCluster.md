# hsbNailCluster

## Overview
Automates the calculation and generation of nail patterns (ElemNailCluster) at intersections between roofing components like rafters, counter-battens, and laths based on material assignments and geometric constraints.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D Elements, Beams, and Sheets. |
| Paper Space | No | Not designed for 2D layouts. |
| Shop Drawing | No | Production data is written to the model, not drawing views. |

## Prerequisites
- **Required Entities**: Roof Elements containing structural beams (rafters) and sheets (laths/boards).
- **Minimum Beam Count**: 0 (Script can be inserted manually on specific entities).
- **Required Settings**: Materials must be correctly assigned to your beams and sheets in the drawing for the script to filter them correctly.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or select from hsbCAD toolbar) → Select `hsbNailCluster.mcr`

### Step 2: Select Elements or Entities
The script provides two different workflows depending on your initial input:

**Option A: Batch Mode (Recommended for full roofs)**
```
Command Line: Select Element(s), <Enter> to select individual entities of one nailing cluster
Action: Select one or multiple Roof Elements in the model.
```
The script will automatically attach to the elements and scan for all beams and sheets matching the specified materials.

**Option B: Individual Mode (For specific joints)**
```
Command Line: Select Element(s), <Enter> to select individual entities of one nailing cluster
Action: Press <Enter> on the command line.
```
```
Command Line: Select rafter or beam
Action: Click on the structural beam (e.g., rafter) supporting the nailing.
```
```
Command Line: Select lath
Action: Click on the sheet or lath to be nailed onto the beam.
```
```
Command Line: Select entities of contact zone
Action: (Optional) Select intermediate components (e.g., counter-battens) if applicable, or press Enter to skip.
```

### Step 3: Configure Properties
After selection, the Properties Palette will open. Configure the material names and offsets to define the nailing pattern. See the *Properties Panel Parameters* section below for details.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Nailing Zone** | | | *Group Header* |
| Material | text | (blank) | The material name assigned to the lath/sheet to be nailed. Must match the material in the drawing. |
| Edge Offset | number | U(5) | Minimum distance from the edge of the lath where nailing may start. |
| Edge Offset Support (0 to ignore) | number | U(15) | Distance from the support edge (rafter) to align the first nail. Set to 0 to ignore. |
| Nail Distance | number | U(20) | Maximum spacing between nails. Set to **0** for a single nail per intersection. |
| Snap Nails to Axis | dropdown | No | Projects nail points onto an axis parallel to the rafter. Ensures straight rows. |
| **Contact Zone** | | | *Group Header* |
| Material | text | (blank) | Material name of the intermediate layer (e.g., counter-batten). |
| Edge Offset (0 to ignore) | number | 0 | Reduces the effective contact area of the intermediate material. |
| **Zone 0** | | | *Group Header* |
| Edge Offset Zone 0 | number | U(5) | Inset from the edge of the rafter face where nailing is prohibited. |
| **General** | | | *Group Header* |
| Tooling index | number | 1 | The machine tool number (e.g., nail gun index) assigned for production. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Create individual cluster nailings | Converts the smart Element-level instance into multiple independent instances, one for each specific beam/lath intersection. Allows for granular editing of specific joints. |

## Settings Files
- **None**: This script relies entirely on Properties Palette settings and geometry within the current drawing.

## Tips
- **Material Matching**: Ensure the text entered in the `Material` fields exactly matches the material names defined in your catalog or assigned to the entities.
- **Single Nail**: For joist hangers or specific single-point connections, set `Nail Distance` to `0`.
- **Alignment**: Use the `Edge Offset Support` parameter to align the first nail in a row to a specific reference point on the rafter (e.g., align with the roof edge).
- **Visual Debugging**: If no nails appear, check your command line. The script reports if no clusters were found due to material mismatches or geometries that do not intersect.

## FAQ
- **Q: I get the message "hsbNailCluster already attached to element".**
  - **A**: An instance of this script already exists on that Element. Select the existing instance in the model and modify its properties in the palette, or delete it to insert a new one.
- **Q: No nails are generated even though I selected the elements.**
  - **A**: Verify that the `Material` property in the script matches the material of the laths in the drawing. Also, check if the `Edge Offset` values are larger than the width of the material, effectively reducing the valid nailing area to zero.
- **Q: How do I change the nail gun used for production?**
  - **A**: Modify the `Tooling index` property. This number corresponds to the tool definitions in your CAM/Machine setup.
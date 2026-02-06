# hsb_Lifting Holes

## Overview
Automatically calculates the center of gravity and inserts lifting holes into wall panels to ensure balanced lifting during transport and installation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D wall elements (ElementWallSF). |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | Not applicable. |

## Prerequisites
- **Required Entities**: Wall Elements (`ElementWallSF`) with constructed geometry.
- **Minimum beam count**: Top plates must exist within the wall element.
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_Lifting Holes.mcr`

### Step 2: Configure Properties (Optional)
```
Dialog: Properties
Action: Review settings such as Hole Diameter, Offsets, and Material Weights. Click OK to confirm.
```
*Note: This dialog typically appears when the script is first inserted. You can also change these later via the Properties Palette.*

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the wall elements you wish to process. Press Enter to confirm selection.
```
*Note: The script will filter elements based on the 'Wall Types To Filter' property.*

### Step 4: Processing
The script attaches to the selected elements, calculates the Center of Gravity (CoG), and generates the drilling operations automatically.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Min Distance from Panel Edge** | Number | 150 | Safety margin between the hole center and the panel edge (mm). |
| **Min Distance between Holes** | Number | 300 | If two holes are closer than this, only one hole is created (mm). |
| **Max Distance between Holes** | Number | 3000 | Maximum allowed spread for two lifting holes (mm). |
| **Diameter Drill** | Number | 50 | Diameter of the lifting hole to be drilled (mm). |
| **Wall Types To Filter** | Text | AA;AB;AC... | List of wall codes to process. Separate codes with a semicolon (;). |
| **Timber Weight (Kg/m3)** | Number | 370 | Density of the timber structure for CoG calculation. |
| **Sheeting Zone 1 (kg/m3)** | Number | 600 | Density of sheeting material in Zone 1. |
| **Sheeting Zone 2 - 10** | Number | 0/60/600 | Density of sheeting materials for respective zones. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | No custom menu items defined. Use standard `Recalculate` if parameters are changed. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies on internal properties and does not require external settings files.

## Tips
- **Accurate Weighting**: If your walls have heavy cladding (e.g., brickwork or concrete), ensure the specific `Sheeting Zone` weights are updated so the Center of Gravity is calculated correctly.
- **Wall Filtering**: If the script skips a wall, check the `Wall Types To Filter` property to ensure the element's code is included in the list.
- **Top Plates**: The script projects holes onto the top plate. Ensure your wall elements have valid top plates assigned.
- **Visualizing CoG**: The script draws crosshairs at the calculated lifting points. Use these to visually verify the position before production.

## FAQ
- **Q: Why did only one hole appear instead of two?**
  A: The wall width might be too narrow to satisfy the "Min Distance between Holes" setting, or the calculated Center of Gravity is too close to an edge.

- **Q: The hole is not in the center of the wall. Is this correct?**
  A: Yes. The script calculates the **Center of Gravity**, not the geometric center. If the wall has heavier features on one side (windows, doors, extra framing), the hole will shift to balance the load.

- **Q: How do I account for floor sheets or insulation?**
  A: Use the `Sheeting Zone` properties (Zone 1 through 10) to assign density values to different layers of the wall construction.
# Pitzl Pfostenträger.mcr

## Overview
This script creates and applies Pitzl adjustable post base hardware (types 10930 and 10931) to timber columns. It automatically generates the necessary saw cuts, drilling, and milling operations on the beam, while providing 3D visualization and BOM entries for the hardware.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be inserted onto a beam in the 3D model. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Does not generate 2D drawings directly. |

## Prerequisites
- **Required entities**: `GenBeam` (Timber beams/columns).
- **Minimum beam count**: 1.
- **Required settings files**: `Pitzl Pfostenträger.xml` (Must be present in Company or Install path).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Pitzl Pfostenträger.mcr`

### Step 2: Select Beams
```
Command Line: Select beams:
Action: Click on one or multiple timber columns (GenBeams) in the model.
```

### Step 3: Specify Insertion Point
```
Command Line: Select insertion point / [Enter] for bottom point:
Action: 
- Press Enter: The post base is placed automatically at the bottom of the column.
- Click a Point: The post base is placed at the projected point on the beam's axis (useful for sloped beams or specific offsets).
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Family | Dropdown | 10930 | Selects the hardware model series. **10930** uses a plain pipe, **10931** uses a threaded pipe. |
| Article | Dropdown | (First available) | Selects the specific article number (e.g., 1000, 1005). Determines the load capacity and height adjustment range. |
| Height | Number | (Calculated) | The installation height of the post base mechanism. Must fall within the Min/Max range defined by the selected Article. |
| Milled | Yes/No | No | If **Yes**, a pocket is milled into the wood to recess the top plate for a flush finish. |
| Mill Depth | Number | 8 mm | Additional depth for the milling operation (only active if Milled is Yes). |
| Drill Dia Oversize | Number | 2 mm | Tolerance added to the central hole diameter for the adjustment pipe. |
| Cover Hull | Yes/No | No | If **Yes**, includes a protective cover (casing) around the rod in the visualization and BOM. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Rotate post base | Rotates the post base geometry 90 degrees around the beam's X-axis. Useful for aligning hardware on rectangular columns. |
| Set to standard height | Resets the **Height** parameter to the midpoint of the allowed range for the currently selected Article. |

## Settings Files
- **Filename**: `Pitzl Pfostenträger.xml`
- **Location**: Company or Install path
- **Purpose**: Defines the catalog of available hardware models, including dimensions (diameters, plate sizes), valid height ranges, and article numbers for Pitzl series 10930 and 10931.

## Tips
- **Height Validation**: If you manually enter a height that is too high or too low for the selected Article, the script will automatically correct it to the nearest valid limit.
- **Milling**: Use the **Milled** option when you want the top plate of the hardware to sit inside the timber rather than on top of it.
- **Sloped Beams**: When working on non-vertical columns, use the "Pick Point" option during insertion to precisely position the base along the beam's axis.

## FAQ
- **Q: Can I use this on horizontal beams?**
- **A**: This script is optimized for vertical columns. Insertion on horizontal beams is restricted or may not produce the expected results.
- **Q: Why did my height change automatically?**
- **A**: The height is constrained by the mechanical limits of the selected Article. If you change the Article to one with a smaller range, the script adjusts the height to fit.
- **Q: How do I adjust the height after insertion?**
- **A**: Select the script instance in the model and change the **Height** value in the Properties Palette, or use the grip point to stretch the connection.
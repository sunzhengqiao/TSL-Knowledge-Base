# FreeDrill.mcr

## Overview
Creates a straight cylindrical drill (hole) through one or multiple selected beams, with optional countersinks (sinkholes) at the start and end positions. Ideal for drilling bolt holes or dowel holes through multiple structural timber members defined by a 3D axis.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script uses 3D points and GenBeam selection. |
| Paper Space | No | Not designed for 2D layouts. |
| Shop Drawing | No | Does not generate shop drawing views. |

## Prerequisites
- **Required entities**: GenBeams (structural timber elements).
- **Minimum beam count**: 1.
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `FreeDrill.mcr` from the file dialog.

### Step 2: Configure Properties (Optional)
Upon insertion, the Properties palette will open. You can adjust the drill diameter and optional sinkhole dimensions here, or accept the defaults (10mm diameter).

### Step 3: Select GenBeams
```
Command Line: Select genbeams
Action: Click on the beam(s) you wish to drill through and press Enter.
```

### Step 4: Pick Start Point
```
Command Line: [Default Prompt]
Action: Click in 3D space to define the start point of the drill.
```

### Step 5: Pick End Point
```
Command Line: Select point
Action: Click in 3D space to define the end point of the drill.
```

*Result*: The drill is generated. If the geometry is valid, the drill color will be **Blue**. If the start/end points are buried inside the beam volume, it will turn **Red**.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Diameter** | Number | 10 mm | The diameter of the main through-hole. |
| **Diameter** (Sinkhole 1) | Number | 0 mm | Diameter of the countersink at the **Start** point (must be > 0 to create). |
| **Depth** (Sinkhole 1) | Number | 0 mm | Depth of the countersink at the **Start** point along the drill axis. |
| **Diameter** (Sinkhole 2) | Number | 0 mm | Diameter of the countersink at the **End** point (must be > 0 to create). |
| **Depth** (Sinkhole 2) | Number | 0 mm | Depth of the countersink at the **End** point along the drill axis. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Add Genbeams** | Prompts you to select additional beams to add to the existing drill operation. |
| **Remove Genbeams** | Prompts you to select specific beams to remove from the drill operation. |
| **Adjust closest grip** | Automatically snaps the nearest drill point (start or end) to the surface of the beam to fix invalid (red) geometry. |
| **Adjust grip 1 / Adjust grip 2** | Specifically adjusts the Start or End point to the beam surface. |

## Settings Files
None required.

## Tips
- **Creating Countersinks**: To create a sinkhole (counterbore) for a bolt head, ensure the Sinkhole Diameter is larger than the main Diameter, and the Depth is greater than 0.
- **Visual Feedback**: A **Red** drill indicates the start or end point is mathematically "inside" the beam volume rather than on the surface. Use the Right-Click "Adjust grip" options to fix this automatically.
- **Unit Independence**: The script handles unit conversions automatically, but values in the Properties palette are displayed in your current CAD units (typically millimeters).

## FAQ
- **Q: Why did my drill disappear?**
  - A: The script erases itself if the Diameter is set to 0 or if no beams are selected. Re-insert the script and check your properties.
- **Q: The sinkhole isn't appearing even though I set a diameter.**
  - A: Check that the **Depth** for that sinkhole is also greater than 0. Both Diameter and Depth must be positive values.
- **Q: Can I drill through non-parallel beams?**
  - A: Yes. As long as the 3D axis defined by your start and end points intersects the envelope bodies of the selected beams, the drill will be created.
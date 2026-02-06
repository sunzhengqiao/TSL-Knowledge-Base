# hsbScarfJoint

## Overview
Automates the creation of structural scarf joints to splice two timber beams together, including the angled cuts and connection drill holes.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates in 3D to modify beam geometry. |
| Paper Space | No | Not designed for 2D drawing views. |
| Shop Drawing | No | Geometry is created in the model, not directly on layouts. |

## Prerequisites
- **Required entities**: 2 Timber Beams (`GenBeam`).
- **Minimum beam count**: 2.
- **Required settings files**: None (Catalogs supported but optional).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbScarfJoint.mcr`

### Step 2: Configure Properties (If prompted)
```
Command Line: None
Action: If the Properties Dialog appears, select the Joint Type and dimensions. 
Note: This step is skipped if the script is executed using a predefined Catalog key.
```

### Step 3: Select Beams
```
Command Line: Select a set of beams
Action: Click on the two beams you want to join together.
```

### Step 4: Select Insertion Point
```
Command Line: Select insertion point
Action: Click on the location in 3D space where you want the two beams to meet (the center of the splice).
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | dropdown | Simple Scarf Joint | Select the geometry style: Simple Scarf, Double Scarf, or Lap. |
| Length | text | *2 | The length of the joint slope. Use `*` for relative values (e.g., `*0.25` = 25% of beam height). |
| Depth | text | *0.15 | The depth of the cut. Use `*` for relative values (e.g., `*0.15` = 15% of beam height). |
| Diameter | number | 18.0 | The diameter of the bolt/drill holes. |
| X-Offset | text | 0 | The offset of the drills from the center along the length. Use `0` for one centered drill. |
| Offset from Axis | number | 0.0 | Vertical offset of the joint from the beam center line (Only for Simple Scarf). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip X | Reverses the orientation of the scarf slope (e.g., slopes up instead of down). |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not require external settings files, though it can load configurations from hsbCAD Catalogs.

## Tips
- **Relative Values**: Use the `*` symbol for dimensions to make the joint scalable. For example, setting Length to `*2` automatically adjusts the cut length if the beam height changes.
- **Drill Placement**: To create two drills instead of one centered hole, set the **X-Offset** property to a value greater than 0 (e.g., `100` or `*0.1`).
- **Lap Joints**: When Type is set to **Lap**, the Depth property is ignored; the joint automatically cuts to 50% of the beam height.
- **Moving the Joint**: You can click and drag the script's insertion point (grip) to slide the joint along the beams. The script prevents you from dragging it past the ends of the beams.

## FAQ
- **Q: Why is my "Offset from Axis" property not changing the beam?**
  A: The "Offset from Axis" only works for the "Simple Scarf Joint" type. If you are using "Double Scarf" or "Lap", this value is forced to zero.
- **Q: Can I use this on beams of different sizes?**
  A: Yes, the script calculates the cuts individually for each selected beam.
- **Q: What happens if I drag the grip point too far?**
  A: The script includes boundary checks. If you try to drag the joint past the end of a beam, it will snap back to the previous valid position.
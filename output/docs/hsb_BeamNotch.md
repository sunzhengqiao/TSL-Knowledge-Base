# hsb_BeamNotch

## Overview
Automatically creates a notch in a target beam to accommodate the cross-section of an intersecting beam, adding a specified tolerance for assembly clearance.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates on 3D beam geometry. |
| Paper Space | No | Not designed for 2D drawing views. |
| Shop Drawing | No | Does not generate shop drawings. |

## Prerequisites
- **Required Entities:** Two GenBeams (Timber beams).
- **Minimum Beam Count:** 2.
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_BeamNotch.mcr` from the list.

### Step 2: Select Beams
```
Action: Pre-select two beams in the model before running the command.
Order Matters:
- 1st Selected Beam: Defines the shape/profile of the notch.
- 2nd Selected Beam: The beam that will be cut (notched).
```

### Step 3: Define Insertion Point
```
Command Line: Specify insertion point:
Action: Click a point in 3D space.
Note: This point represents the origin of the cutting plane. You must click inside the physical volume of the first beam (the one defining the shape). If you click outside, the script will fail to generate a profile.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Tolerance | Number | 0 | The clearance gap (in mm) added to the notch. Increasing this value makes the notch slightly larger than the intersecting beam to allow for easier assembly or paint thickness. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the notch geometry based on changes to the beams or the Tolerance property. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Beam Order:** Always select the "profile" beam first and the "target" beam second. If you reverse them, the wrong beam will be cut.
- **Visualizing the Cut:** Imagine a plane cutting through the first beam exactly where you click. The shape of that cut is what will be carved out of the second beam.
- **Tolerance:** Use the Tolerance property to create a loose fit. For tight connections, leave it at 0.
- **Placement:** If the script fails, check that your insertion point click is actually hitting the first beam, not just near it.

## FAQ
- **Q: Why does the script fail with an error?**
  A: This usually happens if the insertion point you clicked is outside the volume of the first beam. Ensure you click directly on or inside the body of the beam defining the notch shape.
- **Q: Can I move the notch after creation?**
  A: Yes, you can grip-edit the script instance (the coordinate system created at the insertion point) to move the origin of the notch along the beam.
- **Q: How do I make the hole bigger?**
  A: Select the script instance, open the Properties palette, and increase the "Tolerance" value. Right-click and choose "Recalculate" to apply the change.
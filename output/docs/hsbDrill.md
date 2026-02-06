# hsbDrill.mcr

## Overview
Creates a linear distribution of drills (round holes), slotted holes, and sinkholes (counterbores) across one or multiple selected beams to facilitate mechanical connections like bolting.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D model entities. |
| Paper Space | No | Not supported in layouts. |
| Shop Drawing | No | Does not generate 2D drawing views directly. |

## Prerequisites
- **Required Entities**: GenBeam (Timber Beams)
- **Minimum Beam Count**: 1
- **Required Settings Files**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbDrill.mcr`

### Step 2: Select Main Beam
```
Command Line: Select main genbeam
Action: Click on the primary timber beam to define the reference context.
```

### Step 3: Select Additional Beams
```
Command Line: Select additional genbeams
Action: Click any other beams you wish to drill through simultaneously. Press Enter to finish selection if only drilling one beam.
```

### Step 4: Define Start Point
```
Command Line: Select startpoint
Action: Click in the model to set the starting location for the row of holes.
```

### Step 5: Define End Point
```
Command Line: Select endpoint
Action: Click to set the ending location for the row of holes.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **General** | | | |
| Depth | Number | 0 | Depth of the drill hole. Use 0 for a through hole. |
| Diameter | Number | U(18) | Diameter of the main drill hole. |
| UCS | Dropdown | - | Aligns the drill direction relative to the current UCS (-Z, -Y, Z, Y). |
| Snap to center line | Dropdown | - | If "Yes", locks the drill path to the beam's axis. |
| Axis offset | Number | U(0) | Lateral offset from the beam centerline (Only active if Snap to center line is "No"). |
| **Sinkhole Reference Side** | | | |
| Depth | Number | 0 | Depth of the counterbore on the start side. Negative value shortens the drill. |
| Diameter | Number | U(18) | Diameter of the counterbore on the start side. |
| **Sinkhole opposite Side** | | | |
| Depth | Number | 0 | Depth of the counterbore on the end side. 0 for through. |
| Diameter | Number | U(18) | Diameter of the counterbore on the end side. |
| **Slotted Hole** | | | |
| Length | Number | U(18) | Length of the hole. If Length > Diameter, a slotted hole is created. |
| Assignment | Dropdown | - | Selects which objects get the slotted hole (none, first object, second object, all). |
| **Baufritz** | | | |
| Hardware | Dropdown | - | Selects specific hardware fasteners (e.g., Schlüsselschraube, Stehbolzen) for reporting/BOM. |
| **Distribution** | | | |
| Mode | Dropdown | - | Sets spacing logic: "Even Distribution" or "Fixed Distribution". |
| Inter distance | Number | U(70) | Center-to-center distance between holes (used in Fixed mode). |
| Distance from startpoint | Number | 0 | Offsets the first hole from the selected start point. |
| Distance from endpoint | Number | 0 | Offsets the last hole from the selected end point. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| TslDoubleClick | Re-executes the script or performs the default double-click action to modify parameters. |

## Settings Files
None defined.

## Tips
- **Through Holes**: Always set the main Depth to `0` to ensure the hole goes completely through the material, regardless of thickness changes.
- **Counterbores**: Use the Sinkhole parameters to create space for bolt heads or washers. A negative depth on "Sinkhole Reference Side" is useful for hiding bolt heads or creating dowel-like connections.
- **Slotted Holes**: To create a slot, ensure the `Length` property is larger than the `Diameter`. Use the `Assignment` property to apply the slot only to specific beams in a stack (e.g., allow movement on the outer beam while fixing the inner beam).
- **Alignment**: If holes are not drilling in the intended direction, check the `UCS` property to ensure it matches your current view orientation (e.g., switch between Z or Y).

## FAQ
- **Q: How do I drill multiple holes in a line?**
  A: The script automatically creates a distribution based on the start and end points you selected. Adjust the `Inter distance` or `Distribution Mode` in the properties to control spacing.
- **Q: My hole is not going all the way through the beam.**
  A: Check the `Depth` property under General. Ensure it is set to `0`.
- **Q: Can I offset the holes from the center of the beam?**
  A: Yes. Set `Snap to center line` to "No" and define a value for `Axis offset`.
- **Q: What does the Hardware dropdown do?**
  A: This is primarily for reporting (BOM) and potentially presetting dimensions for specific manufacturers (Baufritz standards).
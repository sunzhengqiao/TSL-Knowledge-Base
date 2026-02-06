# TimberLinx.mcr

## Overview
Generates Timberlinx self-tapping timber connectors (Type A and B series), including the necessary drilling for connector tubes, locking pins, and optional allthread for timber beam connections.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D beams in the model. |
| Paper Space | No | Not designed for 2D layout views. |
| Shop Drawing | No | Not a drawing generation script. |

## Prerequisites
- **Required entities**: 2 or more Timber Beams (`GenBeam`).
- **Minimum beam count**: 2 (One Male, One Female).
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `TimberLinx.mcr`

### Step 2: Select Male Beam
```
Command Line: Select male beam
Action: Click on the beam that will be inserted into the other beam (typically the intersecting beam).
```

### Step 3: Select Female Beam
```
Command Line: Select female beam
Action: Click on the beam that will receive the connector and the male beam.
```

### Step 4: Select Additional Beams (Conditional)
```
Command Line: Select Additional Beams
Action: If the selected connector Type is A475, AA675, or AB675, select any additional beams involved in the connection. Press Enter to finish selection.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | dropdown | A095 | Select the Timberlinx model (e.g., A095, A475, B095). This defines geometry and drill patterns. |
| Side | dropdown | Not Flipped | Mirrors the connector to the opposite side of the beam intersection. |
| Direction | dropdown | Perp Female | Sets the orientation of the connector tube relative to the beams (Perpendicular to Female, Parallel to Male, etc.). |
| As end tool | dropdown | No | If "Yes", trims the Male beam to end at the Female beam face. |
| Lateral offset | number | 0 | Shifts the connector position along the length of the beam. |
| Vertical offset | number | 0 | Adjusts the depth of the connector engagement into the female beam. |
| Quantity | number | 1 | Number of connectors to place at this location. |
| Spacing | number | U(2) | Center-to-center distance between multiple connectors. |
| Allthread length (A475, A[A/B]675) | number | 0 | Adds extra length to the connector for longer allthread rods. |
| Link Drill through | dropdown | No | If "Yes", drills the locking pin hole all the way through. |
| Pipe Drill through | dropdown | No | Drills the main connector tube through the Male, Female, or Both beams. |
| A475, AA675 As B type? | dropdown | No | Toggles specific geometry behavior for A475/AA675 types to match B-type configuration. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None detected | No custom context menu options were found for this script. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Automatic Trimming**: Enable the **As end tool** property to "Yes" if you want the script to automatically cut the male beam to meet the female beam, rather than just drilling holes.
- **Multiple Connectors**: Use the **Quantity** and **Spacing** properties to quickly arrays multiple connectors along a joint line.
- **Orientation**: If the connector is facing the wrong way, change the **Side** property to "Flipped" or adjust the **Direction** property to change the angle calculation.

## FAQ
- **Q: How do I make the connector go parallel to the beam?**
  - A: Change the **Direction** property to "Parallel Male". This aligns the connector tube along the length of the male beam.
- **Q: Why can't I see the "Select Additional Beams" prompt?**
  - A: This prompt only appears if the **Type** is set to "A475", "AA675", or "AB675". For other types, only two beams are required.
- **Q: What does the "Vertical offset" do?**
  - A: It moves the drill location deeper into or out of the female beam. Use this to adjust how deep the connector sits relative to the face.
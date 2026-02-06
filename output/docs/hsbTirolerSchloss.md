# hsbTirolerSchloss.mcr

## Overview
This script automates the creation of Tiroler Schloss (Block Dovetail) joinery for log construction. It generates interlocking corner and T-connections between logs with options for convex/concave shapes, seat cuts, and protrusions.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D GenBeams and Elements. |
| Paper Space | No | Not applicable for this script. |
| Shop Drawing | No | Tool geometry is applied in the model. |

## Prerequisites
- **Required Entities**: Two intersecting `Element` (walls) or two `GenBeam` (logs).
- **Minimum Beam Count**: 2.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT` → Select `hsbTirolerSchloss.mcr` from the list.

### Step 2: Choose Insertion Mode
```
Command Line: Select 2 walls, <Enter> to insert with beam mode
Action: 
  - To process entire walls: Select the first wall Element.
  - To process specific logs: Press <Enter>.
```

### Step 3: Select Second Element (Wall Mode Only)
```
Command Line: Select other element
Action: Select the second intersecting wall.
Note: The walls must intersect and cannot be parallel.
```

### Step 4: Select Beams (Beam Mode Only)
```
Command Line: Select beam
Action: Select the first log (GenBeam).
```

### Step 5: Select Intersecting Beams (Beam Mode Only)
```
Command Line: Select a other beams
Action: Select the intersecting log(s).
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Tool Shape | Dropdown | Corner convex | Determines the geometry type (Convex/Male, Concave/Female, Diagonal) and configuration (Corner vs T-Connection). |
| Gap | Number | 0 | Expansion or assembly gap between the interlocking logs (mm). |
| Seat width | Number | 0 | Horizontal offset of the dovetail tail. Use a **negative value** to create a flat seat cut (horizontal notch) instead of a sharp angle. |
| Tapering / Seat depth | Number | 0 | Horizontal offset of the mating profile on the intersecting beam. Acts as socket width or tapering. |
| Flankenwinkel | Number | 8 | The wedge angle of the dovetail sides (degrees). Controls pull-out resistance. |
| Protrusion | Number | 0 | Length of material protruding beyond the intersection point (mm). |
| Start at Height | Number | - | *Wall Mode Only*: The lowest Z-height at which the connection is applied. |
| End at Height | Number | - | *Wall Mode Only*: The highest Z-height at which the connection is applied. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Swap Y-Direction | Flips the orientation of the tool along the Y-axis. Useful for aligning tools with same shapes for extended connections. |
| Swap X-Direction | Flips the orientation of the tool along the X-axis. |

## Settings Files
- **Filename**: None detected.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Wall Mode vs Beam Mode**: Use "Wall Mode" (selecting Elements) to automatically apply the connection to all logs in the wall within the specified height range. Use "Beam Mode" for one-off connections on specific logs.
- **Flat Seat Cuts**: If you need a horizontal seat (shelf) inside the dovetail, enter a negative number for the **Seat width** property.
- **Diagonal Connections**: When "Diagonal" is selected in Tool Shape, the **Seat width** automatically locks to match the **Tapering / Seat depth** to ensure the cut is symmetrical.
- **Avoiding Duplicates**: If the script reports a duplicate and deletes itself, delete the existing connection on the selected beams manually before re-inserting.

## FAQ
- **Q: Why did the tool disappear immediately after I selected the beams?**
  - A: The most likely cause is that a "Tiroler Schloss" tool already exists on that specific connection. Delete the existing tool first, or ensure the elements are not parallel.
- **Q: How can I apply the connection only to the bottom half of a wall?**
  - A: Use Wall Mode, and after insertion, open the Properties Palette. Set "End at Height" to the desired top level of the bottom section.
- **Q: What does a negative "Seat width" do?**
  - A: It forces the script to create an additional horizontal cut (a seat) at the bottom of the dovetail profile, rather than a sharp angled point.
# Klingschrot.mcr

## Overview
This script automates the creation of "Klingschrot" log wall connections, machining complex profiles and seat cuts to join intersecting log walls. It utilizes a specialized fixed milling tool (Radius 175mm, Width 80mm) to create structurally interlocking corners or T-connections.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in Model Space to modify 3D beam geometry. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | This is a model generation script, not a drawing annotation tool. |

## Prerequisites
- **Required Entities**: `ElementLog` (Log Walls)
- **Minimum Beams**: 2 intersecting or touching log walls.
- **Required Settings**: None (Tool properties are static within the script).

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse and select `Klingschrot.mcr`.
3. Click Open.

### Step 2: Select Log Walls
```
Command Line: Select elements
Action: Click on the log walls you wish to connect. Press Enter to confirm selection.
```
*Note: The script will automatically detect pairs of walls. Connections are only generated if walls are perpendicular and intersecting.*

### Step 3: Configure Properties
1. After selection, the script instances are created.
2. Select a connection instance in the model.
3. Open the **Properties Palette** (Ctrl+1) to adjust parameters such as Base Height, End Height, or Seat Width.

### Step 4: Adjust Geometry
- Use **Grip Points** to visually drag and adjust the connection height.
- **Double-click** on a connection to toggle its orientation (Positive/Negative).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| dBaseHeight | Number | 0 | Defines the vertical starting point (elevation) for the machining operation relative to the bottom of the log wall. |
| dEndHeight | Number | 0 | Defines the vertical stopping point. A value of 0 extends the tooling to the top of the wall automatically. |
| dWidth | Number | 0 | Specifies the width of the horizontal seat cut (bearing surface) at the connection. |
| dDepth | Number | 0 | Specifies the penetration depth of the seat cut. Negative values force an additional beam cut operation. |
| sType | Dropdown | Concave | Selects the geometric profile: Concave (standard corner), Convex, or Diagonal (angled transition). *Note: Convex and Diagonal are hidden for T-connections.* |
| dVerticalOffset | Number | 0 | Shifts the milling tool vertically up or down from its calculated center position. |
| sOrientation | Dropdown | Positive | Defines the direction of the T-connection tooling (which side of the main wall the intersecting log connects to). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Swap Direction | Toggles the orientation of the T-Connection between Positive and Negative. This can also be triggered by double-clicking the instance. |
| Remove Logs from Connection | Excludes specific selected logs from the tooling process. Useful if a log should not be cut. |
| Restore all logs of Connection | Re-includes all logs that were previously excluded via the remove option. |
| Grip Point Drag | Activates interactive adjustment of the connection geometry via grip points in the drawing. |

## Settings Files
- **Catalog Usage**: The script supports loading properties from a catalog if executed via a specific Execute Key (`_kExecuteKey`).
- **Location**: Standard hsbCAD Catalog paths.
- **Purpose**: To apply pre-defined connection configurations (e.g., specific seat depths or heights) automatically without manual input.

## Tips
- **Perpendicular Walls**: Ensure your log walls are drawn perfectly perpendicular (90 degrees). The script silently skips non-perpendicular intersections.
- **T-Connection Behavior**: On T-connections, the `sType` is automatically locked to "Concave". If you need a Convex or Diagonal profile, ensure you are working on a corner (L-connection).
- **Grip Editing**: You can visually adjust the `dBaseHeight` and `dEndHeight` by selecting the script instance and dragging the triangular grip points up or down.
- **Double-Click**: Quickly flip the orientation of a T-connection by double-clicking the script instance, rather than changing the property manually.

## FAQ
- **Q: I selected the walls, but no tooling appeared. Why?**
  - A: The script only generates connections for perpendicular, intersecting walls. Ensure your walls cross each other and are not parallel. Also, ensure the intersection area is sufficient.
- **Q: Can I change the tool radius from 175mm?**
  - A: No, the tool radius (175mm) and width (80mm) are static values embedded in the script to match the physical "Klingschrot" tooling requirements.
- **Q: What does a negative `dDepth` value do?**
  - A: A negative depth forces the script to perform an additional beam cut operation, which is sometimes required to clear material completely for specific joint geometries.
- **Q: How do I stop the connection from cutting the top few logs?**
  - A: Set the `dEndHeight` property to the specific elevation where you want the cutting to stop.
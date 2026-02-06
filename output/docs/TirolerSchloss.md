# TirolerSchloss.mcr

## Overview
Automates the creation of "Tiroler Schloss" (dovetail-style) corner joints between intersecting log walls in 3D model space. It calculates geometric intersections and applies a specific notch machining to individual logs within defined height ranges.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in 3D environment to calculate intersections. |
| Paper Space | No | Not supported for layout generation. |
| Shop Drawing | No | This is a model generation/detailing script. |

## Prerequisites
- **Required Entities**: At least two `ElementLog` (Log Wall) entities that physically intersect.
- **Minimum Beam Count**: 2 intersecting walls.
- **Required Settings**: None specific (uses script properties).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `TirolerSchloss.mcr` from the list.

### Step 2: Configure Connection
```
Dialog: "Tiroler Schloss" Properties
Action: Adjust parameters such as Dovetail Angle, Gap, and Joint Type (Convex/Concave/Diagonal). Click OK to confirm.
```
*Note: If run from a catalog, defaults may be applied automatically.*

### Step 3: Select Log Walls
```
Command Line: "Select ElementLog entities:"
Action: Click on the log walls you wish to connect. You can select multiple walls at once to process all corners in a group. Press Enter to finish selection.
```

### Step 4: Processing
The script automatically detects intersections between the selected walls. It creates a new script instance at each valid corner and applies the machining tools to the logs.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sType | dropdown | Convex | Shape of the corner profile (Convex, Concave, or Diagonal). |
| dBaseHeight | number | 0 | Vertical start elevation (Z-level) for the connection. |
| dEndHeight | number | 0 | Vertical end elevation. Set to 0 to run the connection to the top of the wall automatically. |
| dVerticalOffset | number | 0 | Moves the entire connection geometry up or down. Useful for aligning with floor levels. |
| dGap | number | 0 | Clearance distance between the two intersecting log surfaces (for insulation or wood compression). |
| dDovetailAngle | number | 8 | Angle of the dovetail flanks in degrees. |
| dOffsetThis | number | 0 | Width of the seat cut (horizontal flat surface) on the primary wall. |
| dOffsetOther | number | 0 | Seat depth on the secondary wall (Label changes to "Tapering" if Type is Diagonal). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Swap Walls | Switches the priority of the two connected walls. Use this if the notch is cut on the wrong side of the intersection. |
| Remove Logs from Connection | Select individual beams to exclude them from the machining process (e.g., to keep a log full length for a window opening). |
| Restore all logs of Connection | Re-includes all previously excluded logs back into the machining process. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies entirely on Properties Panel inputs and does not require external settings files.

## Tips
- **Batch Processing**: You can select more than two walls during insertion. The script will automatically find all valid corners among the selection set.
- **Floor Alignment**: If your walls start at floor level but you need the notch to align with the finished floor, use the `dVerticalOffset` property to shift the cut without moving the walls.
- **Avoiding Clashes**: Use the "Remove Logs from Connection" context menu option to prevent the notch from cutting into logs that contain door or window frames.
- **Joint Geometry**: If logs are difficult to assemble, try reducing the `dDovetailAngle` (e.g., to 6°). If the joint is too loose, increase the angle.

## FAQ
- **Q: Why didn't the script create a connection between two specific walls?**
  **A**: The script requires walls to physically intersect with a minimum overlap area. Ensure the walls are not parallel and actually cross each other in the 3D model.
- **Q: How do I make the connection stop at a specific height instead of going to the top?**
  **A**: Set the `dEndHeight` property to your desired Z-value (in mm). Setting it to 0 tells the script to go all the way to the top.
- **Q: The "Diagonal" type looks weird. What happened?**
  **A**: When `sType` is set to "Diagonal", the `dOffsetOther` parameter changes behavior to act as a tapering value. Adjust this parameter to flatten or steepen the diagonal cut.
# PunchMarkerSip.mcr

## Overview
This script generates CNC punch markers on Structural Insulated Panels (SIPs) to indicate assembly locations or machining references. It creates visual geometry in the model and automatically generates data for shop drawings and CNC exports.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script runs and attaches to entities here. |
| Paper Space | No | Not applicable. |
| Shop Drawing | Indirectly | Visuals appear here automatically via DimRequests generated in Model Space. |

## Prerequisites
- **Required Entities**:
  - For individual panels: A **GenBeam (Sip)** and an **EntPLine** (Polyline) to define the path.
  - For aggregate panels: A **MasterPanel** containing ChildPanels with existing markers.
- **Minimum Beam Count**: 1
- **Required Settings**: None

## Usage Steps

### Step 1: Launch Script
Command: `hsb_ScriptInsert` (or `TSLINSERT`) → Select `PunchMarkerSip.mcr`

### Step 2: Select Panel
```
Command Line: |Select a Sip or select MasterPanel|
Action: Click on the Structural Insulated Panel (GenBeam) you wish to mark.
```
*Note: If you select a MasterPanel, the script will aggregate markers from its sub-panels.*

### Step 3: Select Tool Path
```
Command Line: |Select tool path|
Action: Click on the Polyline (PLine) that defines where the punch marks should be placed.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Vertex display radius | Number | 20 mm | Sets the visual size of the punch mark circles in the model and shop drawings. |
| Vertex distance | Number | 0 mm | Sets the spacing between punch marks. <br>• **0**: Marks placed only at polyline corners (vertices). <br>• **> 1**: Marks distributed evenly along the line at this interval. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add specific custom items to the right-click context menu. |

## Settings Files
- **None**: This script does not require external settings files.

## Tips
- **Distribute Marks Evenly**: To create a dashed line of punches along a curve instead of just corners, set the **Vertex distance** property to a value greater than 1 (e.g., 600mm).
- **Update Path**: You can move or reshape the original Polyline using AutoCAD grips. The script will automatically recalculate and move the punch markers to match the new geometry.
- **MasterPanel Visualization**: If you use this script on individual ChildPanels inside a MasterPanel, you can insert the script on the MasterPanel itself to visualize all punch markers in the aggregated view.

## FAQ
- **Q: The marks are too small to see clearly in the shop drawing. How do I fix this?**
  - A: Increase the **Vertex display radius** property in the Properties Palette. This only affects the visual size, not the CNC punch depth.
- **Q: I want marks every 500mm, but currently, they are only at the corners.**
  - A: Change the **Vertex distance** from `0` to `500`.
- **Q: Does this change the actual CNC machining?**
  - A: Yes, the script generates a `PUNCHMARKER` tool instruction. Changing the path or spacing will update the CNC code generated for the machine.
# TrussNailPlate.mcr

## Overview
This script generates 3D solid bodies representing metal nail plates used to connect timber members in truss construction. It is designed primarily as a sub-component that is automatically inserted by a parent truss generation script to visualize the position, size, and orientation of connectors.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script creates 3D solid geometry in the model. |
| Paper Space | No | This script does not generate 2D layout views or annotations. |
| Shop Drawing | No | This is a model-space detail component, not a drawing generator. |

## Prerequisites
- **Parent Script**: This script relies on map data (Length, Width, Coordinate System) passed to it from a parent script (e.g., a Truss Generator). It does not prompt for dimensions manually.
- **Required Entities**: None (standalone component, but positioned relative to timber beams via parent script logic).
- **Minimum Beam Count**: 0.

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT` → Select `TrussNailPlate.mcr`
**Note:** This script is typically called automatically by a truss generation macro. If inserted manually, it requires existing Map data to display geometry.

### Step 2: Execution
```
Command Line: [No prompts appear]
Action: The script reads data from the Instance Map (Length, Vectors, etc.) and generates the 3D plate geometry automatically.
```
*Note: Because this script reads from a Map, there are no interactive command-line inputs for dimensions or position.*

## Properties Panel Parameters
All properties listed below are **Read-Only**. To change these values, you must modify the parent generating script or the instance map data.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Plate Gauge | Text | strGauge | Identifies the gauge or thickness standard of the metal plate (e.g., '20ga'). |
| Plate Label | Text | strLabel | A user-defined identifier or part number for the specific plate profile. |
| Plate Length | Number | dLength | The physical length of the nail plate (in mm). |
| Plate Height | Number | dDepth | The physical width or height of the plate (in mm). |
| Plate Thickness | Number | 2.0 | The material thickness of the steel plate (in mm). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Re-runs the script logic to regenerate the plate body based on the current Map data and coordinate system. |
| (Standard Options) | Standard AutoCAD/TSL options (Erase, Move, Rotate, Properties, etc.) are available. |

## Settings Files
No specific external settings files (`xml`) are used by this script. All configuration is handled via the parent script's Map inputs.

## Tips
- **Color Indicator**: Upon insertion, the script automatically sets the instance color to **Index 8** (Dark Grey) to distinguish it from timber elements.
- **Geometry Visibility**: If the plate is not visible, check that the parent script provided a **Length** greater than 0. The script aborts silently if the length is invalid.
- **Modifying Position**: Use standard AutoCAD **Grips** to move or rotate the plate after insertion. The plate will redraw to match the new orientation.
- **Double Plates**: The script supports configurations for double-plating (two plates separated by an offset) or single centered plates, determined by the offset vectors passed by the parent script.

## FAQ
- **Q: Why can't I change the Length or Thickness in the Properties Palette?**
  - A: This script is designed as a "child" component. All dimensions are Read-Only to maintain consistency with the parent truss design. You must edit the source parameters in the truss generation tool.
- **Q: Why did my plate disappear after updating the truss?**
  - A: The script performs a validation check. If the calculated length or width is 0 or negative (e.g., beams no longer intersect), the geometry will not be drawn. Check your truss geometry.
- **Q: Can I use this script manually for a custom plate?**
  - A: Yes, but you must provide the correct Map data (Length, Depth, Vectors) via the API or a custom setup script, as there are no command-line prompts to enter these values.
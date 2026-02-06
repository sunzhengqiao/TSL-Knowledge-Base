# hsbCNC.mcr

## Overview
Generates CNC machining operations (saw cuts, millings, and no-nail zones) on timber elements and wall panels based on user-defined polylines or geometric references.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Must be run inside an active Element or Sheet context. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Manufacturing data is applied directly to the 3D model. |

## Prerequisites
- **Required Entities**: An existing `Element` (e.g., a wall) or `Sheet` must exist in the drawing.
- **Minimum Beams**: 0 (Can be applied to sheets/panels without beams).
- **Required Settings**: Standard hsbCAD catalogs for tool properties.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCNC.mcr` from the list.

### Step 2: Select Target Element
```
Command Line: Select Element / Sheet:
Action: Click on the timber wall, floor, or single sheet where the CNC operation should be applied.
```
*Note: If the script detects you are already inside an element context, it may skip this step.*

### Step 3: Define Geometry
```
Command Line: Select Entity / [Select Point]:
Action:
Option A: Click an existing line, polyline, or beam in the model to use as the reference path.
Option B: Click a point in space to manually draw the tool path.
```

### Step 4: Configure Tool
Once placed, select the script instance and open the **Properties Palette** (Ctrl+1). Adjust the `nTool` parameter to define the operation type (Saw, Milling, or No-Nail).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| nTool | Index | 0 | **Tool Type**: 0 = Saw cut, 1 = Milling, 2 = No-Nail zone. |
| dDepth | Double | 20.0 | **Cut Depth**: The depth of the machining into the material (mm). |
| dAngle | Double | 0.0 | **Saw Angle**: The tilt angle of the saw blade relative to vertical (-89° to 89°). Only used for Saws. |
| nSide | Enum | 0 | **Side Application**: 0 = Automatic, 1 = Left, 2 = Right, 3 = Center. Determines lateral offset. |
| nZone | Int | 0 | **Target Layer**: Specifies which material layer (zone) to machine. Use -99 or 99 for outermost layers. |
| dClearToolDiameter | Double | 0.0 | **Clear Tooling**: Diameter offset used for pocketing closed contours to ensure full material removal. |
| sTxt | String | "" | **Label Text**: Annotation text for the shop drawing (e.g., 'Window Cut'). Supports dynamic variables like '@(Name)'. |
| dTxtH | Double | 100.0 | **Text Height**: Visual height of the label text in the model (mm). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Swap Direction | Reverses the direction of the tool path (e.g., Start Point becomes End Point). |
| Clear Tooling | Calculates offsets for closed contours to ensure the entire area is machined (pocketing). |

## Settings Files
- **Catalogs**: Standard hsbCAD Tool/Machine catalogs.
- **Location**: Defined in your hsbCAD configuration folder.
- **Purpose**: Provides default parameters for tool widths and speeds.

## Tips
- **Toggle Side Quickly**: Double-click the script instance in the model to instantly toggle the machining side (Left <-> Right).
- **Layered Walls**: Use the `nZone` parameter to restrict a milling operation to a specific layer (e.g., only the OSB sheathing) without cutting the structural timber.
- **Dynamic Labels**: Use `@(Name)` in the `sTxt` field to automatically display the name of the element or beam the tool is applied to.
- **Pocketing**: If you need to mill out a completely closed rectangle (pocket), ensure `dClearToolDiameter` is set to your tool width and use the "Clear Tooling" option.

## FAQ
- **Q: Why is the dAngle parameter greyed out?**
  **A:** The angle property is only valid for Saw cuts (`nTool` = 0). It is disabled for Millings and No-Nail zones.
- **Q: How do I cut through the entire wall thickness?**
  **A:** Set the `dDepth` to a value greater than or equal to the total thickness of the target zone/element.
- **Q: What is the difference between "Left" and "Right" side settings?**
  **A:** This depends on the direction the tool path was drawn. "Left" is typically to the left side of the direction vector from the start point to the end point. Using "Automatic" (0) is recommended for complex geometry.
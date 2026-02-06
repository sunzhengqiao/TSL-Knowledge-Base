# hsbCLT-RebateEdge.mcr

## Overview
Creates a single rebate (notch) along the edge of a CLT or SIP panel, supporting rounded or angular profiles. This tool is typically used to create seating recesses for floor joists, rafters, or cross-members.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script modifies 3D geometry directly. |
| Paper Space | No | Not designed for 2D layouts. |
| Shop Drawing | No | Does not generate shop drawing views. |

## Prerequisites
- **Required Entities**: Sip (Panel) element.
- **Minimum Beam Count**: 1 Panel.
- **Required Settings**: None specific.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-RebateEdge.mcr`
*Note: If executed from a catalog, the property dialog may be skipped.*

### Step 2: Select Panel
```
Command Line: Select panels
Action: Click on the CLT or SIP panel edge where you want to apply the rebate.
```

### Step 3: Define Start Point
```
Command Line: Start point [pick]
Action: Click on the panel edge to define the start location of the rebate.
```

### Step 4: Define End Point
```
Command Line: End point [pick]
Action: Click along the same edge to define the end location. This sets the length.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sFace | dropdown | Reference Side | Selects which side of the panel the rebate depth is calculated from (Reference or Opposite). |
| dDepth | number | 20 mm | The depth of the rebate cut perpendicular to the panel edge. |
| dWidth | number | 40 mm | The length of the rebate opening measured along the panel edge. |
| dRadius | number | 0 mm | The radius of the rebate corners. Setting this to 0 forces an angular shape. |
| sShape | dropdown | Round | Determines the profile of the rebate corners (Round or Angular shaped). |
| OverShootStart | Yes/No | No | Extends the rebate cut past the user-defined start point. |
| OverShootEnd | Yes/No | No | Extends the rebate cut past the user-defined end point. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Side (Doubleclick) | Toggles the rebate to the opposite face of the panel (Reference vs Opposite). |
| Overshoot Start | Toggles the extension of the cut beyond the start grip point. |
| Overshoot End | Toggles the extension of the cut beyond the end grip point. |
| Overshoot (Both) | Toggles extensions for both start and end points simultaneously. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: All parameters are managed via the Properties Palette.

## Tips
- **Quick Flip**: Double-click the script grip in the model to instantly flip the rebate to the other side of the panel.
- **Radius Constraints**: If you set the `dRadius` to 0, the `sShape` property automatically locks to "Angular shaped". To enable "Round", ensure `dRadius` is greater than 0.
- **Geometry Limits**: If you use "Angular shaped" with a radius larger than the width, the tool will automatically adjust the width to fit the radius.
- **Visuals**: When using a "Round" shape, the script will generate a radial dimension request and display the radius value (e.g., "R50") in the model.

## FAQ
- **Q: Why is the 'Shape' property locked and grayed out?**
  **A:** This happens when the `dRadius` is set to 0. Increase the radius value to unlock the "Round" shape option.
  
- **Q: How do I make the cut go all the way through a connected member?**
  **A:** Select the script instance, right-click, and choose "Overshoot Start" or "Overshoot End" to extend the tool body beyond the grip points.
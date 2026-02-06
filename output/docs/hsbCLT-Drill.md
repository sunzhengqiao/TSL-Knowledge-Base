# hsbCLT-Drill.mcr

## Overview
Creates customizable vertical or angled drill holes (with optional sinkholes/counterbores) through CLT panels or elements for utilities, fasteners, or connections.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model elements. |
| Paper Space | No | Not applicable for 2D drawings. |
| Shop Drawing | No | Not applicable for shop drawings. |

## Prerequisites
- **Required Entities**: GenBeam (e.g., CLT panels) or Element.
- **Minimum Beam Count**: 1.
- **Required Settings**: `hsbCLT-Drill.xml` (Default configurations).

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT`
**Action:** Browse and select `hsbCLT-Drill.mcr`.

### Step 2: Select Configuration
**Dialog:** "Select properties or catalog entry"
**Action:** Choose a preset (e.g., "Default", "LastInserted") from the list to load initial parameters, or select an option to define settings manually later.

### Step 3: Select Panel
**Command Line:** `Select beams/elements:`
**Action:** Click on the CLT panel or timber element where you want to place the drill.

### Step 4: Select Insertion Point
**Command Line:** `Specify insertion point:`
**Action:** Click on the face or edge of the selected panel to define the start location of the drill.

### Step 5: Adjust Placement
**Action:** Once placed, use the **Grips** (blue squares) in the model view to drag the drill location, adjust depth, or change angles. Alternatively, open the **Properties Palette** (Ctrl+1) to modify numerical values.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **dDiameter** | Number | 12 mm | The diameter of the main drill hole. |
| **dDepth** | Number | 0 mm | The depth of the hole. **0** indicates a through-hole (passing completely through the panel). Any other value creates a blind hole. |
| **sFace** | String | Reference Face | The reference plane for the drill. Options: `Reference Face`, `Top Face`, or `Edge`. |
| **dBevel** | Number | 0° | The tilt angle of the drill axis relative to the perpendicular of the selected face (-90° to 90°). |
| **dRotation** | Number | 0° | Rotates the drill axis direction within the plane of the face. |
| **dAxisOffset** | Number | 0 mm | Distance from the insertion point to the actual drill start axis. Used primarily for edge drilling to clear the material edge. |
| **sSnapAxis** | String | No | If set to `Yes`, forces the insertion point to snap to the calculated axis defined by the offset. |
| **dDiameterSinkStart** | Number | 0 mm | Diameter of a counterbore (sinkhole) at the entry side of the drill. |
| **dDepthSinkStart** | Number | 0 mm | Depth of the counterbore at the entry side. |
| **dDiameterSinkEnd** | Number | 0 mm | Diameter of a counterbore at the exit side of the drill. |
| **dDepthSinkEnd** | Number | 0 mm | Depth of the counterbore at the exit side. |
| **sFormat** | String | @(Radius) | Template string for the text label displayed near the drill (e.g., "D@(Diameter)"). |
| **dTextHeight** | Number | 0 mm | Height of the label text. **0** uses the CAD text style default. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Flip Side** | Reverses the drill direction relative to the selected face. |
| **Add/Remove Format** | Opens a command-line list to add or remove tokens (like Radius or Diameter) from the on-screen text label. |
| **Set Bevel +/- 45°** | Quick shortcuts to set the drill angle to 45 or -45 degrees. |
| **Add/Remove Panels** | Allows you to modify the selection of panels the drill passes through. |

## Settings Files
- **Filename**: `hsbCLT-Drill.xml`
- **Location**: Company or Install path
- **Purpose**: Stores default catalog entries and presets for diameters, depths, and standard configurations.

## Tips
- **Through Holes**: For standard utility penetrations, leave `dDepth` as `0`. This ensures the hole automatically cuts through the entire panel thickness, even if the panel size changes later.
- **Counterbores**: Use the `dDiameterSinkStart` and `dDepthSinkStart` parameters to create space for bolt heads or washers so they sit flush with or below the panel surface.
- **Edge Drilling**: If drilling from the edge, use the `dAxisOffset` property to push the drill start point slightly away from the edge to avoid visual clipping or calculation errors at the boundary.
- **Grip Editing**: You can drag the "Depth" grip (the endpoint handle) in the 3D view to visually set a blind hole depth instead of typing the number.

## FAQ
- **Q: How do I create a hole that goes through multiple stacked panels?**
  **A:** Set `dDepth` to `0` (Through). Select the first panel, and the insertion point. If other panels intersect the drill path, the script will typically cut through them as well or you can add them via the context menu.
  
- **Q: Why is my drill not going through the whole panel?**
  **A:** Check the `dDepth` property in the Properties Palette. It is likely set to a specific value (e.g., 50mm) instead of `0`.

- **Q: Can I angle the hole?**
  **A:** Yes. Use the `dBevel` property to tilt the drill up/down, and `dRotation` to swivel it left/right. You can also use the 3D rotation grips on the drill visualization.
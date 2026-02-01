# Hilti-P2P

## Overview
Automates the connection of timber structural elements (Beams, SIPs, Sheets) using Hilti Point-to-Point fasteners. It calculates optimal placement, generates the hardware components, and applies the necessary drill holes for the connection.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment to calculate intersections and create physical hardware. |
| Paper Space | No | Not designed for 2D detailing or viewports. |
| Shop Drawing | No | This is a model generation script, not a 2D detailing tool. |

## Prerequisites
- **Required Entities**: At least two `GenBeam`, `Beam`, `Sip`, or `Sheet` elements.
- **Minimum Beam Count**: 2 (overlapping or touching).
- **Required Settings**: `TslUtilities.dll` (must be located in `%hsbInstall%\Utilities\DialogService`).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Hilti-P2P.mcr`

### Step 2: Select Elements
```
Command Line: Select GenBeam(s) [Settings]:
Action: Select the timber elements you wish to connect.
```
- **If `sInsertionMode` is "Select"**: Select a group of beams. The script will automatically find valid connections between all pairs in the selection.
- **If `sInsertionMode` is "Single"**: You will be prompted to select exactly two beams to connect.

### Step 3: Configure Connection
Once inserted, the script places an initial connection instance. Select the instance to modify parameters in the Properties Palette or drag the grip (if in Manual mode).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| dOffsetBottom | Number | 0 | Distance from the start of the intersection to the first fastener (mm). |
| dOffsetTop | Number | 0 | Distance from the end of the intersection to the last fastener (mm). |
| dOffsetBetween | Number | 600 | Spacing between consecutive fasteners along the connection (mm). |
| dDepth | Number | 200 | Penetration depth of the screw/drill into the material (mm). |
| sInsertionMode | Dropdown | Select | Choose "Select" for multiple beams or "Single" to connect exactly two specific beams. |
| sDistribution | Dropdown | Equidistant | Choose how fasteners are placed: "Equidistant" (evenly spaced), "Ends" (start/end only), or "Manual" (user defined). |
| sShowTooling | Dropdown | Yes | Toggle to show or hide the graphical representation of drill holes. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Swap Direction | Flips the connection to the opposite side of the beams. Useful if the connection was calculated on the wrong face. |

## Settings Files
- **Filename**: `TslUtilities.dll`
- **Location**: `%hsbInstall%\Utilities\DialogService`
- **Purpose**: Provides the core functionality required for script interaction and dialog services.

## Tips
- **Quick Adjustments**: Select the instance and use the **Properties Palette** to quickly change the screw spacing (`dOffsetBetween`) or depth (`dDepth`).
- **Manual Placement**: Set `sDistribution` to **Manual** to reveal a grip point. You can drag this grip to exactly position a single screw along the beam.
- **Visual Clutter**: If your model becomes too cluttered with drill hole graphics, set `sShowTooling` to **No**. The CNC data will still be generated, but the graphics will be hidden.
- **Swapping Sides**: If the script connects beams on the interior face when you need the exterior, select the instance, right-click, and choose **Swap Direction**.

## FAQ
- **Q: Why does the script fail with "No common intersection region"?**
  **A:** Ensure your timber beams physically overlap or touch in the 3D model. The script requires a geometric intersection to calculate the connection points.

- **Q: The "Swap Direction" option gives an error. Why?**
  **A:** This happens when there is no valid geometry on the opposite side of the beam (e.g., nothing to connect to on the other side) or the gap exceeds the tolerance.

- **Q: Can I connect non-rectangular beams?**
  **A:** The script is designed for standard timber elements. Complex geometries might result in invalid intersections if a common planar face cannot be determined.
# hsbCLT-TongueGroove.mcr

## Overview
Generates a tongue and groove (dovetail) connection profile on the edges of CLT panels. This script supports single or double connections with configurable gaps, chamfers, and offsets, allowing for watertight or structural joints between wall or floor panels.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates in 3D model space only. |
| Paper Space | No | Not designed for 2D layout or shop drawings. |
| Shop Drawing | No | Generates physical geometry/machining, not annotations. |

## Prerequisites
- **Required Entities**: `ElementWall` (CLT Wall) or `Sip` entities.
- **Minimum Count**: At least 1 CLT panel.
- **Required Settings**:
  - `hsbSettings` (specifically the HH2-Tab for milling head configurations).
  - `TslUtilities.dll` (must be loaded).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-TongueGroove.mcr` from the list.

### Step 2: Select Reference Panel
```
Command Line: Select element:
Action: Click on the CLT wall or floor panel you wish to machine.
```

### Step 3: Define Insertion Point
```
Command Line: Give point:
Action: Click on the edge of the panel where the tongue and groove connection should begin.
```
*Note: The side of the edge where you click determines the "Reference Side" vs. "Opposite Side".*

### Step 4: Automatic Processing
- **If Construction (Sips) exists**: The script will automatically split the panel at the insertion point and apply the 3D machining (groove/tongue) to the respective sides.
- **If no Construction exists**: The script will draw a plan symbol indicating the location of the future joint. Machining will be applied automatically once the Sips/Construction are generated.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sReference | Dropdown | Reference Side | Determines which side of the connection acts as the primary reference (Male vs Female logic). Options: Reference Side, Axis, Opposite Side. |
| dInterdistance | Number | 11 | Distance between two parallel profiles. Set to **0** for a single connection. |
| dGapCen | Number | 0 | Width of the material web left in the center of a double connection (ignored if single connection). |
| dReferenceOffset | Number | 10 | Offset distance from the insertion point where the profile actually starts. Set to 0 for the profile to run through the entire intersecting length. |
| dGapRef | Number | 0 | Angle of the dovetail slope on the reference side (0-90 degrees). Use 0 for a rectangular tongue/groove. |
| dGapOpp | Number | 1 | Clearance gap (mm) in the depth of the connection on the opposite side to prevent binding during assembly. |
| dChamferRef | Number | 0 | Size of the chamfer (bevel) on the entry edge of the reference side. |
| dChamferOpp | Number | 0 | Size of the chamfer (bevel) on the entry edge of the opposite side. |
| dWidthTongue | Number | 19 | Depth of the tongue/groove from the panel face. Set to **0** to automatically use 50% of panel thickness. |
| dZDepth | Number | 15 | Width/length of the tongue/groove profile along the panel edge. |
| dGapTongue | Number | 0 | General clearance gap (tolerance) added to the tongue dimensions for a loose fit. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Side | Swaps the reference side to the opposite face of the panel. This effectively moves the insertion point to the other side of the material thickness. |
| Flip Direction | Rotates the orientation of the machining profile 180 degrees along the edge. |

## Settings Files
- **Filename**: `hsbSettings`
- **Location**: Defined in your hsbCAD company or installation path.
- **Purpose**: Provides default data for milling heads (HH2-Tab) required to generate the toolpaths correctly.

## Tips
- **Splitting Behavior**: This script automatically splits the selected panel using a split plane. You do not need to pre-split the wall.
- **Double Connections**: To create a "Double Tongue and Groove" (often used for watertightness), ensure `dInterdistance` is greater than 0. This creates two parallel grooves with a web in between defined by `dGapCen`.
- **Automatic Depth**: If you want the tongue to sit exactly in the center of the panel thickness, set `dWidthTongue` to 0.

## FAQ
- **Q: Why does the script only draw a line and doesn't cut the panel?**
  **A:** The script requires Sips (Construction entities) to calculate the 3D cut. If you are in the early design phase (only ElementWalls exist), it draws a symbol. Generate the construction (Sips) and the script will automatically update to perform the cut.
- **Q: How do I change from a rectangular groove to a dovetail?**
  **A:** Change the `dGapRef` property. A value of 0 is rectangular. Increasing this value adds the angled slope to the dovetail.
- **Q: Can I move the connection after inserting it?**
  **A:** Yes, use the AutoCAD `MOVE` command on the script instance (the TSL symbol). The machining on the panels will update to the new location.
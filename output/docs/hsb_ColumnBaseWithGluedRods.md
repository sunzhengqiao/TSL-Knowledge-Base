# hsb_ColumnBaseWithGluedRods.mcr

## Overview
This script generates a steel-to-timber column base connection consisting of a top steel plate, a bottom steel plate (base plate), and an intermediate timber stub. It creates the necessary 3D geometry and machining for glued-in rods or bolts in both the timber elements and the steel plates.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script generates 3D geometry (Bodies and Beams) and modifies the host beam. |
| Paper Space | No | Not intended for 2D drawing generation. |
| Shop Drawing | No | This is a model generation script. |

## Prerequisites
- **Required Entities**: 1 Structural Beam (GenBeam).
- **Minimum Beam Count**: 1.
- **Required Settings**: None (uses internal script properties).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_ColumnBaseWithGluedRods.mcr`

### Step 2: Select Host Beam
```
Command Line: Select beam
Action: Click on the structural timber beam where the column base should be applied.
```

### Step 3: Define Insertion Point
```
Command Line: Specify insertion point
Action: Click in the model space to define the location of the base connection (typically the bottom or end of the column).
```

### Step 4: Configure Properties
```
Action: The "Properties" dialog appears automatically. Adjust dimensions, plate sizes, and drill patterns as needed. Click OK to generate the elements.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **General** | | | |
| Steel Grade (sGrade) | text | S275 | Material grade for steel plates (e.g., S275, S355). |
| Color (sColor1) | number | -1 | Color index for the steel elements (-1 for ByLayer). |
| **Stub** | | | |
| Overall Foot Height (dFootH) | number | 300 | Vertical distance between Top Plate and Bottom Plate (stub length). |
| Extrusion profile name (sProfile) | dropdown | *From Catalog* | Cross-sectional profile name for the timber stub. |
| Flip Direction (sFlipStub) | dropdown | Yes | Rotates the stub profile by 90 degrees. |
| **Base Plate** | | | |
| Name (sBaseName) | text | Base Plate | Identifier for the bottom plate entity. |
| Base Plate Thickness (dBasePlateT) | number | 20 | Thickness of the bottom steel plate. |
| Base Plate Length (dBasePlateL) | number | 400 | Length of the bottom plate (along beam Y-axis). |
| Base Plate Width (dBasePlateW) | number | 300 | Width of the bottom plate (along beam Z-axis). |
| Quantity of Drill Rows (nBaseRows) | number | 3 | Number of drill holes rows along the width. |
| Quantity of Drill Columns (nBaseCols) | number | 3 | Number of drill holes columns along the length. |
| Drill Row Centers (dRowDistBase) | number | 100 | Spacing between drill hole rows. |
| Drill Col Centers (dColDistBase) | number | 100 | Spacing between drill hole columns. |
| Drill Diametre (dBasePlateDrill) | number | 20 | Diameter of drill holes. |
| Drill Tolerance (dBasePlateDrillTol) | number | 2 | Additional tolerance added to drill diameter. |
| Offset Side 1 (dBasePlateOffset1) | number | 50 | Lateral offset of plate center relative to beam axis (Y). |
| Offset Side 2 (dBasePlateOffset2) | number | 60 | Lateral offset of plate center relative to beam axis (Z). |
| **Top Plate** | | | |
| Name (sTopName) | text | Top Plate | Identifier for the top plate entity. |
| Top Plate Thickness (dTopPlateT) | number | 20 | Thickness of the top steel plate. |
| Top Plate Length (dTopPlateL) | number | 200 | Length of the top plate (along beam Y-axis). |
| Top Plate Width (dTopPlateW) | number | 300 | Width of the top plate (along beam Z-axis). |
| Quantity of Drill Rows (nTopRows) | number | 3 | Number of drill holes rows along the width. |
| Quantity of Drill Columns (nTopCols) | number | 3 | Number of drill holes columns along the length. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *Standard Script Options* | Use the Properties Palette (Ctrl+1) to modify parameters after insertion. |

## Settings Files
- None specified.

## Tips
- Ensure the selected **Extrusion profile (sProfile)** exists in your current hsbCAD catalog; otherwise, the stub generation may fail.
- Use the **Flip Direction** option to orient the timber stub correctly if the width/depth orientation does not match the plates.
- The **Offsets** (Offset Side 1 & 2) allow you to shift the base plate center relative to the timber beam, useful for eccentric connections.

## FAQ
- **Q: Why does the stub beam not appear?**
  A: Check the `sProfile` property. Ensure a valid profile name from your catalog is entered.
- **Q: How do I change the spacing of the anchor rods?**
  A: Modify the "Drill Row Centers" and "Drill Col Centers" properties in the Properties Palette.
- **Q: Can I use this for a wall base?**
  A: Yes, as long as the host element is a GenBeam (structural beam), it can be used for columns or walls.
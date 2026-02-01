# FaceConnector.mcr

## Overview
Automatically detects connections between two walls (Parallel or Corner) and distributes face connector hardware (TFPC) along the intersecting edge.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used in 3D model to place hardware on walls. |
| Paper Space | No | Not designed for layout views. |
| Shop Drawing | No | Not designed for manufacturing details. |

## Prerequisites
- **Required Entities**: Two `ElementWallSF` (Wall) entities.
- **Minimum Beam Count**: 2 Walls.
- **Required Settings**: `TFPC` Block located in `_kPathHsbCompany\Block`.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `FaceConnector.mcr` from the list.

### Step 2: Select Walls
```
Command Line: Select entities:
Action: Select the two walls you wish to connect and press Enter.
```
*Note: The script automatically detects if the walls are Parallel or Corner connected.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sConnectionType | dropdown | Unknown | Sets the geometric configuration (Parallel or Corner). Usually auto-detected. |
| sDistribution | dropdown | Unknown | Strategy for spacing connectors: Evenly, Start+End, or MaxSpacing. |
| dOffsetBottom | number | Unknown | Clearance from the bottom of the wall overlap to the first connector center (mm). |
| dOffsetTop | number | Unknown | Clearance from the top of the wall overlap to the last connector center (mm). |
| dOffsetBetween | number | Unknown | Vertical distance between centers of adjacent connectors (mm). |
| sSideParallelWalls | dropdown | Unknown | Selects the face of the wall for connectors: Reference Side or Opposite Side (Parallel only). |
| dOffset | number | Unknown | Lateral offset of the connector from the wall edge (mm). |
| dTextHeight | number | Unknown | Height of the annotation text label (mm). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Swap Walls | Swaps the two selected wall elements (Available only for Parallel connections). |
| Flip Side | Flips the connection side to the opposite face of the wall (Available only for Parallel connections). |

## Settings Files
- **Filename**: `TFPC` (Block)
- **Location**: `_kPathHsbCompany\Block`
- **Purpose**: Provides the visual symbol block for the connector in the model.

## Tips
- Ensure the two walls have a common vertical (Z) overlap, or the script will fail with "no common area in height".
- For parallel walls, ensure they are close enough (distance < 100mm) to be recognized as connected.
- Use the **Swap Walls** context menu item if the script detects the connection but applies it to the wrong side of the geometry.

## FAQ
- **Q: Why does the script report "Only parallel and corner connected walls supported"?**
  A: The script only works if walls are perfectly Parallel or Perpendicular (Corner). Check your wall alignments.
- **Q: Why are no connectors appearing?**
  A: Check that the vertical overlap between walls is sufficient and that the `dOffsetBottom` and `dOffsetTop` values do not exceed the wall height.
- **Q: How do I change the spacing of the connectors?**
  A: Select the script instance in the model, open the Properties Palette, and change the `sDistribution` strategy or modify the `dOffsetBetween` value.
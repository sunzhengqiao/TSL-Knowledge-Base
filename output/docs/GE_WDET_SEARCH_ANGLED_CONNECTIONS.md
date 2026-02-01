# GE_WDET_SEARCH_ANGLED_CONNECTIONS

## Overview
This script automates the detection and detailing of non-orthogonal (angled) wall connections. It analyzes the intersection geometry of a selected wall and its neighbors to determine if the connection is a "Miter" or a "Skewed Tee" junction, then automatically launches the appropriate detailing sub-scripts.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D wall elements and their outlines. |
| Paper Space | No | Not designed for 2D drawings or viewports. |
| Shop Drawing | Yes/No | This is a model detailing tool, not a layout tool. |

## Prerequisites
- **Required Entities**: At least one valid Wall (`ElementWall`) in the model that intersects with other walls.
- **Geometry Requirements**: Wall outlines must physically touch or intersect correctly. Gaps or significant overlaps may prevent detection.
- **Dependent Scripts**: The script requires the following TSL files to be present in your search path to function correctly:
  - `GE_WALLS_MITER_TO_MITER_ANGLED.mcr`
  - `GE_WALLS_SKEWED_TEE_CONNECTION.mcr`

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or select from the hsbCAD TSL Browser) → Select `GE_WDET_SEARCH_ANGLED_CONNECTIONS.mcr`

### Step 2: Select Wall Element
```
Command Line: |Select element|
Action: Click on the primary wall element that contains the angled connection you wish to resolve.
```

### Step 3: Automatic Processing
```
Action: The script automatically analyzes all walls connected to your selection.
```
- The script filters out orthogonal (90°) connections.
- For angled connections, it calculates the intersection points to determine the connection type.
- It instantiates the correct connection detail (Miter or Skewed Tee) on the walls.
- The script instance deletes itself automatically upon completion.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| *None* | *N/A* | *N/A* | This script has no user-editable properties in the Properties Palette. It is a "fire-and-forget" utility. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add specific items to the entity context menu. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not use external XML settings files.

## Tips
- **Clean Geometry**: Ensure your wall outlines are clean and meet precisely at corners. If the script reports "Connection cannot be established," use the "Clean Up" tools to ensure vertexes coincide.
- **Orthogonal Walls**: This script intentionally ignores 90-degree corners. Use standard wall end-configuration tools for right angles.
- **Batch Processing**: If you have many angled connections, run this script on one wall at a time to ensure each specific geometry is handled correctly.

## FAQ
- **Q: Why did the script disappear after I ran it?**
  - A: This is a utility script designed to run once, apply the specific detailing scripts, and then remove itself from the model to prevent clutter.
- **Q: I get a warning "Connection between wall X and wall Y cannot be established."**
  - A: The script could not determine a valid Miter or Skewed Tee configuration based on the outline intersection. Check if the walls overlap purely or if there is a gap in the intersection.
- **Q: Does this work for T-junctions that are 90 degrees?**
  - A: No. This script is specifically designed for *angled* (non-orthogonal) connections. Standard T-junctions are typically handled by default wall properties or other tools.
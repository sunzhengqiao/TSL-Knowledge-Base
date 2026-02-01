# GE_WALLS_TRIPLE_T_CONNECTION.mcr

## Overview
This script automates the detailing of a triple-wall timber junction where two walls form a perpendicular corner and a third wall aligns with one of them (offset connection). It handles the necessary beam stretching and sheathing modifications to connect the assembly correctly.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates exclusively in the 3D model. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Does not generate 2D drawings directly. |

## Prerequisites
- **Required Entities**: At least 3 `ElementWall` entities must exist in the model.
- **Geometry**: The walls must be arranged in a specific "Triple T" configuration (two walls forming a corner, with a third wall running parallel to one of them at an offset).
- **Cleanup**: Ensure walls are positioned correctly in 3D space before running the script.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_WALLS_TRIPLE_T_CONNECTION.mcr` from the file list.

### Step 2: Select Walls
```
Command Line: Select walls for T connection
Action: Select the 3 ElementWall entities that form the junction.
```
*Note: The script will automatically detect which walls form the corner and which is the offset wall based on their spatial position; you do not need to select them in a specific order.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script has no user-editable properties in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | No custom context menu options are added by this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external settings files.

## Tips
- **Auto-Detection**: You can select all three walls in a single window selection or pick them one by one. The script analyzes the geometry to determine which beams to stretch and where to cut the sheathing.
- **Top Plates**: This script includes functionality to handle "very top plates," ensuring connections are correctly processed even at the highest levels of the wall structure.
- **Sheathing**: The script automatically copies and moves sheathing on the external side of the single wall to wrap around the corner, while cutting the internal sheathing to fit the perpendicular wall.

## FAQ
- **Q: Does the order in which I select the walls matter?**
  A: No, the script calculates the topology automatically. Just ensure you select exactly the three walls involved in the connection.

- **Q: Why didn't the script update the walls?**
  A: Ensure the selected entities are `ElementWall` types and that they are positioned in a valid corner/offset arrangement. The script requires specific geometric relationships to determine how to stretch the beams.
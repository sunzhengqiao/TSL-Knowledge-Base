# GE_WALL_FRAMING_COPY.mcr

## Overview
This script duplicates the framing configuration (studs, plates, and sheets) from a master "source" wall to multiple "target" walls. It is designed to ensure consistency across identical wall panels by automatically verifying geometry and propagating the design.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model entities. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | This script modifies the physical model, not drawing annotations. |

## Prerequisites
- **Required Entities**: An existing `ElementWall` with framing (Beams/Sheets) to serve as the source, and one or more target `ElementWall` entities.
- **Minimum beam count**: 0 (Source wall must be pre-framed).
- **Required settings files**: `GE_WALL_FRAMING_LOCK` (Must be available in the search path).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_WALL_FRAMING_COPY.mcr` from the file dialog.

### Step 2: Select Source Wall
```
Command Line: Select wall to copy FROM
Action: Click on the wall element that contains the framing layout you wish to duplicate.
```

### Step 3: Select Target Walls
```
Command Line: Select element(s) to apply copy
Action: Click on one or more wall elements where you want the framing to be applied. Press Enter to confirm selection.
```

### Step 4: Processing
The script will automatically validate the geometry of the target walls against the source.
- **Success**: The framing is copied, transformed, and the script reports success on the command line.
- **Failure**: If walls do not match (size, shape, or openings), an error message is displayed for the specific wall number, and that wall is skipped.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| New color for framing | dropdown | \|No color\| (32) | Selects the visual display color for the copied timber beams and sheets. Options include standard colors like White, Red, Blue, etc. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific persistent context menu items. It runs once and then erases itself. |

## Settings Files
- **Dependency**: `GE_WALL_FRAMING_LOCK`
- **Purpose**: This required script is automatically inserted onto the target walls to manage the newly copied framing elements.

## Tips
- **Geometric Precision**: The target walls must be geometrically identical to the source wall. Ensure length, width, height, and polygon shape match exactly.
- **Openings**: The script checks the number, size, and position of all openings (windows/doors). If the target wall has a different door configuration, the copy will fail.
- **Source Framing**: Ensure your source wall is completely framed (including sheets if applicable) before running this script. If the source is empty, the script will abort.
- **One-Time Use**: This script instance erases itself after execution. Re-run the script to copy to additional walls.

## FAQ
- **Q: Why did I get a "Size mismatch" error?**
  A: The target wall's length, width, or height differs from the source wall by more than the allowed tolerance (approx. 0.1 inch). Check your wall dimensions.
- **Q: Why did I get a "Shape mismatch" error?**
  A: The target wall has a different polygonal shape than the source (e.g., source is rectangular, target is a gable end).
- **Q: Can I copy framing from a wall to a wall of different lengths?**
  A: No. This tool requires exact geometric matches. It does not stretch or adjust framing dimensions; it performs a rigid transformation (copy/rotate/move).
- **Q: What happens to existing framing on the target wall?**
  A: Any existing beams or sheets on the target wall are erased and replaced by the copied framing from the source wall.
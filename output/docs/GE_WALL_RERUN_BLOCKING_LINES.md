# GE_WALL_RERUN_BLOCKING_LINES.mcr

## Overview
This script converts temporary blocking beams within a wall into parametric blocking components. It automatically detects the elevation, material, and orientation of existing blocking lines and replaces them with a controlled blocking generator.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be attached to a Wall Element. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities:** An ElementWall with existing temporary blocking beams.
- **Minimum Beam Count:** 0 (Script runs safely on empty walls).
- **Required Settings/Dependencies:** The script `GE_WALL_SECTION_BLOCKING.mcr` must be present in the TSL search path.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_WALL_RERUN_BLOCKING_LINES.mcr` from the file browser.

### Step 2: Select Wall Element
```
Command Line: |Select element(s)|
Action: Click on the Wall Element(s) that contain the temporary blocking lines you wish to convert.
```
Once selected, the script will automatically scan the wall, read properties from the temporary beams, and regenerate the blocking using the `GE_WALL_SECTION_BLOCKING` logic.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Minimum Length (Index 0) | Number | 3.0 | Filters out blocking segments shorter than this length (in inches). |

*Note: This script primarily uses internal logic to detect beam properties; explicit OPM properties may be limited.*

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | No custom context menu options are added by this script. |

## Settings Files & Dependencies
- **Filename**: `GE_WALL_SECTION_BLOCKING.mcr`
- **Location**: TSL Script Path
- **Purpose**: This is the core generator script called by the main script to create the actual blocking geometry.

## Tips
- **Cleanup:** The script automatically erases previous instances of blocking TSLs inserted by this script, preventing duplicates.
- **Empty Walls:** It is safe to run this script on a wall that has no blocking; it will simply finish without errors.
- **Debugging:** Text feedback on the command line is minimized; ensure your temporary blocking beams are correctly assigned to the wall element before running.

## FAQ
- Q: What happens if my temporary blocking lines are very short?
  - A: Segments shorter than the "Minimum Length" (default 3 inches) will be ignored and not generated in the final wall.
- Q: Will this script delete my temporary lines?
  - A: Yes, the script manages the element's children. It replaces temporary geometry with the parametric generator instance.
- Q: I don't see any new blocking appear. Why?
  - A: Ensure the temporary beams are actually part of the selected Wall Element's group/definition and not just loose geometry in the drawing.
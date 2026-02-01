# GE_WDET_CLEANUP_KING_OVERLAP.mcr

## Overview
This script automatically resolves framing conflicts in Wall Elements by adjusting King Studs and surrounding standard studs. It ensures King Studs (defined as specific Modules) fit within wall boundaries and trims or moves adjacent studs to eliminate overlaps.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script is designed for use in the 3D Model environment. |
| Paper Space | No | Not intended for layout or detailing views. |
| Shop Drawing | No | This script modifies 3D model geometry, not 2D drawings. |

## Prerequisites
- **Required Entities**: Wall Elements (`ElementWallSF`) containing beams.
- **Specific Content**: The Wall Elements must contain King Studs defined as "Modules" with the specific Type property matching the script's internal criteria (typically `type() == _kKingStud`).
- **Minimum Beam Count**: Not applicable (Script processes existing beams).

## Usage Steps

### Step 1: Launch Script
**Command:** Type `TSLINSERT` in the command line and press Enter.
**Action:** In the file dialog, navigate to the script location and select `GE_WDET_CLEANUP_KING_OVERLAP.mcr`.

### Step 2: Select Wall Elements
**Command Line:** `Select one or More Elements`
**Action:** Click on the Wall Elements in your model that contain the King Studs you wish to clean up. You can select multiple elements.
**Completion:** Press Enter to confirm selection and run the script.

**Note:** The script will process the geometry, modify the beams, and then automatically erase its own instance from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| None | N/A | N/A | This script does not expose user-editable properties in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | The script executes immediately upon insertion and erases itself. There are no persistent right-click menu options for an active instance. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external XML settings files. It operates based on the geometric properties of the selected elements and beams.

## Tips
- **Catalog Setup**: Ensure your King Studs are defined in the catalog as Modules. The script identifies King Studs specifically by checking if a beam has a Module name and matches the specific Type property. Standard studs are treated as "valids" and will be moved/trimmed to accommodate King Studs.
- **Post-Insertion**: This tool is best used after modifying wall dimensions or inserting King Stud sub-assemblies to clean up the resulting overlaps automatically.
- **Boundary Handling**: If a King Stud is found partially outside the wall plate boundaries, the script will resize it to fit. If it is entirely outside, the script will erase it.

## FAQ
- **Q: Why did the script disappear after I ran it?**
  - A: This is designed behavior. The script runs as a "command" script. Once the cleanup calculations are performed and the beams are modified, the script instance deletes itself to keep the drawing clean.
- **Q: The script didn't move a stud that is overlapping my King Stud. Why?**
  - A: The script only moves beams classified as "Standard Studs". If the overlapping beam is also defined as a King Stud (Module) or a different type, it may not be moved. Ensure your beam types in the catalog are correctly assigned.
- **Q: What happens if the wall is shortened and the King Stud is now too long?**
  - A: The script detects if a King Stud extends past the "Outside Profile" of the wall. It will shorten the King Stud width to ensure it remains fully within the wall boundaries.
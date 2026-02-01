# GE_BEAM_INFO_GET_MODULE_ID.mcr

## Overview
Retrieves and displays metadata (Module ID, Information field, Type, and Handle) for selected beams directly in the AutoCAD command line. This tool is designed for quick verification of production module assignments and custom data without manually opening properties for each element.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the model where beams are located. |
| Paper Space | No | Not intended for layout views. |
| Shop Drawing | No | Not intended for shop drawing generation. |

## Prerequisites
- **Required Entities**: At least one structural Beam (`GenBeam`) must exist in the drawing.
- **Minimum Beam Count**: 1 (Script exits silently if nothing is selected).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_BEAM_INFO_GET_MODULE_ID.mcr`

### Step 2: Select Beams
```
Command Line: select a set of other beams
Action: Click on one or more beams in the 3D model or 2D plan and press Enter.
```

### Step 3: Review Output
```
Command Line: [Output list]
Action: Look at the command line to see the Module ID, Information, Type, and Handle for each selected beam.
Note: Press F2 to open the full text history if the list runs off the screen.
```

### Step 4: Completion
The script will automatically erase itself from the drawing after displaying the data.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| None | N/A | N/A | This script runs as a query tool and does not create persistent entities with editable properties. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not create elements that remain in the drawing; thus, no context menu options are available. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Check Full History**: If you select a large number of beams, the output may scroll past the visible command line area. Press **F2** to open the AutoCAD Text Window to see the full report.
- **Empty Fields**: If a beam has no specific Module ID or Information assigned, the script will report it as "EMPTY".
- **Re-running**: Since the script deletes itself immediately after running, you must launch `TSLINSERT` again to query different beams.

## FAQ
- **Q: Why did the script disappear immediately after I used it?**
  - A: This is intended behavior. The script is a "query tool" that performs a check and then cleans itself up to keep your drawing clean. It does not leave any geometry behind.

- **Q: I see "EMPTY" in the output. What does that mean?**
  - A: It means the selected beam does not have a value assigned to the "Module ID" or "Information" attributes in its properties.

- **Q: Can I use this on elements other than beams?**
  - A: No, this script is specifically designed to read data from Beam entities (`GenBeam`). Selecting other object types will result in no data being displayed.
# GE_BEAM_RAFTER_SPLICE

## Overview
This script splits a selected timber beam (typically a rafter) into two overlapping sections to visualize a splice joint. It automatically offsets the lower section laterally by its own width, allowing you to detail or check clearances for site connections.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the 3D model. |
| Paper Space | No | Not applicable for drawings. |
| Shop Drawing | No | This is a modeling tool only. |

## Prerequisites
- **Required entities**: At least one existing timber beam (`GenBeam`).
- **Minimum beam count**: 1.
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_BEAM_RAFTER_SPLICE.mcr`

### Step 2: Select Beams
```
Command Line: Select beam(s) to splice
Action: Click on the beam or beams you wish to splice. Press Enter to confirm selection.
```

### Step 3: Define Splice Location
```
Command Line: Select splice midpoint
Action: Click a point along the length of the beam where you want the center of the overlap to be located.
```

### Step 4: Define Offset Direction
```
Command Line: Offset direction for new beams
Action: Click to the side of the beam to indicate which direction the pieces should separate. The script will snap this to the beam's local side direction.
```

### Step 5: Set Overlap Length
```
Command Line: Set splice overlap <2'-0''>
Action: Type the desired length for the splice overlap (e.g., 600mm or 24") and press Enter. Press Enter without typing to accept the default (2'-0" / 610mm).
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script runs via command line input only and does not expose properties in the Properties Palette. It replaces the geometry and erases itself upon completion. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | No context menu options are available. The script executes once and deletes itself. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- The script automatically determines which of the two resulting segments is "lower" (based on Z-height) and moves that one.
- The standard default overlap is 2'-0" (610mm), which is common for rafter splicing.
- Ensure you pick the splice midpoint far enough from the beam ends; otherwise, the script will report that there is "no room for splice."
- The original single beam is deleted and replaced by two new beam entities.

## FAQ
- **Q: Why did I get the error "ERROR: There is no room for splice on selected point"?**
  A: The overlap length you entered extends beyond the physical ends of the beam from your selected midpoint. Either pick a point closer to the center of the beam or enter a smaller overlap length.

- **Q: Can I undo the changes made by this script?**
  A: Yes, you can use the standard AutoCAD `UNDO` command to revert the operation.

- **Q: The script disappeared after I ran it. Is that normal?**
  A: Yes. This is a "command script" that self-destructs after execution. The results are the new beams created in the model.
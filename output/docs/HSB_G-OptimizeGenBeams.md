# HSB_G-OptimizeGenBeams.mcr

## Overview
This script automatically splits long generic beams, sheets, or structural panels into smaller, manageable segments. It optimizes lengths for transport or manufacturing by calculating cut positions based on user-defined lengths, gaps, and alignment rules.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D model entities. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Not intended for generating views. |

## Prerequisites
- **Required Entities**: GenBeam, Element, Sheet, or Beam entities must exist in the drawing.
- **Minimum Beam Count**: 1
- **Required Settings Files**:
    - `HSB_G-FilterGenBeams.mcr`: For filtering specific beams.
    - `HSB_G-Distribution.mcr`: For calculating split positions.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse the catalog and select `HSB_G-OptimizeGenBeams.mcr`.

### Step 2: Select Input Entities
The script will prompt you to select how it targets beams:
```
Command Line: Select element(s) <ENTER> to select genbeams
```
- **Option A (Elements)**: Click one or more Elements in the drawing. The script will attach itself to these elements and process relevant beams automatically upon generation.
- **Option B (Specific Beams)**: Press `ENTER`. The prompt will change to `Select genbeam(s)`. Click the specific beams, sheets, or panels you wish to split.

### Step 3: Configure Parameters
1. Once selected, the Properties Palette will display the script parameters.
2. Adjust the **Distribution**, **Split length**, **Gap**, and **Offsets** as needed.
3. Right-click and select **ManualInsert** (or click the "Run" button in your catalog browser if applicable) to execute the split.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Distribution | Dropdown | Left | Determines alignment: <br>**Left**: First segment starts at beam origin.<br>**Right**: Last segment ends at beam end.<br>**Center**: Segments are centered on the beam.<br>**Center, no beam in center**: Centers segments but leaves the middle empty. |
| Split length | Number | 5400 mm | The target length for the resulting segments. |
| Gap | Number | 0 mm | The distance left between split segments (e.g., for expansion joints). |
| Start offset | Number | 0 mm | A buffer zone at the start of the beam where no splits occur. |
| End offset | Number | 0 mm | A buffer zone at the end of the beam where no splits occur. |
| Distribute evenly | Dropdown | No | If **Yes**, forces all intermediate segments to be identical in length, adjusting slightly from the target "Split length" to fit perfectly. |
| Split at start | Dropdown | No | If **Yes**, forces a split exactly at the start offset position. |
| Split at end | Dropdown | No | If **Yes**, forces a split exactly at the end offset position. |
| Filter definition beams | Dropdown | *Empty* | Select a filter from `HSB_G-FilterGenBeams` to only process beams that match specific criteria. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| ManualInsert | Executes the optimization process immediately using the current property settings and selected entities. |

## Settings Files
- **Filename**: `HSB_G-FilterGenBeams.mcr`
  - **Location**: TSL Catalog
  - **Purpose**: Allows you to define rules (e.g., name, material, height) to filter which beams within an Element should be split.
- **Filename**: `HSB_G-Distribution.mcr`
  - **Location**: TSL Catalog
  - **Purpose**: Handles the complex mathematical calculations required to determine exact split positions based on your offsets and distribution settings.

## Tips
- **Using Elements**: Selecting an Element rather than individual beams allows this script to run automatically during future element generations or updates.
- **Avoiding Small Offcuts**: If you have a long beam that doesn't divide evenly by your split length, enable **Distribute Evenly**. This will adjust all segments slightly to ensure they are equal, preventing one tiny piece at the end.
- **Roof Logic**: If used on a Roof Element with "Right" beam distribution set, the script automatically inverts the split direction to match the roof layout.
- **Gaps**: Remember that adding a **Gap** increases the total span of the assembly. If you need the overall assembly to stay the same length, use **Distribute Evenly** to compensate.

## FAQ
- **Q: I get the error "Beams could not be filtered!"**
  - A: Ensure the script `HSB_G-FilterGenBeams.mcr` is loaded in your drawing or available in your active catalog.
- **Q: I get the error "Beams could not be distributed!"**
  - A: Ensure the script `HSB_G-Distribution.mcr` is loaded in your drawing or available in your active catalog.
- **Q: Can I undo the split?**
  - A: Yes, use the standard AutoCAD `UNDO` command immediately after running the script.
- **Q: What happens to the original beam?**
  - A: The original beam is erased and replaced by the new split segments. The script instance also erases itself after completion.
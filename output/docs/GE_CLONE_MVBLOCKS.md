# GE_CLONE_MVBLOCKS.mcr

## Overview
This script converts selected AutoCAD Architecture (ACA) MVBlocks into specific hsbCAD wall framing elements. It automatically generates wall openings for recessed fixtures or inserts blocking and no-stud area scripts for cabinets and plumbing based on the block's classification property.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in Model Space where MVBlocks and Walls exist. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | This script generates model elements, not drawing annotations. |

## Prerequisites
- **Required Entities:** AutoCAD Architecture MVBlocks (representing fixtures/furniture) and hsbCAD Walls (`ElementWallSF`).
- **Classification:** Selected MVBlocks must have a Classification property named `ITWBFraming` with specific values (e.g., "CABINET - BASE", "RECESSED", "PLUMBING - VOID").
- **Required Scripts:** The scripts `GE_WALL_SECTION_BLOCKING` and `GE_WALL_NO_STUD_AREA_BLOCKING` must be present in your TSL catalog to generate the framing for cabinets and plumbing.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_CLONE_MVBLOCKS.mcr` from the catalog.

### Step 2: Select MVBlocks
```
Command Line: 
Select a set of MVBlocks
Action: 
Select the desired AutoCAD MVBlocks (e.g., cabinets, light fixtures, toilet blocks) in the drawing and press Enter.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Empty 1 | Text | - - - - - - - - - - - - - - - - | Visual separator for organization purposes only. |
| Empty 2 | Text | - - - - - - - - - - - - - - - - | Visual separator for organization purposes only. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script instance erases itself immediately after processing the blocks. Standard context menu options do not apply post-execution. |

## Settings Files
- **Catalog Dependencies**: `GE_WALL_SECTION_BLOCKING.mcr`, `GE_WALL_NO_STUD_AREA_BLOCKING.mcr`
- **Location**: TSL Catalog
- **Purpose**: These scripts are automatically inserted to generate the specific timber blocking or void areas for the different MVBlock types.

## Tips
- **Classification is Key:** Ensure your MVBlocks have the `ITWBFraming` property set correctly before running the script. Without this, the script will not know what type of framing to create.
- **Intersection:** The MVBlock must physically intersect with a wall body. If the block is floating in front of the wall without touching it, the script will fail to place the opening or blocking.
- **One-Time Use:** This is a generator script, not a dynamic link. If you move the MVBlock later, the generated framing will **not** update. You must delete the old framing and run the script again on the moved block.

## FAQ
- **Q: Why did the script not create anything for my selected block?**
  A: Check that the MVBlock has the `ITWBFraming` classification property assigned and that it physically intersects with an hsbCAD Wall. If the property is missing or the intersection is empty, the script will ignore the block.

- **Q: Can I use this on standard AutoCAD blocks?**
  A: No, this script is designed specifically for AutoCAD Architecture MVBlocks which have extended data properties required for classification.

- **Q: I moved my cabinet; how do I update the framing?**
  A: The generated blocking/opening is not linked to the original block. Delete the previously generated blocking/opening, select the moved cabinet, and run the script again.
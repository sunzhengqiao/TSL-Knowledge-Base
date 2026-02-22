# GE_CLONE_MVBLOCKS - MVBlock Cloning & Special Framing

## Overview

The GE_CLONE_MVBLOCKS script is used in the cloning process (`hsb_structuralclone`) or conversion process (`hsb_acatohsb`) and will insert special TSLs based on mvBlock classifications. It will be attached to MVBlocks only.

## Purpose

This script automatically creates special framing elements and openings in walls based on the classification of MVBlocks (Masonry/Virtual Blocks). It handles different types of fixtures including:

- **Cabinets** (Base, Tall, Wall)
- **Recessed fixtures** (creating framed openings)
- **Plumbing fixtures** (voids and tub/showers)

## Script Information

| **Property** | **Value** |
|--------------|-----------|
| **Type** | Object (O) |
| **Version** | 1.3 |
| **Last Updated** | April 18, 2013 |
| **Author** | David Rueda (dr@hsb-cad.com) |
| **Requires Beams** | 0 |
| **Requires Points** | 0 |

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in Model Space where MVBlocks and Walls exist. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | This script generates model elements, not drawing annotations. |

## Supported MVBlock Classifications

### Cabinet Types
1. **CABINET - BASE**
   - Creates upper backing blocking
   - Used for base cabinets against walls

2. **CABINET - TALL**
   - Creates upper backing blocking
   - Used for tall/heavy cabinets

3. **CABINET - WALL**
   - Creates both upper and lower backing blocking
   - Used for wall-mounted cabinets

### Special Fixtures
1. **RECESSED**
   - Creates framed openings in walls
   - Automatically calculates opening dimensions from block properties
   - Uses "FramedOpeningStyleFixed" property set for dimensions

2. **PLUMBING - VOID 12**
   - Creates a cylindrical void representation (12" diameter)
   - Used for plumbing voids in walls

3. **PLUMBING - TUB SHOWER CENTERED**
   - Creates a cylindrical tub representation
   - Used for centered tub/showers

## How It Works

### During Insertion
1. Prompts user to select a set of MVBlocks
2. Clones itself for each selected MVBlock
3. Processes each block based on its classification

### During Processing
1. **Detects MVBlock classification** from the "ITWBFraming" property
2. **Identifies intersecting walls** by:
   - Moving the block 2 inches towards the wall
   - Checking for intersection with wall bodies
   - Creating cut geometry to find exact intersection points

3. **Creates appropriate framing elements**:
   - For cabinets: Creates `GE_WALL_SECTION_BLOCKING` TSLs
   - For recessed fixtures: Creates framed openings
   - For plumbing: Creates special cylindrical voids

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

## Key Features

### Automatic Wall Detection
- Works with walls that have hsbCAD data
- Can work with walls that don't have hsbCAD data (uses basic wall geometry)
- Handles walls with model display turned off

### Precise Placement
- Calculates intersection points using body geometry
- Places framing elements at exact locations
- Handles elevation calculations automatically

### Special Handling for Recessed Fixtures
- Creates proper openings in walls
- Stores rough dimensions when applicable
- Automatically calculates center points for opening placement

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

## Revision History

| Version | Date | Author | Description |
|---------|------|--------|-------------|
| 1.3 | April 18, 2013 | David Rueda | Bugfix: Filtering out non valid SFWall or Wall entities |
| 1.2 | April 2, 2013 | David Rueda | Bugfix: Searching body was cutting all blocking body (deleting), as result no point was available hence error message |
| 1.1 | April 1, 2013 | David Rueda | Bugfix: when bdMvbMoved the assignation of points where being done when no points where available |
| 1.0 | January 31, 2013 | David Rueda | Version control |
| 0.9 | May 15, 2012 | David Rueda | Thumbnail added, Description made visible to user |
| 0.8 | May 2, 2012 | R. L | In placing the opening it will find the center point of the MvBlock body that intersects with the wall body and base the opening location on the center point of the resulting body |
| 0.7 | April 19, 2012 | R. L | Will now dbCreate an opening for Recessed MVBlocks. No data is attached to the opening |
| 0.6 | November 1, 2011 | David Rueda | Added flag to cloned GE_WALL_SECTION_BLOCKING TslInst to make it load values from certain catalog |
| 0.5 | September 6, 2011 | R. L | Will move a block 2 inches upwards in case it cuts the wall. Will take the realbody of the block with an isometric vector to make sure it gets the body of model display |
| 0.4 | September 8, 2010 | R. L | Added special framing for tubs and toilets ("PLUMBING - VOID 12","PLUMBING - TUB SHOWER CENTERED") |
| 0.3 | July 16, 2010 | R. L | Fixed lower block location in no stud area |
| 0.2 | June 24, 2010 | R. L | Can insert on a wall with no hsbCAD data |
| 0.1 | June 22, 2010 | R. L | Used to clone or convert ACA rules for MVBlocks |

## Dependencies

- Requires MVBlock entities with proper classification in the "ITWBFraming" property
- Works with ElementWallSF, ElementRoof, and basic Wall entities
- Uses standard TSL framework for creating child TSL instances

## Integration

This script is designed to work seamlessly with:
- hsbCAD structural cloning tools
- AutoCAD Architecture content conversion
- MVBlock-based fixture placement workflows

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
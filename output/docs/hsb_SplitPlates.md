# hsb_SplitPlates.mcr

## Overview
Automatically splits wall top and bottom plates into transportable lengths based on a maximum length setting. The script optimizes splice locations relative to studs and openings and optionally creates solid wood splice blocks at the split locations.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the 3D model on wall elements. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required entities**: Wall `Elements` (containing top and bottom plates).
- **Minimum beam count**: N/A (Requires complete wall elements).
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SplitPlates.mcr`

### Step 2: Configure Properties
```
Dialog: Properties Palette
Action: Adjust the Maximum length and split distances if necessary. 
        Choose whether to create splice blocks or reset an existing split status.
```
*Note: The properties dialog appears automatically the first time you run the command in a session.*

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the wall elements you wish to process and press Enter.
```

### Step 4: Processing
The script will automatically:
1. Check if the wall is already marked as split.
2. Join adjacent plate segments.
3. Calculate split points based on studs, openings, and the maximum length.
4. Split the plates and apply labels (A, B, C...).
5. Erase itself from the drawing upon completion.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Maximum length | Number | 4800 | The maximum allowed length for a single plate segment (typically determined by raw material length or transport limits). |
| Opening module dimensions greater than | Number | 605 | Threshold (width) to classify a wall opening as "Large". Openings wider than this trigger "Opening Module" split logic. |
| Split distance to opening mudule | Number | 269 | The minimum distance allowed between a split point and the edge of a "Large" opening. |
| Split distance to small mudule | Number | 119 | The minimum distance allowed between a split point and a "Small" opening/module. |
| Split distance to stud | Number | 119 | The minimum distance allowed between a split point and a vertical stud. |
| Reset 'wall splitted' status | Dropdown | Yes | If **Yes**, the script removes the "Plates are split" status from elements without splitting them. If **No**, the script performs the splitting operation. |
| Create splice blocks | Dropdown | No | If **Yes**, generates solid blocking beams at the location of every split. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific items to the entity context menu. |

## Settings Files
- **None**: This script does not rely on external settings files.

## Tips
- **Resetting Walls**: If you need to re-run the script on a wall that has already been processed, set **Reset 'wall splitted' status** to `Yes` and run it once to clear the previous status. Then change it back to `No` and run it again to apply new splits.
- **Validation Failure**: If the script reports "Increase maximum split length...", it means an opening in your wall is too wide to fit between the required split distances. Increase the **Maximum length** property to resolve this.
- **Plate Labeling**: The script automatically labels resulting plate segments (A, B, C, etc.) to help identify them in lists and drawings.

## FAQ
- **Q: Why did the script disappear after I selected the elements?**
  - **A:** The script is designed to run once and then erase itself automatically. The changes made to the plates (splitting and labeling) are permanent in the model.
- **Q: The script warns that the wall is "already split". What should I do?**
  - **A:** The script detected a marker text indicating previous processing. Use the **Reset 'wall splitted' status** property set to `Yes` to clean the wall, then run the script again with your desired settings.
- **Q: What happens if my Maximum length is shorter than my wall opening?**
  - **A:** The script will fail with a warning. You must increase the **Maximum length** property so that it is larger than the (Opening Width + 2 * Split Distances).
# NA_BUNDLE_LABELER.mcr

## Overview
This script sequentially numbers timber stack bundles within the 3D model to facilitate shipping and production tracking. It allows you to define a specific numbering sequence by selecting stacks in order or automatically numbering all stacks in the drawing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates exclusively on entities in Model Space. |
| Paper Space | No | This script does not function in Paper Space. |
| Shop Drawing | No | This script is not intended for use within Shop Drawing layouts. |

## Prerequisites
- **Required Entities:** TslInst instances (stacks) mapped with the `mpStackMaster` map.
- **Minimum Beam Count:** 0 (This script operates on stack instances, not individual beams).
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
1.  Use the `TSLINSERT` command or drag the script into the AutoCAD model space.
2.  Select the `NA_BUNDLE_LABELER.mcr` file.

### Step 2: Define Start Number
```
Command Line: Start number
Action: Type the starting integer for the sequence (e.g., 1, 101, 500) and press Enter.
```
This number will be assigned to the first stack in your sequence.

### Step 3: Select Stacks
```
Command Line: Select stacks in desired sequence or press Enter
Action: 
   - Option A: Click the stacks one by one in the exact order you want them numbered. 
   - Option B: Press Enter without selecting anything to number all stacks in the drawing automatically.
```
*Note: If you manually select stacks, those selected will be numbered first (in the order clicked), followed by any remaining unselected stacks.*

### Step 4: Completion
The script will process the stacks, update their attributes, and then automatically erase itself from the drawing. A report displaying the total number of labeled stacks will appear in the command line.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| stEmpty | text | `------------------------` | A visual separator in the properties palette. It has no functional effect on the script. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not add specific options to the right-click context menu. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external settings files.

## Tips
- **Partial Sequencing:** If the first few stacks need to be in a specific order (e.g., loading order), select those specific stacks first. The script will number them 1, 2, 3... and then automatically number the rest of the stacks in the drawing immediately after.
- **Re-numbering:** Running the script again will overwrite existing stack numbers starting from your new input. Use this to reset or update bundle numbers for revisions.

## FAQ
- **Q: Why did the script disappear after I ran it?**
  **A:** This is a "utility" script designed to run once. It modifies the stack data and then erases its own instance from the drawing to keep your model clean.
- **Q: What if I select stacks in the wrong order?**
  **A:** Simply run the script again and enter the start number. You can re-select the stacks in the correct order, or just press Enter to reset the numbering for all stacks.
- **Q: Some stacks didn't get a number. Why?**
  **A:** The script only looks for entities mapped as `mpStackMaster` (typically created by the Stacker module). Ensure your stacks are valid instances and not simple 3D solids or blocks.
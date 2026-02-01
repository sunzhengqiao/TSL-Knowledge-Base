# HSB_G-Apply Numbering

## Overview
This script automates the assignment of position numbers (PosNum) to structural beams based on specific label filters. It allows you to create separate numbering sequences for different beam types (e.g., starting wall studs at 1 and floor joists at 100) within a selected scope of the model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on structural elements (GenBeams) in the model. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Not applicable for shop drawing generation. |

## Prerequisites
- **Required Entities:** Elements with assigned GenBeams (structural timber beams).
- **Minimum Beam Count:** 0.
- **Required Settings:** None. Ensure your beams have Labels assigned (e.g., "WAL" for walls, "FLR" for floors) to use the filtering features effectively.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-Apply Numbering.mcr`
1. Type `TSLINSERT` in the command line.
2. Browse to the location of `HSB_G-Apply Numbering.mcr` and select it.
3. Click **OK** to insert the script into the drawing.

### Step 2: Configure Parameters
1. Select the script object in the drawing (if not already selected).
2. Open the **Properties Palette** (Ctrl+1).
3. Adjust the parameters (e.g., **Insert Type**, **Labels**, **Start Numbers**) to define your numbering rules. See the Parameters section below for details.

### Step 3: Execute Numbering
1. With the script selected, right-click in the drawing area.
2. Select the appropriate context menu option (e.g., **Recalculate** or a specific trigger like **Apply Numbering**) to run the script.
3. If **Insert Type** is set to "Manual Select", follow the command line prompts to select the beams you wish to process.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sInsertType | Dropdown | 3 (Manual Select) | Determines the scope of beams to process. <br>0: All beams in drawing.<br>1: Select a specific floor level.<br>2: Current floor only.<br>3: Manually select beams. |
| sNameFloorGroup | Text | "" | The name of the floor group to process (only used if Insert Type is "Floor List"). |
| sKeepExisting | Yes/No | Yes | **Yes**: Retains existing position numbers on beams that already have one.<br>**No**: Clears all position numbers in the selection before applying new ones. |
| sLabel01 | Text | "" | Enter beam labels for Group 1, separated by semicolons (e.g., `WAL;STU`). Supports wildcards `*` (e.g., `*WAL*`). |
| nStartAt01 | Number | 0 | The starting position number for beams matching the criteria in **sLabel01**. |
| sLabel02 | Text | "" | Enter beam labels for Group 2. |
| nStartAt02 | Number | 0 | The starting position number for beams matching the criteria in **sLabel02**. |

*(Note: The script may contain additional groups such as sLabel03/nStartAt03 depending on the specific version. Check the Properties Palette for full availability.)*

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate / Apply | Executes the numbering logic based on the current properties and assigns numbers to the beams. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies entirely on Properties Palette parameters; no external XML settings file is required.

## Tips
- **Wildcards:** Use `*` in label fields to catch variations. For example, `*Wall*` will match "IntWall", "ExtWall", etc.
- **Numbering Gaps:** To ensure numbering sequences do not overlap (e.g., walls vs. floors), set the **nStartAt** values significantly apart (e.g., Walls start at 1, Floors start at 500).
- **Renumbering:** If you want to completely re-sequence a model, set **sKeepExisting** to "No". This clears previous numbers so you can start fresh without duplicates or gaps.

## FAQ
- Q: Why are my beams not getting numbered?
  A: Check the **sLabel** fields. Ensure the text matches the actual Label property of your beams exactly (or use wildcards). Also, verify that the **Insert Type** scope includes the beams you are trying to number.
- Q: Can I number multiple different types at once?
  A: Yes. Use **sLabel01** for your first type (e.g., Studs) and **sLabel02** for your second type (e.g., Plates). Assign different **nStartAt** values to each group.
- Q: What happens if I set sKeepExisting to "No"?
  A: The script will wipe the Position Number property from all beams in the selected scope before applying the new numbers. Use this with caution.
# GE_BEAM_STUD_CLEANUP.mcr

## Overview
This script automatically cleans up wall framing by removing duplicate vertical studs or beams that physically overlap in the model. It resolves conflicts by checking a user-defined priority list for beam types and the load-bearing status of the wall elements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D beam entities in the model. |
| Paper Space | No | Not designed for 2D detailing or layout views. |
| Shop Drawing | No | Not intended for manufacturing views. |

## Prerequisites
- **Required Entities**: GenBeams (vertical beams/studs) and ElementWallSF (associated wall elements).
- **Minimum Beam Count**: 2 or more beams must be selected to run the comparison logic.
- **Required Settings**: None (uses standard catalog beam types).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_BEAM_STUD_CLEANUP.mcr`

### Step 2: Configure Priorities (Optional)
- Before proceeding, check the **Properties Palette** (Ctrl+1).
- Adjust the **Priority 1** through **Priority 4** settings to match your structural rules.
    - *Example*: Set Priority 1 to your main stud type (e.g., type "30") to ensure it is always kept over blocking or secondary studs.

### Step 3: Select Beams
```
Command Line: Select beams
Action: Click to select the vertical studs or wall elements you want to check for duplicates. Press Enter when finished.
```
*Note: The script automatically filters out horizontal beams; only vertical elements are processed.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Priority 1 | Dropdown | 30 | The most important beam type. If this type overlaps with others, the others will be deleted. |
| Priority 2 | Dropdown | 56 | The second most important beam type. Kept over Priorities 3 and 4, but removed if overlapping with Priority 1. |
| Priority 3 | Dropdown | 58 | The third most important beam type. Kept over Priority 4, but removed if overlapping with Priorities 1 or 2. |
| Priority 4 | Dropdown | 59 | The lowest priority beam type. This will be deleted if it overlaps with any higher priority type. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script runs once upon insertion and deletes itself; it does not remain in the drawing for context menu interactions. |

## Settings Files
- **None Required**: This script relies on the standard hsbCAD beam types catalog and element properties.

## Tips
- **Red Beams**: If the script finds overlapping beams that have the exact same Priority and Load-Bearing status, it cannot decide which to delete. In this case, it colors both beams **Red** so you can manually resolve the conflict.
- **Self-Deleting**: The script instance will disappear from the drawing immediately after running. Use the **Undo** command (Ctrl+Z) if you need to revert the changes.
- **Vertical Only**: You can select a whole wall frame including plates; the script will only analyze and clean up the vertical studs, ignoring horizontal top and bottom plates.

## FAQ
- **Q: Why did the script disappear after I selected the beams?**
  - A: This is normal behavior. The script performs the cleanup and then removes itself from the drawing to keep your model clean.
- **Q: Some beams turned Red but weren't deleted. Why?**
  - A: The script turns beams Red when they are duplicates but have identical properties (Priority and Load-Bearing status). It defaults to keeping both and marking them for you to check manually.
- **Q: How do I know which Priority number to use?**
  - A: The values correspond to the codes in your hsbCAD Catalog (Beam Types). Consult your catalog manager or check the properties of an existing beam to find its type code.
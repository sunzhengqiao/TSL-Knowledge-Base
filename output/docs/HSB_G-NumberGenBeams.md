# HSB_G-NumberGenBeams.mcr

## Overview
This script automatically assigns or resets Position Numbers (PosNum) for generic beams in your model. It ensures unique identification for fabrication lists, processing either a user-selected set of beams or all beams in the drawing.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script is designed to run exclusively in Model Space. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required entities:** Generic Beams (`GenBeam`) must exist in the drawing.
- **Minimum beam count:** 0 (You can run this on an empty selection to process all beams).
- **Required settings files:** None.

## Usage Steps

### Step 1: Launch Script
Command: Type `TSLINSERT` in the command line and select `HSB_G-NumberGenBeams.mcr` from the file browser, or use your assigned custom toolbar button.

### Step 2: Select Beams
```
Command Line: Select one or more genbeams, <ENTER> to select all genbeams
Action: Click on the specific beams you want to number, or press ENTER without selecting anything to process every Generic Beam in the Model Space.
```

### Step 3: Processing
The script will automatically reset the position numbers to 0 and then trigger the calculation to assign the correct unique numbers.

### Step 4: Completion
Once finished, the script instance will automatically erase itself from the drawing. Only the updated Position Numbers on your beams will remain.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script has no user-editable properties in the Properties Palette. It runs entirely via command line interaction. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not add any custom options to the right-click context menu. |

## Settings Files
- **Filename:** None
- **Location:** N/A
- **Purpose:** This script operates independently of external XML or settings files.

## Tips
- **Global Renumbering:** If you want to renumber the entire project, simply press `ENTER` immediately when prompted. This selects all Generic Beams in the Model Space.
- **Validation:** The script includes an automatic check (up to 50 retries) to ensure the CAD engine successfully assigns the numbers. You do not need to run the script multiple times manually if there is a slight delay.
- **Clean Up:** Do not be alarmed if the script object disappears after running; this is intended behavior to keep your drawing clean.

## FAQ
- **Q: What happens if I select nothing?**
- **A:** If you press ENTER without selecting any beams, the script will automatically select and process every Generic Beam currently in the Model Space.

- **Q: Why did the script disappear after I used it?**
- **A:** The script is designed to "erase itself" (`eraseInstance`) immediately after updating the beam properties. It is a utility tool, not a permanent object in your design.

- **Q: Can I use this in a shop drawing layout?**
- **A:** No, this script only detects and processes entities in the 3D Model Space.
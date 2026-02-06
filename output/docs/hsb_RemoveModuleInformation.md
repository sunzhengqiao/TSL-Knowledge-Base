# hsb_RemoveModuleInformation.mcr

## Overview
This utility script allows you to remove module assignments from specific beams within selected elements and updates their color to indicate they are no longer part of a module. It is typically used to extract specific beam types (e.g., columns) from a modular assembly to be treated as loose elements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the model space where elements and beams are located. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required entities:** Elements containing GenBeams.
- **Minimum beam count:** 0 (You must select elements, but they do not need to contain a specific minimum number of beams).
- **Required settings files:** None.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Browse to and select `hsb_RemoveModuleInformation.mcr`.

### Step 2: Configure Properties (If Manual Run)
- **Action:** If executed manually (not from a catalog), a Properties dialog will appear automatically.
- **Action:** Enter the **Filter Beams with Code** string (e.g., `COL;STU`) to identify which beams to modify.
- **Action:** Set the **Color for the Beams** to a visible index (e.g., 32) to mark modified beams.
- **Action:** Click OK to proceed.

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the Elements in the drawing that contain the beams you wish to update. Press Enter to confirm selection.
```

### Step 4: Automatic Processing
- **Action:** The script will automatically iterate through the selected elements.
- **Result:** Beams matching your filter criteria will have their **Module** property cleared and their color updated.
- **Cleanup:** The script instance will automatically erase itself from the drawing upon completion.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Filter Beams with Code | text | (empty) | Enter the beam code prefixes to target (e.g., `WAL;COL`). Separate multiple codes with a semicolon `;`. Only beams whose code starts with these values will be modified. |
| Color for the Beams | number | 32 | The AutoCAD color index (1-255) applied to the beams after their module assignment is removed. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| None | This script is a "fire and forget" utility. It erases itself immediately after execution and does not provide context menu options. |

## Settings Files
- No external settings files are required for this script.

## Tips
- **Check Codes:** Ensure the `Filter Beams with Code` matches the beginning of the actual beam codes in your model (e.g., use "COL" for "COL-01"). The filter is case-insensitive.
- **Visual Feedback:** Use a distinct color (like bright Red or Magenta) temporarily to easily verify which beams were affected by the script.
- **Re-running:** Since the script erases itself, you must run `TSLINSERT` again if you need to process additional elements with different settings.

## FAQ
- **Q: I ran the script, but nothing changed color. Why?**
  - A: This usually means the `Filter Beams with Code` did not match any beam codes within the selected elements, or the filter string was left empty. Check the spelling of the beam codes.
- **Q: Where did the script object go after I used it?**
  - A: This script is designed to delete itself automatically after processing to keep your drawing clean.
- **Q: Can I use wildcards in the filter?**
  - A: No, the script filters based on the first token of the beam code. You must list the specific prefixes (e.g., `WAL;FLO`).
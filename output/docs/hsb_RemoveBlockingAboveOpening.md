# hsb_RemoveBlockingAboveOpening

## Overview
Automatically detects and removes solid blocking beams located in the zone directly above wall openings to prevent geometric clashes and clean up the model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on Element entities in the 3D model. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | This script modifies the model, not drawing views. |

## Prerequisites
- **Required Entities:** Elements containing Beams and Openings.
- **Minimum Beam Count:** At least one Element must be selected.
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_RemoveBlockingAboveOpening.mcr`

### Step 2: Configure Filters (Optional)
```
Dialog: Properties Palette or Dialog Box
Action: (Optional) Enter beam codes into the "Filter Beams with Code" field to protect specific blocking types from deletion.
```
*Note: If run from a menu/toolbar, this step may be skipped or handled automatically.*

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the wall elements in the drawing that contain the openings you wish to clear. Press Enter to confirm selection.
```

### Step 4: Automatic Processing
The script will automatically calculate the area above each opening and erase any blocking beams found within that zone. The script instance will then remove itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Filter Beams with Code | text | "" | Enter beam codes (separated by semicolons) to specify which blocking beams should **NOT** deleted. If left empty, all blocking above openings will be removed. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific options to the entity context menu. |

## Settings Files
- **Filename:** None required.
- **Location:** N/A
- **Purpose:** N/A

## Tips
- **Protecting Specific Beams:** If you have specific blocking members (e.g., decorative headers) that you want to keep above windows, enter their specific codes into the *Filter Beams with Code* property (e.g., `HeaderCode1;HeaderCode2`).
- **Undo Changes:** Since the script deletes itself immediately after running, you cannot edit it to "undo" the action. Use the standard AutoCAD `U` (Undo) command to revert the model changes if needed.
- **Tolerance:** The script uses a small geometric tolerance (intersection area > 10mm²) to determine if a blocking beam is actually inside the opening zone, ensuring it doesn't delete beams that are merely touching the edge.

## FAQ
- **Q: The script ran, but no beams were deleted. Why?**
  A: This can happen if the blocking beams found match the codes in your filter list, or if the blocking is defined as a type other than "Blocking" (e.g., a standard stud).
- **Q: Can I run this on multiple walls at once?**
  A: Yes. Use a window selection or select multiple elements during the "Select a set of elements" prompt to process all of them in one go.
- **Q: Why can't I find the script in the drawing after I run it?**
  A: This is a "Run Once" script. It automatically erases itself from the drawing after processing to keep your drawing clean. Simply re-insert it from the catalog whenever you need to use it again.

---
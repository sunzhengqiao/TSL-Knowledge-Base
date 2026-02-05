# HSB_W-SplitPlates.mcr

## Overview
This script automatically splits long wall top and bottom plates into shorter segments to match standard raw material lengths (e.g., 5m or 6m). It helps optimize wall elements for manufacturing and transportation constraints by breaking down continuous plates into manageable pieces.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the 3D Model Space. |
| Paper Space | No | Not supported for 2D layouts or viewports. |
| Shop Drawing | No | This is a modeling tool and does not generate shop drawings. |

## Prerequisites
- **Required Entities**: `ElementWall` (Wall objects) that contain Top Plates or Bottom Plates.
- **Minimum Beam Count**: 0 (The script handles empty walls gracefully, but requires walls to be present to function).
- **Required Settings Files**: None.

## Usage Steps

### Step 1: Launch Script
Command: Type `TSLINSERT` in the command line and select `HSB_W-SplitPlates.mcr` from the file dialog.

### Step 2: Select Wall Elements
```
Command Line: Please select Element
Action: Click on the wall(s) in your model that require plate splitting. You can select multiple walls. Press Enter to confirm.
```

*(Note: If no walls are selected, the script will display a message and terminate immediately.)*

### Step 3: Automatic Processing
The script will automatically detect the Top and Bottom plates within the selected walls and split them according to the logic defined below. The script instance deletes itself automatically once finished.

## Properties Panel Parameters
This script does not expose any editable parameters in the Properties Palette. It is a "fire and forget" tool that executes immediately based on the geometry of the selected walls.

## Right-Click Menu Options
None. The script runs once upon insertion and does not remain in the model to provide context menu options.

## Settings Files
None. The script does not rely on external XML or configuration files.

## Tips
- **Selection Efficiency**: You can select multiple walls at once before pressing Enter to process an entire floor or section quickly.
- **Undo**: If the results are not as expected, use the standard AutoCAD `UNDO` command to revert the changes, as the script deletes itself after running.
- **Split Logic Awareness**:
    - **Bottom Plates**: are split recursively at 5000mm intervals. If a plate is 12m long, it will be split into pieces of 5m, 5m, and 2m.
    - **Top Plates**:
        - If length is **> 5000mm and < 6000mm**: It splits to create a 5000mm piece and a remainder.
        - If length is **> 6000mm**: It extracts a 5000mm section from the center, leaving two tail pieces (e.g., a 7m plate becomes a 1m tail, 5m center, and 1m tail).

## FAQ
- **Q: Can I customize the split length (e.g., change 5000mm to 6000mm)?**
  - A: No, the split thresholds are currently hardcoded within the script logic.
- **Q: Why did the script disappear after I ran it?**
  - A: This is intentional behavior. The script is designed as a one-time command tool. It performs the splits and then removes its own instance from the drawing to keep the project clean.
- **Q: Does this script split studs or other wall components?**
  - A: No, it specifically targets Top Plates and Bottom Plates within the ElementWall. It does not affect studs, headers, or other wall members.
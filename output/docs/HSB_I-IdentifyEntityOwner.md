# HSB_I-IdentifyEntityOwner

## Overview
This tool helps you investigate the model structure by identifying which construction element (such as a Wall or Roof) owns a specific drawing entity (like a dimension, line, or text). It also counts how many other entities of the same type belong to that parent element.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script only operates within the 3D model environment. |
| Paper Space | No | Not designed for layouts or viewports. |
| Shop Drawing | No | Not designed for 2D detailing drawings. |

## Prerequisites
- **Required Entities**: You must have at least one drawing entity (e.g., a dimension, hatch, or line) visible in the model.
- **Minimum Beam Count**: None.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_I-IdentifyEntityOwner.mcr` from the file dialog.
*(Alternatively, click the custom toolbar icon if assigned by your administrator.)*

### Step 2: Select Entities
```
Command Line: Select entities
Action: Click on the drawing object(s) you wish to investigate (e.g., a specific dimension line or annotation).
```
*You can select multiple objects at once using window selection or Ctrl+click.*

### Step 3: Confirm Selection
```
Command Line: (Right-click or Press Enter to finish selection)
Action: Press Enter or Right-click to confirm your choice.
```

### Step 4: View Results
The script will display the results in the **AutoCAD Command Line**. Look for the following information:
- The type and handle of the selected entity.
- The **Code and Number** of the parent Element (e.g., "Wall 1").
- The **count** of similar entities owned by that same Element.

*Tip: Press **F2** on your keyboard to open the full command line history if the text scrolls off the screen.*

## Properties Panel Parameters

This script does not expose any adjustable parameters in the Properties Panel. It runs automatically upon selection.

## Right-Click Menu Options

This script does not add specific options to the right-click context menu, as it performs its task and removes itself immediately.

## Settings Files
No specific settings files are required for this script.

## Tips
- **Check the Command Line**: Since the script erases itself immediately after running, the only place to see the results is the command line history. Make sure to read the output before drawing other commands that might clear the text.
- **Select Valid hsbCAD Entities**: Ensure the entity you select was created by hsbCAD. If you select a standard AutoCAD line (e.g., one drawn manually with the LINE command) that is not associated with an hsbCAD element, the script will report that the element could not be found.
- **Batch Processing**: You can select multiple items at once. The script will generate a separate report for every item selected, which is useful for quickly checking if multiple dimensions belong to different walls.

## FAQ
- **Q: Why did the script disappear after I ran it?**
  **A:** This is a "fire-and-forget" inquiry tool. It automatically deletes its instance from the drawing after reporting the information to keep your model clean.
- **Q: The script says "Element could not be found". What does that mean?**
  **A:** This means the object you selected is not linked to a valid hsbCAD construction element. It might be a standard AutoCAD object or an orphaned entity that lost its connection to the main element data.
- **Q: Can I use this on Shop Drawing dimensions?**
  **A:** No, this script is designed for Model Space only. It will not work on entities inside detail drawings.
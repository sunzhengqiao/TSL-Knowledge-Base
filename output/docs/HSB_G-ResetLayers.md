# HSB_G-ResetLayers.mcr

## Overview
This script serves as a cleanup utility to standardize the layer assignment of timber beams within your model. It automatically resets the layer of all generated beams (GenBeams) inside selected elements to layer '0' and ensures they are correctly grouped with their parent element.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in Model Space to interact with Elements and GenBeams. |
| Paper Space | No | The script is not designed to process entities in Paper Space layouts. |
| Shop Drawing | No | This is a model management tool and does not generate shop drawings. |

## Prerequisites
- **Required Entities**: Elements and GenBeams (Timber beams).
- **Minimum Beam Count**: 0 (The script can process elements even if they contain no beams).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the AutoCAD command line.
2. Navigate to the location of `HSB_G-ResetLayers.mcr` and select it.

### Step 2: Select Elements
```
Command Line: Select a set of elements
Action: Click on the desired Elements in the model and press Enter to confirm selection.
```
*(Note: You can select multiple elements at once using window selection.)*

### Step 3: Automatic Processing
The script will automatically process the selected elements, move all associated beams to layer '0', update their group assignments, and then remove itself from the drawing. No further user input is required.

## Properties Panel Parameters

This script does not expose any user-editable parameters in the Properties Palette.

## Right-Click Menu Options

This script does not add any custom options to the right-click context menu.

## Settings Files

This script does not require any external settings files.

## Tips
- **One-Time Use**: This script acts as a "run once" utility. After processing the selected elements, the script instance automatically deletes itself from the drawing database to keep the project clean.
- **Layer '0'**: Ensure layer '0' is not frozen or locked in your Layer Properties Manager before running this script, otherwise the changes may not be visible immediately.
- **Batch Processing**: You can select as many elements as needed in Step 2. The script will iterate through the entire selection set efficiently.

## FAQ
- **Q: The script seems to disappear after I run it. Is this normal?**
  - **A:** Yes, this is intended behavior. Once the layer reset is complete, the script erases itself to prevent cluttering the drawing with unused script instances.
- **Q: Can I use this to change layers to something other than '0'?**
  - **A:** No, this script is hard-coded specifically to reset entities to layer '0'.
- **Q: I selected elements but nothing happened.**
  - **A:** Ensure that the selected entities are valid hsbCAD Elements containing GenBeams. If the beams are already on layer '0' and correctly grouped, no visible change will occur.
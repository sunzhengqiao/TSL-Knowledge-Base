# hsb-SteelProfileFlip.mcr

## Overview
This script automatically rotates specific steel beams by 180 degrees around the element Z-axis based on roof edge variables. It filters beams by their profile code and flips them if the associated roof edge construction details require a change in orientation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the 3D model. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | This is a model modification script. |

## Prerequisites
- **Required Entities**: Elements (specifically of the "ElementRoof" type) containing Beams.
- **Minimum Beam Count**: 0 (Script processes silently if no beams match criteria).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb-SteelProfileFlip.mcr`

### Step 2: Select Elements
```
Command Line: Select one, or more elements
Action: Click on the Roof Element(s) in the 3D model that contain the steel profiles you wish to process. Press Enter to confirm selection.
```
*Note: Once confirmed, the script will automatically process the elements, rotate the beams, and then remove itself from the drawing.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Convert Beams with Code | text | (Empty) | Enter the beam codes (profile names) to be processed. Separate multiple codes with a semicolon (;). Only beams matching these codes will be flipped. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are provided for this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Beam Codes**: Ensure the beam codes in the properties panel exactly match the codes used in your catalog (e.g., `IPE300;HEA200`).
- **Self-Deleting**: This script instance automatically erases itself after running. You do not need to manually delete the script entity from the model after use.
- **Undo**: If the rotation results are incorrect, use the standard AutoCAD `Undo` command (Ctrl+Z) to revert the changes.
- **Logic Dependency**: The script only flips beams if the Roof Edge has specific construction details set (specifically a "FLIP" variable token). Ensure your roof edge properties are correctly configured before running.

## FAQ
- **Q: Why didn't my beams flip even though I selected the element?**
  **A**: Check three things: 1) The beam code is listed in the "Convert Beams with Code" property; 2) The roof edge construction details include the specific "FLIP" variable logic; 3) The beam is parallel to the roof edge.
  
- **Q: Can I run this on multiple elements at once?**
  **A**: Yes, you can select multiple Roof Elements during the prompt, and the script will process all of them.

- **Q: Where did the script go after I ran it?**
  **A**: The script is designed to "self-destruct" (eraseInstance) immediately after processing to keep your drawing clean. To run it again, simply insert it via `TSLINSERT` again.
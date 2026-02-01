# GE_WALL_INFO_TSL_ATTACHED_TO_ELEMENT

## Overview
This is a diagnostic utility script that identifies which manufacturing or connection TSL scripts are currently attached to a specific wall or element. After displaying the information in a pop-up notice, the script automatically deletes itself from the drawing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be run in the 3D model to select an element. |
| Paper Space | No | This script does not function in layout views. |
| Shop Drawing | No | This script is not intended for shop drawings or detailing views. |

## Prerequisites
- **Required entities**: An existing Element (e.g., a Wall) in the drawing.
- **Minimum beam count**: 0 (Operates on Elements, not individual beams).
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse to and select `GE_WALL_INFO_TSL_ATTACHED_TO_ELEMENT.mcr`

### Step 2: Select Element
```
Command Line: Select element
Action: Click on the wall or element in the model you wish to audit.
```
*Note: The script will wait for you to select an object. Once selected, it will process the information on the next cycle.*

### Step 3: View Results
The script will display a `reportNotice` (pop-up dialog) listing all TSLs attached to the selected element (excluding this info script itself).
- **Result**: If no other scripts are found, it will state "No TSL's is attached to element."
- **Result**: If scripts are found, it lists their names.

### Step 4: Automatic Cleanup
The script automatically executes an `eraseInstance` command immediately after showing the report. It will not remain visible in the model.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script has no editable properties in the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script exposes no custom context menu options. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Self-Deleting**: Do not be alarmed if the script "disappears" immediately after you run it. This is intended behavior to keep the drawing clean.
- **Troubleshooting**: Use this script when a wall is behaving unexpectedly (e.g., missing holes or notches) to verify if the correct processing TSLs are actually attached.
- **Selection**: Ensure you click directly on the main Element entity. If you click on empty space, the script will simply erase itself without producing a report.

## FAQ
- **Q: Why did the script vanish immediately after I selected the element?**
  A: The script is designed to display the report and then automatically delete its own instance from the drawing (`eraseInstance`).
- **Q: The report says "No TSL's is attached," but I expected there to be scripts.**
  A: This indicates the element is raw and has no manufacturing or connection scripts assigned to it. You may need to manually attach the relevant TSLs to the element.
- **Q: What happens if I don't select an element?**
  A: If no element is detected during the execution cycle, the script will erase itself without showing a dialog.
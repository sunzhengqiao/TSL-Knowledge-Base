# hsbConvertSip2Beam.mcr

## Overview
Converts Structural Insulated Panels (Sip entities) into standard timber beams (GenBeams) while preserving their geometry and attributes. It provides options to automatically adjust position numbers and either replace the original panel or keep it as a copy.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates on Sip entities within the model. |
| Paper Space | No | This script is not designed for Paper Space. |
| Shop Drawing | No | This script is not used for generating shop drawings. |

## Prerequisites
- **Required Entities**: Structural Insulated Panels (Sip) must exist in the model.
- **Minimum Beam Count**: N/A (This script creates beams from panels).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbConvertSip2Beam.mcr`

### Step 2: Configure Properties
A properties dialog will appear automatically upon insertion (unless triggered by a catalog).
- **Increment PosNum**: Enter a number (e.g., 1, 10) to add to the panel's original position number for the new beam. Leave as `0` to disable automatic numbering.
- **Delete origin body**: Select `No` to keep the original panel, or `Yes` to remove it from the drawing.
Click OK to proceed.

### Step 3: Select Panels
```
Command Line: Select sips
Action: Click on the Structural Insulated Panels (Sip) you wish to convert. You can select multiple panels. Press Enter to confirm selection.
```

### Step 4: Processing
The script will convert the selected panels into beams. The script instance will erase itself automatically once the process is complete.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Increment PosNum | Number | 0 | Adds this value to the source panel's PosNum for the new beam. If set to 0 (default), no position number is automatically assigned. |
| Delete origin body | Dropdown | No | Determines whether the original panel is deleted. Select "Yes" to replace the panel with a beam, or "No" to keep both. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script executes immediately and erases itself; therefore, it has no persistent right-click menu options. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Undo**: You can use the standard AutoCAD `UNDO` command immediately after running the script if the result is not as expected.
- **Number Conflicts**: If your project already uses the target position numbers, the script may warn you that it could not assign the specific number. Use the `Increment PosNum` setting to offset the new beams into a clear number range (e.g., set to 1000).
- **Visual Check**: If you set "Delete origin body" to No, visually verify that the new beam is correctly placed before manually deleting the original panel to avoid overlapping elements.

## FAQ
- **Q: Why didn't the new beam get a position number?**
- **A:** By default, the "Increment PosNum" property is set to 0. This disables automatic numbering. Change this value to 1 or higher to enable automatic position number assignment.

- **Q: Can I edit the settings after I run the script?**
- **A:** No. The script erases itself immediately after execution. You must insert the script again to run it with different settings.

- **Q: What happens if I select something that isn't a Sip panel?**
- **A:** The script includes a filter that ignores any selected entities that are not Structural Insulated Panels (Sip). Only valid panels will be converted.
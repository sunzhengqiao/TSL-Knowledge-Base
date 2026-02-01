# HSB_E-ConvertToDummyBeams.mcr

## Overview
This script converts specific structural beams into "dummy" (non-manufacturable) parts based on their Beam Code property. It is typically used to mark spacer blocks, temporary members, or alignment parts so they are ignored in production lists and CNC exports.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on Elements and Beams within the 3D model. |
| Paper Space | No | Not intended for layout views. |
| Shop Drawing | No | Not intended for detailing views. |

## Prerequisites
- **Required Entities**: Elements containing GenBeams (beams).
- **Minimum beam count**: 0.
- **Required Settings**: The utility script `HSB_G-FilterGenBeams` must be available in the hsbCAD environment.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT` → Browse and select `HSB_E-ConvertToDummyBeams.mcr`

### Step 2: Configure Properties
```
Dialog Box: Script Properties
Action:
1. In the "Beam codes to convert" field, enter the filter criteria (e.g., "DUMMY*" or "SPACER").
2. (Optional) Adjust the "Sequence number" if execution order matters relative to other scripts.
3. Click OK to proceed.
```

### Step 3: Select Elements
```
Command Line: Select elements
Action:
1. Click on the Elements in the model that contain the beams you wish to convert.
2. Press Enter to confirm selection.
```

### Step 4: Execution
The script will automatically filter the beams within the selected elements, convert matching beams to dummy status, and then remove itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Beam codes to convert | Text | DUMMY* | Determines which beams are converted. Use standard wildcards (e.g., * or ?) to match beam codes (e.g., "TMP_*"). |
| Sequence number | Number | 0 | Defines the execution order during the generation process. Higher numbers run later. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| (None) | This script erases itself after execution and does not provide persistent right-click options. |

## Settings Files
This script relies on the logic within the internal utility script **HSB_G-FilterGenBeams**. No separate XML settings file is required for configuration.

## Tips
- **Wildcards**: You can use `*` to represent any group of characters and `?` for a single character. For example, entering `*NO-CNC` will match any beam code ending with "-NO-CNC".
- **Self-Deleting**: This script instance will disappear from your drawing immediately after it runs. This is normal behavior.
- **Verification**: After running the script, you can check if a beam is a dummy by selecting it and looking at its properties in the AutoCAD Properties palette (check the manufacturing status or dummy flag).
- **Undo**: If you make a mistake, you can use the standard AutoCAD `UNDO` command to revert the changes.

## FAQ
- **Q: Where did the script instance go after I ran it?**
  - A: The script is designed to erase itself immediately after modifying the beams. The changes to the beams remain, but the script instance is removed to keep the drawing clean.
- **Q: How do I make a beam "real" again after it has been converted to a dummy?**
  - A: Re-running this script with a different filter will not automatically "un-dummy" beams. You must manually select the beam and change its status/Dummy property in the Properties palette, or use a script specifically designed to reset dummy status.
- **Q: Can I use this on multiple elements at once?**
  - A: Yes, you can window-select multiple elements during the "Select elements" prompt.
# HSB_I-ListBeamTypes.mcr

## Overview
This script is a diagnostic utility that lists the names of beam types defined in its internal configuration to the command line. It is designed to run once and report this data before automatically removing itself from the drawing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates in the current model context. |
| Paper Space | No | The script does not support Paper Space entities. |
| Shop Drawing | No | This is not a shop drawing generation script. |

## Prerequisites
- **Required entities**: None.
- **Minimum beam count**: None.
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_I-ListBeamTypes.mcr` from the file browser.

### Step 2: View Results
```
Command Line: [Script executes automatically]
Action: Observe the text output in the AutoCAD command line (F2) listing the available beam types.
```

### Step 3: Script Cleanup
```
Action: None required.
Note: The script instance automatically deletes itself from the drawing immediately after generating the report.
```

## Properties Panel Parameters
None. This script does not expose any user-editable properties in the Properties Palette.

## Right-Click Menu Options
None. The script executes and terminates immediately upon insertion.

## Settings Files
None. This script relies on an internal array rather than external settings files.

## Tips
- If the list of beam types is long, press **F2** on your keyboard to open the AutoCAD Text Window to view the full history of the output.
- This tool is useful for developers or advanced users to verify which beam types are currently hardcoded or recognized by the script environment.

## FAQ
- **Q: Why did the script disappear immediately after I inserted it?**
  A: This is the intended behavior. The script is designed to output information to the command line and then erase itself to keep the drawing clean.
- **Q: Where can I find the list of beam types?**
  A: The list is printed directly to the AutoCAD command line history. Look there immediately after inserting the script.
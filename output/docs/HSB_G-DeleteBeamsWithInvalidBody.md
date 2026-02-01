# HSB_G-DeleteBeamsWithInvalidBody.mcr

## Overview
This script is a maintenance tool that automatically scans your model and removes any Timber Beams (GenBeams) with zero volume or invalid geometry. It is designed to clean up "ghost" beams that appear in the project manager but have no physical shape, which can occur after data imports or modeling errors.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script scans all entities in the current Model Space. |
| Paper Space | No | Not intended for use in Paper Space. |
| Shop Drawing | No | Not intended for use in Shop Drawing layouts. |

## Prerequisites
- **Required Entities**: GenBeam entities (the script scans the entire drawing for these).
- **Minimum Beam Count**: 0 (The script can run on an empty drawing).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the AutoCAD command line.
2.  Browse to and select `HSB_G-DeleteBeamsWithInvalidBody.mcr`.
3.  Click **Open**.

### Step 2: Automatic Execution
```
Script Action: Automatically scans Model Space for all GenBeams.
Process: Calculates volume (Length x Width x Height) for each beam.
Result: 
- Beams with zero volume or invalid bodies are deleted immediately.
- A message "Invalid bod for genBeam. GenBeam is deleted" is reported for each deleted beam in the command line.
- The script instance deletes itself upon completion.
```
*No further user input is required.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not expose any user-editable properties. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not add specific options to the right-click context menu. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A (This script does not rely on external settings files).

## Tips
- **Post-Import Cleanup**: Run this script immediately after importing DWG/DXF files to remove corrupt beams that might interfere with subsequent machining or listing processes.
- **Check Logs**: Look at your AutoCAD command line text window after running the script to see how many beams were identified and deleted.
- **Undo**: As the script performs deletions, ensure you have adequate backups or test the script on a copy if you are unsure about the results.

## FAQ
- **Q: Why did the script disappear immediately after I inserted it?**
  - A: This is intended behavior. The script performs its task (scanning and deleting) and then removes its own instance from the drawing automatically to keep the project clean.
- **Q: How do I know if a beam was deleted?**
  - A: The script reports "Invalid bod for genBeam. GenBeam is deleted" to the AutoCAD command line for every beam it removes.
- **Q: Can I undo the deletions?**
  - A: This depends on your current hsbCAD/AutoCAD Undo settings. In many cases, standard `U` or `UNDO` commands can reverse the actions, but it is best practice to save your project before running bulk maintenance scripts.
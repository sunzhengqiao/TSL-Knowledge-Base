# hsbModifyBeamProperties.mcr

## Overview
This script automatically updates the Color and Beamtype of beams by interpreting special codes embedded within the beam's material string. After applying the changes, it cleans the material string to remove the instructions, ensuring the final data is clean.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Designed for processing 3D model elements. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Not intended for shop drawing generation. |

## Prerequisites
- **Required Entities**: Element (e.g., Walls or Roofs containing beams).
- **Minimum beam count**: None.
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbModifyBeamProperties.mcr`

### Step 2: Select Elements or View Report
```
Command Line: Select element(s) | <Enter> to report beamtypes
Action:
- Select the Elements (e.g., walls) you want to process and press Enter.
OR
- Press Enter immediately without selecting anything to see a list of available BeamTypes in the command line history.
```
*Note: Once processing is complete, the script instance will automatically erase itself.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not use Property Palette parameters. Configuration is done via the Beam Material string (see Tips). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | The script erases itself after running, so no context menu options are available. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Instruction Syntax**: To modify a beam, add `(Color:X)` or `(Beamtype:Y)` to the beam's **Material** string (where X is the Color Index 0-255 and Y is the BeamType Index).
- **Case Insensitive**: The keys `COLOR` and `BEAMTYPE` are not case-sensitive (e.g., `(color:3)` works).
- **Data Cleanup**: The script automatically removes the instruction text (e.g., `(Color:3)`) from the Material name and BeamCode after applying the change.
- **Lookup BeamTypes**: If you do not know the specific number for a BeamType, run the script and press `Enter` at the selection prompt. A sorted list of all project BeamTypes and their indices will be printed to the command line.
- **Integration**: This script can be triggered during wall element construction if included in the wall's calculation script, allowing for automatic property adjustments based on catalog definitions.

## FAQ
- **Q: Where do I input the Color or Beamtype number?**
- **A:** You do not type it into the script properties. You must type it directly into the **Material** field of the individual beam (or your catalog definition) in the format `(Color:5)` or `(Beamtype:10)`.
- **Q: Why did the script disappear after I used it?**
- **A:** This is a "run and done" script. It processes the data, updates the beams, and automatically deletes its own instance to keep your drawing clean. To run it again, simply insert it via `TSLINSERT` again.
- **Q: What happens if I type text instead of a number?**
- **A:** The script requires an integer value (e.g., `5`). If you provide invalid text or a bad format, that specific instruction will be ignored, and the property will not change.
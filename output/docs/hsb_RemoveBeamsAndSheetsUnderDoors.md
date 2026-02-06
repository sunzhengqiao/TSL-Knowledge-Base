# hsb_RemoveBeamsAndSheetsUnderDoors.mcr

## Overview
This script automatically cleans up wall panels by removing specific framing members (braces, jack studs, sills) and sheathing sheets that obstruct door openings. It is designed to prepare wall elements for door installation by clearing the aperture area.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates directly on 3D Elements in the model. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: Wall Elements (containing Openings of type "Door").
- **Minimum Beam Count**: 0 (Script processes existing entities).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_RemoveBeamsAndSheetsUnderDoors.mcr`

### Step 2: Select Elements
```
Command Line: Please select Elements
Action: Select the wall elements (panels) in the Model Space that contain the door openings you wish to clear. Press Enter to confirm selection.
```
The script will automatically process the selected elements, identify door openings, and remove overlapping braces, jack studs, sills, and sheets.

## Properties Panel Parameters
This script does not expose any user-editable parameters in the Properties Palette (OPM).

## Right-Click Menu Options
This script does not add any custom options to the right-click context menu.

## Settings Files
No external settings files are required for this script.

## Tips
- **Scope of Deletion**: The script specifically targets beams classified as Braces (`_kBrace`), Jack Studs under openings (`_kSFJackUnderOpening`), and Sills (`_kSill`). It will not delete main structural studs.
- **Overlap Logic**: A member is only deleted if it overlaps with the door's envelope (extended 500mm into the wall) by more than 95%.
- **Selection**: You can select multiple elements at once to process several doors in a single run.
- **Validation**: Ensure your elements have valid Door type openings defined; elements without valid doors will be skipped by the script.

## FAQ
- **Q: Why were the main studs under my door not deleted?**
  **A:** The script is programmed to remove only bracing, jack studs, and sills to maintain structural integrity. It does not remove primary wall studs.
- **Q: Can I undo the changes?**
  **A:** Yes, you can use the standard AutoCAD `UNDO` command immediately after running the script if the results are not as expected.
- **Q: What happens if I select an element that has no doors?**
  **A:** The script will detect that there are no valid door openings and skip that element without making any changes.
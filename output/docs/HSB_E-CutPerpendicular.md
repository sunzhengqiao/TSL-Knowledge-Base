# HSB_E-CutPerpendicular.mcr

## Overview
This script automatically simplifies complex beam intersections into perpendicular (90-degree) cuts based on existing geometry. It is typically used to trim wall studs or joists flat where they meet a roof plane or another beam, standardizing connections without manual editing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D Elements in the model. |
| Paper Space | No | Not applicable for layouts or drawings. |
| Shop Drawing | No | This is a detailing/modeling tool, not a drawing generator. |

## Prerequisites
- **Required Entities**: An existing `Element` (e.g., a wall or roof assembly).
- **Minimum Beam Count**: The Element must contain beams, though the script is applied to the Element container.
- **Required Settings**: The `Beamcode to cut` property must be populated; the script will self-erase and do nothing if this field is left empty.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse to the location of `HSB_E-CutPerpendicular.mcr`, select the file, and click **Open**.

### Step 2: Select Elements
```
Command Line: Select one or more elements
Action: Click on the desired Element(s) in the Model Space and press Enter.
```
*Note: The script is attached to the element. You can then adjust properties via the Properties Palette.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Cut-type bottom/left | Dropdown | Shortest point | Determines how the cut is calculated on the start/left side of the beam. <br>- **Shortest point**: Cuts the beam to the deepest part of the intersection (shortest length).<br>- **Longest point**: Cuts the beam to the outermost edge of the intersection (longest length).<br>- **No cut**: Skips cutting this side. |
| Cut-type top/right | Dropdown | Shortest point | Determines how the cut is calculated on the end/right side of the beam. Options are identical to the bottom/left setting. |
| Beamcode to cut | Text | [Empty] | The filter used to select which beams within the Element are processed. <br>*Example: Enter "STUD" to only cut beams with the code "STUD". Supports wildcards (e.g., "STUD*").* |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are added by this script. All modifications are done via the Properties Palette. |

## Settings Files
- **Filename**: N/A
- **Location**: N/A
- **Purpose**: This script relies on internal properties and standard hsbCAD catalogs. No external XML settings file is strictly required for basic operation.

## Tips
- **Script Self-Erases**: If you insert the script and it disappears immediately, check if `sBmCodeToCut` (Beamcode to cut) is empty. The script requires a target beam code to function.
- **Wildcards**: You can use `*` in the Beamcode field to affect multiple beam types at once (e.g., `*RAFTER*`).
- **Opposing Sides**: Use "No cut" on one side and "Shortest point" on the other if you only want to trim the start or end of a beam, not both.
- **DSP Integration**: This script is often used within DSP (Detailing Standard Processing) rules to automatically apply standard perpendicular cuts during the generation of framing elements.

## FAQ
- **Q: Why didn't the script cut my beams?**
- **A:** Ensure the `Beamcode to cut` property matches the exact code of the beams in your Element (check the General properties of the individual beams to see their codes). If the property is empty, the script will not run.

- **Q: What is the difference between Shortest and Longest point?**
- **A:** Imagine a stud hitting a sloped roof. **Shortest point** cuts the stud at the peak of the roof (making it shorter). **Longest point** cuts the stud at the eave of the roof (leaving it longer). Choose the one that fits your structural detailing requirements.
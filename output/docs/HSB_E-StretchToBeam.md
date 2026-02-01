# HSB_E-StretchToBeam.mcr

## Overview
This script automatically stretches or cuts specific beams (Source) to intersect with other defined beams (Target) within an element. It is primarily used to extend floor joists to meet angled top plates without manual adjustment.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be run in the 3D model. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This is a construction/generation script. |

## Prerequisites
- **Required Entities**: At least one Element containing two or more beams.
- **Minimum Beam Count**: 2 (One to be stretched/cut, and one to serve as the target boundary).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-StretchToBeam.mcr` from the list.
Alternatively, click the custom toolbar icon if mapped.

### Step 2: Configure Properties
A Properties dialog will appear immediately upon insertion.
- **Action**: Set the "Beamcode to stretch" (e.g., your floor joist code) and the "Stretch to code" (e.g., your top plate code).
- **Action**: Choose "Stretch to" to lengthen beams or "Cut at" to trim them.
- **Action**: Click OK to confirm settings.

### Step 3: Select Elements
```
Command Line: Select elements:
Action: Click on the Element(s) in the drawing that contain the beams you wish to modify.
Action: Press Enter to finish selection.
```
*Note: Select the Element container, not the individual beams.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Sequence number | Integer | 0 | Determines the execution order relative to other TSLs (0-1000). |
| Beamcode to stretch | String | ZSP-02 | The code of the beams to be modified (Source). Supports wildcards (e.g., `ZSP-*`). |
| Stretch to | Dropdown | Code | Select how to identify the target beams: by "Code" or by "Type". |
| Stretch to code | String | KRL-07 | The code of the beams to stretch to (Target). Only used if "Stretch to" is set to Code. |
| Stretch to type | Dropdown | [Empty] | The structural type of the target beams (e.g., TopPlate). Only used if "Stretch to" is set to Type. |
| Stretch or cut | Dropdown | Stretch to | Select "Stretch to" to extend the beam, or "Cut at" to trim the end at the intersection. |
| Stretch margin | Number | 0 mm | Allows the source beam to stretch if it ends up slightly outside the target beam's volume (tolerance). |
| Stretch to margin | Number | 0 mm | The maximum allowable gap between the source and target beams for the operation to occur. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | This script does not add custom items to the right-click context menu. It runs once upon insertion/generation. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Wildcards**: You can use wildcards in the "Beamcode to stretch" field (e.g., `Floor-*`) to target multiple beam types at once.
- **Angled Walls**: This script is specifically useful for projects with non-90-degree walls (e.g., dormers or bay windows) where manual beam stretching is time-consuming.
- **Margins**: If the script fails to stretch beams that look like they should touch, try increasing the **Stretch margin** (e.g., to 5 mm) to account for small geometric discrepancies.
- **Sequence Number**: If the beams don't seem to exist when the script runs, increase the **Sequence number** to ensure this script runs *after* the beams are generated.

## FAQ
- **Q: Why did my beams not stretch?**
  **A:** Check that the "Beamcode to stretch" matches the actual code of your joists exactly. Also, ensure the "Sequence number" is high enough that the beams exist when this script runs.
- **Q: Can I use this to trim beams instead of stretching them?**
  **A:** Yes. Set the **Stretch or cut** property to "Cut at". This will trim the source beam at the intersection point of the target beam.
- **Q: What happens if I select the wrong element?**
  **A:** The script will process the selected element. If no matching beams are found, no changes will be made. You can simply undo (Ctrl+Z) and try again.
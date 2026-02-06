# hsb_SetHeadBinderCode.mcr

## Overview
This script identifies specific top plates within wall elements that intersect with perpendicular beams (such as binders or joists). It automatically renames these top plates by adding a 'V' prefix and updates their classification to "Very Top Plate".

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the 3D model where wall elements and beams reside. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | Not intended for 2D shop drawing generation. |

## Prerequisites
- **Required entities**: Wall Elements (`ElementWall`) containing Beams.
- **Minimum beam count**: 0
- **Required settings files**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SetHeadBinderCode.mcr`

### Step 2: Select Wall Elements
```
Command Line: 
Select a set of elements
```
**Action**: Click on the Wall Elements in the drawing that you wish to analyze. Once selected, press Enter to confirm.

## Properties Panel Parameters

No Properties Panel parameters are available for this script.

## Right-Click Menu Options

No Right-Click menu options are available for this script.

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- Ensure that the intersecting binders or joists are already drawn or present in the model before running this script, as it relies on geometric intersection to identify the correct top plates.
- The script specifically targets the highest plate in the wall (the top plate) that crosses the path of a perpendicular beam.
- Check your naming scheme afterwards; the script prepends the character 'V' to the existing BeamCode of the identified plates.

## FAQ
- **Q: What does the 'V' prefix stand for?**
  A: The 'V' denotes a "Very Top Plate," which is often treated differently in manufacturing or lists than standard top plates because it serves as a head binder for intersecting members.
- **Q: Why did the script not rename any plates in my wall?**
  A: Ensure that the selected wall elements actually have beams intersecting them perpendicularly. If there are no intersecting binders/joists, or if they do not physically cross the top plate, the script will not make any changes.
- **Q: Does this script create new beams?**
  A: No, this script only modifies the properties (Name and Type) of existing beams within the selected elements.
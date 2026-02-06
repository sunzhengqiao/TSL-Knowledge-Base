# hsb_SetBeamNameByCode

## Overview
Automatically batch-assigns timber attributes (Name, Material, Grade, and Color) to beams based on specific code matches. It also includes smart fallback logic to assign default properties for roof joists (distinguishing between standard rafters and transverse purlins) when no code is found.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script is designed to work on 3D model Elements. |
| Paper Space | No | Not intended for layout or sheet views. |
| Shop Drawing | No | Does not process manufacturing views. |

## Prerequisites
- **Required Entities**: `Element` objects containing `Beam` entities.
- **Minimum Beam Count**: 0 (Script processes whatever is found in the selection).
- **Required Settings**: The file `Materials.xml` must exist in the `hsbCompany\Abbund\` folder.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or use your assigned toolbar shortcut) → Select `hsb_SetBeamNameByCode.mcr`.

### Step 2: Configure Parameters
A configuration dialog or Properties Palette appears.
- **Define Code Rules (1-8)**: Enter a code (e.g., "ST") to match against existing beam codes. Then define the Name, Material, Grade, and Color to apply if a match is found.
- **Define Defaults (9-10)**: Set default properties for roof joists. Set **Category 9** for standard joists (parallel to slope) and **Category 10** for transverse joists (perpendicular to slope).

### Step 3: Select Elements
```
Command Line: Select element(s):
Action: Click on the Elements (walls, roofs, floors) containing the beams you wish to update. Press Enter to confirm selection.
```

### Step 4: Processing
The script immediately scans the selected Elements.
- It updates beams matching your defined codes.
- It applies roof defaults to rectangular beams without codes.
- The script instance automatically deletes itself from the drawing once finished.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Beam Code 1..8** | Text | (Empty) | The trigger code to search for in the beam's 'BeamCode' property (e.g., "FLR", "WALL"). If empty, that rule is skipped. |
| **Beam Name 1..8** | Text | (Empty) | The descriptive name to assign (e.g., "Floor Joist", "Stud") if the Beam Code matches. |
| **Beam Material 1..8** | List | (From XML) | The timber material to assign (e.g., "C24", "GL28h"). Must exist in your Materials.xml. |
| **Beam Grade 1..8** | Text | (Empty) | The structural grade to assign (e.g., "C24", "GL24h"). |
| **Color 1..8** | Index | 32 | The AutoCAD color index to apply to the beam for visual identification. |
| **Beam Name 9 (Standard)** | Text | (Empty) | Default name for rectangular roof beams running parallel to the slope (Standard Joist). |
| **Beam Name 10 (Transverse)** | Text | (Empty) | Default name for rectangular roof beams running perpendicular to the slope (Purlins). |
| **Material 9 / 10** | List | (From XML) | Default materials for Standard and Transverse roof joists. |
| **Grade 9 / 10** | Text | (Empty) | Default grades for Standard and Transverse roof joists. |
| **Color 9 / 10** | Index | 32 | Default colors for Standard and Transverse roof joists. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | The script automatically erases itself after processing. There are no context menu options available after execution. |

## Settings Files
- **Filename**: `Materials.xml`
- **Location**: `hsbCompany\Abbund\`
- **Purpose**: Provides the valid list of materials (e.g., C14, C24, GL24h) available in the dropdown lists. If this file is missing, the material lists will be empty, and a warning will be displayed.

## Tips
- **Roof Logic**: The script is smart enough to detect Roof Elements. If a beam in a roof has no code, it checks the orientation. Beams crossing the roof slope are treated as "Transverse" (Category 10), while others are "Standard" (Category 9).
- **I-Joists**: If a beam has no code and a non-rectangular profile (e.g., an I-Joist), the script automatically sets the Name to match the Profile Name (e.g., "I-JOIST").
- **Zones**: Beams located in sub-zones (Zone Index != 0) are ignored by the "Default" logic to prevent unwanted overwrites.
- **Empty Properties**: If a property (like Grade) is left empty in the script settings, the script will overwrite the existing beam grade with an empty value.

## FAQ
- **Q: The script disappeared after I ran it. Is that normal?**
  - A: Yes. This is a "command" script that performs a task and then self-destructs to clean up your drawing.
- **Q: The Material dropdown is empty or shows an error.**
  - A: Ensure `Materials.xml` exists in your `hsbCompany\Abbund` folder and contains valid data. You may need to run the `hsbMaterial` utility to generate this file.
- **Q: Why did some beams in my roof not update?**
  - A: Check if the beams are inside a specific "Zone" (Zone Index > 0). The script skips beams in zones for the default fallback logic. Also, verify that the beams have a rectangular profile if you expect the Category 9/10 logic to apply.
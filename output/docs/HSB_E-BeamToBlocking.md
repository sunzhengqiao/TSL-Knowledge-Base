# HSB_E-BeamToBlocking.mcr

## Overview
This script automatically splits long blocking beams into individual segments based on their intersections with structural members like rafters or studs. It applies clearance gaps at the ends of the new pieces and removes any resulting fragments that are too short to be usable.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D geometry processing. |
| Paper Space | No | Script operates on 3D model entities. |
| Shop Drawing | No | Not intended for 2D drawing generation. |

## Prerequisites
- **Required Entities**: An hsbCAD `Element` containing both the blocking beams to be split and the intersecting structural members (e.g., rafters, joists, or studs).
- **Minimum Beam Count**: At least one blocking beam and one intersecting structural member.
- **Required Settings**: `HSB_G-FilterGenBeams.xml` (Standard hsbCAD configuration file used to identify beam types).

## Usage Steps

### Step 1: Launch Script
```
Command Line: TSLINSERT
Action: Select HSB_E-BeamToBlocking.mcr from the file dialog and click Open.
```

### Step 2: Select Elements
```
Command Line: Select Elements:
Action: Click on the wall or roof Element(s) containing the blocking you wish to process. Press Enter to confirm selection.
```

### Step 3: Configure Properties (Optional)
```
Command Line: (Properties Palette opens automatically if no catalog key is preset)
Action: If the default BeamCode for your blocking or rafters is incorrect, change them in the AutoCAD Properties Palette.
```

### Step 4: Execution
```
Action: The script will automatically process the selected elements. It splits the blocking, applies gaps, and deletes short segments.
Note: This script acts as a generator; the script instance will erase itself after execution.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Blocking Code (sBmCodeBlocking) | String | KLO-01 | The BeamCode identifier for the long beams that need to be cut into blocking pieces. |
| Minimal Blocking Length (dMinimalBlockingLength) | Double | 100 | The shortest allowable length for a blocking piece (in mm). Pieces shorter than this are deleted. |
| Gap (dGap) | Double | 0 | The clearance distance (in mm) between the end of the blocking and the face of the intersecting rafter/stud. |
| Rafter Code (sBCRafter) | String | (Empty) | The BeamCode of the structural members (rafters/studs) that define where the blocking is cut. |
| Include/Exclude (sInclExcl) | Enum | Include | Determines if 'Rafter Code' is a whitelist (Include) or blacklist (Exclude). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Re-runs the script logic using the currently selected element and updated properties. |

## Settings Files
- **Filename**: `HSB_G-FilterGenBeams.xml`
- **Location**: Company or Install path (Standard hsbCAD directory)
- **Purpose**: Defines which beam types are treated as structural members (e.g., rafters, studs) to assist in filtering intersections.

## Tips
- **Gap vs. Length**: If you set a large `Gap`, ensure you increase your `Minimal Blocking Length`. The gap shortens the piece, potentially turning a valid piece into "scrap" that gets deleted.
- **Filtering**: If you want the blocking to split at *every* intersecting beam regardless of type, leave the `Rafter Code` empty and set `Include/Exclude` to "Exclude".
- **Selection**: Since this script processes by Element, ensure all relevant blocking and rafters are part of the same Element assembly.

## FAQ
- **Q: Why did some of my blocking disappear entirely?**
  **A:** The resulting segment was likely shorter than the `Minimal Blocking Length` (default 100mm) or was positioned too close to the end of an intersecting rafter. Try lowering the Minimal Blocking Length parameter.
- **Q: The script ran, but nothing happened.**
  **A:** Check your `Blocking Code` property. It likely does not match the BeamCode of the beams you selected in the model.
- **Q: Can I use this for both walls and roofs?**
  **A:** Yes, as long as the Element structure is valid and the intersecting beams are recognized by the system filters.
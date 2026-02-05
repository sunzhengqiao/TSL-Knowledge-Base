# HSB_T-IntegrateTimber

## Overview
Automates the creation of T-connection joinery by cutting slots (pockets) into "female" beams to accommodate intersecting "male" beams, including clearance gaps and optional assembly markings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D geometric operations and beam cutting. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required entities**: GenBeam (Timber beams).
- **Minimum beam count**: 2 (One "female" beam to be cut and one intersecting "male" beam).
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `HSB_T-IntegrateTimber.mcr` from the file list.

### Step 2: Insert Script
```
Command Line: Select insertion point or [Beam]:
Action: Click to place the script instance in the drawing, preferably on a beam within the Element you wish to process.
```
*Note: If the script is attached to a beam belonging to an Element, it processes only that Element. Otherwise, it attempts to process all beams in Model Space.*

### Step 3: Configure Properties
Action: Select the inserted script instance and open the **Properties** palette (Ctrl+1).
Action: Adjust the **Filter female beams** settings to target specific beams (e.g., by BeamCode or Material).
Action: Set the **Tool** dimensions (Depth, Gaps) according to your manufacturing requirements.
Action: The script automatically calculates intersections and applies cuts.

## Properties Panel Parameters

### Filter female beams
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Filter female beams with beamcode | Text | | Enter a BeamCode to only cut beams matching this code. |
| Filter female beams with label | Text | | Enter a Label to only cut beams matching this label. |
| Filter female beams with material | Text | | Enter a Material name to only cut beams matching this material. |
| Filter female beams with hsbID | Text | | Enter a specific hsbID to target a single beam. |

### Tool
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Depth | Number | 3 (unit dependent) | The depth of the pocket cut. |
| Minimum mill width | Number | 25 (unit dependent) | The smallest allowed width for the cut; prevents narrow slivers. |
| Gap width | Number | 1 (unit dependent) | Extra horizontal clearance added to the cut. |
| Gap length | Number | 200 (unit dependent) | Extra vertical clearance added to the cut. |
| Extra width for adjacent connections | Number | 0 (unit dependent) | Additional width added if another T-connection is detected nearby. |

### Marking
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Apply marking | Dropdown | Yes | Adds an assembly mark to the beam. Options: Yes, No. |
| Marking side | Dropdown | Inside | Determines which face receives the mark. Options: Inside, Outside. |

### Visualisation
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Symbol color | Number | 3 | Color index for the standard connection symbol. |
| Symbol color adjacent connections | Number | 72 | Color index for symbols when adjacent connections are detected. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Restore connection | Removes all cuts and markings created by this script and deletes the script instance from the drawing. |

## Settings Files
None required.

## Tips
- **Filtering is Key**: If the script cuts beams you don't intend to modify, use the **Filter female beams** properties (e.g., BeamCode) to restrict the operation to specific structural members.
- **Scope Control**: To process a specific wall or assembly, insert the script onto a beam *within* that Element. To process the entire model, insert it in empty space (Global mode).
- **Adjacent Connections**: If you have multiple T-joints close to each other along a beam, increase the **Extra width for adjacent connections** parameter to ensure the cuts merge or maintain adequate structural spacing.
- **Interference**: The script automatically checks for interference with other beams. If a cut affects a neighboring beam, the cut is applied to both.

## FAQ
- **Q: Why are no cuts appearing?**
  **A:** Check the "Filter female beams" section. If a filter is set (e.g., Material), ensure the target beams actually match that value. If filters are empty, ensure the beams are intersecting correctly in 3D space.
- **Q: Can I undo the cuts without deleting the script?**
  **A:** No, use the "Restore connection" right-click option. This removes the tooling. To re-run, you must re-insert the script or trigger a recalculation if the logic supports it (though "Restore" usually deletes the instance).
- **Q: The cut width is too small for my machinery.**
  **A:** Increase the **Minimum mill width** property. The script will automatically enlarge any calculated cuts that fall below this value.
# hsbStretchBeam2Entity.mcr

## Overview
This script automatically stretches or trims selected timber beams to precisely meet the face of bounding structural elements (such as other beams or trusses). It allows for a user-defined clearance gap to be maintained between the elements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model entities. |
| Paper Space | No | Not designed for 2D layout or detailing views. |
| Shop Drawing | No | Does not generate shop drawings or annotations. |

## Prerequisites
- **Required entities**: At least one beam to stretch and at least one bounding entity (Beam or TrussEntity).
- **Minimum beam count**: 1 beam to modify.
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT` → Select `hsbStretchBeam2Entity.mcr`

### Step 2: Configure Properties
**Action**: The Properties Dialog appears.
- **Gap**: Enter the desired distance (in current drawing units) to leave between the beam end and the bounding entity. A value of 0 creates a flush connection.
- Click **OK** or **Apply** to proceed.

### Step 3: Select Beams to Stretch
```
Command Line: Select beams to stretch
Action: Click on the beam(s) you want to modify (stretch/trim). Press Enter to confirm selection.
```

### Step 4: Select Bounding Entities
```
Command Line: Select bounding entities
Action: Click on the entity(ies) that define the limit for the stretch (e.g., a main supporting beam or truss). Press Enter to confirm.
```

### Step 5: Processing
**Action**: The script calculates intersections and applies the modifications.
- The script will automatically stretch/trim the selected beams to the calculated intersection points.
- The specified gap is applied.
- The script instance self-terminates, leaving only the modified geometry.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Gap | Double | 0 | Defines the clearance distance maintained between the end of the beam being stretched and the face of the bounding entity. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add persistent right-click context menu options. It is a "run-once" script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Direction matters**: The script calculates intersections along the beam's local X-axis (Left and Right directions). Ensure the beam is oriented correctly relative to where you want it to stretch.
- **Gap Usage**: Use the Gap property for insulation spacing or to account for construction tolerances.
- **Batch Processing**: You can select multiple beams to stretch in Step 3 and multiple bounding entities in Step 4. The script will process the combination efficiently.
- **Truss Support**: The script recognizes TrussEntities as valid boundaries, not just standard beams.

## FAQ
- **Q: Why didn't my beam stretch?**
  **A**: The script looks for intersections in the longitudinal direction of the beam. If the bounding entity is not directly in the path of the beam's extension, no cut will be made. Also, ensure the bounding entity was selected in the second step.
- **Q: Can I undo the changes?**
  **A**: Yes, since the script modifies the geometry directly, you can use the standard AutoCAD `UNDO` command to revert the changes.
- **Q: What happens if I set a Gap of 0?**
  **A**: The beam will be stretched or trimmed so that its end face exactly touches the face of the bounding entity (flush connection).
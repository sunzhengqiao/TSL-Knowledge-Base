# hsb_ReduceBlockingLength.mcr

## Overview
This script automatically shortens blocking and short frame beams within selected timber elements. It creates specific clearance gaps around adjacent structural members, such as studs, plates, or roof trusses.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the 3D model where the timber elements exist. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | This script modifies the physical 3D model geometry, not 2D drawings. |

## Prerequisites
- **Required Entities**: An existing Element (Wall or Floor) containing Beams.
- **Beam Types**: The element must contain beams classified as "Blocking" (`_kBlocking`) or "ShortFrame" (`_kSFBlocking`).
- **Minimum Beam Count**: At least one blocking beam must be present in the selection.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `hsb_ReduceBlockingLength.mcr`.

### Step 2: Configure Properties
Action: Upon insertion, a "Properties" dialog will appear automatically.
- Set the **Gap to beams** (standard timber members).
- Set the **Gap to truss entities** (truss chords/webs).
- Click OK to confirm.

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the timber elements (walls/floors) containing the blocking you wish to modify. You can select multiple elements at once using a window selection.
```

### Step 4: Processing
Action: Press **Enter** to confirm the selection. The script will process the elements, cut the blocking beams to the calculated lengths, and then automatically remove itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Gap to beams | Number | U(1) | The clearance distance maintained between the blocking beam and intersecting standard timber members (studs, plates). |
| Gap to truss entities | Number | U(1) | The clearance distance maintained between the blocking beam and intersecting truss components (chords, webs). |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| None | This is a command script that erases itself after execution. It does not remain in the model for right-click interactions. |

## Settings Files
No specific external settings files are required for this script.

## Tips
- **Unit Awareness**: The default value `U(1)` refers to 1 current drawing unit (usually 1 mm). Ensure you input values consistent with your project's unit settings.
- **Truss Support**: This script recognizes Truss Entities separately from standard beams, allowing you to apply a larger gap for trusses if necessary.
- **Beam Orientation**: The script calculates gaps based on the blocking's principal X-axis. Ensure your blocking beams are modeled correctly relative to the element.
- **Batch Processing**: You can select multiple elements (e.g., an entire floor plan) in one go to process all blocking simultaneously.

## FAQ
- **Q: The script ran, but the blocking lengths didn't change.**
  A: Ensure the beams you are trying to modify are defined as type "Blocking" or "ShortFrame" in the element catalog. Standard studs or joists will be ignored.
- **Q: Why are my blocking beams shorter than expected?**
  A: Check both "Gap to beams" and "Gap to truss entities" properties. If the blocking intersects with both a stud and a truss chord, the script applies the respective gap for each intersection.
- **Q: Can I undo the changes?**
  A: Yes, use the standard AutoCAD `UNDO` command immediately after running the script if the results are not as desired.
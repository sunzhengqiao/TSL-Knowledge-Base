# hsbStellbrettnut

## Overview
This script automates the creation of a T-connection joinery (mortise and tenon) between two timber beams. It generates a slot in the main beam and a tenon trim on the inserting beam, allowing for adjustable connections such as shelf supports or joist hangers.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D beam geometry modification. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: 2 GenBeams (one inserting beam, one main carrying beam).
- **Minimum Beam Count**: 2
- **Required Settings**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbStellbrettnut.mcr`

### Step 2: Select Beams
```
Command Line: Select the inserting beam (Beam 0):
Action: Click on the beam that will insert into the other (the tenon side).

Command Line: Select the main beam (Beam 1):
Action: Click on the beam that will receive the groove (the mortise side).
```

### Step 3: Configure Parameters
```
Action: Select the script instance and open the Properties Palette (Ctrl+1).
Adjust the Depth, Gap Depth, and Gap Side as needed.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Depth | Number | 5 mm | Determines how deep the tenon inserts into the main beam. (Tenon Length). |
| Gap Depth | Number | 5 mm | Extra space at the bottom of the groove to prevent bottoming out (Back Clearance). |
| Gap Side | Number | 2 mm | Horizontal clearance added to the groove width for easier assembly (Side Clearance). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No specific custom context menu items are defined for this script. Standard options (Delete, Properties) apply. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Dynamic Stretch Mode**: If you set both **Depth** and **Gap Depth** to `0` or negative values, the script will switch to "Dynamic Stretch" mode. It will delete the machining and instead create a stretch relation between the two beams.
- **Infinite Slot**: The groove cut into the main beam (Beam 1) is infinite in length. You can slide the inserting beam (Beam 0) along the main beam, and the connection will update automatically.
- **Adjustable Fit**: If the timber is swelling or requires loose fit, increase the **Gap Side** value.

## FAQ
- **Q: What happens if I set the Depth to 0?**
  - A: The script detects this value, deletes itself, and converts the connection into a dynamic stretch constraint instead of cutting wood.
- **Q: Why did my groove disappear?**
  - A: This usually happens if the geometry validation fails. Check that the beams are intersecting correctly and try re-inserting the script.
- **Q: Can I use this for curved beams?**
  - A: While the script works on beam geometry, extreme curvature might cause validation errors if the cutting body cannot be calculated. It is best suited for straight or standard arched beams.
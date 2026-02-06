# hsbT-HalfCutMarking.mcr

## Overview
This script automatically creates half-cut notches at T-connections between two beams (e.g., purlins resting on a main beam or wall). It can be applied to selected elements or individual beams to generate joinery details and markings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in 3D model space. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Not applicable for 2D drawings. |

## Prerequisites
- **Required Entities**: Two intersecting beams forming a T-connection (a Male beam crossing a Female beam).
- **Minimum Beam Count**: 2 (one crossing, one supporting).
- **Required Settings Files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbT-HalfCutMarking.mcr` from the list.

### Step 2: Configure Properties
A properties dialog will appear (unless run in silent mode via catalog entry). Adjust settings like depth and alignment here.
- **Action**: Set your desired options (e.g., Depth, Side) and click OK.

### Step 3: Select Beams or Elements
```
Command Line: Select elements and/or beams
Action: Click to select the beams or elements containing the T-connections you want to process. Press Enter to confirm.
```

### Step 4: Generation
The script scans the selection, finds valid intersections, and creates the half-cut instances. The temporary insertion instance is removed, and the tooling is applied to the specific beams found.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| (A) Side | dropdown | Contact face | Determines which face of the beam receives the notch (e.g., Top/Z-axis, Bottom/-Z-axis, or the face touching the other beam). |
| (B) Alignment | dropdown | Left | Sets the lateral placement of the notch: Left, Right, or Both sides of the connection center. |
| (C) Depth | number | 4.0 mm | Specifies how deep the half-cut notch goes into the beam material. |
| (D) Gap | number | 0.0 mm | Defines the tolerance for beam spacing. Use 0 for touching beams. Use a positive value for non-touching beams. Use a **negative value** to cut a recess/pocket into the female (supporting) beam. |
| (E) Contact | dropdown | No | If set to "Yes", the script physically stretches the male beam to touch the female beam and adds a planar cut. |
| (F) Position | dropdown | Outside | Defines whether the notch cuts towards the outside or inside of the T-connection angle. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Side | Swaps the Side property (e.g., from Top to Bottom) and recalculates the cut. This can also be triggered by double-clicking the TSL instance. |

## Settings Files
None required.

## Tips
- **Negative Gap for Pockets**: If you need the supporting beam to have a pocket (recess) for the crossing beam to sit in, enter a negative value for the **Gap** parameter (e.g., -10mm).
- **Batch Processing**: You can select an entire Element (wall/floor) to process all internal purlin connections at once.
- **Dynamic Updates**: If you move the beams using AutoCAD grips or move commands, the TSL will detect the movement and automatically recalculate the cut positions.
- **Both Sides**: Use the **Alignment** "Both" option if you need to create two distinct notches on the beam relative to the connection point.

## FAQ
- **Q: Why did the script disappear immediately after I selected the beams?**
  A: The script likely found duplicate instances already assigned to those beams or detected invalid geometry. Check that the beams actually form a T-connection and are not just crossing in the same plane.
  
- **Q: How do I cut a slot into the main beam instead of just notching the purlin?**
  A: Change the **Gap** property to a negative number. This tells the script to cut into the female (supporting) beam.

- **Q: Can I change the notch from the top face to the bottom face without deleting the script?**
  A: Yes. Select the script instance (or the beam), open the Properties palette, change the **Side** parameter, or simply double-click the script to trigger the "Flip Side" command.
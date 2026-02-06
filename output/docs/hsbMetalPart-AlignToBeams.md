# hsbMetalPart-AlignToBeams

## Overview
Automatically aligns and rotates child components (such as metal plates or brackets) within a parent assembly to match the exact orientation of selected structural beams based on their geometric overlap.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model entities (MassGroups and Beams). |
| Paper Space | No | Not designed for 2D drawings or layout views. |
| Shop Drawing | No | Does not generate shop drawing details. |

## Prerequisites
- **Parent Entity**: A parent MassGroup must exist in the model.
- **Child Components**: Child MassGroups containing the parts to be aligned must exist inside the parent MassGroup.
- **Reference Markers**: Child MassGroups must contain an `EcsMarker` to define their local coordinate system.
- **Target Beams**: At least one structural Beam must be available in the model to serve as the alignment target.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse to and select `hsbMetalPart-AlignToBeams.mcr`.

### Step 2: Insert into Parent Group
Action: Select the parent MassGroup in the model that contains the metal parts or sub-assemblies you wish to align.
*Note: The script must be inserted as a child of the main assembly group.*

### Step 3: Select Target Beams
```
Command Line: |Select Beam(s)|
Action: Click on the structural beams that define the correct orientation/slope for your parts.
```
*Note: You can select multiple beams. The script will calculate which beam best fits each part based on surface area overlap.*

### Step 4: Automatic Alignment
Action: The script automatically adjusts the position and rotation of the child MassGroups.
*Note: If a child part overlaps significantly with a selected beam, it will snap to that beam's coordinate system.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Pt0 | Point | Center of Parent Group | Defines the reference origin point. Modifying this point (e.g., moving it slightly) forces the script to re-calculate and re-align all parts to the beams. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are added by this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not use external settings files.

## Tips
- **Conflict Resolution**: If two metal parts overlap the same beam, the script will prioritize the part with the larger surface area. The part with the smaller overlap may not move.
- **Updating Alignment**: If you modify the beams or the parent group geometry, manually change the `Pt0` property in the Properties Palette to trigger an update of the alignment.
- **EcsMarker**: Ensure your metal part sub-assemblies include an EcsMarker. Without this marker, the script cannot determine how to orient the part.
- **Validation**: If the script disappears immediately after insertion, check that you selected at least one beam and that the parent MassGroup is valid.

## FAQ
- **Q: Why did the script delete itself after I ran it?**
  A: This usually happens if no beams were selected during the prompt, or if the script was not inserted into a valid parent MassGroup. Re-insert the script and ensure you make a valid selection.

- **Q: Some of my parts did not move. Why?**
  A: A part will only align if it has geometric overlap with a selected beam. Ensure the part is physically intersecting or touching the target beam. Also, verify the child part contains an EcsMarker.

- **Q: How do I undo the alignment?**
  A: Use the standard AutoCAD `UNDO` command to revert the script execution.
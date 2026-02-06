# hsbMetalPart-LinkDummyTools.mcr

## Overview
This script transfers machining details (such as holes, slots, and cuts) from a selected metal part dummy to selected timber beams. It effectively prepares the timber geometry to receive the specific hardware defined by the metal part.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model to modify beam geometry. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This script is used for design/ detailing, not shop drawing generation. |

## Prerequisites
- **Required Entities**: At least one `GenBeam` (Timber Beam) and at least one `MassGroup` (Metal Part).
- **Minimum Beam Count**: 1
- **Required Settings**: None

## Usage Steps

### Step 1: Launch Script
```
Command: TSLINSERT
Action: Select 'hsbMetalPart-LinkDummyTools.mcr' from the file dialog.
```

### Step 2: Select Timber Beams
```
Command Line: Select GenBeam(s)
Action: Click on the timber beam(s) you wish to modify. Press Enter to confirm selection.
```

### Step 3: Select Metal Part
```
Command Line: Select Metalpart(s)
Action: Click on the MassGroup (Metal Part dummy) that contains the desired tool geometry (holes/cuts). Press Enter.
```
*Note: The script will create a link between the selected beams and the metal part. The tools defined in the metal part are now applied to the beams.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| AddCut | dropdown | No | Defines whether simple planar cuts found on the metal part are transferred to the timber beam. Select "Yes" to include cuts, "No" to ignore them. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | Standard hsbCAD context options apply. |

## Settings Files
- None required for this script.

## Tips
- **Toggle Cuts Dynamically**: You can turn planar cuts on or off after insertion without running the script again. Select the script instance and change the **AddCut** property in the Properties Palette (Ctrl+1).
- **Auto-Update**: If you move or rotate the Metal Part, the machining on the linked timber beams will automatically update to match the new position.
- **BeamCut Logic**: For "BeamCut" tools, the script automatically calculates the intersection. It ensures the cut is applied correctly by enlarging the tool geometry in "free" directions to fully penetrate the beam.

## FAQ
- **Q: Why did the script disappear immediately after I selected the metal part?**
  - A: This usually happens if no valid MassGroup was found or if no GenBeams were selected. Ensure you select a valid metal part entity and at least one timber beam.
  
- **Q: What types of machining are transferred?**
  - A: The script transfers Drills, Slots, Houses, Mortises, and BeamCuts. Simple Cuts are only transferred if the `AddCut` property is set to "Yes".
  
- **Q: Can I use this on multiple beams at once?**
  - A: Yes, you can select multiple timber beams in Step 2. The script will apply the metal part tools to all selected beams.
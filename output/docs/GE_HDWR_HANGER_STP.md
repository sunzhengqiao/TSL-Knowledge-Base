# GE_HDWR_HANGER_STP.mcr

## Overview
Inserts an STP family metal joist hanger into the 3D model to support timber beams. The script allows placement either attached to specific structural beams or floating freely in space at a defined location and rotation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Generates 3D metal part bodies. |
| Paper Space | No | Not applicable for 2D drawings. |
| Shop Drawing | No | This is a model detailing script. |

## Prerequisites
- **Required Entities**: GenBeam (optional, only required if attaching to timber).
- **Minimum Beam Count**: 0 (Supports floating insertion).
- **Required Settings Files**:
  - `TSL_Read_Metalpart_Family_Props.dll` (Required for the selection dialog).
  - `TSL_HARDWARE_FAMILY_LIST.dxx` (Catalog database located in `_kPathHsbCompany\TSL\Catalog\`).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_HDWR_HANGER_STP.mcr`

### Step 2: Select Hanger Type
```
Dialog Window: [Metalpart Selection]
Action: Search or browse the list for the desired STP hanger model. 
Click OK to confirm selection.
```
*Note: If you cancel this dialog, the script will exit without creating an object.*

### Step 3: Select Placement Method
```
Command Line: Select members or hit enter to insert at specific location
Action: 
Option A: Select one or more timber beams (GenBeams) and press Enter.
Option B: Press Enter without selecting anything to place the hanger freely in space.
```

### Step 4a: Define Location (Free Insertion)
*Only appears if you pressed Enter in Step 3.*
```
Command Line: Select insertion point
Action: Click in the 3D model to place the base of the hanger.

Command Line: Select reference point: direction of hanger
Action: Click a second point to define the rotation/alignment of the hanger.
```

### Step 4b: Define Reference (Beam Attachment)
*Only appears if you selected beams in Step 3.*
```
Command Line: Select reference point: hangers will be inserted at closest end of members
Action: Click anywhere in the model. The hanger will automatically snap to the end of the selected beam that is closest to your click.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | Text | "" | The specific catalog code of the hanger (e.g., 'STP200/100'). Changing this reloads dimensions from the database. |
| Overall depth | Number | 0 | The longitudinal length of the hanger base plate (parallel to the beam). |
| Clear width | Number | 0 | The internal width between the side plates. Must be larger than the timber beam width. |
| Overall height | Number | 0 | The vertical height of the side plates. |
| Flange width | Number | 1 | The width of the horizontal return/flange at the top of the plates. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Change type | Opens the hardware catalog dialog again, allowing you to swap the current hanger for a different model/size. |
| Help | Displays a message box with instructions on using the STP Family hanger script. |

## Settings Files
- **Filename**: `TSL_HARDWARE_FAMILY_LIST.dxx`
- **Location**: `\\Utilities\\TslCustomSettings\\` or `TSL\\Catalog\\`
- **Purpose**: Defines the list of available STP hardware types and their associated dimensions (Depth, Width, Height) used by the selection dialog.

## Tips
- **Automatic Deletion**: If you attach a hanger to a beam that is wider than the hanger's "Clear width," the hanger will automatically delete itself to prevent geometric errors. Select a larger type using "Change type."
- **Grip Editing**: 
  - In **Free mode**, use the two grips to move the hanger or rotate it by moving the direction grip.
  - In **Attached mode**, moving the single grip will slide the hanger to the nearest end of the beam.
- **Batch Insert**: You can select multiple beams in Step 3 to insert a hanger on each beam simultaneously.

## FAQ
- **Q: Why did my hanger disappear immediately after insertion?**
  - **A**: This usually happens if the Clear Width of the hanger is too small for the beam you selected. The script deletes the hanger if it detects a size mismatch. Use the "Change type" context menu to select a wider hanger.
  
- **Q: Can I rotate the hanger after inserting it on a beam?**
  - **A**: When attached to a beam, the hanger aligns automatically to the beam's axis. You cannot freely rotate it, but moving the grip will snap it to the opposite end of the beam. For free rotation, use the "Free Insert" method (hitting Enter at the beam selection prompt).
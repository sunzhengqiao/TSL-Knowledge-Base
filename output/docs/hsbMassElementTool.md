# hsbMassElementTool

## Overview
This script generates machining tools (Drills, Slots, and BeamCuts) on timber beams by using MassElements (Cylinders or Boxes) as 3D geometric templates. It automates the creation of connections based on the size and position of the selected MassElements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for selecting 3D beams and MassElements. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: `GenBeam` (Timber beams) and `MassElement` (Cylinders or Boxes).
- **Minimum Beam Count**: 
  - 1 Beam for **E-Type** connections.
  - 2 Beams (1 Male, 1 Female) for **T-Type** connections.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbMassElementTool.mcr`

### Step 2: Define Connection Type
```
Dialog Box: Select Connection Type
Action: Choose E-Type, T-Type, or O-Type and click OK.
```
- **E-Type**: Single beam connection (End connection).
- **T-Type**: Intersection connection (Male/Female beams).
- **O-Type**: Other (Manual selection).

### Step 3: Select Beams
```
Command Line: Select Beams <Select entities>:
Action: Click the beam(s) to be machined.
```
- *If E-Type*: Select the primary beam(s).
- *If T-Type*: Select the **Male beam** first, then the **Female beam(s)**.
- *If O-Type*: This step is skipped initially.

### Step 4: Select MassElements
```
Command Line: Select MassElements <Select entities>:
Action: Select the Cylinders (for drills) or Boxes (for cuts/slots) that define the tool geometry.
```
*Note: You can select multiple MassElements.*

### Step 5: Assign Target Beam (if applicable)
```
Command Line: Select Beam to apply MassElements to:
Action: Click the specific beam where the selected MassElements should create tools.
```
*Note: This step repeats if you selected multiple MassElements in Step 4.*

### Step 6: Define Depth
```
Command Line: Enter Depth <0>:
Action: Enter a value in mm or press Enter for 0.
```
- **0**: Creates a through-hole/cut (penetrates the entire beam).
- **>0**: Creates a blind hole/cut to the specified depth.

### Step 7: Set Reference Point (T-Type Only)
```
Command Line: Select point on stretching plane:
Action: Click a point in 3D space to define where the Male beam should be cut.
```
*Note: This step is skipped for E-Type and O-Type connections.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Connection Type** | Dropdown | E-Type | Defines the structural behavior. E-Type (Single), T-Type (Male/Female with auto-trim), or O-Type (Manual). |
| **Tool Type** | Dropdown | Drill | Specifies the machining operation. Options: Drill, BeamCut, Slot. (Limited by MassElement shape). |
| **Depth (dD)** | Number | 0 | The depth of the tool in millimeters. A value of 0 indicates a through operation. |
| **Pt0 (Ref Point)** | Coordinate | Calculated | Reference point for alignment. In T-Type, this determines the intersection plane location. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Add/Remove Drills** | Prompts you to select Cylindrical MassElements. Adds them as Drills if new, or removes them if they already exist. |
| **Add/Remove Beamcut** | Prompts you to select Box MassElements. Adds/Removes volumetric cuts based on the Box dimensions. |
| **Add/Remove Slot** | Prompts you to select a Box MassElement. Adds/Removes a Slot tool and allows depth adjustment. |
| **Add/Remove Alignment Dependency** | Links selected MassElements to a specific beam. The MassElements will move/rotate automatically if the beam is modified. |

## Settings Files
- **Filename**: N/A
- **Location**: N/A
- **Purpose**: This script relies on direct user input and standard entity properties rather than external settings files.

## Tips
- **Through Holes**: Always enter `0` for depth if you want the tool to cut completely through the beam cross-section.
- **Shape Matters**: Use **Cylinders** for Drills and **Boxes** for Slots or BeamCuts. The script restricts tools based on shape.
- **T-Type Auto-Trim**: In T-Type connections, the script automatically calculates and applies a cut to the Male beam to fit against the Female beam. Ensure the Reference Point (Step 7) is picked accurately on the intersection face.
- **Dynamic Updates**: Use the "Add Alignment Dependency" right-click option if you expect the beams to move. This keeps the MassElements (and thus the tools) attached to the beams during updates.

## FAQ
- **Q: Why can't I select a "Slot" tool when using a Cylinder?**
  - **A:** Slots are only compatible with Box-shaped MassElements. Cylinders are strictly used for Drills.
- **Q: What happens if I enter a depth greater than the beam size?**
  - **A:** The tool will generate a blind hole/cut. It will not continue through the other side of the beam unless the depth is 0.
- **Q: How do I fix a tool if I moved the MassElement by mistake?**
  - **A:** Simply use the standard AutoCAD **Move** or **Rotate** commands on the MassElement. The script will recalculate and update the tool position automatically when you regenerate the drawing.
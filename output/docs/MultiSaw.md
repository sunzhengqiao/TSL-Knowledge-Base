# MultiSaw.mcr

## Overview
Generates a multi-blade saw spindle tool to create multiple parallel cuts or slots (dados) across selected timber beams simultaneously. It is typically used for machining slots for floor joists, roof battens, or shelf supports.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for selecting beams and applying 3D solid tooling. |
| Paper Space | No | Script operates on 3D GenBeam entities only. |
| Shop Drawing | No | This is a manufacturing/modeling script, not a detailing script. |

## Prerequisites
- **Required Entities**: At least one `GenBeam`.
- **Minimum Beam Count**: 1.
- **Required Settings**: None strictly required to run, though an XML file is used to save/load configurations.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `MultiSaw.mcr`

### Step 2: Select Beams
Action: Select the timber beam(s) you wish to cut. Press **Enter** to confirm selection.

### Step 3: Select Face and Start Point
```
Command Line: Select first point [Lengthwise/Crosswise/Align/FlipSide]
Action: Click on the face of the beam where you want the cuts to start.
```
*Note: The script highlights the face under your cursor. This determines the "Face" normal (Top, Bottom, Left, Right).*

### Step 4: Define Cut Direction
You have several options to define how the saw cuts run across the beam:

*   **Option A (Keywords)**: Type `Lengthwise` or `Crosswise` and press **Enter**. The direction will be calculated automatically relative to the beam axis.
*   **Option B (Custom Align)**: Type `Align` and press **Enter**, then click a second point to define a custom direction vector.
*   **Option C (Drag)**: Simply move your mouse to visually drag the direction of the cut, then click to lock it in.

### Step 5: Confirm and Apply
Action: Press **Enter** or **Space** to confirm the placement. The script will generate the tooling geometry and apply the cuts to all valid, coplanar beams selected in Step 2.

## Configuration Parameters
*Note: This script does not expose parameters directly in the AutoCAD Properties Palette (OPM). These values are controlled via the Import/Export Settings functionality or internal script defaults.*

| Parameter | Default | Description |
|-----------|---------|-------------|
| Direction (`vecDir`) | Beam X-Axis | The direction the cuts run across the beam surface. |
| Tool Width (`toolWidth`) | Map Value | The thickness (kerf) of a single saw blade (e.g., 4mm). |
| Tool Radius (`toolRadius`) | Map Value | The radius of the saw blade, creating rounded corners in the slot. |
| Depth (`depth`) | Map Value | The depth of the cut into the timber material. |
| Distances (`Distances[]`) | Map Value Array | The spacing between the centers of adjacent saw blades. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Select X-Alignment | Resets the cut direction to align with the Global X-axis. |
| Select Y-Alignment | Resets the cut direction to align with the Global Y-axis. |
| Revert Direction | Flips the current cut direction 180 degrees (multiplies vector by -1). |
| Import Settings | Loads a saved configuration (Width, Depth, Radius, Spacing) from an XML file. |
| Export Settings | Saves the current configuration to an XML file for future use. |

## Settings Files
- **Filename**: Variable (Defined by `sFullPath` within the script).
- **Location**: Typically a company standard folder or project directory.
- **Purpose**: Stores tool configuration data such as blade thickness, radius, depth, and spacing arrays. This allows you to reuse standard setups (e.g., a specific joist spacing pattern) without re-entering values.

## Tips
- **Multiple Beams**: You can select multiple beams at the start. The script automatically filters out beams that are not coplanar (on the same plane) as the face you clicked on, preventing errors.
- **Corner Geometry**: If you see sharp 90-degree corners instead of rounded ones, check your `ToolRadius` and `Offset` settings; the script creates rounded profiles only when these values are greater than zero.
- **Visual Feedback**: During insertion, use the `FlipSide` keyword if you initially clicked the wrong face (e.g., clicking the bottom when you meant to cut the top).

## FAQ
- **Q: Why did the tool cut one beam but skip another?**
  **A**: The skipped beam likely does not share the exact same face plane as the insertion point. The script only applies tools to coplanar faces.
- **Q: How do I change the spacing between the cuts?**
  **A**: This is defined in the `Distances` array. The easiest way to change this is to "Export Settings" to an XML file, edit the distances in that file (or have a pre-made file), and then use "Import Settings" via the Right-Click menu.
- **Q: What is the difference between "Align" and just picking points?**
  **A**: "Align" explicitly switches to a mode where you pick two points to define a vector. Simply picking points without the keyword defaults to the visual drag behavior, which may interpret the input differently depending on your view direction.
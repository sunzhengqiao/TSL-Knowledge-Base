# hsbCLT-JointBoard

## Overview
This script manages the connection between CLT (Cross Laminated Timber) panels, allowing for dimensional gaps, alignment adjustments, and the conversion of the connection geometry into structural beams (joint boards) for manufacturing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D panel modeling and beam generation. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | This is a detailing/modeling script only. |

## Prerequisites
- **Required Entities**: CLT Panels (Elements).
- **Minimum Beam Count**: 0 (The script creates new beams; existing beams are not required to run).
- **Required Settings**: None required to run, but an XML configuration file can be used for presets.

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT` → Select `hsbCLT-JointBoard.mcr`

### Step 2: Select Panels and Define Location
The script behaves differently depending on how many panels you select initially.

**Option A: Single Panel**
```
Command Line: Select element
Action: Click on a single CLT panel.
```
```
Command Line: Define split line / [Select edge]
Action: Pick two points to draw a split line across the panel OR select an existing edge.
```
*Result:* The panel is split if a line was drawn, and the tool is assigned to the new edge. If an edge was selected, the tool is assigned directly to that edge.

**Option B: Multiple Panels**
```
Command Line: Select elements
Action: Select multiple panels. **Important:** Select the reference panel (the one you want to modify) first.
```
```
Command Line: Select point near edge
Action: Click near the edge where the reference panel meets the adjacent panel.
```
*Result:* The tool is assigned to the reference panel and linked to the adjacent panel.

### Step 3: Adjust Geometry
Once placed, a blue preview of the joint board appears.
- **Properties Palette:** Change `Gap Panel` to set the distance between elements.
- **Properties Palette:** Change `Alignment` to shift the joint board (e.g., Center, Left, or flush with specific sides).

### Step 4: Create Physical Beams
```
Action: Right-click the script instance → "Create beams"
```
*Result:* The preview geometry is converted into physical GenBeam entities assigned to the specified Group Name.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Gap Panel | Double | 0.0 mm | The distance maintained between the connected panels (construction tolerance or expansion gap). |
| GroupName | String | JointBoard | The group name assigned to the generated beams for organization in the model tree. |
| Alignment | Enum | Left | Lateral position of the joint board relative to the panels. Options include Reference Side, Center, Opposite Side, Higher Quality, or Lower Quality. |
| GripModeCreation | Boolean | false | If enabled, creates interactive "grips" (handles) on the joint for graphical editing. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Create beams | Converts the current preview geometry into physical structural beams (GenBeams). Running this again deletes previous beams and regenerates them. |
| GroupName | Opens a dialog to quickly change the group name assigned to the generated beams. |
| Grip Mode Creation on/off | Toggles the visibility of graphical handles (grips) for resizing the joint board. |
| Import Settings | Loads configuration parameters (Gap, Alignment, etc.) from the standard XML file. |
| Export Settings | Saves the current configuration parameters to the standard XML file for future use. |

## Settings Files
- **Filename**: `hsbCLT-JointBoard.xml`
- **Location**: `hsbInstall\Company\`
- **Purpose**: Stores and retrieves presets for the script (Gap size, Alignment, GroupName) to ensure consistency across projects or users.

## Tips
- **Reference Selection:** When joining multiple panels, always select the "main" or "reference" panel first. The script uses the selection order to determine which panel holds the instance.
- **Splitting:** You can use this script to split a panel and immediately apply a joint treatment in one operation by drawing a split line during insertion.
- **Visual Checks:** Use the `Gap Panel` parameter to visually verify spacing before converting the preview into physical beams.
- **Batching:** Use the `GroupName` parameter to filter all generated joint boards in the model tree for exporting or numbering.

## FAQ
- **Q: Can I change the joint size after creating the beams?**
  **A:** No, once "Create beams" is executed, the geometry becomes standard GenBeams. To change dimensions, edit the TSL instance properties and run "Create beams" again (this will delete and replace the old beams).
- **Q: What happens if I select the wrong panel first?**
  **A:** The script will attach to the wrong element. Delete the instance and re-insert, ensuring the correct panel is selected first.
- **Q: How do I share my settings with a colleague?**
  **A:** Right-click the instance and select "Export Settings". Send the generated XML file (located in your Company folder) to your colleague, who can then use "Import Settings".
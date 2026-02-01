# HSB_E-ElementDrill.mcr

## Overview
This script creates cylindrical drill holes (machining operations) within a specific structural layer (zone) of an Element (wall or floor). It allows you to drill partially through an element assembly, such as for ventilation or conduits, without penetrating the entire thickness.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be inserted in the 3D model. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | Not a shop drawing generation script. |

## Prerequisites
- **Required Entities**: An existing hsbCAD Element (e.g., a wall or floor panel).
- **Minimum Beam Count**: 0.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Execute the command `TSLINSERT` (or your mapped shortcut) and select `HSB_E-ElementDrill.mcr` from the file list.

### Step 2: Configure Parameters
A dialog or property prompt will appear upon insertion.
- Set the **Zone Index** to determine which layer to drill.
- Set the **Drill Diameter** and **Drill Depth** as required.
- Click OK or confirm the values to proceed.

### Step 3: Select Element
```
Command Line: Select an element
Action: Click on the desired Element (wall/floor) in the model where the drill should be applied.
```

### Step 4: Select Drill Position
```
Command Line: Select position
Action: Click on the face of the element where the hole should start.
```

### Step 5: Select Additional Points (Optional)
```
Command Line: Select next point
Action: Click additional locations to add more holes with the same properties.
```
- Repeat this step for all required holes.
- **Press Enter or Esc** to finish the command and generate the drill operations.

## Properties Panel Parameters
These parameters can be edited via the AutoCAD Properties Palette (Ctrl+1) after selecting the script instance.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Zone index** | Dropdown | 0 | Selects the material layer to drill. <br>• **1-5**: Zones 1 to 5 starting from the Primary side.<br>• **6-10**: Zones 5 to 1 starting from the Secondary side (Back side). |
| **Drill diameter** | Number | 10 mm | The diameter of the hole to be drilled. |
| **Drill depth** | Number | 0 mm | The depth of the drill. <br>• **0**: Drills completely through the selected zone (automatic).<br>• **>0**: Drills to the specific depth entered. |
| **Tool index** | Number | 0 | The tool number assigned for CNC export. |

## Right-Click Menu Options
This script does not add specific custom commands to the right-click context menu. Standard hsbCAD context options apply.

## Settings Files
No specific external settings files (XML) are required for this script.

## Tips
- **Drilling Through Zones**: If you want the drill to stop exactly at the boundary of the current layer, keep the **Drill depth** set to `0`.
- **Direction Control**: Pay attention to the **Zone index**. If you select index `6`, it drills into Zone 5 starting from the *back* of the element. Ensure you are viewing the correct side when selecting the insertion point.
- **Moving Drills**: After insertion, you can select the drill instance and use the grip point to move the hole to a new location on the element surface.

## FAQ
- **Q: How do I drill through the entire element?**
  **A:** This script is designed for specific zones. To drill through the whole element, you may need to use a standard drill operation or ensure the element consists of a single zone, or calculate the depth manually.
- **Q: My drill is going the wrong way (backwards).**
  **A:** Check your **Zone index**. If you need to drill from the back side, use indices 6-10. If you need to drill from the front side, use indices 1-5.
- **Q: Can I change the drill size after inserting?**
  **A:** Yes. Select the script instance in the model, open the Properties Palette (Ctrl+1), and modify the **Drill diameter** or other parameters. The element will update automatically.
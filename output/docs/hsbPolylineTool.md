# hsbPolylineTool

## Overview
This script applies complex tooling operations (such as rectangular beamcuts, finger milling, or universal milling) to structural beams or panels. It uses a selected polyline or manually picked points to define the path of the cut.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D geometry generation. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: At least one `GenBeam` (Beam) or `Sip` (Panel) must exist in the model.
- **Minimum Beam Count**: 1.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbPolylineTool.mcr` from the catalog.

### Step 2: Select Beams/Panels
```
Command Line: Select beam(s) or panel(s)
Action: Click on the beams or panels you want to machine. Press Enter to confirm selection.
```

### Step 3: Define Tool Path
```
Command Line: Select polyline(s) (<Enter> to pick points)
Action:
- Option A: Click on an existing polyline in the drawing to use it as the tool path.
- Option B: Press Enter to switch to point mode.
```

### Step 3b: Manual Point Entry (If Option B selected)
```
Command Line: Pick start point
Action: Click the location where the cut should begin.
```
```
Command Line: Select next point
Action: Click subsequent points to draw the path. Press Enter to finish drawing.
```

### Step 4: Configure Properties
After insertion, select the script instance and open the **Properties Palette** (Ctrl+1) to adjust the Depth, Width, Tool Type, and Alignment.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Alignment | Dropdown | Reference Side | Determines if the tool aligns to the Reference Side or Opposite Side of the beam's coordinate system. |
| Side | Dropdown | Left | Offsets the tool to the Left, Right, or Center relative to the polyline path. |
| Depth | Number | 20 | The depth of the cut or mill profile into the material (mm). |
| Width | Number | 30 | The width of the tool or the diameter of the milling cut (mm). |
| Tool | Dropdown | Beamcut | Selects the machining operation: Beamcut (standard slot), Finger Mill, Universal Mill, or Vertical Finger Mill. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Alignment | Toggles the alignment reference and flips the side direction (e.g., Left becomes Right), effectively mirroring the cut. |
| Add entities | Prompts you to select additional beams or panels to apply the current tooling to. |
| Remove entities | Prompts you to select beams or panels to remove from the tooling operation. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script uses the Properties Palette for configuration; no external settings file is required.

## Tips
- **Double-Click**: Double-clicking the script instance in the model triggers the "Flip Alignment" command, allowing you to quickly mirror the cut.
- **Dynamic Editing**: If you selected an existing polyline in Step 3, you can use AutoCAD grips to move or reshape the polyline. The tool path will update automatically.
- **Tool Visualization**: The tool type is visualized; ensure your Width setting matches the physical diameter of the tool you intend to use in production.

## FAQ
- **Q: Why did the script disappear after I ran it?**
  A: The script requires at least one beam or panel to be selected in Step 2. If no valid element is selected, the instance will erase itself automatically.
- **Q: Can I use this on sheets?**
  A: No, this tool is specifically designed for beams (GenBeam) and panels (Sip) and is not available for sheets.
- **Q: How do I create a curved path?**
  A: In Step 3, select an existing polyline that contains arcs (a "Polyline" entity, not a "Line" entity). Manual point picking creates linear segments only.
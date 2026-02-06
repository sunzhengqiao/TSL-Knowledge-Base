# hsbCLT-EdgeTool

## Overview
Adds various machining operations (such as cuts, rabbets, mortises, and drill holes) to the edges of Cross Laminated Timber (CLT) panels. It supports standard shapes, custom profiles, and automated drill patterns based on user selection.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates on 3D panel entities in the model. |
| Paper Space | No | Not designed for 2D drawing layouts. |
| Shop Drawing | No | Not intended for manufacturing view generation. |

## Prerequisites
- **Required Entities:** A Single Insulated Panel (Sip/CLT) must exist in the model.
  - *For Free Profile:* A Polyline defining the cut shape.
  - *For Drill Pattern:* Circles defining hole locations.
- **Minimum Entities:** 1 Panel.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-EdgeTool.mcr` from the list.

### Step 2: Select Panel
```
Command Line: Select Sip
Action: Click on the Single Insulated Panel (CLT panel) you wish to modify.
```

### Step 3: Select Tool Type
```
Command Line: Select Tool Type
Action: Choose the desired operation from the list (e.g., BeamCut, Rabbet, Mortise, Slot, House, Drill, Free Profile, or Drill Pattern).
```

### Step 4: (Conditional) Select Geometry
- **If Free Profile (nTool=0):**
  ```
  Command Line: Select PLine
  Action: Select a Polyline in the drawing that represents the cross-sectional shape of the cut.
  ```
- **If Drill Pattern (nTool=7):**
  ```
  Command Line: Select Circles
  Action: Select multiple Circles in the model to define the positions and sizes of the drill holes.
  ```

### Step 5: Position Tool
```
Command Line: Specify insertion point
Action: Move your cursor along the edge of the panel. The script will highlight the detected edge face. Click to set the insertion point for the tool.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| nTool | Integer (0-7) | 0 | Selects the machining type: 0=Free Profile, 1=BeamCut, 2=Rabbet, 3=Mortise, 4=Slot, 5=House, 6=Drill, 7=Drill Pattern. |
| dLength | Double | 0.0 | The length of the cut along the panel edge (Not used for Free Profile or Drill). |
| dWidth | Double | 0.0 | The horizontal depth of the cut into the panel from the side (Not used for Free Profile or Drill). |
| dDepth | Double | 0.0 | The vertical depth of the cut (thickness direction). Note: For Rabbet, Mortise, Slot, and House, this value is automatically doubled. |
| dRadius | Double | 0.0 | Defines the corner radius for slots/mortises or the drill hole radius. |
| dAngle | Double | 0.0 | The rotation angle of the tool around the insertion point. |
| dAxisOffset | Double | 0.0 | Shifts the tool position along the panel's local axis relative to the insertion point. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Align EPL | Available for Free Profile tools. Re-prompts you to select a new Polyline to update the shape while keeping the current position. |

## Settings Files
- **None Required**: This script relies entirely on user interaction and panel geometry.

## Tips
- **Drill Pattern Behavior**: When using Drill Pattern mode (nTool=7), the main script instance will disappear after insertion. It is replaced by individual Drill tool instances for every circle you selected.
- **Visual Feedback**: During insertion, pay attention to the highlighted edge face; it shows exactly which side of the panel the tool will be applied to.
- **Grip Editing**: After insertion, you can drag the grip point to move the tool along the edge or use the Properties Palette to fine-tune dimensions.

## FAQ
- **Q: Why did my tool disappear immediately after I placed it?**
  A: The tool likely did not physically intersect the panel body (e.g., it was placed too far outside the material). Ensure your Width and Depth settings penetrate the panel.
- **Q: Why are the dLength and dWidth fields hidden?**
  A: These parameters are automatically hidden depending on the tool type. For example, Drills and Free Profiles calculate dimensions from geometry/radius rather than manual length/width inputs.
- **Q: Can I switch a Mortise to a Rabbet without re-inserting?**
  A: Yes. Select the tool in the model, open the Properties Palette (Ctrl+1), and change the `nTool` value from 3 (Mortise) to 2 (Rabbet).
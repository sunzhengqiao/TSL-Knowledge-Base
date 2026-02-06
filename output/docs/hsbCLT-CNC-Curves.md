# hsbCLT-CNC-Curves

## Overview
Generates CNC machining operations (saw cuts, milling contours, or markings) on CLT MasterPanels based on existing 2D geometry or polylines drawn manually in the model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates directly on MasterPanels and 3D geometry. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | This is a 3D model preparation script. |

## Prerequisites
- **Required Entities**: At least one CLT MasterPanel and one Polyline (EntPLine).
- **Minimum beam count**: 1 MasterPanel.
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-CNC-Curves.mcr`

### Step 2: Configure Tool Properties
```
Dialog: Properties Palette appears upon insertion
Action: Adjust default settings for the CNC operation (Tool Type, Depth, Side, etc.) before proceeding.
```

### Step 3: Select Geometry or Draw
```
Command Line: Select Polylines & MasterPanels, <Enter> to draw
Action: You have two options:
1. Select existing Polylines and MasterPanels in the model.
2. Press Enter to draw a new Polyline manually.
```

### Step 4: Define Geometry (if Drawing)
If you chose to draw in Step 3:
```
Command Line: Specify start point:
Action: Click a point on the screen or on the panel.
```
```
Command Line: Specify next point:
Action: Click subsequent points. A preview of the tool will be displayed.
(Optional) Type keywords to change settings on the fly:
- "Left", "Right", or "Center" (changes tool alignment)
- "Saw", "Mill", or "mArker" (changes tool type)
```
```
Command Line: Specify next point or [Enter/Undo] to finish:
Action: Press Enter or Space to complete the shape.
```

### Step 5: Select MasterPanel (if missed)
If no MasterPanel was selected in Step 3 or 4:
```
Command Line: Select MasterPanel:
Action: Click the CLT MasterPanel you wish to apply the machining to.
```

### Step 6: Completion
The script validates that the geometry touches the panel. If successful, the CNC tool is attached to the MasterPanel, and the temporary reference script erases itself.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Tool Type | dropdown | Saw | Determines the operation: Saw (cut), Milling (pocket/contour), or Marker (scribe/print). |
| Depth | number | 10 | The depth of the cut/mill in mm relative to the reference face. |
| Tool Index | number | 0 | The tool number in the CNC machine magazine (defines the bit/blade to use). |
| Angle | number | 0 | The tilt angle of the saw blade (degrees). Only available for "Saw" type. |
| Side | dropdown | Left | The lateral position of the tool relative to the polyline direction (Left, Center, or Right). |
| Alignment (Face) | dropdown | Top | Which side of the panel the operation applies to (Top or Bottom). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Face | Switches the operation between the Top and Bottom face. Automatically inverts the Saw Angle to maintain the correct bevel direction relative to the new face. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **On-the-fly changes**: While drawing the polyline, you can type "Right" or "Center" to quickly adjust where the tool places itself relative to your cursor path without opening the properties palette.
- **Editing later**: You can select the original Polyline and use AutoCAD grips or `PEDIT` to modify its shape. The CNC tool on the panel will update automatically to match the new geometry.
- **Through cuts**: Setting the **Depth** equal to the panel thickness typically results in a through-cut.
- **Angle limits**: If you set a saw angle to 90° or higher, the script will automatically reset it to 0 to prevent calculation errors.

## FAQ
- **Q: Why is the Angle parameter greyed out?**
  **A:** The Angle parameter is only available for the "Saw" tool type. If you are using "Milling" or "Marker", the angle is locked to 0.
- **Q: I selected a panel and a line, but nothing happened.**
  **A:** Ensure that the Polyline physically touches or intersects the MasterPanel geometry. If the line is floating in space away from the panel, the tool cannot be generated.
- **Q: How do I cut from the bottom face up?**
  **A:** Change the **Alignment** property to "Bottom". Alternatively, run the "Flip Face" command from the right-click context menu.
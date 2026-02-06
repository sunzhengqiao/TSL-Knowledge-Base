# hsbProfileConnection

## Overview
This script automatically cuts timber beams, sheets, or panels to fit against profiled beams (such as open-web joists or steel profiles). It calculates complex 3D cuts based on the intersection and allows you to define precise clearance gaps for manufacturing tolerances.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the 3D model where beams intersect. |
| Paper Space | No | Not supported for 2D layouts. |
| Shop Drawing | No | Not applicable for shop drawing generation. |

## Prerequisites
- **Required entities**:
  - **Male elements**: Timber beams, sheets, or panels that will be cut.
  - **Female elements**: Profiled beams (e.g., steel joists) that define the cutting shape.
- **Minimum beam count**: 2 (One male element and one female element).
- **Required settings**: None.
- **Spatial requirement**: The male and female entities must physically intersect or touch in 3D space. Beams running parallel to each other will be ignored.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `hsbProfileConnection.mcr`.

### Step 2: Select Male Elements
```
Command Line: Select male beams, sheets or panels
Action: Click on the timber beams, sheets, or panels you want to cut.
```
Press **Enter** when selection is complete.

### Step 3: Select Female Elements
```
Command Line: Select female (profiled) beams
Action: Click on the profiled beam (e.g., steel joist) that the male elements connect to.
```
Press **Enter** when selection is complete.

### Step 4: Configure Gaps (Dialog)
Action: A dialog box appears displaying the default gap values (usually 0.00). If you require manufacturing tolerances, adjust the values here. Click **OK** to generate the connection.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Length** | Number | 0.0 | Defines the gap in length relative to the cross piece (effectively shortens the timber). |
| **Top Vertical** | Number | 0.0 | Defines the vertical clearance between the timber and the top flange of the profile. |
| **Top Horizontal** | Number | 0.0 | Defines the horizontal clearance to the flange on the top side. |
| **Bottom Horizontal** | Number | 0.0 | Defines the horizontal clearance to the flange on the bottom side. |
| **Facet** | Number | 0.0 | Defines the gap applied to angled or vertical segments (webs) of the profile. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add custom items to the right-click context menu. Use the Properties Palette to modify parameters. |

## Settings Files
- No external settings files are used by this script.

## Tips
- **Tolerances**: Use the **Length** or **Facet** gap properties to add small allowances (e.g., 2mm) to ensure easy assembly on-site.
- **Moving Elements**: If you move or stretch the connected beams using AutoCAD grips or commands, the cuts will update automatically to match the new position.
- **Intersection Check**: Ensure the beams clearly cross each other. If they are only touching at a single edge or are perfectly parallel, the script may skip the connection.
- **Deletion**: If you move the beams far apart so they no longer intersect, the script instance will delete itself and report "No intersection found" on the command line.

## FAQ
- **Q: Why did the connection disappear?**
  - A: The tool requires the beams to intersect. If you moved the beams apart, the tool deletes itself. Re-run the script after repositioning the beams.
- **Q: Can I use this for timber-to-timber connections?**
  - A: While technically possible if the "female" beam has a complex profile, this tool is primarily designed for connecting timber to profiled metal beams or joists.
- **Q: How do I change the gap size after inserting?**
  - A: Select the TSL instance (or the beam), open the **Properties Palette** (Ctrl+1), locate the "Gaps" category, and modify the values. The 3D model will update instantly.
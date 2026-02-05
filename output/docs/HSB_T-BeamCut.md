# HSB_T-BeamCut.mcr

## Overview
This script creates a parametric rectangular pocket or "T-cut" into timber beams. It is designed to create precise housings for steel T-plates, notches for intersecting beams, or seats for connections, with full control over size, position, and rotation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be run in 3D Model Space. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required entities**: At least one existing timber beam (`GenBeam`) in the drawing.
- **Minimum beam count**: 1.
- **Required settings**: None. (Can use a Catalog entry if configured).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_T-BeamCut.mcr` from the list.

### Step 2: Configure Initial Settings (Optional)
If running from a catalog without pre-set values, a dialog may appear.
- **Action**: Set the desired default dimensions and offsets, then click **OK**.

### Step 3: Select Beams
```
Command Line: Select a set of beams
Action: Click on one or more beams in the model and press Enter.
```

### Step 4: Define Position
```
Command Line: Select a position
Action: Click a point on the selected beam(s) to define the origin of the cut.
```

### Step 5: Adjust the Cut
Once placed, the script attaches to the beam showing a preview (wireframe box).
- **Action**: Drag the **Grip Points** (arrows/corners) to resize the cut visually, OR adjust parameters in the Properties Palette.

### Step 6: Apply the Cut
- **Action**: Right-click on the beam/cut preview and select **Apply beam cut** from the context menu.
- **Result**: The material is removed, and the script instance is deleted.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Position** | | | |
| Offset X | Number | 0 | Shifts the cut along the length of the beam (Longitudinal axis). |
| Offset Y | Number | 0 | Shifts the cut across the width of the beam (Lateral axis). |
| **Size** | | | |
| Depth | Number | 75 | The vertical depth of the cut into the beam. |
| Length | Number | 290 | The length of the cut along the beam's axis. |
| Width | Number | 58 | The width of the cut across the beam. |
| Extra depth | Number | 10 | Additional depth added to the cut (Total Depth = Depth + Extra depth). Useful for CNC clearance. |
| **Rotation** | | | |
| Rotation XY | Number | 0 | Rotation around the beam's vertical axis (Z-axis). Angles the cut along the length. |
| Rotation XZ | Number | 0 | Rotation around the beam's lateral axis (Y-axis). Tilts the cut vertically. |
| Rotation YZ | Number | 0 | Rotation around the beam's longitudinal axis (X-axis). Twists the cut. |
| **Preview** | | | |
| Preview mode | Dropdown | Yes | If **Yes**, shows a wireframe box only. If **No**, applies the actual cut to the beam (removing material). |
| Extend Beamcuts | Dropdown | Yes | If **Yes**, permanently modifies the beam's cross-section for CNC and nesting. If **No**, the cut is graphical only. |
| Ref Point Size | Number | 5 | Visual size of the reference point marker in the preview. |
| Symbol Size | Number | 10 | Visual length of the axis arrows (X, Y, Z) in the preview. |
| Txt Height | Number | 2 | Height of the text labels (X, Y, Z) in the preview. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Apply beam cut | Finalizes the operation. Switches off preview mode, cuts the material, updates the CNC section (if enabled), and removes the script instance. |

## Settings Files
- **Filename**: N/A (Standard TSL Script)
- **Location**: TSL Catalog or `hsbCAD` installation folder.
- **Purpose**: If executed via a Catalog entry, it can load pre-defined dimensions (e.g., specific sizes for standard T-plates).

## Tips
- **Visual Adjustments**: Use the **Grip Points** displayed in the preview to quickly resize the cut. Moving the grips updates the Length, Width, and Depth properties automatically.
- **Check Alignment**: Keep **Preview Mode** set to "Yes" while you are fine-tuning the position and rotation. This prevents accidental material removal until you are satisfied.
- **CNC Clearance**: Use the **Extra depth** parameter to ensure the cut goes completely through the material or leaves clearance for tools, preventing machining errors.

## FAQ
- **Q: Why do I see a wireframe box but the beam isn't cut?**
- **A:** The **Preview mode** property is likely set to "Yes". Change this to "No" in the Properties Palette or right-click and select **Apply beam cut** to execute the subtraction.
- **Q: Can I use this on multiple beams at once?**
- **A:** Yes, during the insertion phase (Step 3), you can select a set of beams. The script will attach to all selected beams using the same parameters.
- **Q: What happens if I move a grip point to zero size?**
- **A:** If you flatten the box completely (resulting in zero volume), the dimensions will not update to prevent errors. Ensure you drag the grip in a direction that creates volume.
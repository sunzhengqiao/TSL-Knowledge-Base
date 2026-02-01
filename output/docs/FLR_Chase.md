# FLR_Chase.mcr

## Overview
This script automates the creation of floor chases (openings or notches) in joists and trusses. It is used to cut rectangular, round, or oval openings through multiple structural members along a defined path to accommodate HVAC ducts, plumbing, or wiring.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model to modify beam geometry. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Does not generate 2D drawings directly. |

## Prerequisites
- **Required Entities**: A Floor or Roof Element containing Joists or Beams must exist in the model.
- **Minimum Beam Count**: 0 (The script will run, but requires at least one intersecting joist to create a visible cut).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `FLR_Chase.mcr`

### Step 2: Configure Properties
**Action:** Upon insertion, the Properties Palette (OPM) will open.
- Adjust parameters such as **Shape**, **Width**, **Height**, and **Offset** now or after insertion.
- Click in the model space to begin defining the chase location.

### Step 3: Define Path
```
Command Line: Select start point
Action: Click the location where the chase should begin.
```

### Step 4: Define End Point
```
Command Line: Select next point
Action: Click the location where the chase should end. This defines the centerline path of the opening.
```

### Step 5: Select Reference Element
```
Command Line: Select a reference Element
Action: Click the Floor or Roof element that contains the joists you wish to cut. This provides the height reference for the script.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Shape | dropdown | Rectangular | The geometry of the cut: Rectangular, Round, or Oval. |
| Width (dW) | number | 12.0 | The width of the chase (inches). For Oval shapes, this is the minor axis. |
| Height (dH) | number | 4.0 | The height of the chase (inches). For Round shapes, this acts as the Diameter. |
| Offset (dZOff) | number | 0.0 | Vertical offset (inches) from the center of the reference element. Moves the hole up or down. |
| Joists to use | dropdown | All Floor Joists | Determines the scope of beams to cut. "All Floor Joists" includes broader groups; "Only Element Joists" restricts cuts to the specific element selected. |
| Keep Perpendicular | dropdown | Yes | If "Yes", only joists running perpendicular to the chase path are cut. If "No", any intersecting joist will be cut. |
| Dim Style | dropdown | Current DimStyle | The dimension style used for the 3D text label annotation. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the machining based on current property values or if beam positions have changed. |
| Erase | Removes the script instance and the associated cuts from the model. |

## Settings Files
None required.

## Tips
- **Moving the Chase:** You can drag the Start and End grip points in the model after insertion to resize or move the chase. The machining will automatically update.
- **Perpendicular Logic:** Use the "Keep Perpendicular" setting set to "Yes" to avoid accidentally cutting rim joists or headers that run parallel to the chase path.
- **Oval Shapes:** When using the Oval shape, the script calculates the geometry based on the smaller of your Width and Height values to create the corner radii.
- **Visual Feedback:** A 3D text label is generated showing the size and offset of the chase for easy identification in the model.

## FAQ
- **Q: What happens if I select "Round" shape?**
  **A:** The script ignores the "Width" parameter and uses the "Height" parameter as the diameter to create a cylindrical drill hole.
- **Q: Why did the script not cut a specific joist that crosses the line?**
  **A:** Check if "Keep Perpendicular" is set to "Yes". If enabled, joists that are not at a near-90-degree angle to the chase path will be ignored. Also, ensure the joist is part of the group defined in "Joists to use".
- **Q: How do I lower the chase to avoid a top plate?**
  **A:** Use the "Offset" property. A negative value moves the chase downward relative to the element center.
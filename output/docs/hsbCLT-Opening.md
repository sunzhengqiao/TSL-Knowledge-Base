# hsbCLT-Opening.mcr

## Overview
This script automates the detailing of openings in CLT (Cross Laminated Timber) panels by replacing raw voids with manufacturing-ready machining tools. It supports various strategies for creating window and door openings, including adding surrounding splines, pocketing (extrusions), and applying specific corner radii.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script runs in the 3D model and modifies CLT panels (GenBeam/Element). |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Generates dimension points for shop drawings but does not run inside the drawing view itself. |

## Prerequisites
- **Required Entities**: At least one CLT Panel (`GenBeam` or `Element`) must exist in the model.
- **Minimum Beam Count**: 1
- **Required Settings**: None required for basic functionality, but relies on standard hsbCAD TSL utilities.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-Opening.mcr`

### Step 2: Select Host Panel
```
Command Line: Select Element/GenBeam
Action: Click on the CLT panel that contains the opening you wish to detail.
```

### Step 3: Configure Opening Strategy
```
Action: A configuration dialog appears automatically.
```
1.  Select a **Rule** (Strategy) from the list (e.g., "Midpoint Tool", "Corner Tool", "Extrusion").
2.  Define the **Opening Type** (Door or standard Opening).
3.  Set the **Radius** for corner rounding.
4.  Adjust visual settings (Color, LineType) if desired.
5.  Click **OK** to generate the tool.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Strategy | Dropdown | Midpoint Tool | Determines the manufacturing method: <br>- *Midpoint/Corner Tool*: Creates a surrounding timber spline.<br>- *Opening*: Standard through cut.<br>- *Extrusion*: Creates a recess/pocket.<br>- *House/Mortise*: Specific rectangular tooling strategies. |
| Is Door | Boolean | No | If set to Yes, the script ensures the opening closes correctly at the outer edge of the panel. |
| Radius | Number | 0 mm | Sets the corner radius for the opening or the surrounding tool. |
| Text Height | Number | 2.5 mm | Height of the annotation text (e.g., Opening ID) displayed in the model. |
| Add Dimensions | Boolean | Yes | If Yes, generates dimension points for the shop drawing ruleset (requires `sd_Opening`). |
| Stereotype | String | - | Defines the stereotype used for shop drawing processing. |
| Color | Index | Blue | Visual color of the tool elements in the CAD model. |
| LineType | String | DASHED | Visual linetype of the tool elements. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Side | Toggles the reference face of the tool between the Reference Side and the Opposite Side of the panel. |
| Clone Tool | Creates a duplicate instance of the current tool, allowing for different parameters on the same panel. |
| Reset + Erase | Removes the tool geometry and restores the panel to its raw opening state. |
| Edit Shape | Activates a jig/edit mode, allowing you to graphically modify the boundary of the opening. |
| Configure Display | Re-opens the configuration dialog to adjust colors, linetypes, and text settings. |
| Add/Remove Tool Dimpoints | Toggles the generation of smart dimensioning points for shop drawings. |

## Settings Files
- **Filename**: Standard internal settings or `TslUtilities` configuration.
- **Location**: hsbCAD Application folder.
- **Purpose**: Stores the visual configuration (colors, layers) and default dialog options.

## Tips
- **Strategy Selection**: Use "Midpoint Tool" or "Corner Tool" when you need a physical surrounding piece (spline) for the opening. Use "Extrusion" if you only need a blind pocket (recess) without cutting through the panel.
- **Door Handling**: If a door opening does not appear to close correctly at the panel edge, ensure the **Is Door** property is set to **Yes**.
- **Batch Processing**: You can insert this script on multiple panels at once using the standard hsbCAD batch insert functionality.

## FAQ
- **Q: How do I change the corner radius after insertion?**
  A: Select the tool in the model, open the **Properties Palette**, and modify the **Radius** value.
- **Q: Why is my opening not showing dimensions in the shop drawing?**
  A: Ensure **Add Dimensions** is set to **Yes** in the properties and that your shopdrawing ruleset includes the `sd_Opening` component.
- **Q: What is the difference between "Midpoint Tool" and "Corner Tool"?**
  A: Both create surrounding splines, but they use different calculation strategies for placing the tool geometry relative to the opening edges. Choose the one that fits your specific manufacturing connection best.
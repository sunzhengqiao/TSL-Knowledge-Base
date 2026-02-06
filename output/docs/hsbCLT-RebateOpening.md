# hsbCLT-RebateOpening.mcr

## Overview
This script automatically creates single or double-stepped rebates (grooves) around openings in CLT panels, such as doors or windows. It prepares panel openings for the installation of frames, gaskets, or overlapping elements by machining the material edges.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the 3D model. |
| Paper Space | No | Not applicable for 2D drawings. |
| Shop Drawing | No | Machining is applied to the model, not the drawing layout. |

## Prerequisites
- **Required Entities**: Sip (Panel/Wall element).
- **Minimum Beam Count**: 0 (Attached to Panels, not beams).
- **Required Settings/Dependencies**: 
    - Dependent script: `hsbCLT-RebateEdge` (required for specific editing features).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-RebateOpening.mcr` from the list.

### Step 2: Select Panels
```
Command Line: Select panel(s)
Action: Click on the CLT panels or walls that contain the openings you wish to apply rebates to.
```
*Note: The script will automatically detect openings within the selected panels and apply the configuration based on the properties.*

### Step 3: Configure Properties
After insertion, select the script instance (or the panel) and modify the rebate dimensions in the Properties Palette (Ctrl+1).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **General** | | | |
| Face | dropdown | Reference Side | Selects whether the rebate is cut from the Reference Side or the Opposite Side of the panel. |
| Edge Mode | dropdown | all | Defines which sides of the opening receive the rebate (e.g., all, not bottom, left + right, etc.). |
| **Filter** | | | |
| Minimal Area | number | 0 | Filters openings by size. If set, only openings larger than this value (in mm²) are processed. Useful to exclude small drill holes. |
| **Rebate 1** | | | |
| Depth | number | 20 | The depth of the primary rebate cut (how far into the panel). |
| Width | number | 40 | The horizontal width of the primary rebate (setback from the opening edge). |
| Tool Radius | number | 0 | The radius for internal corners. Set to > 0 for rounded corners; 0 for sharp corners. |
| **Rebate 2** | | | |
| Depth | number | 0 | The depth of the second rebate step. Leave as 0 for a single rebate. |
| Width | number | 0 | The width of the second rebate step. |
| Tool Radius | number | 0 | The radius for the internal corners of the second rebate step. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Side (Doubleclick) | Toggles the rebate between the Reference Side and Opposite Side of the panel. |

## Settings Files
- **Filename**: None specified (Internal defaults used).
- **Dependency**: `hsbCLT-RebateEdge.mcr`
  - **Purpose**: Required for "Edit in Place" functionality where individual tools are grouped into separate edge instances.

## Tips
- **Filtering Small Holes**: Use the **Minimal Area** property to avoid creating rebates on small service openings or drill holes (e.g., set to 10000 mm² to ignore holes smaller than 10cm x 10cm).
- **Partial Rebates**: Use the **Edge Mode** to apply rebates only where needed (e.g., select "not bottom" if the bottom sill requires a different detail).
- **Double Rebates**: To create a stepped profile, enter dimensions for **Rebate 2** (Depth and Width > 0).

## FAQ
- **Q: How do I create a double-stepped rebate?**
- **A:** Enter values greater than 0 for the **Depth** and **Width** properties in the "Rebate 2" section of the Properties Palette.

- **Q: Why are the corners of my rebate sharp?**
- **A:** The **Tool Radius** is set to 0. Increase the **Tool Radius** (Rebate 1 or 2) to create rounded corners based on the milling tool size.

- **Q: Can I apply this to just the top of a window opening?**
- **A:** Yes. Change the **Edge Mode** property from "all" to "top (Y)" to restrict the rebate to just the top edge.
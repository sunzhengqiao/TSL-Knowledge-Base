# hsb_Apply Glue to Elements

## Overview
Automatically calculates and generates CNC glue application instructions (lines or areas) on specific manufacturing layers (zones) of timber elements. It respects exclusion zones and applies specific tooling parameters for manufacturing data.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used to select 3D Elements and generate glue geometry. |
| Paper Space | No | Not applicable for layouts or shop drawings. |
| Shop Drawing | No | Processing occurs in the 3D model. |

## Prerequisites
- **Required Entities**: One or more `Elements` (e.g., walls, floors, CLT panels).
- **Minimum Beam Count**: N/A (Operates on Elements).
- **Required Settings Files**: 
  - `hsb_GlueArea.mcr` (Must be present in the TSL search path).

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT`
**Action:** Browse and select `hsb_Apply Glue to Elements.mcr`.

### Step 2: Configure Properties
**Action:** If running the script manually (not from a catalog), a properties dialog or the Properties Palette will appear.
- Set the **Zone to be Glued** (e.g., Layer 1, 2, etc.).
- Set the **Tool Indexes** for your CNC machine.
- Adjust **Size** and **Offset** parameters if necessary.

### Step 3: Select Elements
```
Command Line: Select one or More Elements
Action: Click on the timber elements in the model you wish to process. Press Enter to confirm selection.
```
*Note: The script will attach to the elements, calculate the geometry, and generate the glue instructions automatically.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone to be Glued | dropdown | 0 | Selects the specific manufacturing layer (1-10) where the glue will be applied. |
| Glue Reference Zone | dropdown | 0 | Defines the reference layer (e.g., adjacent layer) used to calculate glue boundaries. |
| Tool index Line | number | 51 | The CNC machine tool ID used for linear glue paths. |
| Tool index Area | number | 52 | The CNC machine tool ID used for surface glue areas. |
| Size Glue Area | number | 360.0 | The dimension (length/side) of the standard glue application unit (mm). |
| \|Origin X offset\| | number | 0.0 | Shifts the glue pattern along the element's width (X-axis). |
| \|Origin Y offset\| | number | 0.0 | Shifts the glue pattern along the element's length (Y-axis). |
| \|Minimum width to create glue area\| | number | 200.0 | Threshold width (mm). Narrower surfaces generate lines; wider surfaces generate areas. |
| \|Minimum length of glue line\| | number | 200.0 | Shortest allowed length (mm) for a glue line segment. Shorter segments are filtered out. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Reapply Glue | Forces the script to recalculate and regenerate all glue geometry on the element. Useful after modifying the element or changing properties. |

## Settings Files
- **Filename**: `hsb_GlueArea.mcr`
- **Location**: TSL Script Folder
- **Purpose**: This dependency script is spawned by the main script to hold the actual geometric polyline and tooling attributes for the CNC output.

## Tips
- **Lines vs. Areas**: If you want glue lines instead of areas on a specific surface, increase the **Minimum width to create glue area** value to be larger than that surface's width.
- **Offsets**: Use the X and Y offsets to adjust the glue pattern start position to match machine jigging or placement constraints.
- **Exclusions**: The script detects "NoGlue" tags or exclusion zones defined by other scripts and will not apply glue in those areas.
- **Recalculation**: Changing the Element geometry (e.g., moving a window) will automatically trigger an update of the glue paths.

## FAQ
- **Q: Why is no glue appearing on my element?**
  - **A:** Check that the **Zone to be Glued** matches a layer that actually exists in your Element. Also, verify that the width of the target surface exceeds the **Minimum width to create glue area** (if you expect areas) or **Minimum length of glue line** (if you expect lines).
- **Q: What happens if I select a zone that is lower than the Reference Zone?**
  - **A:** The script will generate a notice in the command line, but it will continue to run. Ensure your Reference Zone logic matches your construction setup (e.g., Reference Zone is usually the layer below the Glue Zone).
- **Q: Can I use this for pre-fabricated wall panels?**
  - **A:** Yes, this script is designed for automated manufacturing preparation of panels like CLT or timber frame walls.
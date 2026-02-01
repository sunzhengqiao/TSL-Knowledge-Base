# hsb_FloorSheetingDistribution.mcr

## Overview
Automatically calculates, generates, and distributes floor or roof sheathing boards within a selected element zone. It optimizes material usage with staggered joints, calculates waste area, and allows for layout adjustments perpendicular or parallel to joists.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates in the 3D model to create Sheet bodies. |
| Paper Space | No | Not applicable for layout generation. |
| Shop Drawing | No | Script is for design/modeling phases only. |

## Prerequisites
- **Required Entities**: At least one `Element` (Floor, Roof, or Wall) must exist in the model.
- **Minimum Beam Count**: 0 (Script functions based on Element zones and boundaries).
- **Required Settings**: None specific.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_FloorSheetingDistribution.mcr` from the list.

### Step 2: Select Elements
```
Command Line: Select Elements:
Action: Click on the floor or roof elements you want to apply sheathing to. Press Enter to confirm selection.
```

### Step 3: Define Origin Point
```
Command Line: Pick start distribution point:
Action: Click a point in the model to define the origin (usually a corner) where the sheathing layout grid begins.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| nZones | Integer | 0 | The construction layer (Zone) index within the element where sheathing is applied. Existing sheets in this zone will be regenerated. |
| sOrientation | Dropdown | Perpendicular to Joist | Sets the direction of the boards relative to the joists. Options: *Perpendicular to Joist*, *Parallel to Joist*. |
| dSheetWidth | Number (mm) | 600 | The width of the raw board material (short edge). |
| dSheetLength | Number (mm) | 2400 | The length of the raw board material (long edge). |
| dSheetThickness | Number (mm) | 22 | The thickness of the sheathing boards to be generated. |
| dMinimumLength | Number (mm) | 100 | The minimum usable length of an offcut. Offcuts smaller than this are discarded as waste rather than used in the next row. |
| dMinWidthForWaste | Number (mm) | 150 | Width threshold for waste calculation. Strips narrower than this are still drawn but counted as waste in the area calculation. |
| sDimStyle | String | Standard | The dimension style used for the waste area text annotation. |
| strYNWaste | Dropdown | No | Toggles the visibility of the waste area text label in the model. Options: *Yes*, *No*. |
| _Pt0 | Point3d | User Point | The origin point for the sheathing grid. Moving this point shifts the entire layout to align cuts with joists. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Redistribute Sheets | Forces a full regeneration of the sheathing layout based on the current element geometry and properties. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies on standard hsbCAD Entity properties and does not require external XML settings files.

## Tips
- **Optimizing Layout**: Use the `_Pt0` grip point to slide the sheathing grid. This allows you to ensure joints fall directly over structural joists.
- **Waste vs. Labor**: Lowering `dMinimumLength` will reduce material waste by using smaller offcuts, but it will increase installation time due to more small pieces. Increasing it simplifies installation but increases waste.
- **Visualizing Cuts**: Sheets that are cut (not full size) are marked with a diagonal line. This helps identify non-standard pieces quickly on the shop floor.

## FAQ
- **Q: Why did my existing sheets disappear?**
  A: The script regenerates the layout every time parameters change. Ensure `nZones` is set correctly to the layer containing your original sheets.
- **Q: How do I switch sheets to run parallel to the joists?**
  A: Select the generated sheathing instance, open the Properties palette, and change `sOrientation` to "Parallel to Joist".
- **Q: The waste calculation seems higher than expected. Why?**
  A: Check `dMinWidthForWaste`. If you have narrow strips of sheathing (e.g., 100mm wide) along a wall edge, they are still physically drawn but counted as waste if they are below this threshold (default 150mm).
- **Q: Can I change the sheet size after insertion?**
  A: Yes. Simply select the instance and modify `dSheetWidth` or `dSheetLength` in the Properties palette. The script will automatically recalculate the layout.
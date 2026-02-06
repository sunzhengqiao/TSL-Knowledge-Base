# hsbCLT-OpeningRebate.mcr

## Overview
Automatically applies single or double step rebates (grooves/shoulders) around the perimeter of openings in CLT panels. Ideal for creating weathering seals, gasket grooves, or seating rebates for windows and doors.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script creates 3D machining operations on Sip entities. |
| Paper Space | No | Not applicable for 2D drawing views. |
| Shop Drawing | No | This script models physical geometry, not annotations. |

## Prerequisites
- **Required Entities**: CLT Panels (Sip entities) with existing openings.
- **Minimum Beam Count**: N/A (Operates on Panels).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-OpeningRebate.mcr`

### Step 2: Select Panel
```
Command Line: Select panel(s)
Action: Click on the CLT panel(s) containing the openings you wish to process. Press Enter to confirm selection.
```

### Step 3: Configure Properties
**Note**: If a default catalog entry is not used, a Properties dialog will appear upon insertion.
- **Face**: Select whether to machine on the "Reference Side" or "Opposite Side".
- **Dimensions**: Set the Depth and Width for the rebate.
- **Double Rebate**: If a second step is required, enter values for Depth 2 and Width 2 (leave as 0 for single rebate).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **General** | | | |
| Face | dropdown | Reference Side | Determines which side of the panel the rebate is machined into. |
| Edge Mode | dropdown | all | Defines which edges of the opening are rebated (e.g., all, top only, bottom+top, etc.). |
| **Rebate 1** | | | |
| Depth | number | 98.0 | The depth of the first rebate step (perpendicular to the panel face). |
| Width | number | 44.0 | The width of the first rebate step (inwards from the opening edge). |
| Tool Radius | number | 0.0 | Defines the radius of the tool. If set > 0, it rounds corners and effectively enlarges the tool width. |
| **Rebate 2** | | | |
| Depth | number | 0.0 | The depth of the second rebate step. Set to 0 to disable the second rebate. |
| Width | number | 0.0 | The width of the second rebate step. |
| Tool Radius | number | 0.0 | Defines the tool radius for the second rebate step. |
| **Filter** | | | |
| Minimal Area | number | 0.0 | Filters openings by area. Positive values ignore openings smaller than this; negative values ignore openings larger than this. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Side (Doubleclick) | Toggles the rebate to the opposite face of the panel. You can also double-click the script instance to activate this. |
| Stretch tool to panel edge | Extends the rebate cut all the way to the physical edge of the panel (based on Edge Mode settings). |
| Do not stretch Tool | Restricts the rebate to the immediate perimeter of the opening only. |

## Settings Files
No specific external settings files are required for this script.

## Tips
- **Double Rebates**: To create a two-step machining profile, ensure `Rebate 2 > Depth` is set to a value greater than 0.
- **Filtering Small Holes**: Use the `Minimal Area` property to prevent the script from running on small service holes (e.g., for pipes or cables) that do not need a rebate.
- **Tool Radius Impact**: If you specify a Tool Radius that is larger than half the Width, the tool path will be widened to accommodate the radius size.
- **Partial Rebates**: Use the Edge Mode dropdown to machine only specific sides of an opening (e.g., `|bottom + top|`) rather than the entire perimeter.

## FAQ
- **Q: How do I switch the rebate from the inside face to the outside face?**
  A: Double-click the script instance in the model, or right-click and select "Flip Side".
- **Q: Why is the second rebate not appearing?**
  A: Ensure the property `Rebate 2 > Depth` is set to a value greater than 0.0.
- **Q: Can I apply this to multiple panels at once?**
  A: Yes, during the insertion step ("Select panel(s)"), you can select multiple CLT panels, and the script will iterate through valid openings on all of them.
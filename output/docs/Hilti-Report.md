# Hilti-Report.mcr

## Overview
Generates a detailed table in Model Space that quantifies Hilti fasteners and connectors used on selected timber elements. It creates a dynamic schedule or bill of materials for hardware items like screws, anchors, and hanger bolts.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script draws the table directly into the model layout. |
| Paper Space | No | Not designed for Paper Space or viewports. |
| Shop Drawing | No | This is a model reporting tool, not a detailing script. |

## Prerequisites
- **Required Entities**: Existing TSL instances with script names `Hilti-Decke`, `Hilti-Stockschraube`, or `Hilti-Verankerung` must be present in the model.
- **Associated Elements**: These TSLs must be correctly attached to an Element or Beam.
- **Minimum Beam Count**: 0 (Relies on TSL instances, not raw beams).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Hilti-Report.mcr` from the list.

### Step 2: Select TSLs
```
Command Line: Select tsl(s)
Action: Click on the Hilti connection instances (e.g., Hilti-Decke, Hilti-Stockschraube) in the model that you want to include in the report. Press Enter when finished.
```

### Step 3: Place Table
```
Command Line: Pick insertion Point of the table
Action: Click in the Model Space to define where the top-left corner of the report table should be drawn.
```

## Properties Panel Parameters
This script does not expose any editable parameters in the Properties Palette. All configuration is handled via the command line and context menu.

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **add other TSL(s)** | Prompts you to select additional Hilti TSL instances from the model. These are added to the current report, and the table updates immediately to include the new quantities. |

## Settings Files
No external settings files are required or used by this script.

## Tips
- **Dynamic Columns**: The table only creates columns for components that actually exist in your selection. If you have no "Hanger bolt HSW", that column will not appear.
- **Baufritz Projects**: If your project special is set to `baufritz`, the script will automatically detect and count "Holzdolle" components, adding a specific "Decke-Oben-Dollen" column to the report.
- **Error Handling**: If a selected TSL is attached to more than one structural element (e.g., spanning two walls), the script will report an error and delete itself to prevent incorrect data. Ensure TSLs are associated with a single element.

## FAQ
- **Q: Why did the report disappear immediately after I placed it?**
  A: This usually happens if the selected TSLs are attached to more than one element, or if no valid TSLs were found. Check the command line for an error message like "unexpected error / TSL attached to more than one element".
- **Q: Can I move the table after creating it?**
  A: Yes. Since the output consists of standard lines and text in Model Space, you can select them and use AutoCAD's Move command or grips to reposition the table.
- **Q: How do I update the report if I add more screws to the wall?**
  A: Simply right-click on the script instance (the origin point) and select **Recalculate**, or use the **add other TSL(s)** option if you added new TSL instances.
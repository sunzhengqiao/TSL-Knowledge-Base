# Hilti-Verankerungsplan-Dollen

## Overview
This script aggregates all Hilti anchors and CLT connections for a specific floor, visualizes their positions in the model, and exports a scaled DWG file for manufacturing or site layout planning.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script collects entities and creates geometry within the active Model Space structure. |
| Paper Space | No | This script does not generate viewports or 2D shop drawings. |
| Shop Drawing | No | This is a planning and export tool, not a detailing script. |

## Prerequisites
- **Required Entities:** A grouped floor structure in ModelSpace containing TSL instances of `Hilti-Verankerung` or `hsbCLT-Hilti`.
- **Minimum Beams:** 0
- **Required Settings:** None. The script automatically detects available floor names from the model structure.

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT` (or insert via hsbCAD Ribbon)
**Action:** Browse and select `Hilti-Verankerungsplan-Dollen.mcr`.

### Step 2: Select Floor
**Dialog:** A dynamic list appears showing all available floor names found in the current model (e.g., EG, OG1, GARAGE).
**Action:** Select the desired floor level from the dropdown list and click **OK**.

### Step 3: Visualization
**Action:** The script instance is created in the drawing. It will automatically draw visual markers (crosses/polylines) representing the anchor positions within a subgroup named `DXF Dollen` under the selected floor group.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Floor name | Dropdown | `|_Default|` | Selects the building level to generate the plan for. Changing this updates the visualization and the export data. |
| Nr Connectors | Number (Read-Only) | 0 | Displays the total count of anchors found on the selected floor. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Create Dwg File | Exports the anchor plan geometry to a separate DWG file in the current project folder. The geometry is scaled to 1:1000 for manufacturing purposes. |

## Settings Files
- **Filename:** None required.
- **Location:** N/A
- **Purpose:** N/A

## Tips
- **Dynamic Updates:** If you modify your model (add/remove anchors), select the script instance and change the "Floor name" property to trigger a recalculation and update the count.
- **Export Location:** The exported DWG file is saved directly in the folder of your current project drawing.
- **Group Structure:** Ensure your model is properly grouped by floor. The script relies on finding entities inside specific Group entities to function correctly.
- **hsbCLT-Hilti Orientation:** For `hsbCLT-Hilti` connectors to be included, they must be inserted on a single panel and oriented vertically (aligned with the World Z-axis).

## FAQ
- **Q: Why is the "Nr Connectors" count 0?**
  A: Ensure you have selected the correct floor name in the properties palette that matches the group name containing your anchors. Also, check that your `hsbCLT-Hilti` instances are oriented vertically.
- **Q: Where does the exported DWG file go?**
  A: It is saved in the same directory as the current CAD drawing file you are working in.
- **Q: What does the export file contain?**
  A: It contains circles (representing drilling points/anchors) and polylines (wall outlines) scaled to 0.001 (1:1000).
- **Q: Can I use this for Paper Space layouts?**
  A: No, this script works entirely in Model Space to generate data and export files. It does not create 2D views in layouts.
# hsb_AssignBeamToElementZone.mcr

## Overview
Assigns structural beams or sheets to specific construction zones (Element Groups) within an element. It allows batch updating of properties like color, beam type, and module grouping based on zone settings to help organize production data.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates directly on Elements and GenBeams. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Not intended for detailing views. |

## Prerequisites
- **Required Entities:** Existing Elements and GenBeams in the model.
- **Minimum Beam Count:** 0 (Script can run even if no beams are found, though no updates will occur).
- **Required Settings:** None required; uses standard hsbCAD Catalogs for beam types.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or select from hsbCAD Scripts menu)
Action: Select `hsb_AssignBeamToElementZone.mcr` from the file dialog.

### Step 2: Select Input Mode (Based on Properties)
The script behavior depends on the "Find Beams with Code" property. By default, this is empty, triggering **Manual Selection Mode**.

**Manual Selection Mode (Default):**
```
Command Line: Select an element
Action: Click on the main Element (wall/floor) containing the beams you want to modify.
```
```
Command Line: Select Beams or Sheets
Action: Select the specific GenBeams or Sheets within that element. You can use a window selection.
```

**Automatic Filter Mode (If "Find Beams with Code" is populated):**
*Note: To use this mode, select the script instance after insertion and edit the properties first, then Recalculate.*
```
Command Line: Select elements
Action: Select one or more Elements. The script will automatically find all beams inside these elements that match the specified Beam Codes.
```

## Properties Panel Parameters
After inserting the script, select it to view these properties in the AutoCAD Properties Palette (OPM).

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Find Beams with Code | Text | (Empty) | Enter Beam Codes to filter (e.g., `STUD;RAFTER`). If left empty, you must manually select beams. Separate multiple codes with a semicolon (`;`). |
| Zone to Assign | Number | 1 | Select the target Zone number (1-10). Zones are used to group elements for lists or production. Note: Options 6-9 map to internal negative zones (-1 to -4). |
| Use Sheeting Zone Colour? | Dropdown | No | If set to **Yes**, the script changes the display color of the selected beams to match the color defined for the target Zone in your project settings. |
| Set beam type? | Dropdown | No | If set to **Yes**, the script changes the material/structural type of the beams. |
| New beam type | Dropdown | (Current) | The Beam Type to apply (e.g., C24, GL24h). Only active if "Set beam type?" is Yes. Populated from the hsbCAD Catalog. |
| Reset Module Information | Dropdown | No | If set to **Yes**, clears the Module assignment for the selected beams, effectively removing them from any transport or assembly group. |

## Right-Click Menu Options
After inserting the script, select the script instance in the model and right-click to access:

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Re-runs the assignment logic. Use this after changing properties in the palette (e.g., changing the Zone number or Filter codes) to apply the new settings. |

## Settings Files
- **Filename:** None (Uses internal hsbCAD Catalog)
- **Location:** N/A
- **Purpose:** The script reads Beam Types directly from your active hsbCAD Catalog. Zone colors are read from the Element's project properties.

## Tips
- **Batch Processing:** Use the "Find Beams with Code" property to update all studs or rafters across multiple elements at once without manually picking every beam.
- **Visual Organization:** Enable "Use Sheeting Zone Colour" to visually differentiate specific zones (e.g., making all Zone 2 beams appear Red) directly in the 3D model.
- **Workflow:** Since the script persists in the drawing, you can select it later and change the Zone assignment to move the same set of beams to a different zone, then click Recalculate.

## FAQ
- **Q: I want to change the zone of every beam in a wall, not just specific ones. How do I do that?**
  - A: Leave the "Find Beams with Code" property empty. Run the script, select the Element, and then window-select all beams when prompted.
- **Q: What is the difference between Zone 6 and Zone -1?**
  - A: In the dropdown, selecting Zone 6, 7, 8, or 9 assigns the beams to internal negative zones -1, -2, -3, or -4 respectively. This is often used for sheeting or specific sub-assembly groupings.
- **Q: The script didn't change the color of my beams.**
  - A: Ensure "Use Sheeting Zone Colour?" is set to **Yes** in the properties palette and that you have run **Recalculate**. Also, verify that a specific color is actually defined for that Zone in your Element defaults.
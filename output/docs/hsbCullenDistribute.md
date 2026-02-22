# hsbCullenDistribute

## Overview

`hsbCullenDistribute` automates the placement of Cullen structural metal connectors along timber walls, soleplates, and floor elements. Rather than placing connectors one at a time, this script analyses the selected wall geometry or beam/sheet, calculates evenly spaced positions according to your spacing or quantity settings, and then inserts each connector instance automatically.

The script supports four distinct connector types, each targeting a different structural scenario:

- **FAS** (Framing Anchor System) - vertical connectors at wall-to-wall corners and T-junctions
- **PC** (Panel Closer) - connectors at panel intersections
- **ST-PFS** - stud-to-plate connectors distributed along vertical studs within a wall
- **GA Cullen** - angle brackets (model SP-100x100x50, manufacturer Cullen UK) placed along a horizontal beam or sheet layer

After all connectors have been inserted, the `hsbCullenDistribute` script instance removes itself from the drawing automatically. The individual connector objects it created remain in place.

**Current version:** 2.6 (13 September 2024)
**Initial release:** 1.0 (22 October 2019)
**Keywords:** cullen, FAS, distribute, kingspan

---

## Usage Environment

| Environment | Supported | Notes |
|-------------|-----------|-------|
| Model Space | Yes | All connector types are placed in Model Space |
| Paper Space | No | Not applicable |
| Shop Drawing | No | This script generates 3D entities, not drawing annotations |

**Script type:** O (Object) - no beams need to be pre-attached before insertion.

---

## Prerequisites

The requirements depend on the connector type you intend to use:

| Type | What you need before running |
|------|------------------------------|
| FAS | At least 2 stick frame walls (`ElementWallSF`) that intersect at a corner or T-junction |
| PC | At least 2 stick frame walls (`ElementWallSF`) that intersect at a corner or share a panel edge |
| ST-PFS | One or more stick frame walls with vertical studs already modelled inside them |
| GA Cullen | One horizontal beam or one sheet panel layer belonging to a wall (e.g., a soleplate or sheathing layer) |

No external XML settings files are required.

---

## How to Use

### Step 1: Launch the script

Run `hsbCullenDistribute` from the hsbCAD tool menu or the AutoCAD command line. A dialog box appears where you configure the connector type and spacing before selecting any elements.

### Step 2: Set connector type and spacing in the dialog

Choose the **Type** that matches your structural situation and enter the spacing values. See the [Properties Panel](#properties-panel-opm-parameters) section for a full description of each setting. Click OK to close the dialog and proceed.

### Step 3: Select elements (prompt varies by type)

The command line prompt that appears depends on the chosen type:

- **FAS or PC:** `Select the crossing stick frame walls(s)` - click on all walls that share a junction. You must select at least two walls. The script automatically identifies corner connections (where one wall end meets another) and T-connections (where a wall end meets the face of another wall) and places connectors at each junction point it finds.

- **ST-PFS:** `Select the stick frame walls(s)` - click on one or more walls. The script distributes connectors horizontally across the vertical studs within each selected wall.

- **GA Cullen:** Two prompts appear in sequence:
  1. `Select the sheet or horizontal beam of the wall where bracket will be distributed` - click on the soleplate, top plate, or sheathing sheet where brackets should be placed. Only horizontal beams are accepted; a vertical stud will cause an error.
  2. `Select point that define the edge of the bracket` - click a point near the edge of the selected beam or sheet to tell the script which side the brackets should face.

### Step 4: Result

The script calculates connector positions within the available length (accounting for your Distance Bottom/Start and Distance Top/End margins), places individual connector instances, and then deletes itself. You will see the connector objects appear but the `hsbCullenDistribute` entity will no longer be visible - this is the expected behaviour.

---

## Properties Panel (OPM Parameters)

These properties appear in the AutoCAD Properties Palette when the script dialog opens, and can be adjusted later if you re-run the script. They are grouped into two categories.

### General

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Type | Dropdown | FAS | The connector family to distribute. Choose **FAS** for framing anchors at wall crossings, **PC** for panel closers at wall junctions, **ST-PFS** for stud-to-plate connectors along wall studs, or **GA Cullen** for angle brackets along a beam or sheet. |
| Distance Bottom/Start | Number (mm) | 0 | The clear gap from the bottom (or start) end of the element to the centre of the first connector. Increase this to keep connectors away from the base of the wall or end of the beam. Negative values are automatically reset to 0. |
| Distance Top/End | Number (mm) | 0 | The clear gap from the top (or end) of the element to the centre of the last connector. Increase this to keep connectors away from the head of the wall or the far end of the beam. Negative values are automatically reset to 0. |
| Distance Between | Number (mm) | 0 | The centre-to-centre spacing between consecutive connectors. The script distributes as many connectors as fit evenly within the available length. Enter a **negative value** (for example -1) to switch to count-based mode, where you set the total count using **Nr. Parts** instead. After calculation the field updates to show the actual computed spacing. |
| Nr. Parts | Integer | 0 | The total number of connectors to place. This setting is only active when **Distance Between** is negative. The script divides the available length equally among the requested number of connectors. The minimum enforced value is 2. After calculation the field updates to show the actual count placed. |
| Swap X-Y | Dropdown | No | Flips the orientation of the connector 180 degrees (effectively rotating it upside-down). Set to **Yes** if the connector is placed on the wrong face. Applies to FAS and PC types. |

### Soleplate

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Offset GA | Number (mm) | 10 | Only relevant when using **GA Cullen** type on a soleplate beam. Shifts the angle bracket inward from the plate edge by the specified amount. The offset is applied in the female (inward) direction. |

---

## Right-Click Menu Options

This script does not add any custom right-click (context) menu items via `addRecalcTrigger`. There are no additional menu commands to use after the connectors have been generated.

---

## Tips and Notes

**Counting connectors instead of spacing them**
Set **Distance Between** to any negative number (e.g., `-1`) and enter the exact number of connectors you want in **Nr. Parts**. The script will calculate and apply the correct even spacing automatically. After running, both fields update to reflect the values actually used.

**Script disappears after running**
This is intentional. The `hsbCullenDistribute` instance deletes itself (`eraseInstance()`) after placing all connectors. The individual connector objects (hsbCullenFAS, hsbCullenPC, hsbCullenSt, or GA instances) remain in the drawing and are fully parametric.

**FAS and PC require at least 2 walls**
If you select only one wall for the FAS or PC type, the script aborts with the message "at least 2 walls needed" and removes itself without placing anything. You must select all walls that share the junction.

**T-junctions get two connector sets**
For FAS type, when the script detects a T-connection (one wall end sitting against the face of another wall), it automatically creates two sets of connectors, one for each side of the junction. You do not need to run the script twice.

**GA Cullen requires a horizontal beam**
For the GA Cullen type, selecting a vertical stud will cause the script to report "only horizontal beams are allowed for inserting distribution" and exit. Always select a plate, soleplate, or horizontal rail when using this type.

**Soleplate offset direction**
When distributing GA Cullen brackets along a soleplate, the **Offset GA** value shifts the bracket in the female (inward-facing) direction. The connector's placement script (`GA`) receives the offset as a negative value so that it moves toward the interior face of the plate.

**Wall heights must overlap**
For FAS and PC types, the script checks that the two selected walls share a common vertical range. Walls that are entirely above or below each other will be skipped with the message "no common range". Make sure your walls are modelled at overlapping height ranges.

**Connector model hardcoded for GA Cullen**
When using the GA Cullen type, the connector is always set to manufacturer "Cullen UK", family "SP", model "SP-100x100x50", with fixing "screw+square twist nails". This cannot be changed through the Properties Panel.

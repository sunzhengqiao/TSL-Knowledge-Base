# hsb_ColumnBaseWithGluedRods

## Overview

This script creates a complete steel-to-timber column base connection directly on a structural timber beam (column). It generates three interconnected elements:

- A **Top Plate** (steel) — attaches to the end of the timber column with drilled holes for glued-in rods.
- A **Bottom Plate / Base Plate** (steel) — sits at the foundation level with drilled holes for anchor bolts.
- A **Stub** (timber, profile-based) — spans between the two steel plates, connecting them structurally.

The script applies machining tools automatically: the top plate drill pattern creates matching holes both in the steel plate and in the timber column (to receive glued-in rods), while the base plate receives holes for anchor bolt pass-through.

All three elements are dynamically linked: if the host beam is moved or resized, the connection assembly updates accordingly.

---

## Usage Environment

| Property | Value |
|---|---|
| Script Type | E-Type (Element — attaches to a structural beam) |
| Environment | Model Space only |
| Beams Required | 1 (the timber column to receive the base connection) |
| Version | 1.0 (01.01.2008, Bruno Bortot) |

---

## Prerequisites

- A timber structural beam (GenBeam) representing the column must already exist in the drawing.
- The **Extrusion Profile** you intend to use for the stub must exist in your hsbCAD profile catalog. If the profile name is invalid, the stub will not render correctly.
- The script is placed at the bottom end of the column; ensure the coordinate system (UCS) is oriented correctly before insertion.

---

## How to Use

### Step 1 — Start the Script

Launch the script via the hsbCAD tool panel or the `TSLINSERT` command and select `hsb_ColumnBaseWithGluedRods`.

If the script is assigned to a catalog entry (product library), properties may be pre-populated automatically when launched from that catalog.

### Step 2 — Configure Properties in the Dialog

A properties dialog opens immediately before any geometry is placed. Review and adjust all parameters (plate dimensions, drill patterns, stub profile, steel grade) before proceeding.

Click **OK** to confirm.

### Step 3 — Select the Host Beam

At the command prompt, click on the timber column (GenBeam) that will receive the base connection. This beam will have glued-in rod holes drilled into it by the script.

### Step 4 — Set the Insertion Point

Click in the model to define the origin point of the connection. This is typically the base face of the column or the centerline of the top plate contact surface.

The script then generates:
- The top plate at the insertion point
- The stub spanning downward by the specified Overall Foot Height
- The base plate at the far end of the stub

### Step 5 — Adjust After Insertion (Optional)

Select the inserted entity and open the **Properties Palette** (Ctrl+1) to modify any parameter. The geometry and machining update automatically when properties are changed.

---

## Properties Panel (OPM Parameters)

### General

| Property | Type | Default | Description |
|---|---|---|---|
| Steel Grade | Text | `S275` | Material grade designation applied to both steel plates (e.g., S275, S355). Used in the Bill of Materials. |
| Color | Integer | `-1` | Display color index for all steel elements. `-1` means ByLayer (inherits the current layer color). |

### Stub

| Property | Type | Default | Description |
|---|---|---|---|
| Overall Foot Height | Number (mm) | `300` | The total vertical distance between the top plate and the base plate. This controls the effective length of the connecting stub. |
| Extrusion Profile Name | Dropdown (Catalog) | *(from catalog)* | The cross-section profile for the timber stub. Must match a valid profile name in the hsbCAD extrusion profile catalog. |
| Flip Direction | Dropdown (Yes / No) | `Yes` | Rotates the stub profile by 90 degrees around the beam axis. Use this when the stub's width and depth orientation does not align correctly with the connecting plates. |

### Base Plate (Bottom Steel Plate)

| Property | Type | Default | Description |
|---|---|---|---|
| Name | Text | `Base Plate` | Label for the base plate entity, used in the Bill of Materials. |
| Base Plate Thickness | Number (mm) | `20` | Thickness of the bottom steel plate. |
| Base Plate Length | Number (mm) | `400` | Overall length of the base plate (along the beam's Y-axis). |
| Base Plate Width | Number (mm) | `300` | Overall width of the base plate (along the beam's Z-axis). |
| Quantity of Drill Rows | Integer | `3` | Number of rows of anchor bolt holes. |
| Quantity of Drill Columns | Integer | `3` | Number of columns of anchor bolt holes. |
| Drill Row Centers | Number (mm) | `100` | Center-to-center spacing between anchor bolt rows. |
| Drill Col Centers | Number (mm) | `100` | Center-to-center spacing between anchor bolt columns. |
| Drill Diametre | Number (mm) | `20` | Nominal diameter of anchor bolt holes in the base plate. |
| Drill Tolerance | Number (mm) | `2` | Additional clearance added to the hole diameter (actual hole = Drill Diameter + Tolerance). |
| Offset Side 1 | Number (mm) | `50` | Offset of the base plate center from the beam axis in the Y-direction. Use to place the plate eccentrically relative to the column. |
| Offset Side 2 | Number (mm) | `60` | Offset of the base plate center from the beam axis in the Z-direction. |

### Top Plate (Upper Steel Plate — at column end)

| Property | Type | Default | Description |
|---|---|---|---|
| Name | Text | `Top Plate` | Label for the top plate entity, used in the Bill of Materials. |
| Top Plate Thickness | Number (mm) | `20` | Thickness of the top steel plate. |
| Top Plate Length | Number (mm) | `200` | Overall length of the top plate (along the beam's Y-axis). |
| Top Plate Width | Number (mm) | `300` | Overall width of the top plate (along the beam's Z-axis). |
| Quantity of Drill Rows | Integer | `3` | Number of rows of rod holes through the top plate and into the timber. |
| Quantity of Drill Columns | Integer | `3` | Number of columns of rod holes through the top plate and into the timber. |
| Drill Row Centers | Number (mm) | `50` | Center-to-center spacing between rod hole rows. |
| Drill Col Centers | Number (mm) | `50` | Center-to-center spacing between rod hole columns. |
| Drill Diametre | Number (mm) | `20` | Nominal diameter of the glued-in rod holes in the top plate. |
| Drill Tolerance | Number (mm) | `2` | Additional clearance added to the plate hole diameter. The matching timber holes use the nominal diameter without tolerance. |
| Drilling Depth | Number (mm) | `200` | Depth to which the glued-in rod holes are drilled into the timber column. |

---

## Right-Click Menu Options

This script does not define custom right-click (context) menu items. After insertion, all parameters are accessible through the standard **Properties Palette** (Ctrl+1).

---

## How the Geometry is Built

Understanding the internal logic helps when troubleshooting unexpected results:

1. **Top Plate** is placed at the insertion point (`_Pt0`), centered on the beam axis with its thickness extending outward along `_X0`.

2. **Drill pattern for glued-in rods** is computed as a grid centered on the top plate. For each hole position:
   - A clearance drill is applied to the **top plate** itself (diameter = Drill Diameter + Tolerance).
   - A precision drill is applied to the **timber column** to the specified Drilling Depth (diameter = nominal Drill Diameter).

3. **Base Plate** is placed at a distance of `Overall Foot Height` along `_X0` from the insertion point, with additional lateral offsets applied via Offset Side 1 and Offset Side 2.

4. **Anchor bolt holes** are drilled through the base plate only (not into any concrete or foundation element — those connections are handled separately).

5. **Stub** is created between the two plates and dynamically stretched to meet them. The Flip Direction property controls whether the stub's local Y and Z axes are swapped, changing which face of the stub profile is wider.

6. The **timber column** is dynamically stretched to meet the top plate, so moving the assembly keeps the column geometry correct.

---

## Tips and Notes

- **Profile must exist in the catalog**: The Extrusion Profile Name dropdown lists all available profiles from the active hsbCAD installation. If you type a name manually that does not exist, the stub will not display correctly. Always select from the dropdown.

- **Hole diameter vs. tolerance**: The base plate and top plate holes are drilled oversized (Diameter + Tolerance) to allow bolt/rod insertion. The timber holes are drilled to the exact nominal diameter for a tight glue bond. Set the tolerance to match your fabrication requirements.

- **Eccentric base plates**: Use Offset Side 1 and Offset Side 2 when the base plate must be shifted off-center relative to the column centerline (e.g., for edge columns against a wall). These offsets move the base plate in both lateral directions independently.

- **Flip Direction**: If after insertion the stub profile appears rotated incorrectly (e.g., an I-profile's web is running in the wrong direction), toggle this property between Yes and No to correct the orientation.

- **Steel Grade for BOM**: The Steel Grade property is a free-text field that feeds directly into the Bill of Materials. Enter the exact grade designation your project specification requires (e.g., S275, S355, A36).

- **Dynamic update**: Because the stub and the timber column are linked to the plates via `stretchDynamicTo`, repositioning or resizing any connected element in the model will cause the assembly to recalculate automatically.

- **Insertion cycle guard**: If you accidentally trigger a second insertion cycle (e.g., pressing a hotkey twice), the script will erase the partially placed instance automatically and stop. Simply start the insertion again.

---

## Frequently Asked Questions

**Q: The stub beam does not appear after insertion. What is wrong?**
Check the Extrusion Profile Name property. It must exactly match a profile name in your hsbCAD catalog. Open the Properties Palette, click the profile field, and select from the dropdown list.

**Q: How do I change the number of anchor bolts in the base plate?**
Adjust the "Quantity of Drill Rows" and "Quantity of Drill Columns" properties in the Base Plate section of the Properties Palette. Also update the "Drill Row Centers" and "Drill Col Centers" to control the spacing of the bolt pattern.

**Q: The base plate holes and timber holes are different sizes. Is that correct?**
Yes, this is by design. The timber holes (glued-in rods) are drilled to the nominal diameter for a glued connection. The steel plate holes are drilled to nominal + tolerance to allow the rod or bolt shank to pass through freely.

**Q: Can I use this script for a wall post base instead of a column?**
Yes. As long as the host element is a single GenBeam, the script can be applied to any vertical or inclined timber member. Ensure the insertion point and UCS are aligned with the member's end.

**Q: How do I shift the base plate sideways?**
Use the "Offset Side 1" and "Offset Side 2" properties in the Base Plate section. These shift the plate center relative to the beam axis in the two lateral directions independently.

# hsbBeamcut

## Overview

`hsbBeamcut` is a parametric TSL tool (Type O) for hsbCAD that creates a rectangular notch or cutout on one face of a timber beam. The cut is defined by three dimensions: **Length** (along the beam axis), **Width** (perpendicular to the beam face within the face plane), and **Depth** (how far the cut penetrates into the beam from the selected face). The tool attaches itself to a reference entity and recalculates automatically whenever the linked entity moves or resizes.

Supported reference entities include:

- A single **GenBeam** (timber member)
- A **Wall Element** (ElementWallSF)
- A **Door or Window Opening** (OpeningSF)
- An **Installation Point** (TslInst with conduit data)

A beamcut is commonly used in timber construction to create half-lap joints, ledger cuts, housings for crossing beams, header pockets, and clearance recesses for hardware or MEP penetrations. Because `hsbBeamcut` is a parametric TslInst, every dimension stays live: change the beam size or reposition the wall and the cut updates without manual intervention.

**Current version:** 2.6 (04 March 2025)

**Keywords:** Beam, Beamcut

---

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Applies a 3D Boolean cut directly to one or more timber GenBeam bodies. |
| Paper Space | No | This is a 3D modeling tool, not a drawing or annotation tool. |
| Shop Drawing | No | Not applicable. The cut geometry feeds into downstream shop drawing generation automatically. |

---

## Prerequisites

Before inserting `hsbBeamcut`, at least one of the following entities must exist in the model:

- A **GenBeam** (timber member) to receive the cut. The tool links directly to the beam and re-applies the cut if the beam changes.
- A **Wall Element (ElementWallSF)** -- the tool scans the wall for horizontal beams whose bodies intersect the cutting volume and applies the notch to all matching members. Vertical members (studs running parallel to the wall Y axis) are excluded automatically.
- A **Door or Window Opening (OpeningSF)** -- when linked to an opening, the tool can automatically derive its Length from the opening width (if Length is set to 0).
- An **Installation Point (TslInst with conduit data)** -- for MEP or conduit routing scenarios where a penetration pocket is needed at the top, bottom, or both faces of a beam. When the installation point is configured for "Both" sides, two separate beamcut instances are created automatically.

No entities need to be pre-selected before starting the command.

---

## How to Use

### Step 1 -- Start the Command

Launch the tool using the hsbCAD ribbon, a tool palette, or the AutoCAD command line:

```
(hsb_ScriptInsert "hsbBeamcut")
```

### Step 2 -- Select Preset or Set Values

A dialog opens showing available catalog presets. Select a named preset to load saved values, or adjust the dimensions manually and press **OK**. If a catalog key is passed programmatically via `_kExecuteKey`, the dialog is skipped and the matching preset is applied silently. If the key does not match any existing catalog entry, the last-inserted values are used as a fallback.

### Step 3 -- Select the Reference Entity

The command prompt reads:

```
Select reference item (Beam, Walls, E-Installations or Doors)
```

Click on the beam, wall element, opening, or installation point that the beamcut should be attached to.

- If you select a **GenBeam**, the tool links to that single beam and proceeds to point input.
- If you select a **Wall Element**, the tool links to the wall, locks the Reference Side to ECS -Y, and proceeds to point input. Only horizontal members within the wall receive the cut.
- If you select a single **Opening** with Length > 0, the tool links to the opening and proceeds to point input.
- If you select one or more **Openings** (with Length = 0 or multiple selected) or **Installation Points**, a beamcut instance is created for each selected entity in a single batch operation. No further point input is required; the tool computes each position automatically and then the inserting instance erases itself.

### Step 4 -- Define the Cut Location

Prompts differ based on the selected reference and the current Length setting:

**When Length > 0 (fixed length mode):**

```
Insertion Point
```
Click to place the start point of the cut on or near the reference beam face.

```
Specify direction, <Enter> to insert at center
```
Move the cursor to indicate which direction the cut extends, then click. Press Enter to center the cut at the clicked insertion point.

**When Length = 0 (full-length / dynamic mode):**

```
Pick point to specify length by points, <Enter> to insert full length
```
Click a start point, or press Enter to let the tool span the entire solid length of the referenced beam automatically.

```
Pick second point
```
Click the end point to set the length explicitly from two picked points.

**When linked to a Wall Element with no grips provided:** the tool centers itself on the wall origin and spans the full wall length.

**When linked to an Opening or Installation Point:** the position is calculated automatically. If point prompts appear, pressing Enter at both accepts the automatically computed position.

### Step 5 -- Adjust in the Properties Palette

After placement, select the `hsbBeamcut` entity and open the **Properties Palette** (OPM) to change any parameter. The cut recalculates immediately. Two grip points are also available for direct graphical editing in the viewport.

---

## Properties Panel (OPM Parameters)

### Geometry

| Parameter | Default | Description |
|-----------|---------|-------------|
| **Length** | 300 mm | Length of the cut along the beam long axis (ECS X). Set to **0** to use full-length mode, which automatically spans the entire solid length of the referenced beam. When linked to an opening with Length = 0, the opening width is used. When linked to an installation point with Length = 0, the width is derived from the larger of the reference-side and opposite-side milling dimensions for the active side (top or bottom) of the installation point. |
| **Width** | 30 mm | Size of the cut in the direction perpendicular to the beam face within the face plane (typically ECS Y or ECS Z depending on Reference Side). Set to **0** to span the full beam dimension in that direction. When more than one beam is linked (via Add Beam), Width = 0 expands to cover the combined outermost extents of all linked beams. |
| **Depth** | 30 mm | How deep the cut penetrates into the beam from the selected reference face, measured inward along the face normal. Must be greater than 0 for the cut to be applied. |

### Alignment

| Parameter | Default | Options / Notes |
|-----------|---------|-----------------|
| **Offset** | 0 mm | Shifts the center of the cut sideways along the beam cross-section axis (the axis perpendicular to both the beam length and the face normal). Enter a positive or negative value to offset from the beam centerline. Typing `+` or `-` snaps the cut to the positive or negative edge of the beam in that direction. When the insertion point (_Pt0) is dragged in the viewport, this value updates automatically. |
| **Reference Side** | ECS Y | Selects which face of the beam the cut originates from, relative to the beam Element Coordinate System. Options: **ECS Y** (positive Y face), **ECS Z** (positive Z face), **ECS -Y** (negative Y face), **ECS -Z** (negative Z face). When attached to a Wall Element or Opening, this property is locked to ECS -Y and set to read-only. |

---

## Right-Click Menu Options

When `hsbBeamcut` is selected in the model, two additional items appear in the right-click context menu:

### Add Beam

Prompts you to select one or more GenBeam members to add to this beamcut target list. The cut is then applied to all beams in the combined list. Use this when the automatic intersection detection did not capture every beam you intend to notch, or when you want one beamcut definition to affect a stack of multiple beams simultaneously.

```
Select beams
```

Programmatic trigger:
```
(hsb_RecalcTslWithKey "Add Beam" "Select Tool")
```

### Remove Beam

Prompts you to select one or more currently linked GenBeam members to remove from the target list. The tool enforces a minimum of one beam in the list and will not remove the last remaining linked beam.

```
Select beam(s)
```

Programmatic trigger:
```
(hsb_RecalcTslWithKey "Remove Beam" "Select Tool")
```

---

## Grip-Based Editing

Two grip points are displayed on the entity after placement, positioned at the diagonal corners of the cut face. The grips allow direct graphical editing:

| Drag Direction | Effect |
|----------------|--------|
| Along the beam X axis | Changes **Length**. Both grips move symmetrically. |
| Within the face plane, perpendicular to beam axis | Changes **Width** and **Offset** simultaneously. |
| Along the face normal (toward or away from the beam) | Changes **Depth**, provided neither Length nor Width changed in the same grip move. |
| Diagonal movement | Width, Length, and Offset all update at once (since version 2.4, HSB-21189). |

When a grip is moved, the tool recalculates in a two-loop execution cycle to ensure all dependent dimensions update consistently.

---

## Double-Click Behavior

Double-clicking on a placed `hsbBeamcut` entity rotates the Reference Side setting one step at a time through the four face options:

ECS Y --> ECS Z --> ECS -Y --> ECS -Z --> ECS Y (cycle repeats)

This is the fastest way to flip a cut to an adjacent face without opening the Properties Palette. The grips are reset and the tool recalculates at the new face.

---

## Tips and Notes

**Full-length mode (Length = 0).** When Length is set to 0, the cut automatically spans the full solid length of the linked beam. If the beam is later extended or trimmed, the beamcut length updates on the next recalculation without manual adjustment.

**Full-width mode (Width = 0).** Setting Width to 0 spans the full beam dimension at the selected face. With multiple linked beams, the width extends to the combined outermost extents of all beams in the list, making it straightforward to notch a stacked plate or doubled header in one operation. When switching to full-width mode, the Offset is automatically reset to 0.

**Tolerance at flush faces.** When any face of the cutting volume aligns exactly flush with a face of the target beam -- a common occurrence at beam ends or wall plate intersections -- the tool automatically adds a small 1 mm tolerance extension outward in that direction (introduced in version 2.6, HSB-23612). This prevents the ACIS Boolean subtraction from failing due to coplanar face conditions that would otherwise produce no material removal.

**Installation point integration.** When linked to an `hsbInstallationPoint` whose milling setting is configured for both top and bottom, the tool automatically creates two separate `hsbBeamcut` instances: one positioned at the top conduit extreme point and one at the bottom extreme point. Each instance reads its length from the larger of the reference-side and opposite-side milling widths defined in the installation point (HSB-22941). The reference side is set automatically: ECS Y for top, ECS -Y for bottom.

**Wall attachment restrictions.** Attaching to a Wall Element locks the Reference Side to ECS -Y (the interior face of the wall framing) and excludes vertical members (studs running parallel to the wall Y axis) from the beam scan, since only horizontal plates and headers receive the notch in this mode. The insertion point is projected onto the wall Y-axis plane through the wall origin.

**Beam dimension tracking.** If the dimensions of a linked GenBeam change (for example, the beam depth or width is modified), the tool detects the mismatch between stored grip positions and the current beam geometry and triggers a recalculation to keep the cut aligned (HSB-18550, version 2.3).

**Copying the tool.** `hsbBeamcut` supports being copied to a new location. The copy retains its reference to the original GenBeam. Use Add Beam / Remove Beam after copying to reassign the cut to a different beam if needed.

**Catalog presets.** Common cut configurations (for example, a standard 300 x 30 x 30 mm ledger notch or a 50 x 50 mm service pocket) can be saved as named catalog entries. On subsequent insertions, pass the catalog name as the execute key to skip the dialog and apply those values immediately, streamlining repetitive workflows. Note: catalogs from versions prior to 1.2 are incompatible due to a property structure change.

**Visual feedback.** During recalculation, the tool displays colored axis indicators at the reference point: red for positive X, green for positive Y, and blue-grey for positive Z, with darker shades for the negative directions. The cut body is shown in a color matching the current Reference Side selection (color 140 for ECS Y, 170 for ECS Z, 230 for ECS -Y, 120 for ECS -Z). When attached to a wall or element and the matching beam has not yet been found, a semi-transparent shadow profile is drawn in plan and elevation views to indicate the intended cut location.

**Backward compatibility.** Instances created with versions prior to 1.2 stored alignment data in a different property layout. Those older instances are detected and the conversion code (commented out in current version) was designed to recreate them with the current property structure.

---

## Version History

| Version | Date | Change |
|---------|------|--------|
| 2.6 | 04 Mar 2025 | HSB-23612: Added extra 1 mm tolerance when beamcut face exactly aligns with GenBeam face to prevent Boolean subtraction failures. |
| 2.5 | 11 Nov 2024 | HSB-22941: When attached to installation point with Length = 0, uses the milling width of the active side (reference or opposite) rather than a single property value. |
| 2.4 | 25 Jan 2024 | HSB-21189: Grip changes no longer reset when the trigger comes from moving grips; allows simultaneous width and length changes via diagonal grip drag. |
| 2.3 | 13 Apr 2023 | HSB-18550: Tool now detects GenBeam dimension changes and triggers recalculation to maintain alignment. |
| 2.2 | 29 Apr 2019 | HSB-4858: Splitting, adding, and removing of beams enhanced. Description updated. |
| 2.1 | 29 Apr 2019 | HSB-4858: Splitting, adding, and removing of beams enhanced. |
| 2.0 | 26 Feb 2019 | Validation on element deleted. |
| 1.9 | 19 Feb 2019 | Alignment limited to bottom side (ECS -Y) when attached to a wall. |
| 1.8 | 19 Feb 2019 | Grip behavior fixed for walls, openings, and installation points. |
| 1.7 | 01 Feb 2019 | Added support for selection of walls, openings, and installation points. Display now supports view directions. |
| 1.6 | 31 Jan 2019 | Initial support for selection of walls, openings, and installation points. |
| 1.5 | 08 Nov 2018 | Bugfix for validation. |
| 1.4 | 09 Aug 2018 | Tool can be copied. |
| 1.3 | 09 Aug 2018 | Alignment property based on ECS (Element Coordinate System). |
| 1.2 | 31 Jul 2018 | Major revision: property structure changed (old catalogs incompatible), new commands, grip-based editing for all dimensions. |
| 1.1 | 17 May 2017 | Alignment options reduced and insert mechanism redesigned. |

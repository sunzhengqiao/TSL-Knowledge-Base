# hsbCLT-OpeningSupport

## Overview

`hsbCLT-OpeningSupport` automatically generates structural support crosspieces (bridges) across openings in CLT (Cross-Laminated Timber) panels. These temporary supports stabilize window cutouts, door openings, and edge openings during transport, lifting, and erection, preventing panel deformation before permanent structural connections are established on site.

The script operates in two internal modes:

- **Creation / Distribution Mode** (mode 0): The user-facing mode. It scans selected CLT panels for openings matching configured filter criteria and automatically places a support crosspiece inside each qualifying opening. Each created support becomes a child instance running in Single Support Mode. The creation instance erases itself after distribution is complete.
- **Single Support Mode** (mode 1): Each individual crosspiece persists as an intelligent entity in the drawing. It tracks which opening it belongs to, displays a filled support shape on screen, and exposes display properties (Color, Transparency) in the Properties Palette. A right-click context menu command allows clean removal of the support.

Script version: **1.5** (06 July 2020). Keywords: CLT, Opening, Door, Crosspiece, Bridge, Transport, Support.

---

## Usage Environment

| Property | Value |
|---|---|
| Script Type | `O` (Object) |
| Beams Required | 0 |
| Space | Model Space |
| Target Entities | CLT Panels (`Sip` type) |
| Persistent | No (creation instance self-erases); Yes (child support instances persist) |
| Implicit Insert | Yes |

This script runs entirely in Model Space and operates on CLT panel (`Sip`) entities. No beams or structural members need to be pre-selected. The creation instance is non-resident: it distributes supports and then erases itself from the drawing. Only the individual child support instances remain.

---

## Prerequisites

Before using this tool, ensure the following:

- One or more **CLT panels** (`Sip` entities) exist in the current drawing with defined openings (windows, door edges, or custom cutouts).
- The panels must be fully constructed so that their opening geometry is available for analysis.
- If you intend to use the **bySelection** or **byLine** insertion modes, identify the specific openings or edge locations beforehand so you can click them during the insertion prompts.
- Optionally, a **catalog entry** for `hsbCLT-OpeningSupport` (and/or `hsbCLT-OpeningSupport-Display` for the child instances) can be defined in hsbCAD so that preset configurations are loaded automatically when triggered by a catalog key.

---

## How to Use

### Step 1 -- Launch the Tool

Insert the script using the hsbCAD Script Manager or by running the command:

```
TSLCONTENT
```

(mapped to `hsbCLT-OpeningSupport` in the AutoCAD menu.)

### Step 2 -- Configure Parameters in the Dialog

A dialog box opens where you set the geometry and filter parameters described in the Properties Panel section below. If a valid catalog entry key is passed at launch, the dialog is skipped and values are loaded from the catalog automatically. If the key does not match any catalog entry, the dialog opens as a fallback.

### Step 3 -- Select Panels or Openings

After confirming the dialog, the tool behavior depends on the chosen **Opening Mode**:

**All, Window, or Door/Edge mode:**

The tool prompts:

> **Select panels**

Click to select one or more CLT panels. You can select multiple panels in a single operation; the tool will process every matching opening on all selected panels.

**bySelection mode:**

The tool first prompts you to select a single panel (via the `getSip()` dialog), then asks:

> **Select opening by a point inside or on the opening**

Click inside each opening you want to support. Continue clicking for multiple openings; press Enter or Escape to finish the selection loop.

**byLine mode:**

The tool first prompts you to select a single panel, then asks:

> **Pick start point of support**
> **Pick end point of support**

Click two points that define the line along which the support crosspiece should run. The tool intersects this line with the panel geometry to determine the exact support extent. Cancelling the second point prompt aborts the operation cleanly with no entities created.

### Step 4 -- Supports Are Placed Automatically

The tool calculates the crosspiece geometry for each qualifying opening and places a filled, colored display shape inside that opening. Each support is a persistent child TSL instance (mode 1) visible in the drawing. The parent creation instance erases itself once all supports are placed.

For each support created, the tool:
1. Computes the support rectangle based on Width, Alignment, and Offset settings.
2. Adds the support contour as a ring to the CLT panel (modifying the panel geometry).
3. Creates a child TSL instance of the same script (in Single Support Mode) attached to the panel.
4. If a catalog entry for `hsbCLT-OpeningSupport-Display` exists, applies the last-inserted catalog values to the child.

### Step 5 -- Adjust Individual Supports (optional)

Select any individual support crosspiece in the drawing to view its display properties (Color and Transparency) in the AutoCAD Properties Palette (OPM). These can be adjusted at any time without reinserting the tool.

### Step 6 -- Remove Supports When No Longer Needed

Right-click any support crosspiece and choose **Remove Support** from the context menu to delete it cleanly. The removal process reconstructs the original opening geometry in the CLT panel by merging the support contour back into the opening ring before erasing the instance.

---

## Properties Panel (OPM Parameters)

The following parameters are available when configuring the tool at insertion time. They appear under two categories: **Geometry** and **Filter**.

### Category: Geometry

| Parameter | Type | Default | Description |
|---|---|---|---|
| **Width** | PropDouble | 200 mm | The width of the support crosspiece measured perpendicular to the supporting direction. A wider crosspiece provides more bearing surface across the opening. Adjust this value based on the CLT panel thickness and the structural requirement of the bridging member. |
| **Alignment** | PropString | Automatic | Controls the direction in which the support bridges the opening. Three options: **Automatic** -- the tool selects the direction based on opening type (perpendicular to the open direction for door/edge openings; perpendicular to the largest opening dimension for window openings); **Horizontal** -- forces the support to run along the panel X-axis; **Vertical** -- forces the support to run along the panel Y-axis. Use Automatic in most cases and override only when the result does not match your design intent. |
| **Offset** | PropDouble | 0 mm | Shifts the center of the support crosspiece away from its default position. For window openings the default position is the opening center; for door/edge openings it is the open edge. A positive offset moves the support toward the interior of the panel. Use this to avoid clashing with other inserts or to match structural specifications. |

### Category: Filter

| Parameter | Type | Default | Description |
|---|---|---|---|
| **Opening Mode** | PropString | All | Determines which openings on the selected panels receive a support. Five options: **All** -- every opening that passes the minimum dimension check receives a support, including both window and door/edge types; **bySelection** -- only the openings you click during insertion receive supports; **Window** -- targets only interior window cutouts (openings fully surrounded by panel material); **Door/Edge** -- targets only openings that touch one edge of the panel perimeter (one free direction); **byLine** -- places a support along a manually defined two-point line segment rather than detecting openings automatically. |
| **Min. Dimension** | PropDouble | 0 mm | Openings whose relevant dimension (measured perpendicular to the selected alignment) is smaller than this value are skipped. Set this to filter out small notches, service penetrations, or minor cutouts that do not require transport bridging. A value of 0 disables the filter so all openings are processed. |

### Display Properties (on individual support instances)

After supports are placed, selecting a support crosspiece in the drawing reveals additional display properties under the **Display** category in the Properties Palette:

| Parameter | Type | Default | Description |
|---|---|---|---|
| **Color** | PropInt | 253 | AutoCAD color index for the filled support display shape. Adjust to distinguish supports by type or panel zone. |
| **Transparency** | PropInt | 80 | Transparency percentage for the filled display shape (0 = fully opaque, 100 = fully transparent). The high default (80%) keeps the support visible without obscuring the underlying panel geometry. |

---

## Right-Click Menu Options

When you right-click an individual support crosspiece instance in the drawing, the following context menu command is available:

| Command | Action |
|---|---|
| **Remove Support** | Removes the support crosspiece from the drawing and restores the original opening geometry in the CLT panel. The panel opening ring is reconstructed by merging the support contour back into the opening, then the instance is erased. Use this command when transport bridging is no longer needed, for example after the panel has been permanently installed and connected on site. |

Note: A double-click on the support does **not** trigger removal. This behavior was corrected in version 1.5 (HSB-7730); previously, double-clicking would accidentally remove the support.

---

## Opening Detection Logic

### Window Openings

Window openings are identified directly from the panel's `plOpenings()` list. These are interior cutouts fully surrounded by panel material. The tool retrieves all opening polylines from the Sip entity.

### Door/Edge Openings

Door and edge openings are detected by computing the difference between the panel's bounding rectangle and its actual profile. The tool creates a maximum bounding profile and subtracts the panel shape. Each resulting ring is tested for free directions by checking whether its midpoint extremes coincide with the bounding rectangle edges.

An opening qualifies as a door/edge opening only if it has **exactly one free direction** (one side open to the panel perimeter). Openings with multiple free directions (such as corner notches) are excluded to prevent ambiguous support placement. Additionally, if a specific alignment (Horizontal or Vertical) is selected, door openings whose free direction conflicts with the chosen alignment are excluded.

### Alignment Resolution

For **Automatic** alignment on window openings, the tool compares the X and Y extents of the opening and selects the larger dimension as the support direction. For door/edge openings, the open direction vector is used directly, and the support runs perpendicular to it.

---

## Position Tracking and Stability

Each individual support instance maintains its position through two mechanisms:

1. **Opening Index Tracking**: The instance stores which opening index it belongs to on its parent panel. If openings are added or removed from the panel after placement, the instance detects the change by comparing the stored opening count with the current count. When a mismatch is detected, it re-evaluates by finding the nearest opening to its current position and snaps to it.

2. **Reference Point Vector**: The instance stores its position as a vector relative to the panel's reference point (`sip.ptRef()`). If the panel is moved or regenerated, the support repositions itself to maintain the correct relative position.

When an opening index change is detected, the script calls `setExecutionLoops(2)` to force a recalculation pass that completes the snapping operation.

---

## Version History

| Version | Date | Description |
|---|---|---|
| 1.5 | 06 Jul 2020 | HSB-7730: Support removal restricted to context menu command only (double-click no longer triggers removal). Sloped support display alignment adjusted. |
| 1.4 | 03 Jul 2020 | HSB-7730: Each support now creates a persistent display instance instead of being drawn by the parent. |
| 1.3 | 21 May 2020 | HSB-5591: Bugfix for vertical/horizontal alignment on window openings. |
| 1.2 | 11 May 2020 | HSB-5591: New insertion mode `byLine` added. |
| 1.1 | 30 Apr 2020 | HSB-5591: Initial version. |

---

## Tips and Notes

- **Automatic direction selection** works correctly for most standard rectangular openings. Use the Horizontal or Vertical override only when the panel orientation or opening shape causes the automatic result to be incorrect.

- **byLine mode** is the most flexible insertion method. It allows you to draw a support at any position across an opening, including sloped supports on inclined panels. The tool uses your two-point line to compute split segments against the panel's real profile and creates the crosspiece within the correct plane of the CLT panel. Both window-interior and edge-adjacent placements are supported in this mode.

- **Door/Edge mode** specifically looks for openings where the cutout shares one edge with the panel perimeter -- that is, where the cutout opens outward in exactly one direction. Openings with more than one free direction (such as a corner notch) are excluded from door/edge detection to prevent ambiguous results.

- **Min. Dimension** is particularly useful on panels with many small service holes or electrical penetrations. Setting a minimum such as 300 mm ensures only structural-scale openings receive bridging and small utility holes are ignored.

- **Catalog entries** for `hsbCLT-OpeningSupport` and its display child (`hsbCLT-OpeningSupport-Display`) can be configured in hsbCAD to store preferred width, alignment, and color settings per project or standard detail. When a valid catalog entry is detected on insertion, the last-inserted catalog values are applied to each new support instance automatically.

- **Group assignment**: Each support instance is assigned to the same group as its parent panel with the group category `I` (Internal), making it easy to manage supports alongside their panels.

- The creation instance is a **non-resident TSL**: it performs its distribution work and then erases itself from the drawing. Only the individual child support instances remain. To add more supports to the same panel, run the tool again.

- If the support instance cannot find a valid support area (for example, if the opening geometry has been altered beyond recognition), it reports the message "could not find any support area" to the command line and erases itself.

- The script uses the panel's **envelope body** (not real body) for shadow profile calculations in Single Support Mode, which provides better performance on complex panels with many machining operations.

# AdjustableSupport

## Overview

`AdjustableSupport` is a TSL script for hsbCAD that automatically lays out adjustable pedestal support feet (Stellfüße — screw jacks) across a floor or roof area. The tool is designed for flat or sloped floor constructions where a raised decking system sits on a field of individually height-adjustable pedestals, a common technique in terrace, balcony, and flat-roof construction using insulation gradient systems (Gefälledämmung).

The outer boundary of the support area is not drawn manually. Instead, the script reads the geometry of existing **Raum** (room or zone) TSL instances that already define the construction volume below the floor. These instances provide the floor plan outline automatically. Within that outline, the script projects a configurable rectangular grid and places a support foot symbol at every grid intersection point.

Key capabilities include:

- **Dual-grid system:** A primary grid (Hauptraster) defines the standard pedestal spacing. An optional secondary grid (Hilfsraster) adds a finer layout for zones that require denser support, such as edges or concentrated load areas.
- **Interactive point editing:** After the grid is generated, individual support points can be added or removed interactively through the right-click context menu without altering the underlying grid definition.
- **Automatic pedestal type selection:** The script reads the required height of each pedestal (the vertical distance between the structural substrate surface and the target level) and matches it against a product catalog in `AdjustableSupport.xml`. Each point is assigned to the appropriate pedestal type and color-coded accordingly.
- **Bill of Materials integration:** Every pedestal instance is registered as a `HardWrComp` hardware component linked to the parent element group, so material takeoffs are populated automatically.
- **Linked level management:** The script automatically creates and maintains a child **Raum** instance representing the finished surface level. When the total construction height or top-layer thickness is changed in the Properties Palette, the child Raum is updated without any manual intervention.

**Script version:** 1.3 (09 June 2022)
**Keywords:** Rubner, Gefälledämmung, Insulation, Gradient, Leveling, Stellfüße

---

## Usage Environment

- **Script type:** O-Type (Object — inserted as a freestanding entity in Model Space; does not require pre-selected beams)
- **Works in:** Model Space only — not applicable in Paper Space or shop drawing layouts
- **Beams required:** 0
- **Settings file:** `[Company Path]\TSL\Settings\AdjustableSupport.xml`
  (Fallback: `[Install Path]\Content\General\TSL\Settings\AdjustableSupport.xml`)

---

## Prerequisites

Before inserting `AdjustableSupport`, confirm the following:

1. **Raum instances must exist in the drawing.** The script requires at least one valid `Raum` TSL instance in the model to derive the floor boundary and the substrate elevation. Without a base Raum, the script aborts immediately and removes itself from the drawing.

2. **Raum instances must not be aligned to a tilted plane.** Raum instances that have an associated `TslAlign` entity are treated as inclined surfaces and are excluded from boundary calculation. At least one non-inclined (horizontal) Raum must be present.

3. **The XML settings catalog must be present** at one of the two configured paths. The catalog defines the available pedestal product types (Stellfüße), their height ranges, and their display colors. If the file is missing, no pedestal type can be matched and the hardware BOM will be empty.

4. **Raum instances should have their substrate surface geometry stored in their internal map** (`ptPlaneTop` and `vecPlaneTop`). This is the standard output of the Raum script and is required for the pedestal height calculation at each grid point.

5. **Raum instances should belong to a named element group** for correct BOM assignment. Unassigned instances are supported but the hardware group name may be empty.

---

## How to Use

### Step 1 — Launch the tool

Type the insert command at the AutoCAD command prompt or launch `AdjustableSupport` from the hsbCAD tool palette. A dialog appears for initial property configuration (unless a catalog preset key is passed directly on the command line).

### Step 2 — Select Raum instances

The command line prompts: **"Select Raum tsls"**

Click to select one or more `Raum` TSL instances that define the floor zone where pedestals are needed. Standard AutoCAD selection methods (single click, window, crossing) are accepted.

The script internally:
- Filters the selection to keep only valid `Raum` instances.
- Identifies the lowest (bottom-most) Raum by Z-elevation to use as the structural substrate reference level.
- Projects the combined footprint of all selected Raum volumes onto a horizontal plane to derive the outer boundary of the pedestal field.

If no valid Raum is found, the script prints a message and cancels: "No base Raum found."

### Step 3 — Set the grid origin and optionally adjust grid parameters

The command line prompts: **"Select Insertion Point or [gridX/gridY/offseTX/offseTY]"**

Move the cursor inside the floor contour. The grid preview is drawn live on screen, updating as the cursor moves. The grid origin snaps to endpoints and midpoints.

Before clicking to confirm the insertion point, you may type keyword letters to change grid parameters on the fly:

- Type **G** or **gridX** to enter a new primary X spacing at the command line.
- Type **g** or **gridY** to enter a new primary Y spacing.
- Type **o** or **offseTX** to enter a grid offset in X.
- Type **t** or **offseTY** to enter a grid offset in Y.

Click to confirm the insertion point. Press Escape to cancel and remove the instance.

### Step 4 — Review the generated layout

The script calculates all grid intersection points that fall within the floor boundary and draws the complete grid pattern. For each point, it:
- Determines the pedestal height by intersecting a vertical line with the substrate surface of the Raum at that location, plus the sealing layer thickness.
- Looks up the matching pedestal type in the catalog by height range.
- Draws the pedestal body (a cylinder), the symbol circle, and optionally a text label at each valid point.
- Color-codes each pedestal symbol according to the catalog entry for that size type.

Points where no matching pedestal type can be found (height outside all catalog ranges) are flagged as non-valid and not drawn as symbols.

### Step 5 — Adjust properties in the Properties Palette

Click the `AdjustableSupport` instance to select it. Open the Properties Palette (Ctrl+1). Modify any parameters described in the section below. The layout recalculates automatically after each change.

Note: Changing any primary grid spacing or offset property (Grid X, Grid Y, Offset X, Offset Y) automatically resets all manually added and deleted points, reverting the layout to the pure grid. Make grid adjustments first, then add manual points.

### Step 6 — Manually add or remove individual support points (optional)

Right-click the instance to access the context menu. Use **Add/Delete Point** or **Reset Points** as needed. See the Right-Click Menu Options section for details.

---

## Properties Panel (OPM Parameters)

Properties are organized into four categories in the AutoCAD Properties Palette.

### Category: Boden (Floor Construction)

These parameters define the vertical geometry of the floor assembly.

| Property | Type | Default | Description |
|---|---|---|---|
| **Gesamte Dicke** | Length | 300 mm | Total vertical construction height of the floor assembly, measured from the bottom of the substrate to the top of the finished surface. This value drives the height of the child Raum instance that represents the finished level. |
| **Thickness Boden** | Length | 20 mm | Thickness of the top finishing layer (e.g., decking boards, tiles, or the final insulation layer). This value is subtracted from the total height when setting the target elevation for the finished surface Raum. |
| **Stärke Abdichtung** | Length | 10 mm | Thickness of the waterproof sealing layer (e.g., bitumen membrane) applied over the structural substrate. This thickness is added to the substrate surface elevation when calculating the required pedestal height at each grid point. |

### Category: Hauptraster (Primary Grid)

These parameters define the regular, main support grid.

| Property | Type | Default | Description |
|---|---|---|---|
| **AbstandX 1** | Length | 600 mm | Center-to-center spacing between pedestal positions along the world X-axis. Must be greater than zero; the script resets this to 300 mm if a non-positive value is entered. |
| **AbstandY 1** | Length | 600 mm | Center-to-center spacing between pedestal positions along the world Y-axis. Must be greater than zero; the script resets this to 300 mm if a non-positive value is entered. |
| **Offset X 1** | Length | 0 mm | Shifts all primary grid lines in the X-direction by this amount from the insertion point. Use this to align the grid with a structural axis or an edge of the floor. Changing this value resets manually edited points. |
| **Offset Y 1** | Length | 0 mm | Shifts all primary grid lines in the Y-direction from the insertion point. Changing this value resets manually edited points. |

### Category: Hilfsraster (Secondary / Helper Grid)

The secondary grid is an independent, finer grid used to add supplementary pedestal positions without changing the primary layout.

| Property | Type | Default | Description |
|---|---|---|---|
| **AbstandX 2** | Length | 300 mm | Center-to-center spacing for the secondary grid in the X-direction. |
| **AbstandY 2** | Length | 300 mm | Center-to-center spacing for the secondary grid in the Y-direction. |
| **Offset X 2** | Length | 0 mm | Shifts the secondary grid lines in the X-direction from the insertion point. |
| **Offset Y 2** | Length | 0 mm | Shifts the secondary grid lines in the Y-direction from the insertion point. |
| **Sichtbarkeit** | Yes / No | No | Controls whether the secondary grid lines are drawn on screen. Set to Yes to see the secondary grid pattern for layout review. |
| **Stellfuß** | Yes / No | No | When set to Yes, pedestal symbols and BOM entries are also generated at secondary grid intersection points (in addition to primary grid points). When set to No, the secondary grid is used for visual reference only and no pedestals are placed at secondary-only positions. |

### Category: Darstellung AdjustableSupport (Display Settings)

| Property | Type | Default | Description |
|---|---|---|---|
| **Symbol** | Yes / No | No | When set to Yes, draws the 3D cylindrical pedestal body and the annotated circle symbol at each valid support point. Set to No to suppress the 3D geometry (the grid lines are still drawn). |
| **Text** | Yes / No | No | When set to Yes, draws a text label next to each valid pedestal showing the product name and the calculated height in millimeters. Format example: `SE 2_50-75mm, PH= 62.3mm`. |

---

## Right-Click Menu Options

### Add/Delete Point

Enters an interactive editing session for manually adjusting individual pedestal positions. The session operates in two alternating modes that can be switched at any time.

**Add mode** (default when the trigger is first activated):
- The command line prompts: "Select new point to insert or [Delete/Finish]"
- Move the cursor inside the floor contour. A green circle previews where the new point will be added.
- Left-click to add a pedestal at the cursor position. The point is accepted only if it is inside the floor boundary and not within 100 mm of an existing point.
- Type **D** or select the **Delete** keyword to switch to Delete mode.
- Type **F** or select the **Finish** keyword to end the session and recalculate.

**Delete mode**:
- The command line prompts: "Select new point to delete or [Add/Finish]"
- Move the cursor near the point to be removed. A red circle snaps to the nearest existing point.
- Left-click to mark the nearest point for deletion. It is shown with a red cross marker.
- Type **A** or select the **Add** keyword to switch back to Add mode.
- Type **F** or select the **Finish** keyword to end the session and recalculate.

Points added in the current session are shown in green. Points marked for deletion are shown with red cross markers. Pressing Escape cancels the session without applying any changes.

### Reset Points

Removes all manually added and deleted points, reverting the layout to the pure primary (and secondary, if enabled) grid pattern. This is a non-interactive, immediate operation — there is no confirmation prompt. The layout recalculates immediately after the trigger runs.

---

## Pedestal Product Catalog

Pedestal type selection is fully automatic and driven by the `AdjustableSupport.xml` settings file. At each support point, the script calculates the required pedestal height as the vertical distance from the substrate surface (plus the sealing layer) to the target finished-surface elevation. It then searches the catalog for the first entry whose height range covers that value.

The catalog shipped with the tool defines the following types:

| Product Name | Min Height (mm) | Max Height (mm) | Display Color |
|---|---|---|---|
| SE 0_28-38mm | 28 | 38 | 1 (Red) |
| SE 1_37.5-50mm | 37.5 | 50 | 4 (Cyan) |
| SE 2_50-75mm | 50 | 75 | 3 (Green) |
| SE 3_75-120mm | 75 | 120 | 5 (Blue) |
| SE 4_120-170mm | 120 | 170 | 6 (Magenta) |
| SE 5_170-215mm | 170 | 215 | 40 (Dark Green) |

Support points whose calculated height falls outside all catalog ranges are not assigned a product and are not drawn as pedestal symbols. They appear as non-valid points and are excluded from the BOM.

---

## Tips and Notes

**Grid changes reset manual edits.** Modifying the primary grid spacing (AbstandX 1, AbstandY 1) or primary offsets (Offset X 1, Offset Y 1) in the Properties Palette automatically erases all previously added and deleted points. The layout reverts to the pure grid. Always finalize the grid configuration before performing manual point edits.

**Insertion point is the grid origin.** The primary grid lines radiate outward from the clicked insertion point in all four directions. Moving the insertion point grip in the model (after placement) shifts the entire grid and resets manual edits. Use the offset parameters instead of moving the grip for fine-tuning alignment.

**The insertion point is constrained to the floor boundary.** If the insertion point ends up outside the floor outline after a level change or Raum modification, the script automatically snaps it to the nearest vertex on the contour. Similarly, during the point addition session, click targets outside the boundary are rejected.

**The child Raum level tracks the properties automatically.** The script creates and maintains a linked `Raum` instance for the finished floor surface. If the total construction height or top layer thickness is changed, the child Raum elevation is updated on the next recalculation. If the total height entered is less than the actual height of the Raum stack below, the script raises `Gesamte Dicke` to match the actual height and forces a second recalculation pass to ensure consistency.

**Sealing layer affects required pedestal height.** The `Stärke Abdichtung` value is added to the substrate surface elevation before computing pedestal height. A thicker membrane reduces the available pedestal height and may shift some points into a shorter product range.

**Visual symbols are view-direction aware.** The annular hatch circle symbol (drawn around each pedestal) is assigned a view direction aligned with the world Z axis, so it renders correctly in top-view plan layouts regardless of the current viewport angle.

**Secondary grid intersection points for BOM.** When `Stellfuß` is set to Yes in the Hilfsraster category, the secondary grid end-points and their intersection points with the primary grid are merged into the master point list. Any secondary-grid-only position that is more than 1 mm away from an existing primary grid point is added as an additional pedestal. This prevents duplicate entries where the two grids coincide.

**XML catalog version checking.** When a new instance is first placed in a drawing, the script compares the `Version` value in the drawing's cached map object against the version in the XML file on disk. If they differ, a notice is reported to the AutoCAD command line identifying the version numbers and file paths. This alerts project teams that the catalog has been updated since the drawing was last saved.

**Unit independence.** All dimensional values use the `U()` conversion function internally. The script is compatible with both metric (mm) and imperial (inch) hsbCAD drawing templates. All default values listed in this document are in millimeters.

**Catalog is extensible.** New pedestal types can be added to `AdjustableSupport.xml` by inserting additional `<lst nm="Stellfuß">` entries with `Name`, `Hmin`, `Hmax`, and `Color` fields. The script reads the entire list dynamically and checks them in order; the first matching height range is used. Ensure that height ranges are ordered from smallest to largest and do not have unintended gaps between consecutive entries.

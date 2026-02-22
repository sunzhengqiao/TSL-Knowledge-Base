# hsbTileSingle

Calculates and visualizes the distribution of roof tiles across a roof plane, providing automatic tile layout optimization with width balancing and quantity takeoff.

---

## Overview

**hsbTileSingle** is a roof tile distribution tool that automatically determines optimal tile placement on a roof surface. Given a roof plane and a set of laths (battens), the script calculates a column-by-row tile grid that respects the minimum and maximum visible tile widths defined in the tile configuration. It handles special tile types at gable ends, supports manual tile deletion, addition, and type modification, and generates a 3D body visualization of the complete tile coverage. Tile quantities are tracked by type for material ordering.

The script belongs to the hsbTile family of roofing tools, alongside hsbTileMaster, hsbTileStart, hsbTileEdge, hsbTileHipRidge, hsbTileVerge, hsbTileLath, hsbTileSpecial, and hsbTileEditor.

**Version:** 1.8
**Type:** O-Type (Object) -- standalone object, no beam attachment required
**Category:** Roofing / Tile Layout

---

## Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Creates 3D tile bodies and 2D plan-view annotations |
| Paper Space | No | Not intended for paper space |
| Shop Drawing | No | Modeling and visualization tool only |

---

## Prerequisites

Before using this script:

1. **Roof Plane (ERoofPlane):** A valid ERoofPlane entity must exist in the drawing. The script derives its coordinate system (X along eave, Y toward ridge, Z as roof normal) from this entity.
2. **Roof Laths:** Either individual lath beams (GenBeam type 5 / `_kLath`) or complete ElementRoof entities containing laths must be present. The lath positions define the tile row spacing.
3. **Tile Configuration Data:** The script's internal Map must contain a `tile` sub-map with at least one tile type (`"0"` = standard). Each tile type entry requires:
   - `LMax` -- Maximum tile length (the coverage in the lath-to-lath direction)
   - `H` -- Tile thickness (height of the 3D body)
   - `WMin` -- Minimum acceptable visible tile width
   - `WMax` -- Maximum acceptable visible tile width
   - `art1` -- Article name (displayed during tile type selection)
4. **Dimension Style:** A valid AutoCAD dimension style must exist for text annotations showing visible widths.

---

## Usage

### Step 1: Insert the Script

**Command:** `TSLINSERT`
**Action:** Select `hsbTileSingle.mcr` from the file browser and click **Open**.

On first insertion, a configuration dialog appears automatically (via `showDialog()`). Set the Display mode, Group name, and other initial properties, then click **OK**.

### Step 2: Assign a Roof Plane

**Action:** Right-click the script instance and select **assign roofplane**.
**Prompt:** Click on the target ERoofPlane entity in your model.

This establishes the roof surface, its coordinate system (eave direction, ridge direction, surface normal), and the envelope contour that bounds tile placement.

### Step 3: Append Laths

**Action:** Right-click the script instance and select **append roof laths**.
**Prompt:** `Select a set of laths`
**Action:** Select the GenBeam lath entities and press **Enter**.

The script reads the lath positions, merges laths that are aligned within 50 mm vertically, sorts them from eave to ridge, and calculates one tile row per lath.

### Step 4: (Alternative) Append Roof Elements

**Action:** Right-click the script instance and select **append roof elements**.
**Prompt:** `Select a set of element(s)`
**Action:** Select an ElementRoof entity.

The script automatically extracts all type-5 (lath) beams from the element, so you do not need to select laths individually.

### Step 5: Review and Adjust

After laths are assigned, the script automatically calculates the tile distribution and draws the visualization. Use the Properties Palette and context menu to fine-tune the layout.

---

## Parameters

The following parameters are available in the AutoCAD Properties Palette (OPM):

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Display** | Dropdown | `Tile grid + visible width` | Controls what is drawn: `Tile grid + visible width` shows tiles and width annotations; `Tile grid` shows tiles only; `visible width` shows width annotations only |
| **Auto group tsl** | String | (empty) | Assigns the script to a three-level group hierarchy. Separate levels with backslash, e.g. `Building1\Roof\Tiles`. All three levels are required for the grouping to take effect. |
| **Hip/Valley extension** | Length | 30 mm | Enlarges the roof plane contour outward before intersecting with the tile area. Increase this if tiles at hip or valley edges are clipped too aggressively. |
| **Offset left** | Length | 0 mm | Shifts the tile coverage area to the left (negative eave direction) relative to the lath contour. Use to extend tiles past the roof outline at the left gable. |
| **Offset right** | Length | 0 mm | Shifts the tile coverage area to the right (positive eave direction) relative to the lath contour. Use to extend tiles past the roof outline at the right gable. |
| **Dimstyle** | Dropdown | (from drawing) | Dimension style controlling text size and font for visible-width annotations |
| **Color** | Integer | 252 | Display color index for the 3D tile body and plan annotations |
| **Auto update after changes** | Yes/No | Yes | When Yes, the script automatically recalculates after each context menu operation (delete, add, modify). Set to No on large roofs for better performance, then use manual **Update**. |

---

## Context Menu

Right-click the tile instance to access these commands:

| Command | Description |
|---------|-------------|
| **Update** | Manually triggers a full recalculation. Reports progress to the command line. |
| **assign roofplane** | Select and link a roof plane to define the work surface and tile boundary. |
| **append roof laths** | Select individual lath beams (GenBeam type 5) to define tile rows. |
| **append roof elements** | Select complete ElementRoof entities; internal laths are extracted automatically. |
| **delete tiles** | Mark tiles as deleted (type -1). Click inside tiles to select them. |
| **add tiles** | Restore previously deleted tiles. Restores the original column type. |
| **modify tile** | Change the tile type of selected tiles. Available types are listed in the command line (press F2 to view). If the new type's width range differs from the current column width, you are prompted for a width adjustment. |
| **subtract contour from model** | Select ERoofPlaneOpening entities or closed polylines to cut holes in the tile coverage for skylights, chimneys, or other penetrations. |

---

## Command Prompts

During interactive operations, the following prompts appear:

| Prompt | Context | Action |
|--------|---------|--------|
| `Select a set of laths` | append roof laths | Select lath beams, press Enter to confirm |
| `Select a set of element(s)` | append roof elements | Select ElementRoof entities |
| `Press <F2> to see available types, enter new type index` | add tiles / modify tile | Enter a tile type number (0, 1, 2, ...) |
| `Select a point inside a tile` | delete / add / modify | Click inside a single tile |
| `Select next point to select multiple tiles` | delete / add / modify | Click additional points to extend selection; press Enter or Escape to finish |
| `Actual width of tile at grid: X/Y = Z` | modify tile | Informational: shows column/row index and current width |
| `-1 = new width, 0 = No, Enter width` | modify tile | Enter -1 to accept the new type's average width, 0 to cancel, or a custom width value |

---

## Tile Types

The script stores tile types as integer codes in a point matrix. Each tile in the grid has a column index, row index, and type code:

| Type Code | Meaning | Display Color |
|-----------|---------|---------------|
| -1 | Deleted (hidden) | Not drawn |
| 0 | Standard tile | Color 1 (Red) |
| 1 | Gable end left | Color 2 (Yellow) |
| 2 | Gable end right | Color 3 (Green) |
| 3+ | Additional types (half tile, etc.) | Color = type + 1 |

Additional tile types can be defined in the tile map data. When both gable-end-left and gable-end-right types are present and the net width cannot be evenly distributed, a "Warning" label is displayed.

---

## Tile Selection Modes

When deleting, adding, or modifying tiles, three selection methods are available:

1. **Single tile:** Click once inside a tile to select only that tile.
2. **Line selection (two clicks):** Click two points to create a narrow rectangle along the line between them. All tiles intersecting this line are selected.
3. **Polygon selection (three or more clicks):** Click multiple points to define a polygon. All tiles with area overlapping the polygon are selected. A hatched "jig" preview appears as you add points.

---

## Distribution Algorithm

The script calculates tile column widths using this logic:

1. **Net width** is computed by subtracting widths of non-standard columns (gable end tiles) from the total roof width.
2. **Column count** is determined by dividing the net width by WMin and WMax, yielding minimum and maximum column counts.
3. **Optimal visible width** is selected to fit within the WMin-WMax range. The script tries WMax first, then WMin, then the average, to find a width that divides evenly.
4. If no exact fit is possible, the average of WMin and WMax is used and a "not fit" flag is set.
5. Each standard column receives the same calculated width; non-standard columns keep their configured width.

---

## Tips

### Performance
- Set **Auto update after changes** to `No` when working with large or complex roofs. Use manual **Update** from the context menu when you are ready to see results.

### Hip and Valley Edges
- Increase **Hip/Valley extension** if tiles at hip or valley transitions are being clipped. The default 30 mm is suitable for most cases.

### Display Modes
- Use `Tile grid` for a cleaner plan view during design.
- Use `Tile grid + visible width` to verify that tile widths meet manufacturer specifications.
- Use `visible width` when you only need dimension annotations without the tile grid.

### Offset Adjustments
- If the tile grid does not align with the roof edges at the gable, adjust **Offset left** or **Offset right** rather than repositioning the laths.

### Openings and Obstacles
- Use **subtract contour from model** to handle skylights, chimneys, and other roof penetrations.
- Both ERoofPlaneOpening entities and closed polylines (EntPLine) are accepted.
- Subtracted contours are stored persistently and applied on every recalculation.

### Tile Quantity Takeoff
- Tile quantities by type are stored in the script's Map under the key `TileData`.
- Quantities are sorted by type index for straightforward material ordering.
- Only tiles with visible area exceeding 50 x 50 mm (after intersection with the roof contour) are counted.

### Grouping
- The **Auto group tsl** field requires exactly three hierarchy levels separated by backslashes (e.g., `Project\Building\Roof`).
- If fewer than three levels are provided, grouping is silently skipped.

### Warning: No Laths Found
- If a hatched warning box with the text "append laths or roof elements" appears on the roof plane, no valid laths have been assigned.
- Use the context menu to append laths or roof elements.

---

## FAQ

**Q: Why does a hatched warning box appear on my roof?**
A: The script could not find any assigned laths. Right-click the instance and use "append roof laths" or "append roof elements" to assign the required references.

**Q: How do I change the visible tile width?**
A: The visible tile width is calculated automatically from the lath contour and the WMin/WMax values in the tile configuration. To adjust widths, either change the lath spacing (which changes row heights) or modify the tile configuration data. You can also change individual column widths via the "modify tile" command.

**Q: The width annotations are too small to read.**
A: Change the **Dimstyle** property to a dimension style with a larger text height defined in your drawing.

**Q: How do I handle skylights or chimneys?**
A: Use the "subtract contour from model" context menu command. Select ERoofPlaneOpening entities or draw a closed polyline around the obstacle.

**Q: Why does "Warning" appear at the insertion point?**
A: This indicates that both left and right gable-end tiles are present, but the remaining net width cannot be divided evenly into standard tiles within the WMin-WMax range. Consider adjusting the gable-end tile widths or the roof geometry.

**Q: Can I move tiles after placement?**
A: The "move tile" feature is defined in the code but is not yet implemented in this version (1.8). Use delete and add operations as a workaround.

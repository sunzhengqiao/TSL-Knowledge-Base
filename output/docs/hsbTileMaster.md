# hsbTileMaster

Master controller for roof tile distribution, scheduling, and material takeoff generation.

## Overview

hsbTileMaster is the central management script for roof tile distribution in hsbCAD. It orchestrates the complete tile planning workflow for roofing projects: analyzing roof plane geometry, calculating optimal tile column placement based on manufacturer-specified width tolerances, generating child TSL instances for area tiles (hsbTileSingle) and ridge/hip tiles (hsbTileEdge), and producing a consolidated Bill of Materials (BOM) table directly in the drawing. The script reads tile specifications from an external XML catalog, supports multiple roof planes simultaneously, and automatically detects geometric relationships between roof planes (ridge lines, hip lines, valleys, gable ends, eaves).

## Environment

| Property | Value |
|----------|-------|
| Type | O-Type (Object) |
| Beams Required | 0 |
| Version | 2.5 (25.05.2009) |
| Coordinate System | Model Space |
| Unit System | Millimeters (internal) |
| Dependencies | hsbTileSingle, hsbTileEdge, hsbTileCatalog.xml |
| Implicit Insert | Yes |

## Prerequisites

1. **Tile Catalog XML**: The file `hsbTileCatalog.xml` must be present at:
   - `<hsbCompany>\Abbund\hsbTileCatalog.xml`
   - This file defines all available tile suppliers, products, area tiles, and ridge/hip tiles with their dimensional tolerances.

2. **Roof Planes**: One or more roof planes (ERoofPlane) must exist in the model. These define the surfaces on which tiles will be distributed.

3. **Roof Elements or Lathes** (required for tile creation step): When generating actual tile instances via the "Create Tiles" context command, you must have either:
   - Roof elements (ElementRoof) properly oriented and aligned to the roof planes
   - Roof lathes (Beam objects with type Lath) placed on the roof surface

## Usage

### Insertion Workflow

1. Run the hsbTileMaster insert command.
2. A properties dialog appears for initial configuration (supplier/product selection, offsets, dimension style).
3. **Select roof planes**: Click on the ERoofPlane objects that belong to your roof. You may also select existing hsbTileMaster, hsbTileSingle, or hsbTileEdge instances during this step -- they will be automatically deleted (useful for replacing a previous tile distribution).
4. **Pick the BOM table insertion point**: Click a location in the drawing where the Bill of Materials table should appear.
5. The script performs an initial analysis of the selected roof planes, identifying all edge types (eave, ridge, hip, valley, gable end left, gable end right) and storing the geometric relationships. A preview of the tile column distribution is displayed on each roof plane.

### Understanding the Preview

After insertion, the script calculates how many tile columns fit across each roof plane based on the selected product's minimum and maximum width (WMin/WMax from the catalog). The preview shows:

- **Colored tile column rectangles** on each roof plane, indicating the calculated layout.
- **Dashed lines at gable ends** (when the tile width does not fit evenly): These show the required adjustment range. Two sets of lines are drawn, each with a numeric offset label indicating how much the roof plane width needs to change to achieve a perfect tile fit. Color 240 lines show the minimum adjustment; color 150 lines show the maximum adjustment.
- **Command line message**: If adjustment is needed, the message "Adjustment needed on roof N" appears.

### Generating Tiles

After reviewing the preview and optionally adjusting roof plane widths:

1. Right-click the hsbTileMaster instance.
2. Select **Create Tiles** from the context menu.
3. Select the roof elements or roof lathes that belong to the previously selected roof planes. The script matches elements/lathes to roof planes by checking axis alignment and spatial overlap.
4. The script creates:
   - One **hsbTileSingle** instance per roof plane (handles area tile distribution on that plane)
   - One **hsbTileEdge** instance per ridge/hip/valley intersection between adjacent roof planes
5. Child instances inherit the BOM grouping, dimension style, color, and offset settings from the master.

### Modifying Tile Layout After Creation

If the initial distribution requires manual adjustments (dormers, penetrations, special tiles), use the context menu commands described below.

## Parameters

### Properties Panel (OPM)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Supplier / Product | String (dropdown) | (from catalog) | Select the tile manufacturer and product from the XML catalog. Presented as "Supplier;Product" pairs parsed from the catalog. This property becomes **read-only** after insertion to prevent accidental changes. |
| Auto group analysis BOM | String | (empty) | Group path for BOM organization. Use backslash to separate hierarchy levels (e.g., "Building\Roof"). When set, the master and all child TSL instances are added to an hsbCAD Group for structured BOM analysis. Only the first two levels are used. |
| Offset left | Double | 0 mm | Horizontal offset of the tile layout from the left roof edge. Passed to child hsbTileSingle instances to fine-tune tile positioning relative to the roof outline. |
| Offset right | Double | 0 mm | Horizontal offset of the tile layout from the right roof edge. Passed to child hsbTileSingle instances. |
| Dimstyle | String (dropdown) | (current drawing styles) | Dimension style used for all text rendering in the BOM table and preview annotations. Select from the available dimension styles in the current drawing. |
| Auto update after changes | String (dropdown) | No | Controls whether the BOM table and preview update automatically after context menu modifications. Options: "No" (manual update required, better performance) or "Yes" (automatic recalculation after every change). |
| Color | Integer | 252 | Display color index for the BOM table text and grid lines. |

## Context Menu Commands

| Command | Description |
|---------|-------------|
| **Update** | Manually recalculates the tile distribution and refreshes the BOM table. Required when "Auto update after changes" is set to "No". Displays a progress message in the command line during recalculation. |
| **Append roofplanes** | Add additional roof planes to this master controller. First validates existing roof plane references (removes any that have been deleted from the drawing), then prompts for selection of new ERoofPlane objects. |
| **Create Tiles** | Generate hsbTileSingle and hsbTileEdge child instances. Prompts for selection of roof elements or roof lathes. Skips creation for roof planes that already have a valid SingleTile child. Creates edge tile instances for all detected ridge/hip/valley intersections. |
| **Delete tiles** | Remove a tile column by clicking a point inside it. The script identifies which roof plane and column the picked point falls into, removes that column from the internal matrix, and shifts subsequent column indices. Triggers a recalculation (two execution loops). |
| **Add tiles** | Insert a new tile column adjacent to an existing one. Pick a point inside the reference column, then enter the tile type index. Available tile types are listed in the command line. The new column is inserted after the selected column. Triggers a recalculation. |
| **Modify tile** | Change the tile type of an existing column. Pick a point inside the target column, then enter the new tile type index. Press F2 to review available types in the command line. Triggers a recalculation. |
| **Append roof edge** | Link additional hsbTileEdge instances (from other sources or manual placement) to this master controller for consolidated BOM reporting. Select one or more hsbTileEdge instances. |
| **Read catalog** | Reload tile specifications from the XML catalog file. Use this after editing the hsbTileCatalog.xml file to pick up new products or changed dimensions without reinserting the script. |

## Internal Tile Column Matrix

The script maintains an internal matrix stored as a Point3d array where each entry encodes:

| Axis | Meaning |
|------|---------|
| X | Column index within the roof plane |
| Y | Roof plane index |
| Z | Tile type code |

### Tile Type Codes

| Code | Description |
|------|-------------|
| -1 | Deleted column (removed by user) |
| 0 | Standard tile |
| 1 | Gable end left |
| 2 | Gable end right |
| 3 | Half tile |

Additional type codes may be defined in the XML catalog (type indices map to catalog sub-entries).

## Roof Edge Detection

During initial analysis (on database creation), the script classifies every edge segment of each roof plane envelope:

| Edge Type | Condition |
|-----------|-----------|
| **eave** | Edge parallel to the roof plane X-axis, located below the midpoint |
| **pult** | Edge parallel to the roof plane X-axis, located above the midpoint, with no neighboring roof plane |
| **ridge** | Shared edge between two roof planes where the cross-product of their Z-axes is horizontal |
| **hip** | Shared edge between two roof planes where the cross-product of their Z-axes points upward |
| **valley** | Shared edge between two roof planes where the cross-product of their Z-axes points downward |
| **GableEndLeft** | Edge perpendicular to the roof plane X-axis, at the left extent |
| **GableEndRight** | Edge perpendicular to the roof plane X-axis, at the right extent |
| **rising eave** | Non-parallel, non-perpendicular edge below the midpoint |
| **sloped edge** | Non-parallel, non-perpendicular edge above the midpoint |

Shared edges between roof planes are detected by checking whether the edge segment lies in the same plane as a neighboring roof plane and whether a small test profile at the edge intersects with that neighbor's envelope.

## Tile Distribution Calculation

For each roof plane, the script calculates the optimal tile column width as follows:

1. Determine the net width of the roof plane (total width minus gable end tile widths if present).
2. Calculate the minimum number of columns: `nMin = ceil(netWidth / WMax)`.
3. Calculate the maximum number of columns: `nMax = round(netWidth / WMin)`.
4. Attempt to find a distribution width between WMin and WMax that divides evenly into the net width.
5. If no exact fit is possible, the script sets a "not fit" flag and displays adjustment suggestions at the gable end edges showing how much the roof plane width should change.

## Bill of Materials Table

The generated BOM table is drawn at the insertion point and contains:

### Header
- Project name and number (from drawing properties)
- Supplier and product name

### Table Columns

| Column | Content | Alignment |
|--------|---------|-----------|
| Roof | Roof plane index (e.g., "1", "2") or edge combination (e.g., "1/2" for ridge between planes 1 and 2) | Center |
| Qty | Quantity of tiles | Right |
| Article # | Product article number from catalog (art2 field) | Left |
| Desc | Tile description from catalog (art1 field) | Left |
| Info | Visual tile type indicator sketch and waste quantities | Center |

### Table Structure

The table is organized in three sections:

1. **Per-roof breakdown**: For each roof plane, a miniature sketch of the roof shape is shown alongside a breakdown of tile quantities by type. Tile type indicators are drawn as small colored rectangles.
2. **Ridge/hip/valley breakdown**: For each detected edge intersection, the edge shape is sketched and the associated ridge/hip tile quantities listed. Roof plane combinations are shown as "A/B" notation.
3. **Summary section**: Total quantities across all roof planes and edges, including waste allowance (defined per tile type in the catalog as the "waste" field). Waste quantities are displayed as "+ N pcs" in the Info column.

Horizontal separator lines are drawn between sections for visual clarity. Roof plane sketches are scaled to fit within the Info column width while maintaining aspect ratio.

## XML Catalog Structure

The tile catalog (`hsbTileCatalog.xml`) uses the standard `<Hsb_Map>` format with this hierarchy:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Hsb_Map>
  <lst nm="SupplierName">
    <lst nm="Area">
      <lst nm="ProductName">
        <lst nm="0">                    <!-- Type 0: Standard tile -->
          <dbl nm="WMin" vl="250"/>     <!-- Minimum visible width -->
          <dbl nm="WMax" vl="280"/>     <!-- Maximum visible width -->
          <str nm="art1" vl="Standard tile description"/>
          <str nm="art2" vl="ART-001"/>
          <int nm="waste" vl="5"/>      <!-- Waste pieces to add -->
        </lst>
        <lst nm="1">                    <!-- Type 1: Gable end left -->
          <dbl nm="WMin" vl="200"/>
          <dbl nm="WMax" vl="220"/>
          <str nm="art1" vl="Left gable tile"/>
          <str nm="art2" vl="ART-002"/>
          <int nm="waste" vl="2"/>
        </lst>
        <!-- Additional tile types: 2 (gable end right), 3 (half tile), etc. -->
      </lst>
    </lst>
    <lst nm="RidgeHip">
      <lst nm="ProductName">
        <!-- Ridge/hip tile types with same structure -->
      </lst>
    </lst>
  </lst>
</Hsb_Map>
```

**Key parameters per tile type:**
- **WMin / WMax**: The adjustable visible width range for this tile type (in drawing units). The distribution algorithm uses these bounds to calculate optimal column spacing.
- **art1**: Human-readable description shown in the BOM table and type selection prompts.
- **art2**: Article number shown in the BOM table.
- **waste**: Number of extra pieces to add to the final quantity as waste allowance.

**Validation**: If WMin or WMax is zero or negative, the script displays an error message and halts execution, prompting the user to verify the catalog file.

## Tips and Best Practices

1. **Design for tile modules**: Where possible, design roof plane widths as multiples of the tile's nominal width (average of WMin and WMax). This eliminates the need for manual adjustment and produces a clean distribution.

2. **Performance on large roofs**: Set "Auto update after changes" to "No" when working with complex roofs containing many planes. Use the manual "Update" command when ready to see results. Each automatic update triggers a full recalculation of all tile columns and the BOM table.

3. **BOM grouping strategy**: Use the "Auto group analysis BOM" parameter to organize tiles by building section or roof area (e.g., "ProjectName\Main Roof"). Child instances inherit this grouping, which appears in hsbCAD analysis reports.

4. **Handling dormers and penetrations**: First create the complete tile distribution with "Create Tiles", then use "Delete tiles" to remove columns that conflict with openings. This preserves the column indexing for the remaining tiles.

5. **Catalog maintenance**: After editing hsbTileCatalog.xml (adding new products, updating prices or article numbers), use "Read catalog" on existing instances to reload without reinserting.

6. **Multiple tile types on one roof**: Use "Add tiles" and "Modify tile" to create mixed-type layouts. The F2 key displays available type indices in the command line during these operations.

7. **Edge tile consolidation**: If you have manually placed hsbTileEdge instances (e.g., for complex valley conditions), use "Append roof edge" to include them in this master's BOM table for a complete material takeoff.

8. **Replacing an existing distribution**: During insertion, you can select existing hsbTileMaster, hsbTileSingle, and hsbTileEdge instances alongside the roof planes. Selected tile instances are automatically deleted before the new distribution is created.

9. **Understanding adjustment suggestions**: When the preview shows dashed lines at gable ends with offset values, these represent how much the roof plane boundary needs to move (total, split between both sides) to achieve an exact tile fit. Two options are shown: one for N columns and one for N+1 columns.

## Error Messages

| Message | Cause | Resolution |
|---------|-------|------------|
| "contains invalid values" | WMin or WMax is zero or negative in hsbTileCatalog.xml | Open the XML catalog and verify all WMin/WMax entries are positive numbers. |
| "Adjustment needed on roof N" | The tile module width cannot be evenly distributed across roof plane N | Adjust the roof plane width to match a tile module multiple, or accept a non-exact distribution. |
| "No roofplanes assigned" | No valid roof planes are linked to this instance | Reinsert or use "Append roofplanes" to add roof planes. |

## Related Scripts

| Script | Relationship | Purpose |
|--------|-------------|---------|
| hsbTileSingle | Child (created by master) | Handles area tile distribution on a single roof plane |
| hsbTileEdge | Child (created by master) | Handles ridge/hip/valley tile distribution along an edge line |
| hsbTileEditor | Companion | Interactive tile layout editing |
| hsbTileStart | Companion | Starting tile placement at eave |
| hsbTileVerge | Companion | Verge (gable edge) tile handling |
| hsbTileLath | Companion | Tile lath/batten generation |
| hsbTileSpecial | Companion | Special tile configurations (ventilation, snow guard) |
| hsbTileHipRidge | Companion | Dedicated hip and ridge tile handling |

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.5 | 25.05.2009 | Translation issue fixed |
| 2.4 | 24.03.2009 | Bugfix for orientation; improved contour detection of complex roof elements |
| 2.2 | 31.10.2007 | Added "Auto update after changes" option for performance; roof plane group index starts at 1 |
| 2.1 | 15.10.2007 | Project name/number displayed in header; improved lath detection near ridge with large offset; parallel but non-coplanar elements no longer mix lath assignment |

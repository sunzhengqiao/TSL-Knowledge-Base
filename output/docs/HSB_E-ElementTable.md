# HSB_E-ElementTable

## Overview

HSB_E-ElementTable generates a formatted schedule table for timber construction elements directly in AutoCAD Model Space. The table summarizes key identification and dimensional data for walls, floors, roofs, and other hsbCAD elements, presenting information such as element numbers, thickness, height, length, gross surface area, and scannable barcodes in a structured grid layout.

The script is designed for project managers, production planners, and timber frame designers who need a quick visual summary of element quantities and dimensions for quantity takeoff, production planning, or on-screen review. It supports four element selection modes (entire project, specific floor level, current floor level, or manual selection), optional filtering of beam components by code, material, or label, and full control over the visual styling of the generated table.

When the selection mode is set to manual element picking, the script provides right-click context menu actions that allow you to add or remove elements from the table after placement, without needing to delete and recreate it.

## Usage Environment

| Environment | Supported | Notes |
|---|---|---|
| Model Space | Yes | Primary working environment. Elements are collected from Model Space groups. |
| Paper Space | No | The script does not operate in Paper Space. |
| Shop Drawing | No | This is not a shop drawing script. |

The table is drawn as 2D linework and text at a user-specified insertion point within Model Space. It remains linked to the selected elements and recalculates when properties change or when elements are added or removed via the context menu.

## Prerequisites

Before using this script, ensure the following conditions are met:

1. **Elements must exist in the drawing.** The script operates on hsbCAD Element entities (walls, floors, roof panels, etc.). At least one Element must be present in the model before running the script.

2. **HSB_G-FilterGenBeams must be loaded** (conditional). If you intend to use any of the exclusion filters (beam codes, materials, or labels), the companion script `HSB_G-FilterGenBeams` must be loaded in the current drawing. Without it, filtered calculations will fail and a warning message will appear. If you do not use any exclusion filters, this dependency is not required.

3. **Dimension and text styles should be configured.** The script uses AutoCAD dimension styles to control the appearance of header text, content text, and barcode text. Ensure appropriate text styles exist in the drawing before inserting the table. If you plan to use the barcode column, a barcode font (e.g., Code 39 or Code 128) must be available as a dimension style.

4. **Floor groups should be defined** (if using floor level selection mode). The script reads hsbCAD floor-level groups from the drawing to populate the floor selection dropdown.

## Usage Steps

### Step 1: Launch the Script

Run the `TSLINSERT` command in AutoCAD and select `HSB_E-ElementTable.mcr` from the script browser. Alternatively, if catalog presets have been configured for this script, you can launch it through a catalog key, which will automatically apply saved property values and skip the initial dialog.

### Step 2: Configure the Properties Dialog

When the script launches, it opens a Properties Dialog where you configure all table parameters before placement. The most important setting is the **Selection mode**, which determines how elements are collected:

- **Select entire project** -- Collects every Element entity from the entire drawing automatically. No further selection is needed.
- **Select floor level in floor level list** -- Enables the **Floorgroup** dropdown. Choose a specific floor level, and the script will collect only the Elements belonging to that floor group.
- **Select current floor level** -- Uses the currently active hsbCAD floor group automatically. Only Elements within that group whose floor-level part is defined (i.e., the group has a valid floor name but no sub-element part) are collected.
- **Select elements in drawing** -- After confirming the dialog, the script will prompt you to manually pick Elements from the drawing. This mode also enables right-click context menu options for adding and removing elements later.

### Step 3: Configure Exclusion Filters (Optional)

If the table should reflect filtered dimensions or areas (for example, excluding internal framing studs from a sheathing area calculation), enter values in the filter fields:

- **Beam codes to exclude** -- Enter beam code identifiers to omit specific beam types from the geometric calculations.
- **Materials to exclude** -- Enter material names to omit beams of a specific material grade from calculations.
- **Labels to exclude** -- Enter label strings to omit beams carrying specific user-assigned labels.

These filters are passed to the `HSB_G-FilterGenBeams` utility script, which removes matching beams before dimensions and areas are computed. If that script is not loaded in the drawing, a warning message will appear and filtering will be skipped.

### Step 4: Configure Table Appearance (Optional)

Set the visual styling of the table:

- Choose dimension styles for **header text**, **content text**, and **barcode text** from the available drawing styles.
- Set color values for header text, content text, and table grid lines. Use `-1` for ByLayer color or enter an AutoCAD Color Index value (0--255).
- Enter a custom **Subtitle** for a secondary descriptive line beneath the main title.

### Step 5: Select Elements (Manual Mode Only)

If the selection mode is set to **Select elements in drawing**, the command line will prompt:

> Select one or more elements

Pick the desired Element entities in the drawing and press Enter to confirm the selection.

### Step 6: Place the Table

Regardless of the selection mode, the command line will prompt:

> Select a position for the table

Click a point in Model Space to define the top-left corner of the table. The script will then generate and draw the complete table at that location.

### Step 7: Post-Placement Modifications

After the table has been placed:

- **Modify properties**: Select the table entity and adjust parameters in the Properties Palette. Changes to filters, styles, colors, title, or subtitle will trigger an automatic recalculation and redraw of the table.
- **Add or remove elements** (manual selection mode only): Right-click the table entity and use the context menu options to modify the element list.
- **Relocate the table**: Use standard AutoCAD grip editing or the MOVE command to reposition the table.

## Properties Panel Parameters

### Selection

| Parameter | Type | Default | Description |
|---|---|---|---|
| **Selection mode** | Dropdown | Select elements in drawing | Determines how elements are gathered for the table. Options: "Select entire project", "Select floor level in floor level list", "Select current floor level", "Select elements in drawing". This property becomes read-only after insertion. |
| **Beam codes to exclude** | Text | *(empty)* | Comma or semicolon-separated list of beam code identifiers. Beams matching these codes are excluded from dimension and area calculations. Requires HSB_G-FilterGenBeams to be loaded. |
| **Materials to exclude** | Text | *(empty)* | Comma or semicolon-separated list of material names. Beams with matching materials are excluded from calculations. Requires HSB_G-FilterGenBeams to be loaded. |
| **Labels to exclude** | Text | *(empty)* | Comma or semicolon-separated list of label strings. Beams carrying matching labels are excluded from calculations. Requires HSB_G-FilterGenBeams to be loaded. |
| **Floorgroup** | Dropdown | *(first available)* | Selects a specific floor-level group from the drawing. Only editable when Selection mode is set to "Select floor level in floor level list". Read-only for all other modes. |

### Table

| Parameter | Type | Default | Description |
|---|---|---|---|
| **Title** | Dropdown | Project name / Project number | Format for the main header row of the table. The default and currently only option displays the project name combined with the project number, separated by a forward slash. |
| **Subtitle** | Text | *(empty)* | Free-text input for a secondary header row displayed below the main title. Use this for additional context such as building phase, wing, or description. |

### Style

| Parameter | Type | Default | Description |
|---|---|---|---|
| **Dimension style header** | Dropdown | *(from drawing)* | Selects the AutoCAD dimension/text style used for column header text. Controls font family, text height, and formatting of the header row. |
| **Dimension style content** | Dropdown | *(from drawing)* | Selects the text style used for the data content rows. Controls the font and size of element numbers, dimensions, and area values. |
| **Dimension style barcodes** | Dropdown | *(from drawing)* | Selects the text style used specifically for barcode columns. Must reference a barcode font (e.g., Code 39) for machine-readable output. |
| **Color header** | Integer | -1 | AutoCAD Color Index for the header row text. Set to -1 for ByLayer. Valid range: -1 to 255. |
| **Color content** | Integer | -1 | AutoCAD Color Index for the data row text and barcode text. Set to -1 for ByLayer. Valid range: -1 to 255. |
| **Color Table** | Integer | -1 | AutoCAD Color Index for the table grid lines (borders and column separators). Set to -1 for ByLayer. Valid range: -1 to 255. |

## Right-Click Menu

The following context menu options are available only when the **Selection mode** is set to **"Select elements in drawing"** (manual selection). They do not appear for the other three selection modes.

| Menu Item | Description |
|---|---|
| **Add elements** | Prompts at the command line to select one or more Elements to append to the table. After selection, the table regenerates to include the new elements. Elements already in the table are not duplicated. |
| **Remove elements** | Prompts at the command line to select one or more Elements to remove from the table. After selection, the table regenerates without those elements. Elements not currently in the table are silently ignored. |

## Settings

This script does not use external XML settings files. All configuration is handled through the Properties Palette parameters described above.

The script supports **catalog presets**. If catalog entries have been defined for `HSB_E-ElementTable`, launching the script with a matching catalog key automatically populates all property values from the saved preset, bypassing the initial properties dialog.

### Dependency: HSB_G-FilterGenBeams

The companion script `HSB_G-FilterGenBeams` is called internally when any of the exclusion filter fields (beam codes, materials, or labels) contain values. This script must be loaded in the drawing for filtering to work. If it is not loaded and filters are defined, the following warning will appear in the command line:

> Beams could not be filtered! Make sure that the tsl HSB_G-FilterGenBeams is loaded in the drawing.

To resolve this, either load the script using `TSLLOAD` or clear all exclusion filter fields.

## Tips

- **Calculating net sheathing area.** To obtain the net surface area for sheathing or boarding, enter the beam codes of internal framing members (such as studs or plates) in the **Beam codes to exclude** field. The script will recalculate the area based only on the remaining components.

- **Automatic sorting.** Elements in the table are automatically sorted in ascending order by their element number using an insertion sort. You do not need to select them in any particular order.

- **Barcode columns.** The table includes two barcode-rendered columns: the Barcode column (project number/element number) and the Brutto opp. column (gross area). The barcode content is wrapped with asterisk characters (e.g., `*12345/001*`) which is the standard start/stop pattern for Code 39 barcodes. For these columns to produce scannable barcodes, the **Dimension style barcodes** must reference a barcode font. If a standard text font is used, the barcode column will display the encoded string as regular text.

- **Total row.** The table automatically includes a totals row at the bottom for the Length column. This row sums the length values across all listed elements and is visually separated from the data rows by a double-line border (a thin gap line drawn just above the totals row).

- **Area calculation method.** The script first attempts to use the element's gross profile (`profBrutto`) for the area value. If that profile is not available or returns zero area, it falls back to a computed method: it projects all beam envelope bodies onto the element plane using shadow profiles, unions them together with a small shrink/expand tolerance to merge overlapping shapes, and then measures the area of the largest non-opening ring from the resulting profile. The area is displayed in square meters (the raw value in square millimeters is divided by 1,000,000).

- **Dimension calculation method.** The thickness, height, and length values are calculated by collecting all vertices from the envelope bodies of the element's beams, projecting them onto the element's Z, Y, and X axes respectively, and measuring the distance between the extreme points along each axis. This means the values represent the overall bounding dimensions of the element's beam content after any exclusion filters have been applied.

- **Updating after model changes.** Since the table is a live TSL entity, it recalculates automatically whenever you modify its properties. If elements in the model are moved, resized, or modified, selecting the table and triggering a recalculation (e.g., via a property change or context menu action) will refresh the displayed values.

- **Floor group selection.** The **Floorgroup** dropdown is only active when the Selection mode is set to "Select floor level in floor level list". The dropdown is populated with all groups that have a floor-level name (namePart 1) but no sub-element part (namePart 2). For all other modes, this dropdown is read-only and has no effect on the table content.

- **Preventing accidental duplication.** The script includes a safeguard that detects if it has already been inserted in the current insert cycle (using `insertCycleCount`). If a duplicate insertion is detected, the extra instance is silently erased to prevent duplicate tables.

- **Column width auto-sizing.** Each column width is automatically calculated to fit the widest content across both the header text and all data rows, plus a padding margin equivalent to the width of two "X" characters in the content font style. This ensures no text is clipped.

- **Element number formatting.** Element numbers in the table are zero-padded to a minimum of 3 digits (e.g., element 5 displays as "005", element 42 displays as "042").

## Technical Notes

| Property | Value |
|---|---|
| **Script Type** | O-Type (Object) |
| **Required Beams** | 0 |
| **Version** | 1.04 (14.09.2016) |
| **Author** | Anno Sportel (anno.sportel@hsbcad.com) |
| **Dependency** | HSB_G-FilterGenBeams (for exclusion filtering) |
| **Catalog Support** | Yes -- supports `setPropValuesFromCatalog` for preset configurations |
| **Implicit Insert** | Yes (`#ImplInsert 1`) |
| **DXA Output** | Yes (`#DxaOut 1`) |

### Table Columns (Hardcoded)

The table columns are defined within the script and are not user-configurable. The default columns are:

| Column | Content | Format | Notes |
|---|---|---|---|
| Element | Project number / Element number | `ProjectNumber/ElementNumber` | Element number is zero-padded to 3 digits |
| Barcode | Encoded project/element number | `*ProjectNumber/ElementNumber*` | Rendered in barcode font style; asterisks are Code 39 start/stop characters |
| Dikte [mm] | Element thickness (Z-axis) | Numeric, 2 decimal places | Calculated from beam envelope vertices projected onto element Z-axis |
| Hoogte [mm] | Element height (Y-axis) | Numeric, 2 decimal places | Calculated from beam envelope vertices projected onto element Y-axis |
| Lengte [mm] | Element length (X-axis) | Numeric, 2 decimal places | Supports total row summation |
| Brutto opp. [m2] | Gross surface area | `*AreaValue*`, 3 decimal places | Displayed in square meters; rendered in barcode font style |
| Versterkingen | Reinforcements | Empty | Manual entry column (no auto-populated data) |
| Electra | Electrical notes | Empty | Manual entry column (no auto-populated data) |
| Datum | Date | Empty | Manual entry column (no auto-populated data) |

### Version History

| Version | Date | Changes |
|---|---|---|
| 1.00 | 07.05.2014 | Pilot version |
| 1.01 | 16.10.2014 | Added width, height, and length as name formats. Added support for a total row. |
| 1.02 | 06.09.2016 | Added filter options for beam codes, materials, and labels. |
| 1.03 | 14.09.2016 | Elements sorted by element number. Changed area calculation to use profBrutto instead of bounding box. |
| 1.04 | 14.09.2016 | Added right-click context menu triggers to add and remove elements in manual selection mode. |

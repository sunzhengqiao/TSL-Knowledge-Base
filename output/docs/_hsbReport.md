# _hsbReport

## Overview

`_hsbReport` places a live, parametric data table directly in the CAD drawing. The table reads structural data from selected entities (beams, elements, panels, hardware) and renders it using a report definition created in the **hsbExcel Report Designer**. Because the script is an O-Type entity (TslInst), the table updates automatically whenever referenced entities are modified.

The script works in three environments:

- **Model Space** - the user selects entities manually and the table is placed anywhere in the drawing.
- **Element Layout (Paper Space with Viewports)** - the table attaches to a viewport and pulls data from the element displayed in that viewport, optionally filtered by zone.
- **Shop Drawing (Multipage)** - the table attaches to a ShopDrawView block and generates its data when the shop drawing is produced.

Keywords: BOM, Report, Schedule, List, Output.

---

## Usage Environment

| Environment | Supported | Notes |
|---|---|---|
| Model Space | Yes | User selects any combination of GenBeams, Elements, TslInst objects, MassGroups, FastenerAssemblies, CollectionEntities, Openings, and MasterPanels. |
| Paper Space / Element Layout | Yes | Attaches to an existing viewport. Data is collected from the element in that viewport, filtered by zone index. |
| Shop Drawing (Multipage) | Yes | Attaches to a ShopDrawView. The table is regenerated each time the shop drawing is produced. |

- **Script type**: O-Type (Object / TslInst)
- **Beams required**: 0

---

## Prerequisites

- At least one report definition must exist in the company folder (`_kPathHsbCompany`). Report definitions are XML files created and managed by your hsbCAD administrator using the **hsbExcel Report Designer**.
- The file `hsbExcel.dll` must be present at `_kPathHsbInstall\Utilities\hsbExcel\hsbExcel.dll`. This DLL provides the reporting engine.
- For Element Layout mode, a viewport that is already associated with an element must exist in Paper Space before inserting the script.
- For Shop Drawing mode, a ShopDrawView entity must already be placed in the block space.

---

## How to Use

### Step 1: Start insertion

Run the script using the standard TSL insert command:

```
^C^C(hsb_ScriptInsert "_hsbReport")
```

Alternatively, launch it via the hsbCAD ribbon or toolbox.

**Shortcut using a catalog entry (no dialog):**

If your administrator has set up named catalog entries, you can bypass the dialog entirely:

```
^C^C(hsb_scriptinsert "hsbReport" "Element")
```

Replace `"Element"` with the exact catalog entry name. The script will load properties from that catalog and skip the selection dialogs if the report name is valid.

### Step 2: Select the report name

A dialog appears listing all available report definitions from the company folder.

- Select the report that matches the data you need (for example, "Cut List", "Hardware Schedule", "Element Overview").
- Confirm with OK.

After selecting the report name, it is locked. To change it later use the right-click context command **Change Report Definition**.

### Step 3: Select sub-report and formatting options

A second dialog appears with all remaining properties:

- **Sub Report**: choose the section (named grouping) within the report definition.
- Set formatting properties such as text height, alignment, direction, column widths, and colors.
- Confirm to proceed.

### Step 4: Select entities (Model Space only)

If you are working in Model Space, the command line prompts:

```
Select entities:
```

Select any combination of supported entity types. The selection can be expanded or reduced later via the right-click menu.

If you are in Paper Space, the script automatically prompts you to select a viewport. If you are inside a Shop Drawing block space, it picks up the ShopDrawView automatically.

### Step 5: Pick the insertion point

```
Pick insertion point:
```

Click in the drawing to place the anchor point of the table. The table expands from this point according to the Alignment and Direction settings.

### Step 6: Adjust column widths (optional)

After placement, each column boundary is represented by a **grip point**. Drag a grip left or right to resize a column interactively. The Column Widths property in the Properties Panel is updated automatically after dragging.

---

## Properties Panel (OPM Parameters)

| Property | Type | Default | Category | Description |
|---|---|---|---|---|
| Report Name | Dropdown (string) | (first available report) | - | The master report definition to use. Populated from the company folder. Read-only after insertion; use **Change Report Definition** to change it. |
| Sub Report | Dropdown (string) | (first section in report) | - | The named section (data subset) within the selected report definition. |
| Description | Text (string) | (empty) | - | A free-text label displayed above the table as a banner row. Useful for identifying the table when multiple reports are placed in the same drawing. |
| Alignment | Dropdown (string) | Horizontal | Alignment | Controls table orientation. **Horizontal** = columns grow along the X axis. **Vertical** = columns grow along the Y axis (table is rotated 90 degrees). Changing this resets grip positions. |
| Direction | Dropdown (string) | Bottom | Alignment | Controls the direction rows are added from the insertion point. **Bottom** = rows grow upward. **Top** = rows grow downward. |
| Dimstyle | Dropdown (string) | (first alphabetically) | Format | AutoCAD dimension style used to determine text font, weight, and style. All text in the table uses this style. |
| Color | Integer | 0 | Format | AutoCAD color index for header and standard row text and borders. A value of 0 means "by entity". |
| Color Child Entities | Integer | 10 | Format | AutoCAD color index used for sub-rows (indented/child-level rows). |
| Decimals | Text (string) | (empty) | Format | Semicolon-separated list of decimal place overrides per column. Example: `2; 0; 3`. If fewer values are provided than columns, remaining columns use the unit default. |
| Column Widths | Text (string) | (auto from header text) | Size | Semicolon-separated list of column widths in drawing units. Example: `40; 80; 60`. When Text Height is changed, all column widths are scaled proportionally. Drag grip points in the drawing as an alternative to typing values. |
| Text Height | Number (double) | 100 mm | Size | Height of all text in the table, in the current drawing units. Changing this value automatically rescales all column widths. |
| Header Overrides | Text (string) | (empty) | - | Semicolon-separated list of custom column header labels that replace the names defined in the report definition. Example: `Length; Qty; Mark`. Pipe notation is supported for translation lookups: `\|Length\|; \|Quantity\|`. |

---

## Right-Click Menu Options

| Menu Item | Description |
|---|---|
| Change Report Definition | Opens the report selection dialog to switch to a different report definition or sub-report. Properties are reset to the new definition's defaults. |
| Set first column as subheader | Groups rows by the value in the first column. When consecutive rows share the same first-column value, that value is displayed only once (as a section header), and the cell borders between duplicates are reduced to a single left line. Requires at least one sorting criterion applied to the first column in the report definition. |
| Disable first column as subheader | Reverts the grouping behavior and shows all first-column values normally. This option appears only when subheader mode is active. |
| Add entities | Prompts the user to select additional GenBeams, Elements, MasterPanels, TslInst objects, MassGroups, FastenerAssemblies, CollectionEntities, or Openings to include in the report data. Entities already in the list are ignored. |
| Remove entities | Prompts the user to select entities to exclude from the report data. |
| Show only visible entities | Filters the entity list so that only entities currently visible in the drawing are included in the report data. Invisible (frozen or off-layer) entities are excluded. |
| Show all entities | Removes the visibility filter and includes all linked entities regardless of layer state. This option appears when the visibility filter is active. |
| Show dependencies | Toggles a visual overlay that draws lines from the table insertion point to each linked entity. Each entity type is shown in a distinct color (beams = color 40, sheets = color 12, elements = color 4, TslInst = color 94, openings = color 172, fastener assemblies = color 252, collection entities = color 250). Double-clicking on the table also toggles this overlay. |
| Add/Remove zone (Paper Space mode only) | Manages which element zones contribute data to the table in Element Layout mode. Enter a zone index (typically -5 to 5) to toggle it on or off. Enter 99 to include all zones; enter -99 to reset to the current active zone only. The current zone selection is shown in parentheses in the menu item label. |

---

## Automatic Position Number Assignment

When operating in Model Space or Element Layout mode, the script checks whether any of the linked GenBeam entities lack a position number (posnum = -1). If unnumbered beams are found, the script automatically assigns position numbers before generating the table and reports the assignments in the command line:

```
Element 3 Beam_LVL 200x50x2400 PosNum: 7
***** _hsbReport  has applied posnums to 2 unnumbered items. *****
```

This behavior does not apply in Shop Drawing mode.

---

## Zone Filtering (Element Layout / Paper Space)

When the script is placed in Paper Space and attached to a viewport that contains an element, data is collected from the element's GenBeams, Openings, and TslInst objects. Zones allow you to limit the data to specific layers or zones of the element:

- Zone 0 is the default (active zone of the viewport).
- Zones -5 to -1 represent zones below the active zone; zones 1 to 5 represent zones above.
- Entering zone index 99 in the Add/Remove zone dialog selects all zones simultaneously.
- Entering -99 resets to the active zone only.
- MassGroups and MassElements associated with the element are always included.

---

## Tips and Notes

- **Column width auto-scaling**: When you change the Text Height property, all existing column width values are automatically scaled by the ratio of the new to old text height. This keeps proportions consistent. The Column Widths property is updated to reflect the new values.

- **Hidden columns**: Setting a column width to 0 (or dragging its grip to collapse it) hides that column's data and border. The column still exists in the definition; its grip is offset slightly in the perpendicular direction to remain accessible.

- **Text truncation**: If a cell value is too long for its column, the script truncates the text and appends `...`. The truncation preserves a minimum of three characters before the ellipsis. Widen the column to show the full value.

- **Summary rows**: If the report definition includes a Summary Type of "Sum" for any column, a totals row is automatically drawn below each group of rows that share the same row definition name. The summary row uses the same format and color as standard data rows.

- **Invalid data guard (Shop Drawing)**: If any cell value contains the `@` character when rendered inside a shop drawing block, the script immediately erases itself and prints a warning. This prevents corrupt table output in fabrication documents.

- **Report definitions stored in the drawing**: The full report definition XML is cached in the script's internal Map when first created. This means the table continues to display correctly even if the company folder is inaccessible (for example, when the drawing is sent to a different office). The definition can be refreshed by using **Change Report Definition**.

- **Catalog-based insertion for automation**: Administrators can pre-define named catalog entries that store all property values (report name, sub-report, column widths, text height, etc.). Using the catalog key in a command macro eliminates all dialogs and places the table with a single click.

- **Multipage / Showset compatibility**: When used inside a Multipage definition, the script reads its entity data from the ShowSet of the associated ShopDrawView, including the defining entity. This ensures the table reflects exactly the entities shown in that specific view.

---

## Settings and Dependencies

| Item | Location | Purpose |
|---|---|---|
| `hsbExcel.dll` | `_kPathHsbInstall\Utilities\hsbExcel\` | Reporting engine DLL. Provides `Reports`, `GetReportSections`, `GetReportDefinition`, and `RunMapReport` methods. |
| Report definition XML files | `_kPathHsbCompany` (company folder) | Contain column definitions, filter queries, sort orders, and summary rules. Created with the hsbExcel Report Designer. |
| Catalog entries | Company catalog | Named property sets for one-command insertion without dialogs. |

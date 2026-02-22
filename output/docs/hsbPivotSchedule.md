# hsbPivotSchedule

## Overview

hsbPivotSchedule is a schedule table generator for hsbCAD that creates formatted tabular reports directly in the drawing. It collects data from selected hsbCAD entities -- elements, beams, sheets, panels, trusses, stacking items, TSL instances, tool entities, and master panels -- and presents the information in a structured grid with customizable headers, grouping, value columns, and totals. The table updates dynamically when linked entities change, making it suitable for bills of material, quantity take-offs, and structured listings of any entity property available through the hsbCAD format system.

The script supports placement in Model Space, Paper Space (via viewports), and Shop Drawing views. It works with the hsbCAD catalog system, allowing users to save and reuse table configurations across projects. A Painter Definition filter can optionally be applied to narrow down which entities appear in the schedule based on predefined classification rules.

## Usage Environment

| Property | Value |
|---|---|
| Script Type | Object (O-Type) |
| Number of Beams Required | 0 |
| Insertion Mode | Implicit Insert |
| Keywords | Schedule, Report, List, Table, BOM |
| Applicable Spaces | Model Space, Paper Space (Layout Tab), Shop Drawing Block Space |
| hsbCAD Version Required | hsbCAD 23 or higher (for viewport and painter support) |

The script operates in three primary environments:

- **Model Space** -- Select entities directly in the 3D model and place the schedule table at any point.
- **Paper Space (Layout Tab)** -- Select a viewport first, then choose entities visible through that viewport. The schedule is placed in paper space and respects the viewport scale.
- **Shop Drawing Block Space** -- When working inside a shop drawing (MultiPage or ShopDrawView), the schedule automatically resolves the entities from the define set and show set of the associated view.

## Prerequisites

1. **Entities must exist in the drawing.** At least one valid hsbCAD entity (element, beam, sheet, panel, truss, stacking item, TSL instance, tool entity, or master panel) must be present before inserting the schedule.
2. **A dimension style must be defined.** The schedule uses a DimStyle to control text appearance. Make sure a suitable dimension style exists in the drawing.
3. **Painter Definitions (optional).** If you want to filter entities by painter, the painter definitions must be created in the drawing beforehand. The script can also auto-create painter definitions from catalog entries.
4. **Catalog entries (optional).** To use saved configurations, catalog entries must have been previously stored for the hsbPivotSchedule script.

## Usage Steps

### Inserting the Schedule Table

1. **Launch the script** by inserting `hsbPivotSchedule` from the hsbCAD TSL insertion mechanism (for example via the TSL palette, command line, or ribbon).

2. **If you are in a Layout Tab (Paper Space):**
   - You are prompted to **select a viewport**. Click on the desired viewport.
   - If the viewport is linked to an hsbCAD element (wall, floor, roof), the entity type is detected and set automatically. You are then prompted to pick an insertion point in paper space.
   - If the viewport is an ACA (AutoCAD Architecture) viewport, the script switches to model space so you can select entities manually.

3. **If a catalog entry or execute key is provided**, the script loads the saved configuration automatically. Otherwise, the standard **properties dialog** opens.

4. **In the dialog**, configure the following:
   - **Type** -- Choose the entity type for the schedule (see the full list in Properties Panel Parameters below).
   - **Mode** -- Choose between "for each Instance" (one schedule per selected entity) or "as Collection" (all entities in a single schedule).
   - **Painter** -- Optionally select a Painter Definition to filter entities.
   - **Format fields** -- Configure the Header, Group, Value, and Totals format strings.
   - **Display settings** -- Set columns, text height, colors, and dimension style.

5. **Select entities** when prompted. The prompt adapts to the chosen type:
   - "Select masterpanels" / "Select stickframe walls" / "Select beams" / "Select sheets" / and so on.
   - You can select multiple entities. Nested selection is allowed.

6. **Pick an insertion point** for the schedule table:
   - In **Collection mode** or when only one entity is selected, you are prompted to click a single point for the table location.
   - In **"for each Instance" mode** with multiple entities, you pick a relative insertion point and the script creates one schedule instance per entity, positioned relative to each entity's origin.

7. The schedule table appears at the chosen location, displaying grouped rows with value columns and optional totals.

### Adding Entities After Insertion

1. Right-click on the schedule table to open the context menu.
2. Select **"Add Entities"**.
3. You are prompted to select additional entities of the matching type.
4. The schedule recalculates to include the new entities.

### Removing Entities After Insertion

1. Right-click on the schedule table to open the context menu.
2. Select **"Remove Entities"** (available only when more than one entity is linked).
3. Select the entities you want to remove from the schedule.
4. The schedule recalculates without the removed entities.

### Modifying Format Columns

1. Right-click on the schedule table to open the context menu.
2. Select one of the following triggers:
   - **"Add/Remove Format Header"** -- Modify which properties appear in the table header.
   - **"Add/Remove Format Group"** -- Modify the grouping format string.
   - **"Add/Remove Format Value"** -- Modify which properties appear in the data grid cells.
   - **"Add/Remove Format Total"** -- Modify which properties appear in the totals row.
3. A numbered list of all available format variables is displayed in the command line, showing the variable name, a sample resolved value, and a checkmark if it is currently included.
4. Enter the **index number** of a variable to toggle it on or off in the format string. Enter **0** to exit.
5. The schedule recalculates with the updated format.

### Selecting a Catalog Default (Shop Drawing Context)

When the schedule is placed in a shop drawing view, an additional context menu option is available:

1. Right-click on the schedule table.
2. Select **"Select Catalog Default"**.
3. A dialog opens where you can enter a configuration name.
4. The schedule reloads using the specified catalog entry.

## Properties Panel Parameters

### General Category

| Parameter | Type | Default | Description |
|---|---|---|---|
| **Type** | Dropdown list | (first in sorted list) | Defines the entity type for data collection. Options: Masterpanel, Stacking, Truss, Wall Stickframe, Wall CLT, Element Roof/Floor, Element, Shopdrawing, Beam, Sheet, Panel, GenBeam, TslInstance, Tool Entity. This property is locked after insertion. |
| **Mode** | Dropdown list | "for each Instance" | Defines whether the schedule is created once per selected entity ("for each Instance") or as a single combined table ("as Collection"). This property is locked after insertion. |
| **Painter** | Dropdown list | \<Disabled\> | Selects a Painter Definition to filter entities. Only entities accepted by the painter will be included in the schedule. Choose \<Disabled\> to include all selected entities without filtering. |

### Formats Category

| Parameter | Type | Default | Description |
|---|---|---|---|
| **Header** | Text | `@(ProjectName)` | Defines the header text of the schedule table. Supports format variables such as `@(ProjectName)`, `@(DrawingName)`, and others. Variables enclosed in pipe characters (for example `\|Number\|`) are automatically translated. |
| **Group** | Text | `@(ProjectName)` | Defines how entities are grouped into rows. For example, `@(Material)` groups all entities of the same material together. Supports all format variables available on the selected entity type. |
| **Value** | Text | `@(PosNum)` | Defines what data is displayed in each cell of the data grid. Common examples: `@(PosNum)`, `@(Length)`, `@(Width)@(Depth)`. Multiple variables can be concatenated in a single string. |
| **Totals** | Text | `@(Quantity)` | Defines what summary data appears in the totals column for each group and in the grand total row. Available total variables: `@(Quantity)` (count of entities), `@(Volume)` (sum of volumes), `@(Weight)` (sum of weights), `@(Area)` (sum of areas, for sheets and panels only). |

### Display Category

| Parameter | Type | Default | Description |
|---|---|---|---|
| **Columns** | Integer | 5 | Defines the maximum number of value columns per row before wrapping to the next line. Set to **0** for no limit (all values in one row). |
| **Text Height** | Double (length) | 0 | Defines the text height in drawing units. When set to **0**, the height is determined by the selected DimStyle. On viewports, the viewport scale is applied automatically. |
| **Text Color** | Integer | 0 | Defines the AutoCAD color index for the text. Use standard ACI color numbers (0 = ByBlock, 1 = Red, 2 = Yellow, and so on). |
| **Grid Color** | Integer | 252 | Defines the AutoCAD color index for the grid lines. Set to **-1** to hide the grid entirely. |
| **DimStyle** | Dropdown list | (current DimStyles) | Selects the dimension style that controls text font, height ratios, and other typographic properties of the schedule. |

### Hidden Properties

| Parameter | Description |
|---|---|
| **Painter Definition** | Stores the serialized data of the associated painter definition. This property is hidden and managed automatically. It enables auto-creation of painter definitions when catalog entries are used in new drawings. |

## Right-Click Menu

| Menu Item | Action |
|---|---|
| **Add Entities** | Opens an entity selection prompt to add more entities to the schedule. Available when the schedule is not placed on an hsbCAD viewport. |
| **Remove Entities** | Opens an entity selection prompt to remove entities from the schedule. Available only when more than one entity is currently linked. |
| **Add/Remove Format Header** | Opens an interactive command-line dialog to toggle format variables in the header format string. |
| **Add/Remove Format Group** | Opens an interactive command-line dialog to toggle format variables in the group format string. |
| **Add/Remove Format Value** | Opens an interactive command-line dialog to toggle format variables in the value format string. |
| **Add/Remove Format Total** | Opens an interactive command-line dialog to toggle format variables in the totals format string. |
| **Select Catalog Default** | (Shop Drawing context only) Opens a dialog to select a saved catalog configuration to apply to the schedule. |

## Settings

The script uses the hsbCAD catalog system to save and load configurations. Catalog entries are stored under the script name `hsbPivotSchedule` and contain all property values (Type, Mode, Painter, format strings, display settings).

- **Saving a configuration:** Use the standard hsbCAD catalog save mechanism to store the current property set under a named entry. A dialog with a "Configuration" text field appears when this mode is triggered.
- **Loading a configuration:** When inserting the script with an execute key matching a catalog entry name, the configuration is loaded automatically. In shop drawing context, the "Select Catalog Default" context menu option allows switching configurations.
- **_LastInserted fallback:** The script automatically falls back to the `_LastInserted` catalog entry if the specified execute key does not match any existing entry.
- **Auto-create Painter Definitions:** When a catalog entry includes a Painter Definition that does not yet exist in the current drawing, the script automatically creates it on first recalculation (during `_bOnDbCreated`). This ensures portability of schedule configurations across drawings. The painter's Name, Type, Filter, and Format are all stored in and restored from the hidden property.

The script also uses the dictionary system (`MapObject`) with the dictionary name `"hsbTSL"` and key `"hsbPivotSchedule"` for runtime caching.

## Tips

- **Use format variables wisely.** The `@(VariableName)` syntax resolves against the entity. Use the "Add/Remove Format" context menu triggers to explore all available variables for your selected entity type rather than guessing variable names.
- **Invalid format variables are reported.** If a format variable cannot be resolved, the script displays a warning in the command line identifying which variable is unknown, helping you correct typos or mismatched variable names.
- **Combine multiple variables in one format string.** You can write `@(PosNum) - @(Material) @(Length)x@(Width)` to create rich cell content. Plain text between variables is preserved literally.
- **Group strategically.** Setting the Group format to `@(Material)` groups all beams of the same material into one row; setting it to `@(ElementName)` groups by parent element. Experiment to find the grouping that suits your report.
- **Control table width with the Columns property.** If you have many entities in a group, limiting the columns (for example to 5 or 10) causes the value cells to wrap into multiple rows rather than creating an extremely wide table. Set to 0 for no wrapping.
- **Use Painter filters for complex models.** When a model contains many entity types, use a Painter Definition to narrow the schedule to only the entities you need (for example only structural beams, only exterior sheets). If the painter filters out all entities, the command line reports which entity types were present versus what the painter expected.
- **Weight calculation uses hsbCenterOfGravity.** The `@(Weight)` total variable triggers the `hsbCenterOfGravity` script via MapIO to compute accurate weight values. This may increase recalculation time for large entity sets.
- **Viewport scale is handled automatically.** When placed in paper space on a viewport, the text height is multiplied by the viewport scale factor, ensuring consistent appearance regardless of viewport zoom.
- **For SIP panels, masterpanel data is accessible.** When the Type is set to Panel and master panels exist in the drawing, additional format variables become available: `@(Masterpanel_Number)`, `@(Masterpanel_Name)`, `@(Masterpanel_Information)`, and `@(Masterpanel_Style)`.
- **For beams, cut angle properties are available.** The additional format variables `@(CutN)`, `@(CutP)`, `@(CutNC)`, and `@(CutPC)` expose beam end-cut angle data in the schedule.
- **SubMapX data is fully supported.** Any custom data stored in an entity's subMapX is automatically exposed as format variables in the Add/Remove Format dialogs, allowing schedules to report on custom TSL-attached metadata.
- **Translation support.** Format strings containing pipe-delimited text (for example `|Number|`) are automatically translated through the hsbCAD translation system, enabling multilingual schedule output.
- **GenBeam types force Collection mode.** When the Type is set to Beam, Sheet, Panel, or GenBeam, the script automatically switches to Collection mode regardless of the Mode setting. This is because the "for each Instance" mode is not meaningful for individual beam-level entities.
- **Shop drawing auto-type detection.** When the Type is set to Shopdrawing and the schedule is linked to a MultiPage, the script automatically detects the actual entity type from the define set (wall, truss, masterpanel, and so on) and switches the internal type accordingly. The Type dropdown label remains "Shopdrawing" but the data collection adapts.
- **Position number collection in shop drawings.** When a single GenBeam with a position number is present in a shop drawing show set, the schedule automatically collects all GenBeams in the drawing that share the same position number. This is useful for summarizing all instances of a particular beam cut across the project.
- **Stacking entity filtering.** In Stacking mode, entities with zero or near-zero volume (such as label-only TSL instances) are automatically excluded from the schedule to avoid blank rows.

## Technical Notes

| Property | Value |
|---|---|
| Script Name | hsbPivotSchedule |
| Version | 2.8 |
| Last Updated | 2023-11-27 |
| Authors | Thorsten Huck, Marsel Nakuci |
| Script Type | O-Type (Object, free-standing) |
| Implicit Insert | Yes |
| Unit System | Millimeters (with U() conversion) |
| Dictionary | `hsbTSL` / `hsbPivotSchedule` |

### Entity Type Index Mapping

The internal type index determines which entities are collected:

| Index | Type | Entity Class |
|---|---|---|
| 0 | Masterpanel | MasterPanel |
| 1 | Stacking | TslInst (with Hsb_Child[] subMapX) |
| 2 | Truss | TrussEntity |
| 3 | Wall Stickframe | ElementWallSF |
| 4 | Wall CLT | ElementWall |
| 5 | Element Roof/Floor | ElementRoof |
| 6 | Element | Element |
| 7 | Shopdrawing | MultiPage / ShopDrawView |
| 8 | Beam | Beam |
| 9 | Sheet | Sheet |
| 10 | Panel | Sip |
| 11 | GenBeam | GenBeam |
| 12 | TslInstance | TslInst |
| 13 | Tool Entity | ToolEnt |

### Data Collection Logic

- For **Element** types (indices 3-6): The script collects all GenBeams, Openings, and attached TslInst entities from the element. The current script instance is excluded to avoid circular references.
- For **Masterpanel** type: The script collects all nested ChildPanels and their associated Sip entities.
- For **Stacking** type: The script reads the `Hsb_Child[]` subMapX to collect child entities. TSL instances with zero or near-zero volume are filtered out.
- For **Truss** type: The script collects GenBeams and TslInst entities from the TrussDefinition.
- For **Shopdrawing** type: When linked to a MultiPage, the script auto-detects the entity type from the define set (for example if the define set contains a wall, it switches to wall mode). It also tracks the relative position to the MultiPage origin so the schedule moves with the page when relocated.
- For **GenBeam** types (indices 8-11): In shop drawing context, if a single GenBeam with a position number is in the show set, the script collects all GenBeams with the same position number across the drawing.
- For **TslInstance** and **Tool Entity** types (indices 12-13): The script collects the selected TSL instances or tool entities directly. Other TSL types not matching the requested mode are purged from the selection set.

### Display and Rendering

- The schedule is drawn using the `Display` class with `draw()` for text and polyline grid rectangles.
- Grid cells are rendered as rectangles using `PLine.createRectangle()`.
- Group rows, value cells, and total rows are drawn in separate display objects with independent color control.
- A filled separator bar is drawn between group rows using `PlaneProfile` with `_kDrawFilled`.
- Text alignment: group text is left-aligned top, value text is left-aligned top within cells, total text is right-aligned.
- The grand total row is marked with a summation symbol (sigma).
- Hide directions are set on all display objects for both X and Y axes to ensure proper visibility control.

### Recalculation Behavior

- The Type and Mode properties are locked (`setReadOnly(true)`) after insertion to prevent accidental changes that would invalidate the entity selection.
- When entities are added or removed via context menu triggers, `setExecutionLoops(2)` is called to force a full recalculation.
- When the format is modified via the Add/Remove Format triggers, `setExecutionLoops(2)` is also called after the user finishes toggling variables.
- The script tracks the relative position to MultiPage origins via a `vecOrg` entry in the internal Map, so the schedule table moves with the shop drawing page when it is relocated. If the user manually moves the insertion point (`_Pt0`), the offset is recalculated.
- Invalid entities (deleted or corrupted) cause the script to display an error message and, in non-debug mode, erase itself.
- The Painter property is validated on each recalculation; if the selected painter no longer exists, it falls back to the first available painter and triggers a recalculation.
- If no entities can be collected (for example all were filtered by the painter), a text message is displayed at the insertion point explaining the situation. In shop drawing context this is suppressed to a simple "Shopdraw Setup" label.
- A duplicate-insertion guard prevents multiple instances from being created during a single insert cycle (`insertCycleCount() > 1`).

### Version History

| Version | Date | Change |
|---|---|---|
| 2.8 | 2023-11-27 | Support translation of formats when given inside pipes |
| 2.7 | 2023-07-10 | Check element validity |
| 2.6 | 2021-09-28 | Full subMapX support, painter definition can filter child entities, hidden property for auto-creating painter definitions in blank drawings |
| 2.5 | 2021-08-06 | Collection of all genbeams with same posnum in shop drawing relation, SIP panels may show masterpanel data |
| 2.4 | 2021-03-08 | Display in element layout corrected, new CutN/CutP/CutNC/CutPC properties for beams |
| 2.3 | 2021-03-01 | Bugfix for stacked entities in shop drawing |
| 2.2 | 2021-02-26 | Bugfix for totals not being shown |
| 2.1 | 2021-01-22 | Alert on invalid format definitions |
| 2.0 | 2020-12-17 | Various bugfixes |
| 1.9 | 2020-12-01 | Default catalog set via trigger used without changing properties |
| 1.8 | 2020-11-30 | Add trigger to set catalog |
| 1.7 | 2020-11-27 | Fix bug for shop drawings |
| 1.6 | 2020-10-28 | Resolve stacking items in model space |
| 1.5 | 2020-10-19 | Resolve stacking items based on multipages, bugfix on adding/removing format variables |
| 1.4 | 2020-10-01 | Support for ACA and hsbCAD viewports, beams, sheets, panels, and shop drawings |
| 1.3 | 2020-09-23 | Supporting parent stacking data for grouping |
| 1.2 | 2020-08-21 | Painter and viewports added (requires hsbCAD 23+) |
| 1.1 | 2020-08-21 | Area and weight added to possible total formats |
| 1.0 | 2020-08-20 | Initial version |

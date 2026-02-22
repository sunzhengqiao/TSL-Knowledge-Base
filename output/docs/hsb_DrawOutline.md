# hsb_DrawOutline

## Overview

`hsb_DrawOutline` is a TSL script for hsbCAD that generates a 2D flat outline (plan view) of selected structural elements directly in the 3D model. Depending on the operating mode chosen at insertion, it traces the outline of **walls** (with type-based hatching and color coding), individual **beams**, **floor/roof elements**, or **sheets**.

The script operates as a persistent, live-linked entity: once placed, it tracks the selected objects and redraws itself automatically whenever those objects move or change. It is the primary tool for generating schematic floor-plan overlays, framing plan annotations, and element-boundary references without leaving Model Space.

Key capabilities by mode:

- **Walls mode** — draws the plan footprint of selected wall elements (ElementWall entities). Walls are classified by a user-defined type code (e.g., `A`, `B`, `D`, `E`) and rendered with distinct outline colors and fill hatch patterns for External, Party, Load-Bearing, Internal, and Other categories. Openings (doors, windows) are identified with `D`, `W`, or `O` labels. Point loads attached to walls are also drawn as a cross symbol.
- **Beams mode** — draws the shadow profile (top-down projection) of selected timber beams onto the working plane.
- **Floors mode** — generates a hidden-line projection of an entire floor or roof element, including both its beams and sheets as a combined solid. The element number is placed as a text label at the geometric center.
- **Sheets mode** — draws the shadow profile of selected sheet panels (OSB, gypsum, etc.) onto the working plane.

After initial placement the outline instance can be repositioned freely in the drawing, and objects can be added or removed from the tracked set using right-click context menu commands.

**Script version:** 2.15 (November 2017)

---

## Usage Environment

- **Script type:** O-Type (Object — no beams are pre-linked at definition; all entities are selected interactively during insertion)
- **Works in:** Model Space only. The outline is drawn as AutoCAD display geometry in the 3D model. This script is not intended for Paper Space or shop drawing layouts.
- **Beams required at start:** 0 (all objects are selected by the user during insertion)
- **Compatible entity types:** ElementWall (walls mode), Beam (beams mode), ElementRoof/floor elements (floors mode), Sheet (sheets mode)

---

## Prerequisites

Before running `hsb_DrawOutline`, confirm the following:

1. **At least one compatible entity must already exist in the drawing.** The mode you choose at insertion determines what you must have: wall elements for Walls mode, timber beams for Beams mode, a floor or roof element for Floors mode, and sheet panels for Sheets mode. If nothing is selected or no valid objects are found, the script cancels itself automatically.

2. **Wall type codes must be consistently applied to your wall elements** if you intend to use the automatic color-and-hatch classification in Walls mode. The script matches the code field of each ElementWall against your configured code lists (`Code External Walls`, `Code Party Walls`, etc.). Walls whose code does not match any category are drawn as "Other" using the default color and hatch.

3. **Standard hsbCAD line types, hatch patterns, and dimension styles must be loaded** in the drawing. The Properties Panel dropdowns for Line Type, Hatch patterns, and Dim Style are populated from the built-in system catalogs (`_LineTypes`, `_HatchPatterns`, `_DimStyles`). These are present in any standard hsbCAD drawing template.

4. **For Floors mode:** each floor or roof element selected must contain at least one beam or one sheet, otherwise the instance erases itself. Additionally, only one floor element per instance is supported in Floors mode — the script automatically creates one instance per selected floor when multiple floors are chosen at insertion.

---

## How to Use

### Step 1 — Launch the tool

Type `hsb_DrawOutline` at the AutoCAD command prompt, or activate it from the hsbCAD tool palette. The tool launches into its insertion phase.

### Step 2 — Choose the operating mode

A dialog or command-line prompt presents four modes:

| Mode | What is drawn |
|---|---|
| **Walls** | 2D plan outlines of wall elements, classified and colored by wall type code |
| **Beams** | Top-down shadow profiles of individual timber beams |
| **Floors** | Hidden-line projection of a complete floor/roof element (beams + sheets combined) |
| **Sheets** | Top-down shadow profiles of sheet panels |

The mode is locked in after insertion and cannot be changed later (the `Enter the required mode` property is set to read-only after the first calculation).

### Step 3 — Select entities

A selection prompt appears matching the chosen mode:

- **Walls mode:** "Please select Walls" — select one or more ElementWall entities using any AutoCAD selection method.
- **Beams mode:** "Please select Beams" — select one or more Beam entities.
- **Floors mode:** "Please select Floors" — select one or more floor/roof elements. If you select multiple floor elements, the script automatically creates a separate instance for each one and then removes the original instance you just placed.
- **Sheets mode:** "Please select Sheets" — select one or more Sheet entities.

If no valid objects are selected, the script displays "No valid object selected" in the command line and cancels without placing anything.

### Step 4 — Confirm insertion

After selection, the outline instance is placed in the drawing. The 2D outline geometry is computed immediately and drawn at the location of the selected objects. The instance's origin point is automatically set to the bottom-left vertex of the bounding box of the drawn geometry.

### Step 5 — Review and adjust in OPM

Click the placed outline instance to select it. Open the Properties Palette (Ctrl+1 or the `PROPERTIES` command) to inspect and change the display settings described below. Any change triggers an automatic recalculation and redraw.

---

## Properties Panel (OPM Parameters)

### General Category

| Property | Type | Default | Description |
|---|---|---|---|
| **Show in Disp Rep** | String | (empty) | Restricts the outline to a specific Display Representation. When left empty the outline is always visible regardless of the active display state. Enter a display representation name (e.g., `Reflected`) to show the outline only in that representation. |
| **Line Type** | String (dropdown list) | First available line type | The AutoCAD line type used to draw all outline polylines. The dropdown is populated from the hsbCAD system line type catalog. |
| **Enter the required mode** | String (dropdown list) | Walls | Selects the operating mode: `Walls`, `Beams`, `Floors`, or `Sheets`. This property is locked to read-only after the first insertion and cannot be changed on an existing instance. |
| **Show Cummulative Opening Dimension** | String (Yes/No) | No | (Walls mode) When set to `Yes`, cumulative dimension annotations are drawn for wall openings. |
| **Dim style** | String (dropdown list) | First available dim style | The AutoCAD dimension style used when the script draws dimension annotations (opening dimensions in Walls mode). |
| **House Level group name** | String | Ground Floor | The name of the top-level drawing group to which this script instance is assigned. This organizes multiple outline instances in the layer/group tree. |
| **Floor Level group name** | String | Wall Layout | The name of the second-level group under the house level group. Used alongside `House Level group name` to form a two-level group path in the project tree. |

### External Walls Category

Applies only in **Walls mode**. Controls the appearance of walls whose type code matches the External Walls code list.

| Property | Type | Default | Description |
|---|---|---|---|
| **Code External Walls** | String | `A;B;` | Semicolon-separated list of wall type codes that identify External walls (e.g., `A;B;EXT;`). The match is case-insensitive. Walls whose element code matches any entry in this list are drawn with the External color and hatch. |
| **Hatch for External Walls** | String (dropdown list) | None | The hatch pattern applied to the filled area of External wall outlines. Select `None` to draw only the outline without fill. |
| **Color External Walls** | Integer (AutoCAD color index) | 1 | Outline color for External walls. AutoCAD color index 1 = Red. |
| **Select the External Walls Hatch Color** | Integer (AutoCAD color index) | 1 | Fill hatch color for External walls. Applied independently from the outline color so you can use a lighter or different hatch tint. |

### Party Walls Category

Applies only in **Walls mode**. Controls walls that separate one dwelling unit from another (fire walls, compartment walls).

| Property | Type | Default | Description |
|---|---|---|---|
| **Code Party Walls** | String | (empty) | Semicolon-separated list of wall type codes identifying Party walls. Leave empty if no party wall classification is needed. |
| **Hatch for Party Walls** | String (dropdown list) | None | Hatch pattern for Party wall areas. |
| **Color Party Walls** | Integer (AutoCAD color index) | 3 | Outline color for Party walls. Color index 3 = Green. |
| **Select the Party Walls Hatch Color** | Integer (AutoCAD color index) | 1 | Hatch fill color for Party walls. |

### Bearing Walls Category

Applies only in **Walls mode**. Controls structural load-bearing walls that are not classified as External or Party.

| Property | Type | Default | Description |
|---|---|---|---|
| **Code Load bearing Walls** | String | `A;B;` | Semicolon-separated list of wall type codes identifying Load-Bearing walls. |
| **Hatch for Load bearing Walls** | String (dropdown list) | None | Hatch pattern for Load-Bearing wall areas. |
| **Color Load bearing Walls** | Integer (AutoCAD color index) | 4 | Outline color for Load-Bearing walls. Color index 4 = Cyan. |
| **Select the Bearing Walls Hatch Color** | Integer (AutoCAD color index) | 1 | Hatch fill color for Load-Bearing walls. |

### Internal Walls Category

Applies only in **Walls mode**. Controls non-load-bearing partition walls inside the building envelope.

| Property | Type | Default | Description |
|---|---|---|---|
| **Code Internal Walls** | String | `D;E;` | Semicolon-separated list of wall type codes identifying Internal walls. |
| **Hatch for Internal Walls** | String (dropdown list) | None | Hatch pattern for Internal wall areas. |
| **Color Internal Walls** | Integer (AutoCAD color index) | 2 | Outline color for Internal walls. Color index 2 = Yellow. |
| **Select the Internal Walls Hatch Color** | Integer (AutoCAD color index) | 1 | Hatch fill color for Internal walls. |

### Other Walls Category

Applies only in **Walls mode**. Defines the fallback appearance for any wall whose type code does not match any of the four categories above.

| Property | Type | Default | Description |
|---|---|---|---|
| **Hatch for Others** | String (dropdown list) | None | Hatch pattern for uncategorized walls. |
| **Color other walls** | Integer (AutoCAD color index) | 3 | Outline color for uncategorized walls. Color index 3 = Green. |
| **Select the Hatch Color** | Integer (AutoCAD color index) | 1 | Hatch fill color for uncategorized walls. |

---

## Right-Click Menu Options

The context menu commands available depend on which mode the instance uses. They appear when you right-click a selected `hsb_DrawOutline` instance.

### Walls Mode

| Menu Item | Description |
|---|---|
| **Add Elements** | Opens a selection prompt ("Please select Elements") to add more wall elements to the tracked set. The outline is redrawn immediately to include the newly added walls. |
| **Remove Elements** | Opens a selection prompt to select wall elements you want to remove from the tracked set. Only walls currently tracked by this instance can be removed. The outline updates after removal. |

### Beams Mode

| Menu Item | Description |
|---|---|
| **Add Beams** | Opens a selection prompt ("Please select Beams") to add more beams to the tracked set. |
| **Remove Beams** | Opens a selection prompt to remove beams from the tracked set. |

### Sheets Mode

| Menu Item | Description |
|---|---|
| **Add Sheets** | Opens a selection prompt ("Please select Sheets") to add more sheet panels to the tracked set. |
| **Remove Sheets** | Opens a selection prompt to remove sheet panels from the tracked set. |

> **Note:** Floors mode does not provide Add/Remove context menu commands. Each Floors-mode instance is permanently linked to exactly one floor or roof element.

---

## Tips and Notes

**Wall code matching is case-insensitive and prefix-based.** The script converts both the wall element code and your configured code lists to uppercase before comparing. You can enter codes in any case in the Properties Panel. Codes are separated strictly by semicolons. Do not use spaces around the semicolons, and always close the list with a trailing semicolon (e.g., `A;B;` rather than `A;B`).

**Classification priority follows a fixed order.** When a wall's code matches entries in more than one category, the first match wins in this order: External → Party → Load-Bearing → Internal → Other. Ensure your code lists are mutually exclusive if you want predictable results.

**Openings are labeled and subtracted from the wall footprint.** In Walls mode, door openings are labeled `D`, windows `W`, and all other opening types `O`. Each label is drawn in color 4 (Cyan) at the midpoint of the opening along the wall's horizontal axis. The area of the opening is removed from the hatch fill, so the printed plan accurately shows void areas.

**Point loads are drawn as a cross symbol.** Any TSL instance attached to a tracked wall that stores a `mpPL` map key with a `plPointLoad` polyline is visualized as an outlined rectangle and two diagonal cross lines in color 3 (Green). This provides a quick visual indicator of concentrated load areas in the plan.

**The outline origin moves automatically.** On every recalculation the script identifies the lowest-left vertex of all drawn geometry and uses it as the reference origin point. When you physically move the outline instance, the script detects the translation vector and shifts all geometry accordingly, keeping the displayed outlines aligned with the dragged position.

**Floors mode creates one instance per element.** When you select multiple floor elements in Floors mode, the script loops through them, creates a new TSL instance for each one, and then deletes the parent instance you originally placed. The result is one persistent outline instance per floor. This is by design to allow individual floors to be independently positioned and labeled.

**The element number is shown as a text label in Floors mode.** The label is drawn at the geometric center of the element's bounding box. The label position is stored as a grip point (`_PtG[0]`) so you can drag it to a better location if the automatic placement overlaps other geometry.

**Mode is permanent after insertion.** The `Enter the required mode` property is set to read-only immediately after the first execution. If you need a different mode (for example, switching from Walls to Beams), you must delete the existing instance and place a new one.

**Unit independence.** All dimensional values in this script use the `U()` conversion function and are compatible with both metric (mm) and imperial (inch) hsbCAD drawing templates.

**Display representation filtering.** If your project uses multiple display representations (e.g., a standard architectural plan and a reflected ceiling plan), use the `Show in Disp Rep` property to assign this outline to a specific representation. This prevents the outline from cluttering views where it is not relevant.

**Group assignment for project organization.** Every instance assigns itself to a two-level group hierarchy defined by the `House Level group name` and `Floor Level group name` properties. The combined group path is `{House Level}\{Floor Level}`. Adjust these names to match your project's group structure so that outline instances appear in the correct location in the hsbCAD project tree.

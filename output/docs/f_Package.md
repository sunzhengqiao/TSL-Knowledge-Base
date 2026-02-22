# f_Package

## Overview

`f_Package` is an Object-type TSL script that is part of the hsbCAD freight and transport stacking workflow. It groups one or more `f_Item` stacking items into a named, numbered shipping package, draws color-coded footprint overlays in both the top-view (plan) grid and the truck-elevation cross-section, and automatically writes package metadata (number, wrapping material) back to the source entities' Stacking property sets.

---

## Metadata

| Field | Value |
|-------|-------|
| Script Type | O (Object) |
| Beams Required | 0 |
| Current Version | 2.22 |
| Release Date | 22 September 2025 |
| Keywords | Stacking, Truck, Package, Nesting |
| DXA Output | Yes |
| Implicit Insert | Yes |

---

## Usage Environment

| Space | Supported |
|-------|-----------|
| Model Space | Yes |
| Paper Space | No |
| Shop Drawing View | No |

This script operates entirely in Model Space as part of the `f_Stacking` solution (alongside `f_Truck`, `f_Item`, and related stacking scripts). It is inserted after items have already been distributed onto a truck grid.

---

## Prerequisites

- A complete **f_Stacking** setup must already exist in the drawing: at least one `f_Truck` and the associated `f_Item` entities must be present.
- All items you intend to package must belong to the **same truck**. Items from different trucks cannot be combined into a single package.
- The `f_Stacking.xml` settings file must be available in the company settings folder (`<CompanyPath>\TSL\Settings\f_Stacking.xml`). This file defines available colors, text height, wrapping materials, and visual style options for packages. If the file does not yet exist, the script creates the `Settings` subfolder automatically at first insertion.
- A **Stacking** property set definition must exist in the drawing if you want package data written back to the source entities (the property set name is configurable via `PropsetName` in the `SourceEntity` section of `f_Stacking.xml`).

---

## How to Use

### Step 1: Launch the Script

Type `TSLINSERT` at the AutoCAD command line and select `f_Package.mcr` from the script browser.

If a catalog entry has been preconfigured, you can pass the entry name directly via the execute key. If the catalog key matches a known entry name (case-insensitive), property values are loaded from that catalog entry silently. If no catalog key is found or no key is provided, the script automatically opens its insertion dialog.

### Step 2: Configure Package Properties in the Dialog

A dialog window appears at insertion time. Set or confirm the following before clicking OK:

- **Number** -- The package's unique identifier number within the truck. Set to `0` to let the script automatically assign the next available free number.
- **Information** -- Free-text annotation for the package. Separate multiple lines with `\n`.
- **Format** -- A format expression that controls the text shown on the package label. Use `@(VariableName)` tokens. See the Format Variable Reference section below for available tokens.
- **Style** -- The visual style of the label: `Text only`, `Border` (outline circle or rounded rectangle), or `Filled Frame` (semi-transparent filled background at 80% transparency).
- **Wrapping** -- The wrapping material applied to this package. Available options are read from `f_Stacking.xml`. Select `Disabled` (or `No` in KLH projects) if no wrapping is needed.

Click **OK** to proceed.

### Step 3: Select Items to Include

After accepting the dialog, the command line prompts:

```
Select item(s):
```

Click on one or more `f_Item` entities in the drawing. The script validates each selected entity by checking:

1. The entity has a valid `Hsb_Item` sub-MapX reference.
2. The entity has a valid layer parent reference (`Hsb_LayerParent`).
3. The layer has a valid truck/grid parent reference (`Hsb_GridParent`).
4. All selected items belong to the same truck as the first valid item found.

Items from other trucks, or entities that are not valid `f_Item` instances, are silently skipped.

If no valid items are selected, the script aborts and erases itself automatically. If at least one valid item is selected, the package entity is created and the selected items are linked to it.

### Step 4: Review the Result

After creation, the package entity draws:

- A **filled or outlined footprint** in the top-view (plan) grid, colored according to the package number and the sequential color list defined in settings.
- A **filled or outlined profile** in the truck-elevation view, showing the stacked cross-section of the contained items.
- A **label** placed at the label grip point, displaying the resolved Format text (package number, dimensions, weight, or other properties). The label shape can be a plain text, a circle or rounded-rectangle border, or a filled frame, depending on the Style setting.
- A **leader line** drawn automatically from the label to the nearest package boundary point when the label grip is positioned outside the package footprint.

---

## Properties Panel (OPM Parameters)

These parameters appear in the AutoCAD Properties Palette when the package entity is selected. They can be edited at any time after insertion.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Number | Integer | 0 | Package number within the truck. Setting to `0` triggers automatic assignment of the next free number. Changing this value causes the script to find the next available slot starting from the entered value. |
| Information | String | (empty) | Free-text annotation. Use `\n` to separate multiple lines within the label if the Format string references this field. |
| Format | String | (empty) | Controls the text displayed on the package label. Supports `@(VariableName)` tokens (see Format Variable Reference). Use `\P` to create line breaks in the label. |
| Style | String (dropdown) | Text only | Visual style of the label: `Text only`, `Border` (outline circle or rounded rectangle), or `Filled Frame` (semi-transparent filled background). |
| Wrapping | String (dropdown) | Disabled | Wrapping material for the package, sourced from `f_Stacking.xml`. For KLH projects, shows `No` / `Yes` options. The selected value is written back to linked source entities' Stacking property set. |

**Note for KLH projects and read-only mode:** When the `PropertyReadOnly` flag is set to `1` in the `SourceEntity` section of `f_Stacking.xml`, or when the project type is KLH, the `Format` and `Style` properties are locked as read-only on insertion. Use the **Block Properties** or **Unblock Properties** context menu command to toggle editability.

---

## Right-Click Menu Options

Right-clicking the package entity shows the following context commands:

| Command | Description |
|---------|-------------|
| Add Items | Prompts you to select additional `f_Item` entities to include in this package. Valid new items are appended; items already in the package are skipped. |
| Remove Items | Prompts you to select `f_Item` entities to remove from this package. The package-parent link is cleared from any removed items. |
| Add/Remove Format | Opens an interactive command-line list of all available format variables from the package and its parent truck. Each variable is shown with its current resolved value and a `(+)` or `(-)` indicator showing whether it is currently absent from or present in the Format string. Enter the index number of a variable to toggle it. Enter `0` to exit. |
| Global Settings | Opens a sub-dialog to configure the **Group Assignment** behavior for all `f_Package` instances in the drawing. Options are `Default` (group by entity) or `No group assignment` (assign to layer 0). Changing this setting recalculates all other package instances in the drawing. |
| Block Properties / Unblock Properties | Available in KLH and `PropertyReadOnly` mode only. Toggles the read-only state of the `Format` and `Style` properties on this package instance. |

Double-clicking the package entity triggers the **Add Items** workflow, the same as the right-click context command.

---

## Format Variable Reference

The `@()` token syntax in the **Format** property supports the following built-in variables:

| Token | Description |
|-------|-------------|
| `@(Number)` | Package number |
| `@(Weight)` | Calculated total weight of all items in the package, in kg (computed via the `hsbCenterOfGravity` script). Displayed with two decimal places for values under 10 kg, or as whole numbers for 10 kg and above. |
| `@(Quantity)` | Number of entities linked to the package |
| `@(Length)` | Package dimension along the world X axis |
| `@(Width)` | Package dimension along the world Z axis |
| `@(Height)` | Package dimension along the world Y axis |
| `@(Truck.*)` | Any variable from the parent truck entity's property sets; prefix with `Truck.` (e.g., `@(Truck.Name)`). Project-level, Group-level, and Element-level variables from the truck are excluded. |

Additional variables from both the package's and the truck's attached property sets are listed dynamically via the **Add/Remove Format** context command. The variable list is presented in alphabetical order by translated name.

**Example Format string:**

```
Pkg @(Number)\P@(Weight)\P@(Length)x@(Width)x@(Height)
```

This produces a three-line label showing the package number, total weight, and overall dimensions.

---

## Automatic Package Numbering

When the **Number** property is `0`, or when a package is first created, the script scans all other `f_Package` instances associated with the same truck, collects their existing numbers, and assigns the lowest available positive integer starting from 1.

When you manually enter a number that is already assigned to another package on the same truck, the script increments until a free number is found.

---

## Visual Color Assignment

The package overlay color is determined automatically from the package number:

- If a `SequentialColor[]` list is defined under `Package` in `f_Stacking.xml`, the color cycles through that list using the package number as the index, wrapping around if there are more packages than colors.
- If no `Package\SequentialColor[]` is defined, the script falls back to `Truck\SequentialColor[]`.
- If no sequential color list is defined at all, the AutoCAD color index is set equal to the package number directly.

---

## Property Set Integration

The script attaches the **Stacking** property set to each source entity linked to this package and writes the following fields automatically on every recalculation:

| Stacking Field | Value Written |
|----------------|---------------|
| Package Number | Current value of the Number property |
| Package Wrapping | Current value of the Wrapping property |

The name of the property set is configurable via the `PropsetName` key in the `SourceEntity` section of `f_Stacking.xml`. The property set is only updated (not created or structurally modified) -- it must already exist as a definition in the drawing.

---

## Settings File Reference (f_Stacking.xml)

The following settings keys under the `Package` section control the appearance and behavior of packages:

| Key Path | Type | Default | Description |
|----------|------|---------|-------------|
| `Package\Color` | Integer | 12 | Fallback AutoCAD color index |
| `Package\DimStyle` | String | (current) | Dimension style used for label text |
| `Package\TextHeight` | Double | U(100) | Text height for labels (minimum enforced: U(10)) |
| `Package\SequentialColor[]` | Integer list | (none) | Cyclic color list indexed by package number |
| `Package\Wrap[]\Name` | String list | (none) | Available wrapping material names |
| `Package\Grid\Linetype` | String | CONTINUOUS | Linetype for plan-view overlay |
| `Package\Grid\LinetypeScale` | Double | U(1) | Linetype scale for plan-view overlay |
| `Package\Grid\Transparency` | Integer | 90 | Transparency for plan-view fill (0=opaque, 100=wireframe only) |
| `Package\Grid\LineThickness` | Double | U(30) | Ring thickness for plan-view contour outline |
| `Package\Truck\Linetype` | String | CONTINUOUS | Linetype for truck-elevation overlay |
| `Package\Truck\LinetypeScale` | Double | U(1) | Linetype scale for truck-elevation overlay |
| `Package\Truck\Transparency` | Integer | 60 | Transparency for truck-elevation fill |
| `Package\Truck\LineThickness` | Double | U(30) | Ring thickness for truck-elevation contour |
| `Package\Contour\Thickness` | Double | 0 | Wrapping contour thickness (KLH: applied inward; others: applied symmetrically) |
| `Package\GripDistanceOnInsert` | Double | (none) | Initial X offset of the label grip from the profile center at insertion time (v2.22+) |
| `Package\GlobalSettings\GroupAssignment` | Integer | 0 | 0 = Default (group by entity), 1 = No group assignment (layer 0) |
| `SourceEntity\PropsetName` | String | Stacking | Name of the property set to update on source entities |
| `SourceEntity\PropertyReadOnly` | Integer | 0 | 1 = Lock Format and Style as read-only on insertion |

---

## KLH-Specific Behavior

When the project is identified as a KLH project (via `projectSpecial()`):

- **Weight** is always calculated, regardless of whether `@(Weight)` appears in the Format string.
- Items at the physical **bottom** and **top** of the stacked package are identified using shadow-profile intersection analysis across both the top view (Z-plane) and side view (X-plane). A `BOTTOMPANEL` or `TOPPANEL` marker is written to each source entity's extended MapX data.
- A **DataLink** reference pointing back to the package instance is written to each source entity's MapX, enabling external data connections.
- A **wrapping contour** is drawn as a solid opaque ring around the package elevation profile when a PlotViewport is present in the truck entity. The contour thickness is configured via `Contour.Thickness` in settings and is applied inward from the package boundary.
- When wrapping is enabled (any option other than `No`), an additional colored border (color 5) with a thickness of U(4) is drawn around the truck-elevation profile.
- The **Wrapping** property dropdown shows `No` / `Yes` instead of material names.
- The `Format` and `Style` properties are set to read-only on insertion by default.

---

## Label Grip Behavior

The package label has a movable grip point that is initially positioned at the center of the truck-elevation profile extent. You can drag this grip to reposition the label anywhere in the drawing.

- If the grip is inside the package footprint, only the label is displayed.
- If the grip is dragged outside the footprint, a leader line is drawn automatically from the label boundary to the nearest point on the package outer profile.
- The label boundary shape adapts to the content: when the text fits within a roughly square area (width less than or equal to 1.6 times height, with 3 lines or fewer), a circle is drawn. Otherwise, a rounded rectangle is used.

The initial X offset of the label grip at insertion time can be preset via the `GripDistanceOnInsert` parameter in the `Package` section of `f_Stacking.xml` (available from version 2.22 onward).

---

## Moving the Package

Dragging the package's base insertion point (`_Pt0`) along the X axis moves all linked `f_Item` entities together with the package, preserving the group relationship. Y-axis movement of the base insertion point is locked automatically -- only horizontal repositioning is permitted.

---

## Data Published by the Script

On every recalculation, the script publishes the following data for downstream consumption:

| Key | Location | Description |
|-----|----------|-------------|
| `EntityRef[]` | Internal Map | Array of handles to all source entities referenced by the package items |
| `MapWeight\Weight` | SubMapX on `_ThisInst` | Total weight of the package in kg |
| `Hsb_PackageParent\ParentUid` | SubMapX on each `f_Item` | Handle of this package instance, written to each child item |
| `Hsb_TruckParent\MyUid` | SubMapX on `_ThisInst` | Handle of the parent truck |

---

## Version History

| Version | Date | Change |
|---------|------|--------|
| 2.22 | Sep 2025 | Added `GripDistanceOnInsert` XML parameter for label grip initial positioning |
| 2.21 | Oct 2024 | Fixed DataLink saving issue |
| 2.20 | Oct 2024 | Provide DataLink reference to the TSL on source entities |
| 2.19 | Sep 2024 | Added Global Settings context command for group assignment control |
| 2.18 | Jun 2024 | Changed strategy for investigating Top/Bottom flag using shadow-profile analysis |
| 2.17 | Jun 2024 | Write MapX containing f_Package reference to bottom and top panel |
| 2.16 | Jun 2024 | Provide handle for bottom and top panel in package for KLH |
| 2.15 | Nov 2023 | For KLH, always calculate weight regardless of Format string |
| 2.14 | Sep 2023 | Apply contour thickness on the inside for KLH |
| 2.13 | Jul 2023 | Apply configurable contour thickness at packages |
| 2.12 | Jun 2023 | Read `PropertyReadOnly` flag from XML settings |
| 2.11 | Jun 2023 | On insert, set Format and Style as read-only for KLH |
| 2.10 | Feb 2023 | Added translation support for property names and wrapping materials |
| 2.9 | Feb 2023 | Draw contour when wrapping is applied |
| 2.8 | Jan 2023 | Modified Wrapping property for KLH (No/Yes instead of material names) |
| 1.0 | Aug 2017 | Initial release |

---

## Tips and Notes

- A package requires at least one valid `f_Item` entity. If you complete the selection step without selecting any valid items, the package entity is erased automatically.
- All items in a single package must belong to the same truck. Mixed-truck selections are filtered out silently during both insertion and the Add Items command.
- The `f_Stacking.xml` settings file is cached in the AutoCAD drawing dictionary as a `MapObject`. If you update the XML on disk, close and reopen the drawing to reload the settings.
- The package entity is drawn on the Information Layer and is set to draw-order front, so its overlays always appear above other entities.
- Weight calculation delegates to the `hsbCenterOfGravity` script via `callMapIO`. It collects the actual entities inside each `f_Item` (not the items themselves) for accurate mass computation.
- To see all packages belonging to a specific truck highlighted, use the truck entity's context commands or selection filters based on the Stacking property set.
- The script supports full internationalization: all user-facing strings use the `T()` translation function with pipe-delimited keys.
- Inserting the script more than once in a single insert cycle (e.g., via rapid double-click) is guarded -- the second cycle erases the instance immediately.

# hsbCLT-X-Fix-L

## Overview

`hsbCLT-X-Fix-L` is a TSL script for hsbCAD that creates **Greenethic X-Fix-L** connections between two CLT (Cross-Laminated Timber) panels. The X-Fix-L is a longitudinal connector — it runs along the length of the joint between two panels, in contrast to the X-Fix-C (which distributes discrete connectors along an edge) and the X-Fix-Connector (which places individual connectors). The X-Fix-L produces a continuous mortise-and-tenon style interlocking profile that spans the full overlapping length of two joined panels.

The script:

- Automatically detects whether the connection is **parallel**, **mitred**, or **T-connected** between two SIP/CLT panels and calculates the correct joint geometry for each case.
- Applies the machining cut to both panels using a **Dove (dovetail) tool** (default) or a custom **FreeProfile tool** loaded from an XML settings type definition.
- Registers the connector as a **HardWrComp** hardware component (manufacturer: Greenethic) linked to the element Bill of Materials.
- Publishes **shop drawing annotation requests** (dimension lines, text labels, hidden-line profiles) so that connected shop drawing scripts can render the connection correctly.
- Supports optional **chamfers** and **relief cuts** at the panel faces to accommodate machining constraints.

This script is version **1.6** (05 December 2024). It is the L-variant (longitudinal, single joint per instance) of the X-Fix family. See the comparison table at the end of this document for differences from related scripts.

---

## Usage Environment

| Environment | Supported | Notes |
|---|---|---|
| Model Space | Yes | Only environment where this script runs |
| Paper Space | No | Not applicable |
| Shop Drawing | No | Script generates data consumed by shop drawing tools, but does not run in Paper Space itself |
| hsbView | Yes | Graphics are saved to file for rendering (added in v1.6) |

- **Script type:** O-Type (Object/Tool)
- **Panels required:** Exactly 2 CLT/SIP panels per connection instance
- **Beams required at definition time:** 0 (panels are selected interactively during insertion)
- **Associative:** Yes — if linked panels move or change geometry, the connection automatically recalculates

---

## Prerequisites

Before running this script, confirm the following:

1. **Two CLT/SIP panels must exist in the model.** The panels must be in one of three recognized geometric configurations:
   - **Parallel** — panels lie in parallel planes and share a common face edge (e.g., two wall panels side by side in the same plane).
   - **Mitred** — panels meet at an angle, with a vertex of one panel touching the face of the other.
   - **T-connection** — one panel (the "male") butts into the face of the other (the "female"), forming a T or L junction.

2. **The panels must have a meaningful overlapping length** in the connection direction. If the computed common range is zero or negligible, the script cancels with the message "no common range" and erases the instance.

3. **The settings file `hsbCLT-X-Fix-L.xml` should be present** in one of two locations:
   - Company path: `[hsbCompany]\TSL\Settings\hsbCLT-X-Fix-L.xml`
   - Installation path: `[hsbInstall]\Content\General\TSL\Settings\hsbCLT-X-Fix-L.xml`

   If no settings file is found, the script still operates using the built-in default dovetail geometry (hexagonal profile with `XWidth` = 24.75 mm and `ZDepth` = 41.06 mm). Named types loaded from the XML extend and override this default.

4. **At least two panels must be selected during insertion.** If fewer than two are selected, the script cancels immediately with the message "This tool requires at 2 panels. Tool will be deleted."

---

## How to Use

### Step 1 — Launch the script

Type `hsbCLT-X-Fix-L` at the AutoCAD command prompt, or insert it from the hsbCAD tool palette using the TSLINSERT command and selecting `hsbCLT-X-Fix-L`.

### Step 2 — Configure type (dialog or catalog)

At insertion, the script displays its property dialog. You can:

- **Select a type** from the Type dropdown (if named types have been defined in the settings XML), or accept the `<Default>` entry to use the built-in dovetail geometry.
- **Load a catalog preset** by supplying an execute key — the script will apply saved property values from the named catalog entry and skip the manual dialog.

If neither a catalog key nor settings types are available, the dialog will show only the `<Default>` entry and the built-in geometry will be used.

### Step 3 — Select panels

The prompt **"Select panels"** appears. Select exactly two CLT/SIP panels that share the joint you want to connect. Standard AutoCAD selection methods work (single click, window, etc.).

- You must select at least 2 panels. If fewer than 2 are valid SIP entities, the script cancels.
- If more than 2 panels are selected, the script creates **separate instances** for every pair combination (all-pairs distribution) and erases the current multi-panel instance. Each panel pair gets its own dedicated X-Fix-L instance.

### Step 4 — Connection geometry is computed

After panel selection, the script automatically:

1. Identifies the connection type (parallel, mitred, or T-connection) from the panel coordinate systems.
2. Computes the reference point and orientation axes for the joint.
3. Determines the overlapping length between the two panels at the joint.
4. Calculates the joint profile (solid shape) using either the built-in default hexagonal dovetail shape or the custom shape from the selected type.

If the joint geometry is invalid (e.g., overlapping panels with the same Z-axis direction but non-coplanar faces, or a non-recognizable connection angle), the script reports an error message and cancels.

### Step 5 — Review the result

The X-Fix-L connection appears as a colored 3D solid running along the joint. The color is determined by the type definition (default color index 40). The insertion point (`_Pt0`) is placed at the midpoint of the joint.

Use the Properties Palette (Ctrl+1) to inspect and adjust parameters as described below.

### Step 6 — Adjust parameters and use right-click menu as needed

Use the OPM properties to fine-tune axis offset, chamfers, and relief cuts. Use the right-click context menu to toggle tooling visibility, edit type shapes, configure shop drawing appearance, and manage settings files.

---

## Properties Panel (OPM Parameters)

### General Category

| Property | Type | Default | Description |
|---|---|---|---|
| **Type** | String (dropdown) | `<Default>` | Selects a named connector type from the XML settings file. Each type defines a cross-section shape, tool profile, display color, maximum length, and optional width and depth overrides. When no named types are defined, only `<Default>` is available and the built-in dovetail geometry is used. |

### Alignment Category

| Property | Type | Default | Description |
|---|---|---|---|
| **Axis Offset** | Double (length) | 0 mm | Shifts the connector profile along the X-axis of the connection coordinate system (perpendicular to the joint length direction, within the joint plane). Use this to move the connector away from the center of the joint interface when the joint geometry requires an eccentric placement. |

### Chamfer Category

Chamfers are 45-degree angled cuts applied at the panel faces where the two panels meet. They are used to prevent edge damage and to accommodate slight misalignment during assembly.

| Property | Type | Default | Description |
|---|---|---|---|
| **Reference Side** | Double (length) | 0 mm | Size of the chamfer on the reference side of Panel A (the first selected panel). A value of 0 mm means no chamfer. The chamfer is applied as a BeamCut at 45 degrees along the joint length. |
| **Opposite Side** | Double (length) | 0 mm | Size of the chamfer on the opposite face of Panel A. For perpendicular (T) connections, only the perpendicular-face chamfer is applied and its size is doubled internally to account for the geometry. A value of 0 mm means no chamfer. |

### Relief Cut Category

Relief cuts are flat plane cuts applied longitudinally to each panel near the joint line. They reduce the contact surface area to ensure only the connector profile bears the load, and can compensate for dimensional tolerances in prefabricated panels.

| Property | Type | Default | Description |
|---|---|---|---|
| **Reference Side** | Double (length) | 0 mm | Depth of the relief cut on the reference face of the connection. The cut is a planar slice through the panel at a calculated position near the chamfer zone. A value of 0 mm means no relief cut. |
| **Opposite Side** | Double (length) | 0 mm | Depth of the relief cut on the opposite face. Works in combination with the Opposite Side chamfer position. A value of 0 mm means no relief cut. |

---

## Right-Click Menu Options

The following items appear in the context menu when you right-click an X-Fix-L instance in the model.

### Show Tooling / Hide Tooling

Toggles the display of the 3D machining solid. When tooling is shown, the dovetail or FreeProfile cutting body is rendered as a visible 3D solid intersecting both panels, making it easy to inspect the cut geometry in 3D. When tooling is hidden, the 3D solid is suppressed and the connection is represented only by outline graphics and shop drawing annotations.

- Default state: tooling hidden (the 3D solid is not shown by default after insertion).
- State is persisted across recalculations and file saves.
- Note: For the default dovetail type, toggling to "Show Tooling" applies a `SolidSubtract` operation to both panels. For custom FreeProfile types, the solid display is controlled by the `setDoSolid` flag.

### Edit Shape

Opens a secondary dialog to define or modify the cross-section shape for a named type. This is an administrator/setup function — it is not needed during normal daily use.

When "Edit Shape" is triggered:

1. A dialog opens showing the current type name, selection mode (Edit current shape / Select new shape), tool index, display color, maximum length, dovetail width, and dovetail depth.
2. If "Select Shape" is chosen: you are prompted to select two polylines drawn in the XY world plane — one defining the symmetric solid cross-section, one defining the tool profile for one side. A visual jig previews how the shape will appear at the joint.
3. If "Current Shape" is chosen (only available when the type already has a shape): the existing shape is retained and only the numeric parameters (color, tool index, max length, width, depth) can be updated.
4. After confirmation, the shape is saved to the drawing's settings MapObject and can optionally be exported to the XML file.

**Important:** The shape polylines must be drawn in the World XY plane before running "Edit Shape." The script cannot create polylines — you must draw them manually in AutoCAD first.

### Delete Shape

Opens a dialog listing all currently defined named types. Select a type name and confirm to permanently remove it from the settings MapObject. The `<Default>` built-in type cannot be deleted through this menu.

**Warning:** This operation modifies the shared settings MapObject that all X-Fix-L instances in the drawing reference. Deleting a type that is currently in use by other instances will cause those instances to fall back to `<Default>` geometry on their next recalculation.

### Configure Shopdrawing

Opens a dialog to control how the X-Fix-L connection is annotated in shop drawing views. Settings modified here are saved to the shared settings MapObject and affect all X-Fix-L instances in the drawing.

**Text sub-section:**

| Setting | Description |
|---|---|
| **Format** | Text format string for the label placed on each panel in shop drawing views. Default: `@(Type)` — displays the type name. You can include other variables such as `@(Length)`. |
| **Text Height** | Height of the annotation text in drawing units. |
| **Offset** | Vertical offset of the text label from the connector base line in shop drawing views. |
| **Stereotype** | The MultiPage style stereotype that controls text rendering. Select `*` for all stereotypes, or a specific named stereotype, or `Disabled` to suppress text. |
| **Color** | AutoCAD color index for the annotation text. |

**Symbol sub-section:**

| Setting | Description |
|---|---|
| **Stereotype** | The MultiPage style stereotype that controls the dove/connector symbol graphics in shop drawing views. Select `*` for all, a named stereotype, or `Disabled` to suppress the symbol. |

**Hidden Line sub-section:**

| Setting | Description |
|---|---|
| **Line Type** | AutoCAD line type name used for hidden-line projection graphics (e.g., `DASHED`, `HIDDEN`). |
| **Scale Factor** | Line type scale multiplier for the hidden-line graphics. |
| **Color** | AutoCAD color index for hidden-line projection graphics. |

### Import Settings

Reads the XML settings file from `[hsbCompany]\TSL\Settings\hsbCLT-X-Fix-L.xml` and loads it into the drawing's settings MapObject, replacing the current in-drawing settings. This menu item only appears when the settings XML file exists at the company path.

Use this to synchronize drawing settings with updated company standards after the XML has been revised externally.

### Export Settings

Saves the current in-drawing settings MapObject to `[hsbCompany]\TSL\Settings\hsbCLT-X-Fix-L.xml`. If the file already exists, you are prompted to confirm overwriting it. This menu item only appears when the settings MapObject contains data.

Use this to distribute type definitions and shopdrawing configuration created in one drawing to all future projects.

---

## Tips and Notes

**The L-variant connects exactly two panels per instance.** Unlike X-Fix-C (which distributes discrete connectors along an edge) or X-Fix-Connector (which also places individual connectors), X-Fix-L represents a single continuous longitudinal joint profile. One instance connects one pair of panels. If you select more than two panels at insertion, the script automatically creates one instance per panel pair and removes the original multi-panel instance.

**Connection type is auto-detected.** You do not need to specify whether panels are parallel, mitred, or T-connected. The script analyzes the panel coordinate systems and determines the appropriate joint geometry automatically. The three supported configurations are:
- **Parallel:** Both panels have the same thickness direction (Z-axis). The connector runs between coplanar panel faces.
- **Mitred:** Panels meet at an angle. The connector bisects the angle between both panels.
- **T-connection:** One panel butts into the flat face of the other. The "male" panel (the one whose axis intercepts the female panel face) is detected automatically. If the panels need to be swapped, the script handles this internally.

**The default dovetail profile is a hexagonal (double-trapezoid) cross-section.** The default shape has a width of approximately 24.75 mm and a depth of approximately 41.06 mm (in millimeters). These values are defined internally and used when `<Default>` is selected or when no custom shape has been defined for the active type.

**Custom shapes require two pre-drawn polylines.** When defining a new type using "Edit Shape" with "Select Shape," you must first draw:
1. A closed polyline representing the **symmetric solid cross-section** of the connector, centered at the origin in the World XY plane.
2. A closed polyline representing the **tool profile for one side only** (the right or positive-X half), also in the World XY plane.

The tool profile is automatically mirrored by the script to produce the full bilateral tool cut. Both polylines must be closed and have a non-zero area.

**Maximum Length limits where tooling is applied.** Each named type can define a `MaxLength` value. If the detected overlapping length of the two panels exceeds `MaxLength`, the display color of the connection changes to red (color index 1) as a warning, indicating the connector is being used beyond its rated capacity. Tooling is still applied, but the warning signals that a different connection type or additional connectors may be needed.

**Tool Index controls the CNC machining mode for custom shapes.** For default types, a Dove (dovetail) tool is used, which generates a standard dovetail mortise on both panels. For custom types:
- **Tool Index = 0:** Forces the Dove (dovetail) tool regardless of the custom shape, using the shape's width and depth to set the dovetail dimensions.
- **Tool Index > 0:** Uses a FreeProfile CNC tool with the specified CNC mode index. The custom tool polyline is applied to one panel and its mirror image to the other panel.

**Hardware BOM is populated automatically.** The script registers the connector as a `HardWrComp` component with manufacturer "Greenethic" and the type name as both the article number and model name. Physical dimensions (length along joint, width, and depth of the cross-section) are recorded as scale values. The hardware component is linked to the element group of the first selected panel, so it appears correctly in element-level BOMs and exports.

**Shop drawing annotation is request-based.** The script does not draw directly in Paper Space. It publishes dimension and text requests (`DimRequest[]`) in its internal map. These are consumed by shop drawing dimension scripts to place annotations in the correct element view. If no shop drawing script is active, the requests are simply stored and ignored.

**Axis Offset should be used with care on mitred joints.** On mitred connections, the X-axis of the connection coordinate system bisects the angle between the two panels. A non-zero Axis Offset shifts the connector profile along this bisector, which changes how deeply the cut enters each panel. Verify the resulting geometry visually after applying an offset.

**XML catalog version is verified on instance creation.** When a new X-Fix-L instance is first placed, the script compares the `Version` field in the drawing's settings MapObject against the version in the XML file on disk. If they differ, a notice is printed to the command line identifying the version numbers and file paths. This signals that the XML has been updated since the drawing was last worked on. Triggering a recalculation or re-inserting an instance will load the current settings.

**Unit independence.** All dimensional values in the script use the `U()` function and are compatible with both metric (mm) and imperial (inch) hsbCAD drawing templates.

---

## Comparison: X-Fix Family Scripts

| Feature | hsbCLT-X-Fix-L | hsbCLT-X-Fix-C | hsbCLT-X-Fix-Connector |
|---|---|---|---|
| Connector type | Continuous longitudinal joint | Discrete connectors distributed along edge | Individual connector at a point |
| Panels per instance | 2 (fixed) | 2 or more | 2 |
| Joint configurations | Parallel, mitred, T-connection | Coplanar edge-to-edge only | Coplanar edge-to-edge |
| Machining tool | Dove (dovetail) or FreeProfile | Dove or FreeProfile | Dovetail only |
| Distribution control | None (full overlap length) | Offset 1, Offset 2, Interdistance | Per-instance placement |
| Custom shape definition | Yes, via Edit Shape context menu | Yes, via Set Tool Contour (admin mode) | No |
| Chamfer support | Yes (reference and opposite sides) | No | Yes |
| Relief cut support | Yes | No | No |
| Shop drawing annotations | Yes (text, hidden lines, dim points) | Yes | Limited |
| Hardware BOM | Yes | Yes | Yes |
| Settings file | `hsbCLT-X-Fix-L.xml` | `hsbCLT-X-Fix-C.xml` | (built-in) |

---

## Version History

| Version | Date | Notes |
|---|---|---|
| 1.6 | 05.12.2024 | Save graphics to file for rendering in hsbView and hsbMake |
| 1.5 | 18.01.2022 | Description text corrected for block or rule set consumption |
| 1.4 | 17.01.2022 | Polyline display in shop drawings when tooling is hidden |
| 1.3 | 22.12.2021 | Faro laser scanner export unified |
| 1.2 | 22.12.2021 | Tool description format support; Faro, Share, Make exports; Dove or FreeProfile via tool index; new shape definition method |
| 1.1 | 14.04.2021 | Additional graphics drawing support; context command added for setup |
| 1.0 | 13.04.2021 | Initial release |

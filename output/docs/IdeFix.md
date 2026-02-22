# IdeFix

## Overview

IdeFix is a Tool-type TSL script (version 1.4) that automates the placement and drilling of **EuroTec Ideefix concealed connectors** in timber construction. The Ideefix connector is a cylindrical dowel-based hidden fastening system manufactured by EuroTec, used to join two timber members (e.g. post to beam, joist to rim beam, or as a rotation lock) without any visible fasteners on the exterior surfaces.

When placed, IdeFix performs the following operations:

- Drills a cylindrical barrel pocket (the "male" bore) into the primary beam where the Ideefix barrel sits.
- Drills a through-bolt hole for the clamping bolt through the secondary (female) beam.
- Optionally drills a countersunk female pocket on the face of the female beam, depending on the connector type (Floor Connector or Rotation Lock).
- Applies a Cut operation to the male beam at the connection face, trimming it flush for a proper butt joint.
- Renders a 3D visual representation of the connector body, clamping bolt shaft, and hex-head bolt.
- Draws radial screw lines around the barrel for Post Connector and Floor Connector types.
- Supports a grid pattern of multiple connectors (rows and columns) in a single placement.
- Optionally draws a labeled annotation in plan view showing the connector count and diameter (e.g. "4x IF50").

The script supports three Ideefix connector diameters (30 mm, 40 mm, 50 mm) and three application types: Post Connector, Floor Connector, and Rotation Lock.

---

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary operating environment. All 3D geometry, drilling operations, and machining data are generated here. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | The script generates 3D machining data only. Separate shop drawing scripts handle fabrication output. |

The optional plan view annotation (Show Plan Info) uses a view direction filter set to the World Z axis, so the label is only visible when viewing from above (plan view). This makes it suitable for layout sheet viewports.

---

## Prerequisites

1. **Two timber members must exist** in the model as `Beam` or `GenBeam` entities. They must be positioned at the intended connection point before running the script.
2. **The connection geometry must be valid.** The male beam should abut a face of the female beam. The script uses a snap distance of 200 mm to locate the connection.
3. **A dimension style** should be configured in the drawing if you plan to use the plan view annotation feature (Show Plan Info = Yes).
4. **Unit compatibility.** The script uses `U()` for all dimensional values, so both millimeter and inch drawing templates are supported without modification.
5. **No external settings files required.** All EuroTec product specifications (barrel depths, bolt diameters, screw lengths, axis spacings) are stored as internal lookup arrays within the script.

---

## How to Use

### Step-by-Step Insertion

1. **Launch the script** from the hsbCAD tool palette or command line using the name `IdeFix`.

2. **Select the male beam(s).** When prompted with "Select male beam(s)", click one or more primary beams. These are the members that will receive the cylindrical Ideefix barrel pocket. You may select multiple beams to create connectors on several members to the same female beam in a single operation.

3. **Select the female beam.** When prompted with "Select female beam", click the secondary (receiving) beam. This is the member through which the clamping bolt passes.

4. **Configure parameters in the dialog.** A property dialog appears showing all configurable parameters. Set the connector type, diameter, grid arrangement (rows and columns), offsets, and display options as needed (see Properties Panel below).

5. **Confirm.** After closing the dialog, the script automatically:
   - Creates one IdeFix instance per selected male beam.
   - Applies the barrel pocket drill to each male beam.
   - Applies a Cut to each male beam at the connection face plane.
   - Drills the clamping bolt through-hole in the female beam.
   - Drills the countersunk female pocket (for Floor Connector and Rotation Lock types).
   - Draws the 3D connector body, bolt shaft, and hex-head bolt geometry.

6. **Modify after placement.** All parameters remain editable via the AutoCAD Properties Palette (OPM). Selecting an existing IdeFix instance and changing any value causes immediate geometry recalculation. The connection also updates automatically if either linked beam is moved or resized.

> **Tip:** Only one dialog interaction is needed even when multiple male beams are selected. The same parameter set is applied to all instances created in that operation, but each instance is independently editable afterward.

> **Note:** If you attempt to run the insertion cycle more than once on the same instance (e.g. by pressing Enter again), the script erases the duplicate and exits cleanly.

---

## Properties Panel (OPM Parameters)

The following parameters appear in the AutoCAD Properties Palette when an IdeFix instance is selected. All values can be modified after placement and the geometry recalculates immediately.

| # | Parameter | Type | Default | Description |
|---|-----------|------|---------|-------------|
| 0 | Type | PropString (dropdown) | Post Connector | Selects the connector application type. **Post Connector** drills only the male barrel pocket and a through-bolt hole in the female beam; used for post-to-beam or vertical connections. **Floor Connector** adds a countersunk female pocket on the face of the female beam in addition to the through-bolt hole; used for joist-to-rim or horizontal connections. **Rotation Lock** uses the same geometry as Floor Connector but is intended for mechanically limited connector patterns (see Tips). |
| 1 | Diameter | PropDouble (dropdown) | 30 mm | The Ideefix barrel diameter. Available values: **30 mm**, **40 mm**, **50 mm**. Selecting a diameter automatically determines all dependent dimensions from built-in lookup tables (see Connector Specifications below). |
| 2 | Qty Rows | PropInt | 1 | Number of connectors arranged along the Z direction (vertical rows on the connection face). Minimum value: 1. |
| 3 | Qty Columns | PropInt | 1 | Number of connectors arranged along the Y direction (horizontal columns across the connection face). Minimum value: 1. |
| 4 | Center Offset Y | PropDouble | 0 mm | Shifts the entire connector grid in the Y direction relative to the default centered position at the insertion point. |
| 5 | Center Offset Z | PropDouble | 0 mm | Shifts the entire connector grid in the Z direction relative to the default centered position at the insertion point. |
| 6 | Show Plan Info | PropString (Yes/No) | No | When set to **Yes**, draws a labeled annotation visible only in plan view. The label shows the total connector count and diameter (e.g. "4x IF50") with a bounding box and leader line from the connection point. |
| 7 | Dimstyle | PropString (dropdown) | Drawing default | The AutoCAD dimension style applied to the plan view annotation text. Controls text height, font, and styling. Only relevant when Show Plan Info is set to Yes. |
| 8 | Color | PropInt | 94 | AutoCAD color index used for drawing the 3D connector geometry and plan view annotation. Change to distinguish connector types visually or to match company drawing standards. |

---

## Right-Click Menu Options

This script does not define custom right-click context menu entries. Standard hsbCAD entity operations (recalculate, erase, properties) are available through the default right-click menu on any TSL instance.

---

## Connector Specifications

When you select a Diameter, the script automatically looks up all dependent dimensions from internal arrays. You do not need to enter drill depths or bolt sizes manually.

### Post Connector (Type 0)

| Diameter | Male Barrel Depth | Female Pocket | Bolt Diameter | Screw Length | Screw Diameter | Axis Spacing |
|----------|-------------------|---------------|---------------|-------------|----------------|-------------|
| 30 mm | 27 mm | n/a | 12 mm | 40 mm | 5 mm | 50 mm |
| 40 mm | 35 mm | n/a | 16 mm | 60 mm | 6 mm | 60 mm |
| 50 mm | 45 mm | n/a | 20 mm | 90 mm | 8 mm | 80 mm |

### Floor Connector / Rotation Lock (Types 1 and 2)

| Diameter | Male Barrel Depth | Female Pocket Depth | Bolt Diameter | Screw Length | Screw Diameter | Axis Spacing |
|----------|-------------------|---------------------|---------------|-------------|----------------|-------------|
| 30 mm | 20 mm | 7 mm | 12 mm | 40 mm | 5 mm | 50 mm |
| 40 mm | 25 mm | 10 mm | 16 mm | 60 mm | 6 mm | 60 mm |
| 50 mm | 30 mm | 15 mm | 20 mm | 90 mm | 8 mm | 80 mm |

Note: The bolt through-hole diameter is the Bolt Diameter plus 2 mm (1 mm clearance on each side).

---

## Tips and Notes

**Diameter drives all specifications automatically.** When you change the Diameter, the script retrieves all dependent values (barrel drill depth, female pocket depth, clamping bolt diameter, connecting screw length, and center-to-center grid spacing) from internally stored lookup tables matching EuroTec product specifications. No manual drill depth entry is required.

**Multiple male beams in one operation.** During insertion you can select several male beams before selecting the female beam. The script creates a separate, independent IdeFix instance for each male beam. All instances share the same initial parameters from the dialog but can be edited independently afterward.

**Non-perpendicular connections are fully supported.** When the two beams meet at an angle other than 90 degrees, the script calculates the exact exit point of the clamping bolt through the female beam face using Boolean body intersection. A countersunk sinkhole is automatically added at the exit face to ensure the bolt head seats correctly on the angled surface.

**Grid layout: rows and columns.** Connectors are distributed along the Z axis (rows) and Y axis (columns) of the connection face, spaced at the standard axis distance for the selected diameter. The entire grid is centered at the insertion point before applying the Center Offset Y and Center Offset Z adjustments.

**Rotation Lock type has grid restrictions.** If you configure more than 2 rows AND more than 1 column while Type is set to Rotation Lock, the script automatically resets the type to Floor Connector and displays a warning message on the command line. Review your row and column counts before using Rotation Lock for larger grids.

**A Cut is applied to the male beam.** In addition to drilling the barrel pocket, the script applies a Cut operation at the connection face plane. This trims the male beam end flush, which is the correct geometry for a butt-joint Ideefix application.

**Plan view annotation: moving the label.** When Show Plan Info is enabled, a grip point is placed on the instance. You can drag this grip point to reposition the text label without affecting the connector geometry. The leader line automatically adjusts to connect the label bounding box to the connection point.

**The annotation label format** follows the pattern: `[total count]x IF[diameter]`. For example, a 2-row by 2-column grid of 50 mm connectors displays as "4x IF50".

**Alignment is always parallel to the female beam.** Since version 1.3, the connector array orientation is automatically set parallel to the face of the female beam regardless of the UCS orientation at the time of insertion. This ensures correct drill direction even from unusual view angles.

**Screw visualization.** For Post Connector and Floor Connector types, the script draws eight radial lines around each barrel position representing the connecting screws. These are omitted for the Rotation Lock type. The screw lines are drawn at the barrel diameter and extend at 45-degree angles for a length matching the screw length value from the lookup table.

---

## Version History

| Version | Date | Author | Description |
|---------|------|--------|-------------|
| 1.0 | 2008-03-06 | th@hsbCAD.de | Initial release. |
| 1.1 | 2008-03-07 | th@hsbCAD.de | Renamed script; added main beam drill depth. |
| 1.3 | 2011-10-18 | th@hsbCAD.de | Alignment now always parallel to the abutting member, regardless of UCS. |
| 1.4 | 2014-05-20 | th@hsbCAD.de | Bugfix for drill operations in Rotation Lock type. |

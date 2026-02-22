# hsbT-Marking

## Overview

`hsbT-Marking` is a T-type TSL script that places CNC marking inscriptions on timber members at T-connections -- the junctions where one beam (the "male" or framing beam) butts into the face of another beam (the "female" or receiving beam). Each instance of the tool sits at a single beam-to-beam contact point and uses the hsbCAD `Mark` entity to engrave a customizable text label onto the female beam, most commonly the position number of the male beam.

The script supports both individual placement and batch distribution. When launched with a selection of multiple beams or complete elements (walls, floors, roofs), it scans every T-contact within the set and automatically creates one marking instance per connection. This makes it practical to apply markings across an entire project in a single operation.

The tool integrates with the hsbCAD Painter Definition system for advanced beam filtering and provides a legacy migration path from older `HSB_G-FilterGenBeams` filter catalogs to the newer Painter workflow.

---

## Metadata

| Property | Value |
|----------|-------|
| Script Type | `T` (T-Type -- requires two beams) |
| Beams Required | 2 (male framing beam + female receiving beam) |
| Version | 2.3 |
| Implicit Insert | Yes (`#ImplInsert 1`) |
| Keywords | Marking, Mark, Inscription |
| File State | Released (`#FileState 1`) |

---

## Usage Environment

| Property | Value |
|----------|-------|
| Space | Model Space (3D construction model) |
| Element Support | Wall, Floor, Roof elements |
| Output | CNC Mark tools on the female beam |
| Visual Feedback | Short line segment and circle at each marking location in the 3D model; circle symbol in element views |

The tool operates in the 3D model and writes `Mark` tools directly onto the female beam. The resulting markings are visible in the 3D model view, element views (viewed along the element Z-axis), and in shop drawing/CNC fabrication output.

---

## Prerequisites

- Two beams forming a T-connection must already exist in the drawing.
- For element-aware side detection (Inside/Outside), the female beam must belong to an hsbCAD Element (wall, floor, or roof panel).
- If Painter-based beam filtering is desired, the relevant `PainterDefinition` entries must be configured before inserting the tool. The painter collection should be named `hsbT-Marking` for the script to discover it automatically.
- The default text format `@(PosNum)` requires that position numbers have been assigned to the beams. If position numbers are not yet assigned, the inscription will be empty.

---

## How to Use

### Step 1 -- Launch the Tool

Start `hsbT-Marking` from the hsbCAD tool palette, catalog, or command line. A dialog appears where you can choose a saved catalog entry or configure the initial property values (Side, Alignment, Format, Filters, etc.).

If the tool is launched via a catalog key (`_kExecuteKey`), it will silently load properties from the matching catalog entry without showing the dialog. If the key does not match any catalog entry, the last-inserted settings are applied.

### Step 2 -- Select Entities

After the dialog, the command line prompts:

> **Select elements and/or beams**

Pick any combination of:
- **Individual beams** -- the script will find T-connections among the selected beams.
- **Complete elements** (walls, floors, roofs) -- the script expands each element into its constituent beams and evaluates all of them.

The script needs at least two non-parallel beams in the selection to proceed. If fewer than two qualifying beams are found, the distribution instance is erased and no markings are created.

### Step 3 -- Automatic Distribution

The script enters distribution mode: for each male beam that has a T-contact with a female beam, one individual `hsbT-Marking` instance is created. The distribution instance (the parent) erases itself after spawning all children.

During distribution:
1. Male and female beams are identified according to the active filter settings.
2. A fast capsule-intersection test prunes candidates, followed by a precise body-intersection refinement.
3. Beams running parallel to each other are excluded (a T-connection requires non-parallel beams).
4. If the Inside or Outside side option was chosen, the script resolves the correct Z-axis or -Z-axis direction based on the beam's geometric position relative to the element origin.

### Step 4 -- Review and Adjust

Each created marking instance can be individually selected and refined through the Properties palette. Double-clicking an instance (or using the right-click Flip Side command) toggles the marking to the opposite face.

### Step 5 -- Verify Results

Each marking appears as:
- A short line with a small circle in the 3D model view.
- A circle symbol when viewed from the element direction (along the element Z-axis).
- A CNC inscription in shop drawing and fabrication output.

---

## Properties Panel (OPM Parameters)

### Marking Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Side** | List | Contact face | Which face of the female beam receives the mark. Options: **Contact face** (the face touched by the male beam), **Opposite contact face** (the face on the other side), **Z-axis** (the reference-side face of the beam), **-Z-axis** (the opposite reference face). During insertion or distribution mode, two additional options become available: **Inside** and **Outside**, which target the inner or outer leaf face for twin-wall elements. After placement, Inside/Outside are resolved to their corresponding Z-axis or -Z-axis value. |
| **Alignment** | List | Left | Where along the beam width the mark is placed. Options: **Left** (one edge), **Center** (beam center), **Right** (opposite edge), **Left+Right** (marks at both edges simultaneously). The definition of Left and Right is based on the element view direction for element-linked beams, or on the male beam's local axes if no element is present. |

### Inscription Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Format** | Text | `@(PosNum)` | The text to inscribe on the beam. Supports hsbCAD format tokens: `@(<KEY>)` is replaced at runtime by the corresponding beam attribute. Common tokens: `@(PosNum)` for position number, `@(Name)` for beam name, `@(Material)` for material label, `@(Label)` for custom label. Multiple tokens can be combined in a single format string. The formatting helper UI (available in hsbDesign 24 and later) assists with token selection. |
| **Horizontal** | List | Center | Horizontal anchor of the inscription text relative to the marking point. Options: **Left**, **Center**, **Right**. |
| **Vertical** | List | Center | Vertical anchor of the inscription text relative to the marking point. Options: **Bottom**, **Center**, **Top**. |
| **Alignment** (Inscription) | List | Alongside | Orientation of the text relative to the beam axis. Options: **Alongside** (parallel to beam length), **Across** (perpendicular to beam length), **-Alongside** (reversed alongside), **-Across** (reversed perpendicular), **Perpendicular**, **-Perpendicular**. |
| **Text Height CNC** | Length | 20 mm | Height of the CNC-routed inscription text in the current drawing unit. A value of 0 uses the CNC machine's default text height. |

### Geometry Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Gap** | Length | 0 | Maximum allowable gap between the male and female beam faces for a contact to still be recognized. Increase this value if beams are modeled with a small construction gap (e.g., for insulation or tolerance) and the marking is not being detected. The gap value is also used as a tolerance parameter during the capsule-intersection contact search in distribution mode. |
| **Contact** | Yes/No | No | When set to **Yes**, the male beam is dynamically stretched with a `Cut` tool at the contact plane so it physically touches the female beam. This is useful when the male beam is shorter than the zone and needs to be extended to create a real contact surface. When changed back to **No**, the stretch is removed. |

### Filter Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Marking Beams** | List | \<Default\> | Determines which beams act as the male (framing) members during distribution. The \<Default\> filter excludes beams running parallel to the element Z-axis. Additional built-in options: **X-Parallel** (only beams parallel to element X), **Y-Parallel** (only beams parallel to element Y), **Non Orthogonal** (only beams that are neither X-parallel nor Y-parallel). Any Painter Definition name from the project also appears in this list. This property is only visible during insertion or distribution mode. |
| **Beams to be marked** | List | \<Default\> | Determines which beams act as the female (receiving) members. Filter logic mirrors the Marking Beams property. This property is only visible during insertion or distribution mode. |

### Hidden Properties

| Parameter | Index | Description |
|-----------|-------|-------------|
| **Painter Definition Male** | 9 | Stores serialized Painter Definition data for the male filter. When a catalog entry is loaded in a new drawing that does not have the referenced painter, the script automatically recreates the painter from this stored stream. Hidden in normal use. |
| **Painter Definition Female** | 10 | Stores serialized Painter Definition data for the female filter. Same auto-recreation behavior as the male counterpart. Hidden in normal use. |

---

## Right-Click Context Menu

When an existing `hsbT-Marking` instance is selected and right-clicked, the following entries appear:

| Menu Item | Description |
|-----------|-------------|
| **Flip Side** | Toggles the marking between Contact face and Opposite contact face, or between Z-axis and -Z-axis. This is the quickest way to move a marking to the other side of the female beam. Double-clicking the entity triggers the same flip action. |
| **Migrate Filters -> Painters** | Visible only when legacy `HSB_G-FilterGenBeams` catalog entries are detected. Converts all compatible legacy filter definitions into `PainterDefinition` objects in one step. This is a one-time migration action for drawings from older hsbCAD versions. |
| *(Indented filter names)* | When individual legacy filters can be migrated, each appears as an indented sub-item so they can be converted one at a time rather than all at once. |

---

## Interaction Behavior

**Double-click**: Triggers the Flip Side action, identical to the right-click menu option.

**Initial color**: The instance is set to color 10 (dark yellow) upon creation.

**Grip point**: The grip at the insertion point is disabled (`setAllowGripAtPt0(false)`), so the marking cannot be accidentally moved by dragging.

**Dependencies**: The script sets dependencies on the length of both the male and female beams (`setDependencyOnBeamLength`). If either beam changes length, the marking automatically recalculates its position.

**Element group assignment**: When the female beam belongs to an element, the marking is assigned to that element's tool group with type `T`, ensuring it appears correctly in element views.

---

## Distribution Mode Details

The distribution mode (mode=1) is the primary insertion workflow. It performs the following sequence:

1. **Entity collection**: All selected beams and elements are gathered. Elements are expanded into their constituent beams.
2. **Male beam filtering**: Beams are filtered according to the Marking Beams property. If a Painter Definition is selected, it is used as the filter. Otherwise, built-in filters apply (Default excludes Z-parallel beams; X-Parallel, Y-Parallel, and Non Orthogonal filter by orientation relative to the element).
3. **Female beam filtering**: Same logic as male filtering, using the Beams to be marked property.
4. **Conflict resolution**: If the male and female filters are identical and both use a default filter, the male filter is reset to \<Default\> to avoid self-referencing conflicts.
5. **Contact detection**: For each male beam, a capsule-intersection test finds candidate female beams. This is refined with a full body-intersection check. Parallel beams are excluded.
6. **Instance creation**: For each valid male-female contact pair, a new `hsbT-Marking` instance is created with the configured properties. The insertion point is set to the intersection of the male beam center line with the female beam face.
7. **Inside/Outside resolution**: If the Side is set to Inside or Outside for element-linked beams, the script calculates the beam's position relative to the element origin and resolves to the appropriate Z-axis or -Z-axis direction.
8. **Self-cleanup**: The distribution instance erases itself after all children have been created.

---

## Duplicate Prevention

When the distribution mode creates multiple instances, the script automatically detects and removes duplicates. On each recalculation, an instance checks the female beam for other `hsbT-Marking` tools that share the same male beam, the same Side, and the same Alignment. If a match is found, the newer duplicate erases itself. This prevents double-marking when beams appear in overlapping selection sets.

---

## Twin-Wall Support

For walls built from two parallel leaf elements (twin walls), the **Inside** and **Outside** side options place the mark on the correct leaf face:

- **Inside**: Targets the face closer to the element interior (based on the beam's position relative to the element origin minus half the zone width along the element Z-axis).
- **Outside**: Targets the face closer to the element exterior.

When the female beam does not belong to a valid element, Inside defaults to Z-axis and Outside defaults to -Z-axis. The Inside/Outside options are only shown during insertion or distribution mode; after placement, each instance stores the resolved Z-axis or -Z-axis value.

---

## Non-Perpendicular Connections

When the male and female beams are not at exactly 90 degrees, the script uses `extractContactFaceInPlane` to determine the actual contact boundary between the two beams. The marking location is derived from this real intersection profile rather than a simple beam-center projection. This ensures accurate positioning on angled connections, including:

- Calculating the extent of the contact face in the relevant direction.
- Projecting marking points onto the opposite face when Side is set to Opposite contact face.
- Validating that each marking point falls within the physical profile of the female beam face.

---

## Location Validation

After computing candidate marking positions, the script validates each one against the female beam's contact face profile:

1. Points that fall outside the face profile are removed.
2. Points that land exactly on the face boundary edge (within 0.1 mm tolerance) are removed to avoid ambiguous edge markings.
3. If no valid location remains and the Contact option is off and no text is configured, the instance is erased with the message: "could not find any valid marking location. Tool will be deleted."
4. If no valid physical location remains but text is configured, the script still places the text inscription at the best available position, offset inward by half the male beam width if the computed location falls on a boundary.

---

## Painter Definition Integration

The Painter Definition system provides fine-grained control over which beams are treated as male and which as female during distribution:

- **Collection-based filtering**: If a painter collection named exactly `hsbT-Marking` exists in the Painter Definition manager, only painters within that collection appear in the filter dropdowns. This keeps the lists focused in projects with many painter definitions.
- **Fallback behavior**: If no such collection exists, all painters with type `Beam` are listed.
- **Catalog portability**: When a painter-based filter is used, the script serializes the painter's name, type, filter expression, and format into hidden properties (indices 9 and 10). When the catalog entry is loaded in a different drawing that lacks the painter, the script automatically recreates it from the serialized data.
- **Automatic catalog update**: If a painter is selected but its serialized stream is not yet stored in the catalog entry, the script updates the catalog entry to include the stream for future portability.

---

## Legacy Filter Migration

The script supports drawings that used the older `HSB_G-FilterGenBeams` script for beam filtering:

- If no painter collection named `hsbT-Marking` exists, legacy filter catalog entries appear in the Marking Beams and Beams to be marked dropdowns alongside the built-in defaults.
- When a legacy filter is selected during distribution, the script automatically converts it into a `PainterDefinition` object in the `hsbT-Marking` collection.
- The conversion translates the legacy filter's include/exclude logic, property comparisons (BeamCode, Material, Label, hsbID, Zoneindex, Name, PropertyValue), and logical operators (All/Any) into the painter filter expression syntax.
- The right-click menu provides both a bulk migration option (Migrate Filters -> Painters) and individual filter migration sub-items for selective conversion.

---

## Tips and Best Practices

- **Quick side toggling**: Double-click any marking instance to flip it to the opposite face instantly.
- **Batch application**: Select entire elements rather than individual beams to mark all T-connections in a wall, floor, or roof in one operation.
- **Gap tolerance**: If markings are not appearing on beams with small construction gaps, increase the Gap value slightly (e.g., 1-2 mm) rather than modifying beam geometry.
- **Format tokens**: Use `@(PosNum)` for position numbers, `@(Name)` for beam names, or combine multiple tokens such as `@(PosNum) - @(Name)` for composite labels.
- **Painter collections**: In large projects with many beam types, create a painter collection folder named `hsbT-Marking` in the Painter Definition manager. Only painters inside this collection will appear in the filter dropdowns, keeping the interface clean.
- **Catalog entries**: Save commonly used configurations (filter combinations, side preferences, text formats) as catalog entries. These entries carry the serialized painter data and can be shared between drawings.

---

## Error Messages

| Message | Cause | Resolution |
|---------|-------|------------|
| "could not find any valid marking location. Tool will be deleted." | The computed marking point falls outside the physical profile of the female beam's contact face. | Try setting Alignment to Center, increase the Gap value, or verify that the beams have sufficient overlap. |
| "No location found." | The contact face extraction for non-perpendicular beams returned fewer than two boundary points. | Check that the male and female beams actually intersect or overlap. Increase the Gap value if a small clearance exists. |

---

## Version History

| Version | Date | Reference | Changes |
|---------|------|-----------|---------|
| 2.3 | 25.10.2024 | HSB-22873 | Fixed contact detection with the male beam by passing the gap parameter to `filterBeamsCapsuleIntersect`. |
| 2.2 | 28.07.2023 | HSB-19669 | Painter collection folder name matching is now case-insensitive. |
| 2.1 | 03.06.2022 | HSB-15457 | Formatting helper enabled for hsbDesign 24 and higher. |
| 2.0 | 03.06.2022 | HSB-15457 | Formatting helper disabled for hsbDesign 23. |
| 1.9 | 01.06.2022 | HSB-15457 | Added twin-wall Inside/Outside sides, Painter Definition support, and legacy filter migration. Excluded blockings of twin walls from element selection marking. |
| 1.8 | 12.05.2022 | HSB-15457 | Excluded blockings of twin walls from being marked during element selection. |
| 1.7 | 22.03.2017 | -- | New visualization in element view (circle symbol visible along element Z-axis). |
| 1.6 | 23.02.2017 | -- | Tool removal on edge beams now respects the Contact option. |
| 1.5 | 23.02.2017 | -- | Added dynamic male beam contact stretching option. Enhanced tool cleanup. |
| 1.4 | 22.02.2017 | -- | Element view display rule added. |
| 1.3 | 22.02.2017 | -- | Duplicate removal on distribution. Silent catalog-entry-based insertion supported. |
| 1.2 | 21.02.2017 | -- | Bugfix for the Gap property. |
| 1.1 | 09.11.2016 | -- | Bugfix: single markings out of range but marking text still placed. |
| 1.0 | 08.11.2016 | -- | Initial release. |

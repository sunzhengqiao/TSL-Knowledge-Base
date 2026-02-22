# HSB_G-EntityInformation

## Overview

`HSB_G-EntityInformation` is a TSL script for hsbCAD that places **position number labels and entity information** directly on a Paper Space layout, reading live data from the 3D model through a selected viewport. Each beam, sheet panel, or TSL instance in the linked view receives an automatically positioned text label displaying whichever data attribute you choose — position number, name, label, sublabel, material, length, or a fully custom formatted string.

The tool was formerly called `HSB_G-Numbering` (versions 1.x through 2.x) before being renamed at version 3.00.

Key capabilities:

- **Automatic collision avoidance.** The script tries up to five candidate positions per member (center, left 20%, right 20%, left 40%, right 40% of the member axis) and shifts labels step-by-step until no two labels overlap. Positions are stored on each member and survive recalculations so that manual grip-point adjustments are preserved.
- **Flexible filtering.** Members can be included or excluded by beam code, name, label, material, hsbID, sublabel, sublabel2, zone index, or TSL script name. Multiple values are separated by semicolons and wildcard matching is supported (e.g. `ST*` or `*PINE*`).
- **Leader lines.** An optional leader line connects each label back to the corresponding member outline in the viewport.
- **Style control per entity type.** Text size, color, dimension style, and prefix can be set independently for beams, sheets, and TSL instances.
- **Element filtering.** A right-click menu lets you restrict display to a single wall or floor element, which is useful when two elements overlap in the same viewport.
- **Custom content format.** A free-text format string using `@(PropertyName)` tokens (handled by the companion script `HSB_G-ContentFormat`) overrides the built-in content options for unlimited label flexibility.

**Script version:** 3.40 (04 June 2024)

---

## Usage Environment

| Space | Role | Notes |
|---|---|---|
| Paper Space (Layout) | Primary execution space | The script instance is placed on a Layout tab. All labels are drawn in paper space coordinates. |
| Model Space | Data source | Beams, sheets, and TSL instances are read from the 3D model through the selected viewport. The user never needs to switch to model space to operate this tool. |
| Shop Drawing | Not applicable | This is a general annotation and numbering tool, not a fabrication shop drawing script. |

- **Script type:** O-Type (Object — not pre-linked to beams; the user selects the target viewport during insertion)
- **Beams required:** 0 (entities are collected automatically from the element visible in the viewport)

---

## Prerequisites

Before using this script, confirm the following:

1. **A Paper Space layout with at least one viewport must exist.** The viewport must be pointed at an hsbCAD element (wall, floor, or roof) in model space. If the viewport contains no hsbCAD data, the script instance erases itself immediately after placement.

2. **Entities to be labeled must already exist in the model.** The script reads beams, sheets, and TSL instances from the element associated with the selected viewport. Nothing is created — only labeled.

3. **Optional: a prefix catalog file (`Posnum.xml`)** placed at `[Company Path]\Custom\Posnum.xml` enables automatic per-material or per-beam-code prefix assignment. If this file is absent, prefix fields remain empty and the feature is simply unavailable.

4. **Optional: the `HSB_G-FilterGenBeams` catalog script** enables selection of saved filter definitions from the `Filter definition for GenBeams` dropdown. Without it, only the manual text filters are available.

5. **Optional: the `HSB_G-ContentFormat` companion script** must be loaded in the drawing if you use the `Content format` property for custom label templates. If it is not found, a notice appears in the command line and the label is left empty.

---

## How to Use

### Step 1 — Launch the script

Type `HSB_G-EntityInformation` at the AutoCAD command prompt, or insert it from the hsbCAD tool palette. The insertion phase begins.

### Step 2 — Select a viewport

The prompt **"Select a viewport"** appears. Click on the rectangular viewport frame in your Layout tab. The script links to that viewport and reads the hsbCAD element displayed through it.

### Step 3 — Select a position

The prompt **"Select a position"** appears. Click anywhere on the layout to place the script instance's anchor point. The script name is drawn here as an identifier label; this point is also used as the paper space origin for all label coordinates.

A settings dialog opens. You may adjust properties now or close the dialog and change them later through the Properties Palette.

After insertion, clicking the script instance and pressing Enter (or using OPM) recalculates and redraws all labels.

### Step 4 — Adjust properties

Open the Properties Palette (Ctrl+1) with the script instance selected. The properties are organized into the eight categories described in the next section. Common adjustments:

- Set `Take entities from` to choose between the full current element, a specific floor group, or the floor group of the current element.
- Set `Content` to choose what text is displayed on each label (position number, name, material, length, etc.).
- Enable `Show leader` to draw a connecting line from each label to its member.
- Use the filter fields (beam code, label, material, etc.) to restrict which members receive labels.

### Step 5 — Reposition individual labels with grip points

Each label has a blue grip point that can be dragged to move that label independently. The new position is stored on the beam or sheet entity and persists through subsequent recalculations. Use the right-click option `Reset positions for this element` or `Reset positions for entire project` to return all labels to their automatically calculated positions.

### Step 6 — Filter by element (optional)

If two elements are visible in the same viewport and you only want to label one of them, right-click the script instance and choose `Filter this element` while the desired element is the active element in the viewport. Labels for all other elements are then hidden. Use `Remove filter for this element` or `Remove filter for all elements` to restore normal display.

---

## Properties Panel (OPM Parameters)

Properties are organized into eight categories.

### Selection

These properties control which entities are included in the labeling operation.

| Property | Type | Default | Description |
|---|---|---|---|
| Include/Exclude | Dropdown | Include | Sets whether the filter fields below select entities to **show** (Include) or entities to **hide** (Exclude). When all filter fields are empty, the mode is forced to Exclude so that all entities are shown without restriction. |
| Filter beams with beamcode | Text | (empty) | Restricts labeling to beams whose beam code matches this value. Separate multiple values with semicolons. Wildcards are supported: `ST*` matches any code starting with ST; `*PINE*` matches any code containing PINE. Matching is case-insensitive. |
| Filter beams and sheets with name | Text | (empty) | Restricts labeling to entities whose Name property matches. Semicolons and wildcards are supported. |
| Filter beams and sheets with label | Text | (empty) | Restricts labeling to entities whose Label property matches. |
| Filter beams and sheets with material | Text | (empty) | Restricts labeling to entities made of a specific material (e.g. `C24`, `GL28h`, `OSB`). |
| Filter beams and sheets with hsbID | Text | (empty) | Restricts labeling by the entity's internal hsbCAD ID string. Used for precise scripted workflows. |
| Filter beams and sheets with subLabel | Text | (empty) | Restricts labeling to entities with a specific secondary label value. |
| Filter beams and sheets with subLabel2 | Text | (empty) | Restricts labeling by the tertiary label field. |
| Filter zones | Text | (empty) | Enter zone index numbers separated by semicolons to restrict labeling to entities in specific building zones. |
| Filter tsl names | Text | (empty) | Restricts labeling to TSL instances (macros) whose script name matches. Semicolons and wildcards are supported. |
| Filter definition for GenBeams | Dropdown | (empty) | Select a pre-defined filter preset from the `HSB_G-FilterGenBeams` catalog. When selected, this filter is combined with any active manual filter fields above. |
| Take entities from | Dropdown | Floorgroup from current element | Determines the source of entities to label. Options: **Selected floorgroup from list** (uses the floor group chosen in the Floorgroup property); **Current element** (labels only the element directly associated with the viewport); **Floorgroup from current element** (labels all entities in the floor group that contains the current element — the most common choice for floor plans). |
| Floorgroup | Dropdown | (first in list) | Active only when `Take entities from` is set to `Selected floorgroup from list`. Lists all floor groups found in the drawing. |

### Orientation and Position

These properties control how individual label text is oriented and where it is offset from the member center.

| Property | Type | Default | Description |
|---|---|---|---|
| Alignment | Dropdown | Aligned with entity | Controls the reading direction of each label. **Aligned with entity** — the label runs parallel to the member's own axis; **Horizontal** — all labels are drawn horizontally regardless of member orientation; **Vertical** — all labels are drawn vertically; **Custom angle** — all labels are drawn at the angle specified in the `Custom angle` field. |
| Custom angle | Number | 270 | Active only when `Alignment` is set to `Custom angle`. The rotation angle in degrees measured from the X axis. The default of 270 produces vertical text. |
| Offset X | Length | 0 | Shifts every label by this distance in the X direction relative to the entity center in model space units. Useful for nudging labels away from overlapping geometry. |
| Offset Y | Length | 0 | Shifts every label by this distance in the Y direction. |
| Horizontal text alignment | Dropdown | Left | Controls how text is aligned relative to the label anchor point. Options: Left, Center, Right. Note: when `Show leader` is enabled, this setting is overridden and the alignment is always Left. |

### General Style

| Property | Type | Default | Description |
|---|---|---|---|
| Show leader | Dropdown | Yes | When set to `Yes`, a three-segment polyline leader is drawn from each label back to the outline of the corresponding member in the viewport. The leader's start point snaps to the nearest point on the member's shadow profile. When set to `No`, labels appear without leader lines. |
| X-Offset leader | Length | 0 | Shifts the leader start point in the X direction along the member axis. |
| Y-Offset leader | Length | 0 | Shifts the leader start point in the Y direction. |
| Draw boundingbox | Dropdown | No | When set to `Yes`, a rectangular border is drawn around each label text, making it easier to read against complex linework. |
| Set beams as invalid area for numbering | Dropdown | No | When set to `Yes`, the projected footprint of each beam body is treated as a blocked zone. Labels are automatically displaced to avoid being drawn on top of beam outlines in the viewport. Useful for plans where beam outlines are drawn. |

### Style Beams

Controls the appearance of labels for standard timber beams (not sheets or TSL instances).

| Property | Type | Default | Description |
|---|---|---|---|
| Dimension style beams | Dropdown | (drawing default) | The AutoCAD dimension style used to determine text font and size for beam labels. Select from all dimension styles available in the current drawing. |
| Text size beams | Number | -1 | Override for text height in drawing units. When set to `-1`, the text size is taken from the dimension style. Any positive value directly sets the text height, scaling all text proportionally. |
| Color beams | Integer (ACI) | -1 | AutoCAD Color Index for beam labels. `-1` means the color is taken from the dimension style. Use standard ACI values (1=Red, 2=Yellow, 3=Green, etc.) to override. |
| Prefix beams | Text | (empty) | A fixed text prefix added in front of every beam label. For example, entering `B-` would produce labels like `B-01`, `B-02`, etc. |
| Use prefix catalog for beams | Dropdown | No | When set to `Yes`, the prefix is looked up automatically from the `Posnum.xml` catalog file based on the beam's beam code or material. A matching entry overrides the manual `Prefix beams` value. The catalog must be located at `[Company Path]\Custom\Posnum.xml`. |

### Style Sheets

Controls the appearance of labels for sheet panels (OSB, gypsum, etc.). All options are identical in structure to Style Beams.

| Property | Type | Default | Description |
|---|---|---|---|
| Dimension style sheets | Dropdown | (drawing default) | Dimension style for sheet labels. |
| Text size sheets | Number | -1 | Text height override for sheet labels. `-1` uses the dimension style value. |
| Color sheets | Integer (ACI) | -1 | ACI color for sheet labels. `-1` uses the dimension style value. |
| Prefix sheets | Text | (empty) | Fixed prefix added before every sheet label. |
| Use prefix catalog for sheets | Dropdown | No | Enables automatic prefix lookup from `Posnum.xml` based on sheet material. |

### Style TSL

Controls the appearance of labels for TSL instances (macro objects such as hangers, hold-downs, or connectors) when `Show content tsls` is enabled.

| Property | Type | Default | Description |
|---|---|---|---|
| Dimension style tsls | Dropdown | (drawing default) | Dimension style for TSL labels. |
| Text size tsls | Number | -1 | Text height override for TSL labels. `-1` uses the dimension style value. |
| Color tsls | Integer (ACI) | -1 | ACI color for TSL labels. `-1` uses the dimension style value. |

### Content

These properties control what text is displayed on each label.

| Property | Type | Default | Description |
|---|---|---|---|
| Content format | Text | (empty) | A free-text template string using `@(PropertyName)` tokens for fully custom label content. Example: `@(Name) - @(Width)x@(Height)-@(Length)`. When this field is non-empty, it takes priority over the `Content` dropdown and delegates formatting to the `HSB_G-ContentFormat` companion script. The new line character defined below can be used to split label text across multiple lines. |
| New line character | Text | ~ | The character sequence that triggers a line break within a TSL instance label. The default is the tilde character (`~`). You can change this if your content strings already contain tildes for other purposes. |
| Content | Dropdown | Position number and text | Selects the built-in label content type. Options: **Position number** — the entity's position number only; **Position number and text** — position number combined with the name text; **Name** — the entity Name property; **Label** — the entity Label property; **Sublabel** — the entity SubLabel property; **Extrusion profile** — the beam profile code (beams only); **Longest length** — the longest of the three solid dimensions, formatted to 0 decimal places; **Length** — the solid length along the primary axis, formatted to 0 decimal places; **Material** — the material name. |
| Show content sheets | Dropdown | Yes | When set to `No`, sheet panels are filtered out and receive no labels regardless of other settings. |
| Show content beams | Dropdown | Yes | When set to `No`, structural beams receive no labels. |
| Show content tsls | Dropdown | No | When set to `Yes`, TSL instances (macro objects) within the element are also labeled. The label is the TSL position number by default, or the custom content format if defined. Multi-line content is supported for TSL labels using the new line character. |
| Special | Text | (empty) | Reserved field for project-specific behavior. Known values: `RRL` enables a special pass for beams with beam code `RRL-01` even when beam content is hidden; `@(Length)` appends the longest length to the position number label. Contact your hsbCAD support for project-specific values. |

### Name and Description

Controls the appearance of the script instance's own identifier label drawn at the anchor point, and the colors used when an element filter is active.

| Property | Type | Default | Description |
|---|---|---|---|
| Default name color | Integer (ACI) | -1 | ACI color of the script name label drawn at the anchor point. `-1` uses the current layer color. |
| Filter other element color | Integer (ACI) | 30 | When an element filter is active (via right-click), labels for elements that are **not** the filtered element are drawn in this color. Default is color 30 (orange). |
| Filter this element color | Integer (ACI) | 1 | When an element filter is active, labels for the **filtered element** are drawn in this color. Default is color 1 (red). |
| Dimension style name | Dropdown | (drawing default) | Dimension style for the script instance name label drawn at the anchor point. |
| Extra description | Text | (empty) | Optional annotation appended to the script name label at the anchor point. Use this to distinguish multiple instances of this script in the same layout (for example, entering `BEAMS ONLY` would display `HSB_G-EntityInformation - BEAMS ONLY` at the anchor). |

---

## Right-Click Menu Options

Right-clicking a selected `HSB_G-EntityInformation` instance displays the following options in addition to the standard AutoCAD context menu.

| Menu Item | Description |
|---|---|
| Filter this element | Restricts labels to only the element currently displayed in the viewport. All other elements become visually de-emphasized (drawn in the `Filter other element color`). This is useful when two walls share the same viewport and you only want to number one of them. The filter is stored internally in the instance map and survives saves and recalculations. |
| (separator) | Visual divider — not clickable. |
| Remove filter for this element | Clears the filter for the currently active element, restoring it to normal label display. Other element filters (if any) remain active. |
| Remove filter for all elements | Clears all element filters at once, restoring all elements to normal label display. |
| (separator) | Visual divider — not clickable. |
| Reset positions for this element | Returns all grip-adjusted label positions for the current element back to their automatically calculated positions. Labels are recalculated fresh on the next redraw. Use this if manually moved labels have drifted too far from their members. |
| Reset positions for entire project | Returns all grip-adjusted label positions for every entity in the entire drawing back to automatic positions. This affects every element the script has labeled, not just the current view. Use with care — all manual repositioning work is lost. |

---

## Tips and Notes

**Multiple filter values use semicolons, not commas.** To filter for beams with beam code `ST` or `PL`, enter `ST;PL` in the `Filter beams with beamcode` field. Spaces around semicolons are ignored. Matching is always case-insensitive.

**Wildcard filtering is powerful.** Use `*` as a prefix, suffix, or both. For example, `*24*` in the material filter matches C24, GL24h, and any other material containing the string "24". A single `*` in any filter field matches everything (equivalent to leaving the field empty).

**Label positions are stored on the beam, not on the script instance.** Each time a label position is set (either automatically or by dragging a grip), the coordinates are saved in a sub-map on the beam or sheet entity itself. This means position data survives even if the script instance is deleted and reinserted, as long as the beam entities remain. It also means that if two different instances of this script label the same element, each stores its own positions independently.

**Grip points are indexed.** Each label corresponds to one grip point (`_PtG[i]`). If the viewport scale changes or the element's entity list changes length, grip indices can become mismatched. If you see the warning "Invalid position", use `Reset positions for this element` to clear stale data and recalculate from scratch.

**The `Content format` field completely overrides the `Content` dropdown.** When `Content format` is non-empty, the dropdown selection has no effect. To return to built-in content modes, clear the `Content format` field.

**The `HSB_G-ContentFormat` script must be present.** If you use the `Content format` property and `HSB_G-ContentFormat` is not loaded in the drawing, labels will be empty and a notice will appear in the command line. Load the script into the drawing to resolve this.

**Longest length vs. Length.** The `Longest length` option compares all three solid dimensions and returns the largest, regardless of which axis it is on. It also enforces that beams report width less than height (depth), and sheets report height less than width. This gives the finished board length regardless of how the piece is oriented in the model. The `Length` option always returns the `solidLength()` property along the primary axis — which may be shorter than the longest dimension for diagonally placed pieces.

**Leader start point tracks the beam outline.** When leaders are enabled, the start of each leader line is constrained to the nearest point on the beam's shadow profile (projected footprint) as seen through the viewport. The profile is shrunk by 2 mm (in paper space units) before the closest-point calculation, so the leader tip lands slightly inside the beam boundary rather than exactly on the edge. This gives a clean visual result.

**The script erases itself if the viewport is invalid.** If the viewport is deleted or no longer contains hsbCAD data, the script instance erases itself the next time it recalculates. Reinsert the script and select a valid viewport to restore labels.

**Prefix catalog location must be exact.** The `Posnum.xml` file is read from `[Company Path]\Custom\Posnum.xml`. This is not configurable from OPM. If the file is missing or empty, the prefix catalog features are silently skipped and the manual `Prefix beams` / `Prefix sheets` fields are used instead.

**TSL label multi-line support.** When `Show content tsls` is enabled and the content contains the new line character (`~` by default), the label is split into multiple lines. Each line is drawn separately, stacked vertically. The total bounding box height is scaled proportionally to the number of lines. You can change the line break character in the `New line character` property if your content data already uses tildes.

**Changing viewport scale invalidates stored positions.** Because positions are stored in model space units relative to the member center, a change in viewport scale does not move labels incorrectly — they transform with the scale. However, if you `Zoom` within the viewport (changing the apparent scale), run `Reset positions for this element` to let the script recalculate optimal non-overlapping positions at the new scale.

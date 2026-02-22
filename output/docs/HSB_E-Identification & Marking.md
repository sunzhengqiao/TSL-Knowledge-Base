# HSB_E-Identification & Marking

## Overview

This script labels and marks the timber beams within a wall, floor, or roof element for production and assembly purposes. It serves two related but distinct functions:

1. **Beam Identification**: Prints a text label directly onto each beam face. The label can include the beam position number, element number, and project number - all in a single composite string such as `ProjectNo-ElementNo/BeamPos`. You can control which numbers appear based on the minimum length of each beam.

2. **Beam Marking**: Draws physical mark lines (scribe lines) on the face of a beam to show exactly where a connecting (crossing) beam meets it. This is the physical indication that helps assembly crews and CNC machines know the location of each intersection. You can also mark the footprint of supporting beams that sit below rafters or other framing.

Both functions can be enabled independently. The script attaches itself to an element and automatically recalculates whenever the element is regenerated or modified.

**Version**: 3.25 (20 September 2022)
**Script name**: `HSB_E-Identification & Marking`

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Attaches to 3D Elements (walls, floors, roofs). |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | Does not generate shop drawing views. |

**Script type**: O (Object - attaches to an Element entity)
**Beams required for insertion**: 0 (the element is selected after insertion)

## Prerequisites

- An existing **Element** (wall, floor, roof panel) must be present in the drawing, containing at least one GenBeam.
- The helper script **`HSB_G-FilterGenBeams`** must be loaded in the drawing. This is used when you apply named filter definitions to control which beams are treated as "female" (frame beams that receive marks) and which are "male" (connecting beams that generate the marks). If this script is not loaded, the marking will fail.
- If you use the **Override beam identification** field with format codes, the script **`HSB_G-ContentFormat`** must also be loaded.

## How to Use

### Step 1: Start the script

Run `TSLINSERT` from the AutoCAD command line, then select `HSB_E-Identification & Marking.mcr` from the file browser. A configuration dialog appears before you pick any element.

### Step 2: Configure settings in the dialog

A dialog box opens showing the same parameters that appear later in the Properties Palette. Set your preferred marking and identification options here. You can also leave the defaults and adjust them later.

### Step 3: Select one or more elements

After the dialog, the command line prompts:

```
Select elements:
```

Click on each wall, floor, or roof element you want to label. You can select multiple elements in one operation. The script will create a separate attached instance on each element.

### Step 4: Script attaches and calculates

The insertion instance erases itself and a new instance is created directly on each selected element. The script immediately calculates all marks and identification labels based on the current element geometry.

### Step 5: Adjust parameters in the Properties Palette (OPM)

Select the element or the script symbol and open the Properties Palette. You will see all parameters grouped into four categories: **Filters**, **Identification**, **Marking**, and **Visualisation**. Changing any value triggers an automatic recalculation.

### Step 6: Element regeneration

Whenever the element is regenerated (e.g., after moving a beam or changing a wall), the script recalculates all marks and identification labels automatically. No manual re-run is needed.

### Attaching to an element definition

This script can also be attached to an **element definition** (not a placed element instance). When attached to the definition, it runs automatically every time a new element is generated from that definition.

## Properties Panel (OPM Parameters)

### General

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Identifier | Text | _(empty)_ | A unique name for this script instance on the element. Only one instance per identifier per element is allowed. If you attach a second instance with the same identifier, the old one is removed. Use different identifiers (e.g., `"MarkOutside"`, `"MarkInside"`) to run multiple marking configurations on the same element simultaneously. |
| Preferred beam face | Dropdown | Outside | The face of the beam on which marks and text are placed. The script picks the beam face most aligned with the outside (or inside) of the element. If the preferred face has a tool applied to it, the script automatically switches to the opposite face and notifies you in the command line. |

### Filters

These settings control which beams in the element participate in the marking.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Filter definition female beams | Dropdown | _(empty)_ | Select a named filter preset (defined with `HSB_G-FilterGenBeams`) to determine which beams are **female beams** - the frame members that receive the mark lines. Leave blank to use the beam code field below. |
| Female beam codes to filter | Text | _(empty)_ | Enter one or more beam codes (separated by spaces or commas) to exclude specific beam types from the female beam set. **This field only applies when the filter definition above is left blank.** |
| Filter definition male beams | Dropdown | _(empty)_ | Select a named filter preset to determine which beams are **male beams** - the crossing members whose end positions are marked onto the female beams. Leave blank to use the beam code field below. |
| Male beam codes to filter | Text | _(empty)_ | Enter beam codes to exclude specific beam types from the male beam set. **This field only applies when the filter definition above is left blank.** |

**Understanding female vs. male beams:**
- A **female beam** is a frame member (e.g., a stud or plate) that receives the mark. The mark line is drawn on its face.
- A **male beam** is a crossing member (e.g., a noggin or blocking piece) that generates the mark. The script detects where the male beam body intersects the female beam and places the mark at that location.

### Identification

These settings control the printed text label placed on each beam face.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Add beam identification | Dropdown | Yes | Enables or disables the text identification label on beams. Set to `No` to suppress all identification text without removing the script. |
| Add beam ID for beams longer than | Number (length) | 0 | Minimum beam length to include the **beam position number** in the label. Set to `0` to always include it. Increase this value to suppress position numbers on short off-cuts. |
| Add element number for beams longer than | Number (length) | 250 | Minimum beam length to include the **element number** in the label. Beams shorter than this threshold will not show the element number. Default is 250 mm. |
| Add project number for beams longer than | Number (length) | 500 | Minimum beam length to include the **project number** in the label. Beams shorter than this threshold will not show the project number. Default is 500 mm. |
| Override beam identification | Text | _(empty)_ | Enter a custom format string to completely replace the standard identification text. Supports content format codes processed by `HSB_G-ContentFormat` (e.g., property references). Leave blank to use the standard numbering logic. |
| Position Text | Dropdown | Center | Where along the beam's length the identification text is placed: **Center**, **Start**, or **End**. |
| Offset Text | Number (length) | 0 | An additional offset distance applied to the text position along the beam, from the position set above. |
| UCS used for position | Dropdown | Use beam ucs | The coordinate system used to determine the direction of the text offset. **Use beam ucs** positions relative to the individual beam's own length axis. **Use element ucs** positions relative to the overall element direction, which keeps text consistently placed across all beams even when individual beams run in different directions. |
| Recalculate Position | Dropdown | Yes | When set to `Yes`, the script finds the largest gap between connecting marks along the beam and places the identification text in that gap, avoiding overlap with mark lines. When set to `No`, the text is placed at the fixed position (Center/Start/End) without checking for overlap. |

### Marking

These settings control the physical mark lines drawn on beam faces to show connection locations.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Add beam marking | Dropdown | Yes | Enables or disables the physical mark lines. Set to `No` to suppress all marking without removing the script. |
| Mark supporting beams | Dropdown | Yes | When enabled, beams on the back of the frame (e.g., rafters or purlins sitting below the main frame) also have their footprint marked on the frame. This shows assembly crews the location of structural supports behind the panel. |
| Mark touching face | Dropdown | No | Applies only to supporting beam marking. When set to `Yes`, the mark is drawn only on the actual contact area (touching face) of the supporting beam. When `No`, the full width or height of the supporting beam is used as the mark boundary. |
| Allow Markerline | Dropdown | Yes | Controls whether angled **markerlines** are permitted. A markerline can be drawn at an angle to show a diagonal connection, whereas a standard mark cannot. Set to `No` to skip diagonal connections and only use perpendicular marks. |
| Face marking | Dropdown | Reference side | Which face of the female beam receives the **mark lines**: **Reference side** (the face determined by the Preferred beam face setting) or **Connecting face** (the face that directly touches the male beam). |
| Face marking text | Dropdown | Reference side | Which face of the female beam receives the **identification text**. Can be set independently of the mark line face. This allows the lines and text to be on different faces for specific CNC or assembly requirements. |
| Marking text | Text | _(empty)_ | The text to display alongside the mark lines. Leave blank to use the default (position number). Enter `|No text|` to suppress the text. Supports format codes such as `@(PosNum)` for the beam position number. |
| Set reference face | Dropdown | No | When set to `Yes`, the script calls `setReferenceFace()` on each marked beam, designating the marked face as the machining reference. This is used by CNC workflows to orient the workpiece correctly on the machine. |
| Add markerline and text as one tool | Dropdown | No | When set to `Yes`, the mark lines and the identification text are combined into a single tool entity on the beam. When `No`, they are separate tool entities. Note: this option is automatically disabled when the mark line face and text face differ. |

### Visualisation

These settings control the appearance of the script's symbol in the model view (the symbol does not affect production output).

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Color | Integer | 4 (Cyan) | The AutoCAD color index for the script's visualisation symbol drawn at the element origin. |
| Symbol size | Number (length) | 40 | The size of the arrow-shaped visualisation symbol drawn at the element. Increase for large-scale models; decrease for densely packed elements. |

## Right-Click Menu Options

This script does not define any custom right-click (context) menu items (`addRecalcTrigger` calls).

## Tips and Notes

- **Multiple instances on the same element**: You can attach this script more than once to the same element, as long as each instance has a different **Identifier**. A common use case is running one instance for the outside face and one for the inside face with different filter settings.

- **Automatic cleanup**: If you insert a second instance with the same identifier as an existing one, the old instance is automatically removed before the new one is created. You will not end up with duplicate marking.

- **Mark face auto-swap**: If the script detects that the preferred marking face has been modified by a tool (cut, slot, etc.), it automatically switches the mark to the opposite face. A message is printed in the command line identifying which beam was affected and which side was used instead.

- **Length thresholds control label clutter**: Short pieces (blocking, cripples, short noggins) can be excluded from identification text by raising the minimum length values. This prevents very short pieces from being covered with text that cannot be stamped or burned legibly.

- **Beam UCS vs. Element UCS**: Use **Element UCS** when you want the identification text to always read in a consistent direction across the whole panel (useful when some beams run perpendicular to the main framing). Use **Beam UCS** when text should follow each individual beam's own orientation.

- **Recalculate Position**: With this enabled, the script finds the widest open space between existing mark lines and places the identification text there. This prevents text from being printed directly on or inside a mark line. Disable it only if you need the text at a strict position (Start/Center/End).

- **Supporting beam marking**: This feature is intended for roof panels where purlins or blocking beams sit behind the rafter frame. The mark shows the frame assembly crew exactly where the purlin sits and how wide it is, even though the purlin is hidden behind the frame.

- **CNC reference face**: Enabling **Set reference face** is important for automated machining. It tells the CNC machine which face of the beam was used for marking, so the machine can orient the workpiece correctly for drilling and cutting operations relative to the mark positions.

- **Filter hierarchy**: The script first checks the **Filter definition** dropdown. If a named filter is selected there, the beam code text field is ignored. Only when the filter definition is left blank does the beam code field take effect.

- **HSB_G-FilterGenBeams must be loaded**: Even if you leave the filter definitions blank and only use beam code filtering, this helper script must be present in the drawing. If it is not found, the script displays a notice and stops without creating any marks.

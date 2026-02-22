# Rothoblaas ALU

## Overview

This script places Rothoblaas ALU retractable aluminum connectors on timber beam-to-beam (or timber-to-concrete/steel) connections. It supports three product families:

- **AluMini** -- Smallest profile, for light-duty connections
- **AluMidi** -- Mid-range profile, most commonly used (default if no family is specified)
- **AluMaxi** -- Largest profile, for heavy-duty connections

Each connector is modeled as a 3D solid body and is automatically sized to fit the selected beams. The script machines the male beam by adding a slot cut and an optional beam cut-back, machines the female beam with a housing recess, and optionally drills shank pin holes. All hardware components (bracket, fasteners, shank pins) are registered in the project Bill of Materials automatically.

**Version:** 1.18 (27 June 2025)
**Manufacturer:** Rothoblaas (www.rothoblaas.com)
**Keywords:** Connector, Hanger, ALU, Slot

---

## Usage Environment

| Property | Value |
|----------|-------|
| Space | Model Space only |
| Script Type | T (Tool) -- attaches to beam entities and recalculates when beams move |
| Beams Required | 2 (one male beam, one female beam per connector instance) |

---

## Prerequisites

- At least two GenBeam entities must exist in the drawing.
- The male beam and female beam must meet at approximately 90 degrees in the horizontal (XY) plane. Non-perpendicular connections are rejected and the instance is deleted (a static cut is left on the male beam as a visual marker).
- The beam dimensions must be sufficient for the chosen connector family and type height.

---

## How to Use

### Step 1 -- Launch the Script

Insert through the hsbCAD toolbar, catalog browser, or by command:

```
^C^C(hsb_scriptinsert "Rothoblass Alu" "Mini")
^C^C(hsb_scriptinsert "Rothoblass Alu" "Midi")
^C^C(hsb_scriptinsert "Rothoblass Alu" "Maxi")
```

If no catalog entry is used (or a reserved family keyword MINI/MIDI/MAXI is used), a dialog box appears for initial property configuration. If a specific catalog entry name is provided (e.g., "Mini185 no holes"), properties are set from the catalog without a dialog.

### Step 2 -- Select Male Beam(s)

```
Command prompt: Select male beam(s)
```

Click one or more beams that will receive the connector shank (the vertical body) and the slot cut. Press Enter to confirm.

### Step 3 -- Select Female Beam(s)

```
Command prompt: Select female beam(s)
```

Click the beams that intersect the male beam(s) and will receive the connector wing and housing recess. Press Enter to confirm.

### Step 4 -- Automatic Instance Creation

The script filters female beams using a T-connection test (within 500 mm tolerance). For each valid male/female pair, a separate connector instance is created. The original insertion instance is then removed.

### Step 5 -- Review and Adjust

Select any connector instance and open the Properties Palette (Ctrl+1) to adjust parameters. The connector recalculates automatically when any property changes.

---

## Properties Panel (OPM Parameters)

### General

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Type | Dropdown | Auto detect | Connector height selection. "Auto detect" picks the largest type that fits within the female beam depth. Available heights depend on the active family (Mini: 65--215 mm in 30 mm steps; Midi: 80--440 mm in 40 mm steps; Maxi: 384--896 mm in 64 mm steps). |
| Connection Mode | Dropdown | Wood/Wood | Controls wing fastener type. Mini: Wood/Wood only. Midi: Wood/Wood, Wood/Concrete with Screw, Wood/Concrete with chemical Dowel. Maxi: Wood/Wood, Wood/Concrete with chemical Dowel. |

### Shank Drills

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Depth | Number (mm) | 0 | Depth of shank pin drill holes into the male beam. 0 = no pre-drilled holes (self-perforating pins used instead). A positive value drills from one side; use the "Flip Drill Side" right-click command to reverse direction. |

### Alignment

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Gap between Beams | Number (mm) | 3 | Gap between male and female beams at the connection face. The male beam is cut back by this amount. |
| Offset Z-Direction | Number (mm) | 0 | Vertical offset of the connector position relative to the connection point. |

### Housing

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Housing Type | Dropdown | Centered | Recess cut into the female beam for the connector wing. Options: Bottom, Centered, Top, Full Height, None. When set to "None", the male beam cut-back is extended by the bracket thickness. |
| Gap | Number (mm) | 0 | Clearance around the bracket inside the housing cut. |
| Extra depth | Number (mm) | 0 | Additional depth beyond bracket thickness (e.g., for sealant or gasket layers). |

### Slot

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Slot | Dropdown | Top | Slot position in the male beam for the connector shank. Options: Top, Bottom, Full height. |
| Gap (X) | Number (mm) | 20 | Extra slot length beyond the connector body in the beam axis direction. |
| Gap (Y) | Number (mm) | 2 | Extra slot width beyond the shank thickness. |
| Gap (Z) | Number (mm) | 20 | Extra slot depth beyond the connector body height. |
| Alignment | Dropdown | Female beam | Slot axis alignment. "Female beam" aligns with the female beam axis (standard). "Male beam" aligns with the male beam axis (use for rotated beam situations). |

### Display

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Color | Integer | 252 | AutoCAD color index for the connector 3D body. |
| Dimstyle | Dropdown | (Drawing default) | Dimension style used for annotations. |

---

## Right-Click Menu

| Command | Description |
|---------|-------------|
| MINI / MIDI / MAXI | Switches the connector family. Only the two non-active families are shown. The Type resets to "Auto detect" after switching. |
| Extend length to be cut from rod | Toggles extended type list for custom rod lengths (Midi up to 2200 mm, Maxi up to 2176 mm). Run again to revert to the standard catalog list. |
| Flip Drill Side | Reverses the side of the male beam where shank pin drill holes are placed. |

---

## Hardware Bill of Materials

Each connector instance automatically registers the following in the project BOM:

| Component | Families | Details |
|-----------|----------|---------|
| ALU bracket | All | 1 piece per instance. Model name includes height, e.g., "AluMidi 160". Material: Aluminium. |
| Wing fasteners (Wood/Wood) | Mini | HBS+ Screw, 5x60 mm. Base qty 7, +4 per type step. |
| Wing fasteners (Wood/Wood) | Midi | Anker nail, 4x60 mm. Base qty 10 (standard) or 12 (pillar), increment 4 (standard) or 2 (pillar) per type step. |
| Wing fasteners (Wood/Wood) | Maxi | Anker nail, 6x60 mm. Base qty 24, increment 8 (standard) or 4 (pillar) per type step. |
| Wing fasteners (Wood/Concrete, Screw) | Midi only | Screw-in anchor, 10x80 mm. Base qty 3, +1 per type step. |
| Wing fasteners (Wood/Concrete, Dowel) | Midi | Chemical dowel, 8x110 mm. Base qty 3, +1 per type step. |
| Wing fasteners (Wood/Concrete, Dowel) | Maxi | Chemical dowel, 16x150 mm. Base qty 6, +2 per type step. |
| Shank pin (Depth > 0) | Midi, Maxi | Steel pin, 12x[beam width] mm. Base qty 3 (Midi) or 6 (Maxi), +1 or +2 per type step. |
| Self-perforating pin (Depth = 0) | Mini | 5x[length] mm. Base qty 2, +1 per type step. |
| Self-perforating pin (Depth = 0) | Midi | 7x[length] mm. Base qty 3, +1 per type step. |
| Self-perforating pin (Depth = 0) | Maxi | 7x[length] mm. Base qty 3, +1 per type step. |

Pin lengths are rounded down to the nearest 10 mm step of the male beam depth (self-perforating pins are further reduced by 7 mm).

---

## Tips and Notes

- **Auto-detect picks the largest valid type.** If no standard size fits, the script defaults to the smallest available type and prints a warning in the command line.
- **Pillar connections receive reduced nailing.** When the female beam axis is parallel to the world Z-axis (vertical), the increment quantity for wing fasteners is halved automatically, matching the Rothoblaas partial nailing specification.
- **Non-perpendicular connections are rejected.** The script validates approximate perpendicularity in the XY-plane. If rejected, it deletes itself and leaves a static cut on the male beam.
- **Family is stored per instance.** Switching families via the right-click menu persists the change and resets the type to "Auto detect".
- **Slot alignment may need adjustment.** For rotated (non-axis-aligned) male beams, switch the Alignment property from "Female beam" to "Male beam".
- **Extended rod lengths are non-standard.** The "Extend length to be cut from rod" option unlocks custom fabrication heights. Confirm availability with Rothoblaas before specifying these in production.
- **Technical data sheets** for load capacities and minimum beam dimensions are available at www.rothoblaas.com.

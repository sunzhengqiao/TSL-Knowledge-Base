# hsbElektro Typ3

## Overview

`hsbElektro Typ3` places electrical installations (outlets, switches, luminaires, and other devices) onto a timber wall element in hsbCAD. A single instance can hold up to five device positions in one cluster.

After placement the script automatically:

- Cuts cylindrical, slotted, or rectangular pockets into studs and sheathing panels at the specified mounting height.
- Routes a wire chase (groove) through the studs so cables can reach the installation point.
- Applies "no-nail" exclusion zones to every material layer in the affected area so fastener guns and CNC nailers cannot place fasteners through cables or conduit.
- Exports all selected device types to the Bill of Materials (BOM) as `Electrical` components.
- Draws the correct 2D electrical symbol in both the element elevation view and the plan view, including a mounting-height label.

The entity is side-aware: it detects whether the insertion point is on the icon face or the back face of the element and adjusts its color (3 = icon side, 4 = back side) accordingly so dimension scripts can filter by face.

## Usage Environment

| Context | Supported | Notes |
|---|---|---|
| Model Space | Yes | Primary use. 3D machining and 2D graphics are generated here. |
| Element view (elevation) | Yes | Symbols and wire-chase lines appear in the element's own flat view. |
| Plan view | Yes | Electrical symbols are projected and scaled into the plan display. |
| Paper Space / Shop Drawing | No | This script is not a shop drawing generator. |

## Script Metadata

| Field | Value |
|---|---|
| Script type | O-Type (Object — attached to the model, not to a specific beam) |
| Beams required | 0 (the element is selected interactively at insertion) |
| Current version | 2.9 (20 December 2024) |
| Keywords | Elektro, Element |

## Prerequisites

- A timber wall **Element** must already exist in the drawing. The element must contain at least one structural stud (GenBeam) if CNC machining is expected; the 2D symbol is generated regardless.
- hsbCAD version 19.1.31 or later is required for categorised properties to display correctly in the Properties Palette.
- A TSL catalog entry may optionally be configured by your company so that the script launches with preset values and skips the selection dialog.

## How to Use

### Step 1 — Launch the script

Run `TSLINSERT` (or use the hsbCAD toolbar/menu) and select `hsbElektro Typ3`. Only one insertion cycle is permitted per instance; a second click during the same insertion cycle cancels and removes the object.

### Step 2 — Select the wall element

```
Command line prompt: Select element
```

Click the timber wall element where the electrical installation should be placed. If no element is selected the instance is removed automatically.

### Step 3 — Set the insertion point

```
Command line prompt: Select insertion point
```

Click the approximate position on or near the wall face. The script snaps the point onto the wall outline automatically and uses the element's coordinate system to determine which face you are working on.

### Step 4 — Configure device types (dialog)

If a catalog key has not been predefined, a selection dialog opens. Choose the device types for positions 1 through 5. You can leave positions empty to use fewer than five outlets.

If a catalog key is active (`_kExecuteKey`), all properties are loaded from the catalog and the dialog is suppressed.

### Step 5 — Review and adjust in the Properties Palette

After insertion all parameters are available in the AutoCAD Properties Palette (OPM). Changes take effect immediately when the entity recalculates.

## Properties Panel (OPM Parameters)

Properties are grouped into three categories.

### Category: Installation

| Property | Type | Default | Description |
|---|---|---|---|
| Elevation | Number | 400 mm | Mounting height of the centre of the installation measured from the element's base reference. Adjust this to match standard socket heights (e.g. 400 mm for floor outlets, 1100 mm for switches). |
| Alignment | Dropdown | Horizontal | Arrangement of multiple devices in the cluster. **Horizontal** places them side by side along the wall; **Vertical** stacks them above one another. |
| Installation 1 | Dropdown | (empty) | Device type for position 1. Select from the 38-item list below. Leave empty to use fewer positions. |
| Installation 2 | Dropdown | (empty) | Device type for position 2. |
| Installation 3 | Dropdown | (empty) | Device type for position 3. |
| Installation 4 | Dropdown | (empty) | Device type for position 4. |
| Installation 5 | Dropdown | (empty) | Device type for position 5. |
| Diameter | Number | 68 mm | Diameter (for drill shape) or width (for slotted/rectangular shape) of the box cutout. Use the box manufacturer's specification. |
| Depth Installation | Number | 68 mm | Depth of the box pocket into the timber. |
| Offset Installation | Number | 70 mm | Centre-to-centre spacing between adjacent device positions in the cluster, measured in the model. |

### Category: Wirechase

| Property | Type | Default | Description |
|---|---|---|---|
| Alignment (wirechase) | Dropdown | Bottom | Direction of the wire chase (groove) through the studs. Options: **Bottom** (groove runs from the installation point to the bottom plate), **Top** (groove runs upward to the top plate), **Both** (grooves run in both directions), **Kabelführung versetzen** (offset conduit — the conduit is shifted horizontally to a second grip point and a connecting groove is added), **none** (no groove, only the box pocket). |
| Width | Number | 60 mm | Width of the wire chase groove. |
| Depth | Number | 30 mm | Depth of the wire chase groove into the stud face. |

### Category: Tooling

| Property | Type | Default | Description |
|---|---|---|---|
| Shape | Dropdown | Drill | Shape of the box cutout machining: **Drill** (circular hole, uses Drill tool), **Slotted Hole** (oblong slot covering all box positions), **Rectangular** (rectangular pocket covering all box positions). |
| W+P Tool | Dropdown | Milling | CNC operation type applied to the element: **Milling** (ElemMill operation), **Drill** (ElemDrill operation), **None** (suppress CNC output, keep only beam-level geometry). |
| Tool Index | Integer | 1 | CNC tool number sent to the W+P (Weinmann/Hundegger) machine for this operation. |
| Element Tooling | Dropdown | Yes | Master toggle for all element-level CNC output (ElemMill, ElemDrill, ElemNoNail). Set to **No** to model the geometry visually without producing CNC instructions — useful for preliminary layouts. |
| Tooling zone | Integer | 0 | Selects which material layer (zone index) receives the CNC tooling. Zone 0 means the outermost layer on the insertion side. Increase this value to target an inner layer (e.g. the structural stud layer rather than the sheathing). The value is clamped automatically to the number of zones that actually exist on the element. |

## Available Device Types

The following 38 types can be assigned to positions 1 through 5. Each type generates a specific 2D symbol in the plan and element views and is exported as a named article in the BOM.

| # | Name (German) | Meaning |
|---|---|---|
| 1 | Antenne | Antenna outlet |
| 2 | Ausschalter Kontroll | Switch with indicator light |
| 3 | Ausschalter Orientierungslicht | Switch with orientation light |
| 4 | Ausschalter | Single-pole switch |
| 5 | baus Lampe mit BW + Taster | PIR lamp with push button |
| 6 | baus Lampe mit BW | PIR lamp |
| 7 | Bewegungsmelder | Motion detector |
| 8 | CAT5 | Data outlet (Cat5) |
| 9 | Dimmer | Dimmer switch |
| 10 | Fensterkontakt | Window contact |
| 11 | Geschirrspüler | Dishwasher outlet |
| 12 | Gong | Door chime |
| 13 | Haustüröffner | Door opener |
| 14 | Herdanschluss | Cooker connection |
| 15 | Jalousiemotorschalter | Blind/shutter motor switch |
| 16 | Klingeltaster | Doorbell button |
| 17 | Kreuzschalter | Four-way (cross) switch |
| 18 | Lautsprecher | Speaker outlet |
| 19 | Leuchte allgemein | General luminaire |
| 20 | Leuchte DIN (1) | DIN luminaire type 1 |
| 21 | Leuchte DIN (2) | DIN luminaire type 2 |
| 22 | Leuchte DIN (3) | DIN luminaire type 3 |
| 23 | Leuchte DIN (4) | DIN luminaire type 4 |
| 24 | Motor | Motor outlet |
| 25 | Raumthermostat | Room thermostat |
| 26 | Rollo | Roller shutter outlet |
| 27 | Rolloschalter | Roller shutter switch |
| 28 | Serienschalter | Two-circuit (series) switch |
| 29 | Sprechanlage | Intercom |
| 30 | Steckdose 2-fach | Double socket outlet |
| 31 | Steckdose | Single socket outlet |
| 32 | Taster beleuchtet | Illuminated push button |
| 33 | Taster | Push button |
| 34 | Telefon | Telephone outlet |
| 35 | Twin | Twin cable outlet |
| 36 | Wandauslass | Wall outlet (generic) |
| 37 | Waschmaschine | Washing machine outlet |
| 38 | Wechselschalter | Two-way switch |

Types with a distinct 2D symbol (Antenne, Ausschalter variants, Dimmer, Kreuzschalter, Leuchte variants, Serienschalter, Steckdose) display their full symbol in the plan view. All other types display a standard placeholder symbol.

## Side Detection and Color Coding

The script detects which face of the wall element the insertion point is closest to by comparing the insertion point to the element centroid:

| Face | Entity color | Use in dimensioning |
|---|---|---|
| Icon side (front) | Color 3 (green) | Filter for front-face dimension scripts |
| Back side | Color 4 (cyan) | Filter for back-face dimension scripts |

This color is applied to the instance itself and can be used as a filter criterion in `hsbCAD Layout-Bemassung` (layout dimensioning) scripts to produce face-specific dimensions.

## Dimension Anchor Points

The script publishes key geometry coordinates through the `_Map` object so that external dimension scripts (such as `hsbLayoutDim`) can attach dimensions:

| Map key | Content |
|---|---|
| `ptExtraDim0` | Centre point of the installation (all shapes) |
| `ptExtraDim1` | Start of the slotted/rectangular tool outline (slotted and rectangular shapes only) |
| `ptExtraDim2` | End of the slotted/rectangular tool outline (slotted and rectangular shapes only) |

## Bill of Materials (BOM) Export

Each non-empty device position (s0–s4) generates one `HardWrComp` entry:

- **Category**: Electrical
- **Article / Model / Description**: the device name string (e.g. "Steckdose", "Ausschalter")
- **Quantity**: 1 per position

The compare key used to group identical clusters in the BOM is the concatenation of all active device names and the instance's model description.

## Tips and Notes

- **Mounting height**: `Elevation` is measured from the element's own base reference, not from the drawing's world Z=0. Verify the element's reference level before specifying height.
- **Multiple devices in one cluster**: Fill positions s0 through s4. The cluster spacing is controlled by `Offset Installation`. Leave unused positions empty — they do not generate any geometry or BOM entry.
- **Alignment vs. symbol direction**: `Alignment` controls whether positions are laid out horizontally (along the wall length) or vertically (along the wall height). It also rotates the 2D symbols accordingly.
- **Offset conduit option**: When `Alignment (wirechase)` is set to `Kabelführung versetzen`, a second grip point (`_PtG[1]`) appears in the model. Drag this grip to offset the conduit run horizontally. An additional vertical connecting groove is added automatically between the installation point and the offset conduit.
- **Suppressing CNC output**: Set `Element Tooling` to `No` during design phases to keep visual geometry without generating W+P instructions. Switch back to `Yes` before exporting CNC data.
- **Targeting inner layers**: Use `Tooling zone` to direct machining to an inner stud layer rather than the outer sheathing. The value is automatically clamped so it cannot exceed the number of zones present on the element.
- **No hole in the stud**: If no drill appears in the stud, check that the insertion point overlaps with a GenBeam. The beam-level machining uses `addMeToGenBeamsIntersect` which requires geometric intersection.
- **Color coding in dimensions**: Use entity color 3 or 4 as a filter in layout dimension scripts to dimension only the front or back face installations, respectively.
- **Catalog-based insertion**: If your company has configured a TSL catalog, the script can be launched with a predefined key (`_kExecuteKey`) that loads all properties automatically and skips the dialog — useful for standardised socket heights and types.
- **Version compatibility**: Property categorisation (Installation / Wirechase / Tooling groups in the Properties Palette) requires hsbCAD 19.1.31 or later. On older versions the properties still work but appear ungrouped.

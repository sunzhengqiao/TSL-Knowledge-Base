# Rothoblaas Titan F-N

## Overview

The Rothoblaas Titan F-N script places Rothoblaas **TITAN F** and **TITAN N** angle brackets in your hsbCAD model. These L-shaped steel connectors are used to transfer shear loads between timber walls (or solid panels) and concrete foundations or slabs. The script generates a 3D model of the selected bracket, applies any required CNC milling pockets to the timber, and registers all hardware components in the Bill of Materials.

Two product families are supported:

- **Titan N** (TCN 200, TCN 240, TTN 240): Larger brackets for heavier shear loads. The base plate uses bolt anchors to the concrete and nails or screws to the timber face. A steel reinforcement washer (TCW) is available for the TCN 200 and TCN 240 models.
- **Titan F** (TCF 200, TTF 200): Smaller, lighter brackets for moderate shear loads.

The bracket can be placed on individual timber beams (stick-frame bottom plates) or on Structural Insulated Panels (SIP). When placed on a panel, extra alignment controls become available in the right-click context menu.

**Version**: 1.2 (22 October 2018, david.rueda@hsbcad.com)

---

## Usage Environment

| Property | Value |
|---|---|
| Space | Model Space only |
| Script type | O-Type (Object) — placed as a persistent, parametric entity |
| Beams required before running | None (script prompts for selection after launch) |
| Works on beams | Yes (horizontal bottom plates) |
| Works on SIP panels | Yes |
| Paper Space / Shop Drawing | Not supported |

---

## Prerequisites

Before running this script:

- At least one **horizontal timber beam** (e.g., a wall bottom plate) or one **SIP panel** must exist in the model where the bracket will be attached.
- The beam must be perfectly horizontal (perpendicular to the World Z axis). Sloped or vertical beams are automatically excluded.
- The timber member must have sufficient height to accommodate the bracket:
  - Titan N brackets require at least **140 mm** of timber depth behind the vertical plate.
  - Titan F brackets require at least **60 mm** of timber depth behind the vertical plate.
- If you want to use the **No nail areas** feature, the hsbCAM module must be installed and active.

---

## How to Use

### Step 1: Launch the script

Run `TSLINSERT` and select **Rothoblaas Titan F-N**, or double-click the script in the TSL palette.

### Step 2: Configure bracket settings in the dialog

A settings dialog opens before placement. Choose your anchor model, fastener types, and tooling options. You can also adjust these settings later through the AutoCAD Properties Palette (OPM) after placement.

### Step 3: Select the timber member(s)

The command line prompts:

```
Select beam(s) or panel(s):
```

Click on one or more horizontal beams or SIP panels. You can select multiple objects in one pick. Non-horizontal beams are automatically filtered out and a count of rejected beams is reported on the command line.

### Step 4: Define the insert side (beam mode)

For each selected **beam**, the command line prompts:

```
Select insert point  or  <Enter> to continue
```

Click a point on the face of the beam where the bracket should sit. The script snaps the bracket to the closest bottom edge on that side. You can place multiple brackets on the same beam by clicking additional points. Press **Enter** when done with that beam.

### Step 5: Define alignment direction (SIP panel mode only)

When working with **SIP panels** that are not part of a wall element, the script may ask:

```
Set the anchor alignment:
```

Click a point to indicate the direction the bracket "hangs" (i.e., which way is down relative to the panel face). For panels that are vertical in the current UCS, the script automatically suggests the negative Z direction (downward) and reports this on the command line.

### Step 6: Place the bracket(s) on the panel

```
Select insert point  or  <Enter> to continue
```

Click along the panel face to place each bracket. Press **Enter** to move to the next panel or finish.

The script creates the 3D bracket geometry, applies milling if configured, and registers hardware in the BOM. It then erases the master instance, leaving only the placed copies.

---

## Properties Panel (OPM Parameters)

After placement, select the bracket and open the **Properties Palette** (Ctrl+1) to view and modify these settings.

### Category: Type

| Property | Type | Default | Description |
|---|---|---|---|
| A - Type | Dropdown | Titan N - TCN 200 | Selects the specific bracket model. This controls all bracket dimensions, hole patterns, and the number of timber fasteners. Options: **Titan N - TCN 200**, **Titan N - TCN 240**, **Titan N - TTN 240**, **Titan F - TCF 200**, **Titan F - TTF 200**. |
| B - Reinforcement Washer | Dropdown | No | Adds a steel reinforcement plate (TCW washer) between the bracket base and the timber. Only available for Titan N - TCN 200 (uses TCW200) and Titan N - TCN 240 (uses TCW240). Ignored for all Titan F models and Titan N - TTN 240. Options: **No**, **Yes**. |

### Category: Mounting

| Property | Type | Default | Description |
|---|---|---|---|
| C - Mounting type | Dropdown | Anchor Nail LBA 4x60 | Selects the fastener used to attach the vertical plate of the bracket to the timber face. Options: **Anchor Nail LBA 4x60** (Rothoblaas LBA 4 mm x 60 mm nail, article PF601460) or **Round head screw LBS 5x50** (Rothoblaas LBS 5 mm x 50 mm screw, article PF603550). The exact quantity installed is calculated from the timber depth behind the bracket. |
| D - Anchoring to the ground | Dropdown | Expansion anchor | Defines the type of concrete anchor used in the base plate holes. Options: **Expansion anchor** (AB1), **Screw anchor** (SKR), **Chemical dowel VINYLPRO**, **Chemical dowel EPOPLUS**. Note: The Titan N TTN 240 and Titan F TTF 200 use 5 mm nail holes in the base plate instead of bolt holes, so this setting is not reflected in BOM for those models. |
| E - Screw Diameter | Dropdown | 12 mm | Diameter of the concrete anchor bolt used in the base plate. Options: **12 mm** or **16 mm**. Applies only when the selected model uses bolt holes in the base plate (TCN 200, TCN 240, TCF 200). |

### Category: Tooling

| Property | Type | Default | Description |
|---|---|---|---|
| F - Mill depth | Number (mm) | 0 | Depth of the recess milled into the timber surface so the bracket sits flush. When set to 0, no milling is applied. Enter a positive value to embed the bracket by that amount. |
| G - Oversize milling | Number (mm) | 5 | Additional clearance added on all sides of the milling pocket beyond the bracket footprint. A value of 5 mm creates a pocket that is 5 mm wider on each side than the bracket, making it easier to fit during installation. |
| H - No nail areas | Dropdown | No | When set to Yes, adds no-nail exclusion zones around the bracket on stick-frame wall elements. These zones prevent automated nailing machines from shooting nails into the bracket area. Requires the **hsbCAM module**. Has no effect on SIP panels or non-wall elements. Options: **No**, **Yes**. |

---

## Right-Click Menu Options

The following options appear in the context menu when you right-click a placed Titan F-N bracket. The first two items (Flip Z alignment and Set Z alignment) only appear on brackets attached to SIP panels, not on beam-attached brackets.

| Menu Item | Available On | Description |
|---|---|---|
| Flip Z alignment | SIP panels only | Reverses the vertical alignment direction of the bracket by 180 degrees. Use this if the bracket is pointing the wrong way after initial placement. |
| Set Z alignment | SIP panels only | Prompts you to click a point to redefine the vertical alignment direction. Use this when the bracket needs to align with a non-standard gravity direction. |

Standard AutoCAD right-click options (Properties, Erase, etc.) are also available.

---

## Bill of Materials

Each placed bracket automatically registers the following hardware components in the hsbCAD BOM:

| Component | Details |
|---|---|
| Bracket body | Rothoblaas TITAN model (e.g., TCN200), quantity 1 per instance |
| Timber fasteners | LBA or LBS screws/nails. Quantity is calculated from timber depth — only rows fully supported by timber are counted as active fasteners |
| Concrete anchors | 2 per bracket (expansion, screw, or chemical dowel type as selected). Only added when the base plate has bolt holes (not for TTN 240 or TTF 200) |
| Reinforcement washer | TCW200 or TCW240, quantity 1, only when Washer = Yes and model is TCN 200 or TCN 240 |

---

## Tips and Notes

- **Horizontal beams only**: The script rejects beams that are not perpendicular to the World Z axis. If your bottom plate is part of a tilted wall element, the script will use the element's Y axis as the vertical reference instead of the global Z axis.

- **Timber height validation**: Before creating geometry, the script measures how much timber is available behind the vertical plate. If the timber is too shallow for the selected model, the bracket is automatically deleted and an error is reported on the command line. Switch to a smaller bracket model (e.g., from TCN to TCF) or verify that the beam section is correct.

- **Titan F minimum depth**: At least 60 mm of timber depth is required for the smallest Titan F models (2 active fastener rows). At 70 mm, 3 rows are active; at 80 mm, 5 rows; at 90 mm or more, all 6 rows are active.

- **Titan N minimum depth**: All 6 fastener rows become active only when timber depth is 140 mm or more.

- **Milling pocket**: When Mill depth is greater than 0, a `BeamCut` operation is applied to all beams in the associated element, not just the one beam the bracket is attached to. The pocket width is `bracket width + 2 × oversize milling`.

- **Multiple placements in one run**: You can select several beams or panels in a single script run. For each object, you can click multiple insert points to place several brackets before pressing Enter to move on.

- **Bracket hyperlink**: Each placed bracket instance carries a hyperlink to the Rothoblaas product page for the shear angle bracket family. This can be accessed via the hyperlink icon in AutoCAD or through the entity properties.

- **Reinforcement washer compatibility**: The washer option (B - Reinforcement Washer) is only meaningful for Titan N - TCN 200 and TCN 240. If you select Yes for any other model, the washer geometry and BOM entry are silently omitted.

- **Panel alignment**: When placing on a SIP that is part of a wall element, the alignment direction is automatically set to the wall's Y axis (the direction the wall faces). For free-standing SIPs, the script either uses the negative Z direction (for vertically-oriented panels) or asks you to click a point to set the alignment.

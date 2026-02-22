# hsbHiddenConnector

## Overview

`hsbHiddenConnector` is a TSL script for hsbCAD that places concealed timber-to-timber connectors from the **Knapp RICON** product family at the intersection of two crossing timber members. The connector is embedded entirely within the wood, leaving no visible metal on the finished surface. This makes the tool ideal for exposed timber construction, architectural woodwork, and high-end prefabricated building systems where surface aesthetics are a priority.

The script implements a **paired instance model**: one instance is assigned to the **male beam** (the beam whose end receives the tongue/pin of the connector) and a synchronized sibling instance is assigned to the **female beam** (the beam receiving the pocket into which the connector clicks). Both halves are created and managed automatically. When properties are changed on one instance, those changes propagate to the sibling instance on the next recalculation, keeping both sides consistent without manual effort.

Beyond 3D visualization, the tool performs all downstream production tasks automatically:

- Applies precise **milling pockets** (House cuts with relief rounding) to each beam using the `addTool` mechanism, ensuring correct CNC machine output.
- Places **drill holes** for the fixing screws at the positions defined in the product catalog.
- Registers all **hardware articles** (connector body, screws, nails) as `HardWrComp` components linked to the element Bill of Materials, so material takeoffs and shop drawings are populated without manual entry.

Supported connector products (as defined in the XML settings catalog `hsbHiddenConnector.xml`):

| Model | Article Number | Milling Depth | Connector Width | Typical Application |
|---|---|---|---|---|
| RICON 100/30 | K276 | 11.5 mm | 30 mm | Smaller timber cross-sections |
| RICON 160/40 | K364 | 12 mm | 40 mm | Standard framing beams |
| RICON S 200/60 VS | K127 | 25 mm | 60 mm | Heavy timber, structural joints |
| RICON S 400/60 VS | K127 | 25 mm | 60 mm | Long-span heavy timber |

**Script version:** 1.6 (July 2025)
**Keywords:** Baufritz, Knapp, Ricon, connector

---

## Usage Environment

- **Script type:** O-Type (Object/Tool — not pre-linked to beams at definition time; beams are selected during insertion)
- **Works in:** Model Space (3D construction model only — not for Paper Space or shop drawings)
- **Beams required:** 2 per connection (one male, one female). The script accepts standard `Beam` entities and `TrussEntity` elements.
- **Settings file:** `[Company Path]\TSL\Settings\hsbHiddenConnector.xml`
  (Fallback: `[Install Path]\Content\General\TSL\Settings\hsbHiddenConnector.xml`)

---

## Prerequisites

Before running `hsbHiddenConnector`, confirm the following:

1. **Two geometrically crossing (non-parallel) timber beams must exist in the model.** The script auto-detects the contact plane. If the beams are parallel, or if the extended male beam axis does not intersect any face of the female beam, the pair is rejected. Check beam orientation in 3D before running the tool.

2. **The XML settings catalog must be present** at one of the two configured paths. If no manufacturer data can be found, the script cannot start and immediately erases the new instance with the message: "Could not find manufacturer data. Tool will be deleted."

3. **Beams should belong to a named element group** (wall, floor, or roof element) so that hardware components are assigned to the correct Bill of Materials group. Unassigned loose beams are supported, but the BOM group name may be empty or derived from a generic group.

4. **For Baufritz-specific features** (fixture screw selection and tag badge), the project must have the special project identifier `"baufritz"` returned by `projectSpecial()`. In all other projects these features are automatically hidden.

---

## How to Use

### Step 1 — Launch the tool

Type `hsbHiddenConnector` at the AutoCAD command prompt, or activate it from the hsbCAD tool palette. The tool launches into its insertion phase immediately.

### Step 2 — Select male beams

The prompt **"Select male beams"** appears. Click to select one or more beams that will receive the **male side** (tongue/pin) of the connector. You can use any standard AutoCAD selection method (single click, window, crossing). Truss entities are accepted in addition to standard beams.

### Step 3 — Select female beams

The prompt **"Select female beams"** appears. Click to select one or more beams that will receive the **female side** (pocket) of the connector.

Internally the script:
- Removes any beam that was selected in both sets (a beam cannot be male and female simultaneously).
- Tests each male/female pair: the male beam axis is extended across the full drawing and checked for intersection with each face of the female beam. Only geometrically valid intersecting pairs are processed.

If no valid pairs can be found, the script displays "No valid couple found" and cancels without placing anything.

### Step 4 — Select product (manufacturer, family, model)

When only one manufacturer is defined in the catalog, it is automatically selected and the dialog for that level is skipped. The same logic applies at the family and model levels. When multiple choices are available at any level, a selection dialog is shown:

- **Manufacturer dialog:** Choose the connector brand (default catalog includes Knapp only).
- **Family dialog:** Choose the product family (default: Ricon).
- **Model dialog:** Choose the specific connector model (RICON 100/30, RICON 160/40, RICON S 200/60 VS, RICON S 400/60 VS).

Once a model is selected, all milling dimensions and drill positions are loaded from the XML catalog automatically.

You can also bypass dialogs by launching the tool with a pre-built OPM key in the format `Manufacturer?Family?Model`. For example: `Knapp?Ricon?RICON 160/40`.

### Step 5 — Connector instances are created

For each valid beam pair, two linked TSL instances are created automatically:

- **Male instance** — attached to the male beam. Applies the recess cut (`House` with `_kFemaleEnd`) to the male beam. Displays the beam-side connector body solid. Registers male-side fasteners in the BOM.
- **Female instance** — attached to the female beam. Applies the pocket cut (`House` with `_kFemaleSide`) to the female beam. Displays the stud-side connector body solid. Registers female-side fasteners in the BOM.

Both instances display the connector geometry with a T-shaped cross-section consisting of a rectangular plate body and a cylindrical locking pin element.

### Step 6 — Review and adjust in OPM

After insertion, click either connector instance to select it. Open the Properties Palette (Ctrl+1 or the `PROPERTIES` command) to inspect and modify the parameters described below.

---

## Properties Panel (OPM Parameters)

### Component Category

| Property | Type | Description |
|---|---|---|
| **Manufacturer** | String (dropdown list) | The connector manufacturer. Populated dynamically from the XML catalog. Changing this value resets Family and Model to the first available option for the new manufacturer. |
| **Family** | String (dropdown list) | The product family within the selected manufacturer (e.g., Ricon). The list updates when Manufacturer changes. |
| **Model** | String (dropdown list) | The specific connector model. The list updates when Family changes. Selecting a new model reloads all milling dimensions and drill positions from the catalog defaults. |

### Tooling Category

| Property | Type | Description |
|---|---|---|
| **Milling** | String (dropdown list) | Determines which beam receives the male-side cut. Options: **Male** (male beam is milled) or **Female** (female beam is milled). Switching the Milling value automatically swaps the Width, Height, and Depth values between the two milling categories so that the catalog geometry is preserved correctly on each side. |

### Milling Female Beam Category

Defines the pocket cut dimensions in the **female** (receiving) beam. Values default to the catalog specification for the selected model and reset to defaults when the model changes (unless they were already set to non-zero values).

| Property | Type | Default Source | Description |
|---|---|---|---|
| **Width** | Double (length) | XML `Milling.Width` | Width of the milled pocket. For RICON 160/40: 40 mm. For RICON S 200/60 VS: 60 mm. |
| **Height** | Double (length) | XML `Milling.Length` | Length of the milled pocket along the beam axis. For RICON 160/40: 170 mm. For RICON S 200/60 VS: 210 mm. |
| **Depth** | Double (length) | XML `Milling.Depth` | Depth of the pocket from the beam face. For RICON 160/40: 12 mm. For RICON S 200/60 VS: 25 mm. |

### Milling Male Beam Category

Defines the recess cut dimensions in the **male** (inserting) beam.

| Property | Type | Default Source | Description |
|---|---|---|---|
| **Width** | Double (length) | XML `Milling.Width` | Width of the male recess. Typically the same as the female pocket width for the selected model. |
| **Height** | Double (length) | XML `Milling.Length` | Length of the male recess along the male beam axis. |
| **Depth** | Double (length) | XML `Milling.Depth` | Depth of the recess from the male beam face. |

### Position Category

| Property | Type | Default | Description |
|---|---|---|---|
| **Distance Height** | Double (length) | 0 | Shifts the connector position along the height direction of the male beam from the auto-detected contact point. Positive values move the connector toward the top of the beam. |
| **Distance Width** | Double (length) | 0 | Shifts the connector position in the lateral (width) direction of the male beam. Used for precise positioning when multiple connectors are placed side by side. |

### Verbindungsmittel Category (Baufritz Projects Only)

Visible only when the active project uses the `"baufritz"` special project identifier.

| Property | Type | Options | Description |
|---|---|---|---|
| **Verbindungsmittel Nebenträger** | String (dropdown list) | None; Ricon S SK-Schraube 8x80; Ricon S SK-Schraube 8x160; Megant SK-Schraube 8x240 | Specifies the screw type for the secondary (male/Nebenträger) beam side. When a screw is selected, 32 units of that screw are registered in the BOM linked to this instance. |
| **Verbindungsmittel Hauptträger** | String (dropdown list) | None; Ricon S SK-Schraube 8x80; Ricon S SK-Schraube 8x160; Megant SK-Schraube 8x240 | Specifies the screw type for the main (female/Hauptträger) beam side. When a screw is selected, 32 units are registered in the BOM. |

### Display Category

| Property | Type | Default | Description |
|---|---|---|---|
| **Color** | Integer (AutoCAD color index) | 7 | Display color for the 3D solid representing the connector body. Color 7 renders as white on dark backgrounds and black on light backgrounds. |

---

## Right-Click Menu Options

### Show Badge / Hide Badge (Baufritz Projects Only)

This context menu trigger is added automatically in Baufritz projects. It toggles an in-model annotation label that displays the connector specification and screw count next to the connector body. The label text format is:

```
1x [Model name],
32x [Screw type]
```

For example: `1x RICON S 200/60 VS, 32x Ricon S SK-Schraube 8x80`

The annotation is drawn with a leader line from the connector body to a grip point. The grip point can be repositioned by dragging it in the model.

- **Show Badge** — Displays the annotation. The menu entry then reads "Hide Badge" on the next right-click.
- **Hide Badge** — Removes the annotation. The menu entry then reads "Show Badge."

The badge state is persisted in the instance internal map (`_Map.setInt("ShowTag", ...)`) and survives recalculations and file saves. For new Baufritz project instances, the badge defaults to visible (on).

---

## Tips and Notes

**Connector geometry is fully catalog-driven.** All milling dimensions and drill positions are specified in the XML settings file. When a model is selected, dimensions are loaded automatically. You should only change Width, Height, or Depth in OPM if the specific connection in your project deviates from the catalog standard. Such manual overrides are sticky — they persist across recalculations unless the model is changed, which reloads the catalog defaults.

**Swapping the milling side does not lose data.** Switching the Milling property between Male and Female triggers an automatic value swap: the Female Width/Height/Depth values move to the Male category and vice versa. You never have to re-enter dimensions manually when correcting the milling assignment.

**Two sibling instances are always required.** The tool always creates exactly two TSL instances per beam pair — one per beam. These instances are mutually dependent and track each other through the internal Map system (`maleTsl` / `femaleTsl` entity references). If one sibling is deleted, the other will attempt to recreate it automatically on the next recalculation. Deliberately removing a connector requires deleting both instances.

**Geometric intersection validation is strict.** The algorithm extends the male beam axis to a very large length and checks for intersection with each face plane of the female beam. The most aligned intersecting face is chosen as the contact plane. If the extension does not intersect any face (beams too far apart, parallel, or oriented away from each other), the pair is rejected silently. Only pairs that pass this test receive a connector.

**Batch insertion processes all valid pairs.** You can select multiple male beams and multiple female beams at the same time. The tool tests every male/female combination and creates a connector pair for each valid intersection. This is useful for connecting a row of joists to a single header beam or populating all intersections in a timber grid structure in one operation.

**Bill of Materials is automatic.** All hardware items — the connector body (1 unit per side), the fastening nails or screws (as specified in the NailMale, NailFemale, DrillMale, DrillFemale catalog entries), and optionally the Verbindungsmittel screws (32 units per side in Baufritz projects) — are registered as `HardWrComp` hardware components. These are linked to the parent element group and appear in all standard hsbCAD BOM reports and exports without any additional manual steps.

**XML catalog version is checked on placement.** When a new instance is first created, the script reads the `Version` field from both the drawing-cached map object and the XML file on disk. A mismatch triggers a console notice identifying the current version and the file path of the differing version. This is a signal that a catalog update has occurred since the drawing was last worked on. Re-running the tool or triggering a recalculation updates the instance to the current catalog.

**Unit independence.** The script uses the `U()` function for all dimensional values and is compatible with both metric (mm) and imperial (inch) hsbCAD drawing templates.

**Product catalog is extensible.** The XML settings file `hsbHiddenConnector.xml` has an open hierarchical structure: Manufacturer > Family > Model. New manufacturers, families, and models can be added by extending the XML without modifying the script. Each new Model entry must define: `Milling` (Width, Length, Depth, Radius), `MillingBeamParameters` (Cover, WidthMin, LengthMin, LengthMax), `DrillFemale[]`, `DrillMale[]`, `NailFemale[]`, `NailMale[]`, and `Part` (Width, Length, Thickness, TopHanger) for full tool functionality.

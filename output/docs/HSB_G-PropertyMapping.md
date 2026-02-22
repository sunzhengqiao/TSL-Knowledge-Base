# HSB_G-PropertyMapping

## Overview

`HSB_G-PropertyMapping` is a batch property editor for timber members (GenBeams) within hsbCAD elements. It works as a conditional "find and replace" tool for beam data: you define up to six filter conditions that identify which beams to target, then define up to eleven property assignments that are written to every beam that matches any one of those conditions.

Typical use cases include:

- Renaming all beams of a specific material grade to a new grade designation after a specification change.
- Assigning zone numbers or layer prefixes to structural members identified by their label or information field.
- Correcting the isotropic setting on a set of beams that were initially created with the wrong structural behavior.
- Updating beam type, color, or HsbId across an entire wall or floor element in a single automated pass.
- Standardizing sublabel fields for CNC export or shop drawing annotation.

The script inserts once, applies its mapping to all GenBeams in the selected elements, then removes itself from the drawing. It leaves no persistent object in the model — all the work is done during the single recalculation pass triggered at insertion.

**Script version:** 2.9 (17 November 2022)
**Script type:** O-Type (Object/Tool)
**Author history:** AS (pilot, 2014), YB (2017), FA (2018-2020), Robert Pol (2021), Marsel Nakuci (2021), Ronald van Wijngaarden (2022)

---

## Usage Environment

| Space | Supported | Notes |
|---|---|---|
| Model Space | Yes | All processing happens in the 3D model context. |
| Paper Space | No | Not applicable to layout views or viewports. |
| Shop Drawing | No | Does not interact with 2D drawing generation scripts. |

- **Script type:** O-Type (no beams are pre-linked at insertion time)
- **Beams required:** 0 at script level — elements containing GenBeams are selected interactively during insertion
- **Settings file:** None required. The script uses internally populated lists for Beam Types and Isotropic values.

---

## Prerequisites

Before running `HSB_G-PropertyMapping`, confirm the following:

1. **Elements with GenBeams must exist in the model.** The script prompts you to select one or more elements (walls, floors, or roof elements). All GenBeams belonging to those elements are candidates for property mapping. If no elements or GenBeams are found, the script exits immediately with the message "No genbeams or element found."

2. **You must know the current property values of the beams you want to target.** Conditions match on exact values. For example, if you want to match beams where Material is "C24", the Value condition field must contain exactly "C24". Use the standard hsbCAD beam properties inspector or the `HSB_I-ListBeamTypes` script to confirm the exact strings present in your model.

3. **For Type and Isotropic conditions and setters**, you may use either the property name or its numeric index. Use the `HSB_I-ListBeamTypes` TSL script to retrieve the full list of available Beam Types and their index numbers in your installation.

4. **For Zone assignments**, understand the zone numbering in your project. The script supports a layered zone-prefix system where the first character of the zone value can be a letter that identifies the zone layer within the element group.

---

## How to Use

### Step 1 — Launch the script

Type `HSB_G-PropertyMapping` at the AutoCAD command prompt, or insert it from the hsbCAD TSL tool palette. The script enters insertion mode.

If a catalog key is active (set via DspToTsl or an execute key), the script automatically loads its property settings from that catalog and skips the dialog.

### Step 2 — Configure conditions and setters (dialog)

A configuration dialog opens. Set the Condition and Value condition fields to define which beams to find. Set the Set property and Value property fields to define what to write to matching beams. See the Properties Panel section below for a full description of each parameter.

If you prefer to configure parameters after insertion rather than through the dialog, close the dialog and use the Properties Palette (Ctrl+1) to set values on the placed instance before it runs.

### Step 3 — Select elements

The command line prompt reads: **"Select a set of elements"**

Click to select one or more hsbCAD elements (walls, floors, roof elements) in the model. You may use any standard AutoCAD selection method: single click, window selection, or crossing selection. Only `Element` entities are recognized; loose beams not belonging to an element are not selectable at this prompt.

After confirming the selection, the script:

1. Collects all GenBeams from the selected elements.
2. Evaluates each beam against the active Condition rules (in order, Condition 1 through Condition 6).
3. For each beam that matches any active condition, applies all active Set property rules in sequence (Setter 1 through Setter 11).
4. Reports the number of script instances inserted to the command line.
5. Erases itself — the script instance does not remain in the drawing.

### Step 4 — Verify results

After the script completes, inspect the affected beams in the Properties Palette or through the hsbCAD Element Inspector. Run `REGEN` or `TSLRECALC` if the visual display does not update immediately. Because the script self-erases, you cannot re-run it by recalculating an existing instance — it must be re-inserted if the mapping needs to be applied again.

### Satellite mode (automated use)

When this script is triggered by another script as part of an automated pipeline (for example, from a display script using DspToTsl), it runs in satellite mode: it reads its configuration from a named catalog entry passed through the `_Map`, applies the property mapping to the current element's GenBeams, then erases itself immediately after the pass completes. No user interaction is required in satellite mode.

---

## Properties Panel (OPM Parameters)

### Sequence Number Category

| Parameter | Type | Default | Description |
|---|---|---|---|
| **Sequence Number** | Integer | 2000 | Controls the execution order of this script relative to other TSL scripts during element recalculation. Lower numbers run first. Set a lower value if this mapping must complete before other scripts that depend on the results (for example, if a subsequent script reads the Label field that this script sets). Accepts positive and negative values. |

---

### Condition Category

Conditions are evaluated in order from Condition 1 to Condition 6. The conditions work as an **OR chain with early exit**: a beam is processed if it matches Condition 1 *or* Condition 2 *or* ... Condition 6. Once a beam matches any one condition, the remaining conditions are skipped for that beam and the setters are applied.

Leave both the Condition dropdown and Value condition field empty (set to `---` and empty string respectively) for any condition slot you do not want to use.

**Available properties for filtering (Condition dropdown choices):**

| Choice | What is checked on the beam |
|---|---|
| `---` | Condition is inactive — all beams pass this slot |
| Name | The timber member name field |
| Material | The material designation (e.g., "C24", "GL28h") |
| Grade | The strength grade or quality class |
| Information | The free-text information field |
| Label | The primary label used for shop drawings and BOM grouping |
| Sublabel | The first sublabel field |
| Sublabel 2 | The second sublabel field |
| Beamcode | The beam production code (first token only) |
| Type | The hsbCAD beam type (structural classification) |
| HsbId | The internal hsbCAD identifier |
| Isotropic | The structural isotropy classification |
| Zone | The zone index within the element group |
| Extrusion profile | The cross-section profile shape (Rectangular, Round, or custom extrusion) |

| Parameter | Type | Default | Description |
|---|---|---|---|
| **Condition 1** | String (dropdown) | `---` | The beam property to evaluate for the first filter rule. |
| **Value condition 1** | String | (empty) | The value that the selected property must match. For multiple accepted values, separate them with semicolons (e.g., `C24;C16;C18`). |
| **Condition 2** | String (dropdown) | `---` | The beam property to evaluate for the second filter rule. |
| **Value condition 2** | String | (empty) | The value(s) to match for Condition 2. |
| **Condition 3** | String (dropdown) | `---` | The beam property to evaluate for the third filter rule. |
| **Value condition 3** | String | (empty) | The value(s) to match for Condition 3. |
| **Condition 4** | String (dropdown) | `---` | The beam property to evaluate for the fourth filter rule. |
| **Value condition 4** | String | (empty) | The value(s) to match for Condition 4. |
| **Condition 5** | String (dropdown) | `---` | The beam property to evaluate for the fifth filter rule. |
| **Value condition 5** | String | (empty) | The value(s) to match for Condition 5. |
| **Condition 6** | String (dropdown) | `---` | The beam property to evaluate for the sixth filter rule. |
| **Value condition 6** | String | (empty) | The value(s) to match for Condition 6. |

**Special input formats for specific condition properties:**

- **Extrusion profile:** Enter `0` to match beams with a standard rectangular or round cross-section. Enter `1` to match beams with a custom extrusion profile (any shape that is not Rectangular or Round).
- **Type:** Enter the beam type name (spaces and underscores are ignored, matching is case-insensitive) or the numeric index from the `HSB_I-ListBeamTypes` list.
- **Isotropic:** Enter the name (`ISOTROPIC`, `NONISOTROPIC`, or `MULTIPLEXISOTROPIC`, case-insensitive) or the numeric index: `0` = Isotropic, `1` = NonIsotropic, `2` = MultiPlexIsotropic.
- **Zone:** Enter the zone index as an integer. Values greater than 5 are wrapped using the formula `5 - value` to produce negative zone indices.

---

### Set Properties Category

All active setters are applied to every beam that matched any Condition. Setters are processed in sequence from Setter 1 to Setter 11. Multiple setters can be active simultaneously, allowing multiple properties to be updated in a single pass.

Leave both the Set property dropdown and Value property field empty (set to `---` and empty string respectively) for any setter slot you do not want to use.

**Available properties for writing (Set property dropdown choices):**

| Choice | What is written on the beam |
|---|---|
| `---` | Setter is inactive |
| Name | Sets the member name |
| Material | Sets the material designation |
| Grade | Sets the strength grade |
| Information | Sets the free-text information field |
| Label | Sets the primary label |
| Sublabel | Sets the first sublabel |
| Sublabel 2 | Sets the second sublabel |
| Beamcode | Sets the production beam code |
| Type | Sets the hsbCAD beam type |
| HsbId | Sets the internal hsbCAD identifier |
| Isotropic | Sets the structural isotropy classification |
| Zone | Assigns the beam to a zone within its element group |
| Color | Sets the AutoCAD display color of the beam |

| Parameter | Type | Default | Description |
|---|---|---|---|
| **Set property 1** | String (dropdown) | `---` | The beam property to write for the first setter. |
| **Value property 1** | String | (empty) | The value to write. |
| **Set property 2** | String (dropdown) | `---` | The beam property to write for the second setter. |
| **Value property 2** | String | (empty) | The value to write. |
| **Set property 3** | String (dropdown) | `---` | The beam property to write for the third setter. |
| **Value property 3** | String | (empty) | The value to write. |
| **Set property 4** | String (dropdown) | `---` | The beam property to write for the fourth setter. |
| **Value property 4** | String | (empty) | The value to write. |
| **Set property 5** | String (dropdown) | `---` | The beam property to write for the fifth setter. |
| **Value property 5** | String | (empty) | The value to write. |
| **Set property 6** | String (dropdown) | `---` | The beam property to write for the sixth setter. |
| **Value property 6** | String | (empty) | The value to write. |
| **Set property 7** | String (dropdown) | `---` | The beam property to write for the seventh setter. |
| **Value property 7** | String | (empty) | The value to write. |
| **Set property 8** | String (dropdown) | `---` | The beam property to write for the eighth setter. |
| **Value property 8** | String | (empty) | The value to write. |
| **Set property 9** | String (dropdown) | `---` | The beam property to write for the ninth setter. |
| **Value property 9** | String | (empty) | The value to write. |
| **Set property 10** | String (dropdown) | `---` | The beam property to write for the tenth setter. |
| **Value property 10** | String | (empty) | The value to write. |
| **Set property 11** | String (dropdown) | `---` | The beam property to write for the eleventh setter. |
| **Value property 11** | String | (empty) | The value to write. |

**Special input formats for specific setter properties:**

- **Type:** Enter the beam type name (case-insensitive, spaces and underscores ignored) or the numeric index from `HSB_I-ListBeamTypes`. Example: entering `SOLIDTIMBER` and entering `2` produce the same result if Solid Timber is index 2 in your installation.
- **Isotropic:** Enter the name (`ISOTROPIC`, `NONISOTROPIC`, `MULTIPLEXISOTROPIC`) or numeric index: `0` = Isotropic, `1` = NonIsotropic, `2` = MultiPlexIsotropic.
- **Zone:** The zone value supports two formats:
  - If the value starts with a digit (e.g., `3`), the script derives the zone layer prefix character automatically from the beam's current layer name and uses the number as the zone index.
  - If the value starts with a letter (e.g., `A3`), the letter is used as the explicit zone layer prefix and the number after it is used as the zone index.
  - Zone index values greater than 5 are wrapped: a value of `7` produces zone `-2` (formula: `5 - 7 = -2`).
- **Color:** Enter an AutoCAD color index integer (1 = Red, 2 = Yellow, 3 = Green, 4 = Cyan, 5 = Blue, 6 = Magenta, 7 = White/Black).

---

## Right-Click Menu Options

`HSB_G-PropertyMapping` does not add custom right-click context menu entries. The script is a one-shot tool that executes and erases itself immediately — there is no persistent instance in the drawing on which a context menu would appear.

If the script is deployed in automated workflows via the DspToTsl mechanism, it is always launched programmatically without user-facing context menus.

---

## Tips and Notes

**The script runs once and erases itself.** Unlike most TSL scripts that remain as persistent entities in the model, `HSB_G-PropertyMapping` removes itself from the drawing after completing the mapping pass. This means you cannot recalculate it later. If you need to apply the same mapping again (for example, after adding new beams to an element), you must re-insert the script and re-enter or re-load the same settings. Consider saving your configuration as a named catalog entry using the hsbCAD TSL catalog system to speed up repeated use.

**Conditions work as OR logic, not AND logic.** A beam is updated if it matches Condition 1 *or* Condition 2 *or* any other active condition. The script does not require a beam to match all conditions simultaneously. If you need AND logic (beam must match property A *and* property B), a common workaround is to pre-populate a combination field such as the Information or Label field with a combined tag (e.g., "C24_WALL"), then use a single Condition that matches on that combined tag.

**Multiple values in a single condition.** Separate multiple accepted values with semicolons in the Value condition field. For example, entering `C24;C16` in Value condition 1 with Condition 1 set to Material will match any beam whose Material is either "C24" or "C16". This allows grouping of similar members without using multiple condition slots.

**Setters apply to all matched beams regardless of which condition matched.** There is no way to apply different setters to beams matching different conditions in a single script instance. If beams matching Condition 1 need different property values than beams matching Condition 2, run the script twice with different configurations — once for each targeted group.

**Conditions are evaluated in order and processing stops at the first match.** If Condition 1 is active and a beam matches it, Conditions 2 through 6 are not evaluated for that beam. This means the most specific or most common condition should be placed first for best performance. It also means that if a beam could theoretically match multiple conditions, only the first matching condition counts — the setters are applied once, not once per matching condition.

**Type names are normalized before comparison.** When you enter a Type name in a Value condition or Value property field, all spaces and underscores are removed and the string is converted to uppercase before the lookup. This means "Solid Timber", "solid_timber", and "SOLIDTIMBER" are all equivalent. This normalization only applies to Type; all other property fields use exact string matching (case-sensitive for condition checks).

**Use HSB_I-ListBeamTypes to find valid Type indices.** The numeric indices for Beam Types are installation-specific. Run the `HSB_I-ListBeamTypes` script in your drawing to generate the complete list of type names and their corresponding index numbers before using Type conditions or setters.

**Zone assignments affect element group membership.** When the Set property is Zone, the script calls `assignToElementGroup()` which reassigns the beam to a sub-zone within its parent element. This is a structural grouping change, not just a metadata tag. Verify zone assignments carefully before applying them to production models, as incorrect zone assignments can affect CNC output, shop drawing grouping, and bill of materials reporting.

**The script can be triggered from display scripts via DspToTsl.** If the `_Map` contains a `DspToTsl` key, the script reads the named catalog and applies those settings without showing a dialog or prompting for element selection. This mechanism allows project-wide automated property mapping to be embedded in element construction workflows.

**Sequence number controls execution order in automated pipelines.** When multiple TSL scripts are attached to the same element and run during an element recalculation (e.g., via `OnElementConstructed`), the Sequence Number determines which script runs first. The default of 2000 places this script late in the sequence. Reduce the sequence number if other scripts must receive the updated property values during the same recalculation pass.

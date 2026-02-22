# hsbMatchProperties

## Overview

`hsbMatchProperties` is a productivity tool for hsbCAD that copies selected data properties from one timber element (the **source**) to any number of elements of the same type (the **targets**). It works like AutoCAD's native MATCHPROP command, but for hsbCAD-specific attributes that MATCHPROP cannot reach: timber grade, material, labels, zone assignments, render materials, property sets, and more.

You choose exactly which properties to transfer by toggling each one to **Yes** in the Properties Palette before picking the source and targets. Only the toggled properties are modified on the targets; all other attributes are left untouched.

After the operation completes, the tool reports how many items were updated and which properties were applied, then automatically removes itself from the drawing. Nothing permanent is added to the model — the tool is a one-shot command that leaves no residual entities.

Supported source and target entity types:

| Source Entity | Target Entity Type | Transferable Categories |
|---|---|---|
| Beam | Beams | General + Beam-specific properties |
| Sheet | Sheets | General + Sheet thickness |
| Sip (SIP panel) | Sip panels | General + Sip style and surface quality |

**Script version:** 1.1 (28 May 2020)
**Keywords:** property, modify, matchprop

---

## Usage Environment

- **Script type:** O-Type (Object/Tool — inserts and runs immediately, then self-deletes)
- **Works in:** Model Space only (3D construction model). Not for Paper Space or shop drawing layouts.
- **Beams required:** 0 (beams and other entities are selected interactively during the command)
- **Settings file:** None required

---

## Prerequisites

Before running `hsbMatchProperties`:

1. **A source entity must exist in the model.** This is the single Beam, Sheet, or Sip whose properties you want to copy. It must already have the correct attributes set (material, grade, label, etc.).

2. **One or more target entities of the same type must exist.** You can only copy from a Beam to other Beams, from a Sheet to other Sheets, or from a Sip to other Sip panels. Cross-type copying is not supported.

3. **Decide which properties to transfer before or during insertion.** The Properties Palette dialog appears as the first step of the command, so you should know in advance which attributes need to be standardized.

---

## How to Use

### Step 1 — Launch the tool

Type `hsbMatchProperties` at the AutoCAD command prompt, or insert it from the hsbCAD tool palette. The tool launches immediately into its insertion phase.

### Step 2 — Select properties to transfer

A dialog window opens listing all transferable property categories. Toggle each property you want to copy from **No** to **Yes**. Only properties set to Yes will be modified on the target elements.

Alternatively, if the tool is launched with a catalog key (for example, via a macro or script that passes a predefined configuration name), the property selection is applied automatically from the saved catalog entry and this dialog is skipped.

### Step 3 — Pick the source entity

The command line prompts:

```
Select source entity
```

Click on the single element whose properties you want to copy. The tool accepts any Beam, Sheet, or Sip entity. The type of this entity determines which target type you will select in the next step.

### Step 4 — Select the target entities

A second prompt appears, automatically filtered to the same entity type as your source:

- If you picked a **Beam**: prompt reads `Select beams`
- If you picked a **Sheet**: prompt reads `Select sheets`
- If you picked a **Sip**: prompt reads `Select sip`

Use any AutoCAD selection method (single click, window, crossing selection, or filter) to select all elements that should receive the properties. Press Enter to confirm.

### Step 5 — Properties are applied and the tool exits

The tool applies all toggled properties from the source to every selected target. A summary message appears in the AutoCAD command line:

```
hsbMatchProperties: [N] items mapped with [list of property names]
```

The tool then erases itself from the drawing automatically. No manual cleanup is needed.

---

## Properties Panel (OPM Parameters)

All parameters are Yes/No toggles. The default value for every parameter is **No** (do not copy this property). Set a parameter to **Yes** to include it in the transfer.

### General Category

These properties are common to all entity types (Beams, Sheets, and Sip panels).

| Property | Description |
|---|---|
| **Color** | Copies the AutoCAD color override of the source entity to all targets. This is the per-entity color, not the layer color. Useful for matching visual coding schemes across a set of members. |
| **Label** | Copies the primary Label (piece mark or position number) field. This is the main identifier used in shop drawings and bills of materials. |
| **SubLabel** | Copies the SubLabel field (secondary piece mark or sub-identifier). |
| **SubLabel2** | Copies the SubLabel2 field (tertiary identifier). |
| **Grade** | Copies the structural timber grade (for example, C24, GL28h, LVL). This is critical for structural calculations and BOM reports. |
| **Information** | Copies the free-text Information field attached to the entity. |
| **Material** | Copies the material definition (for example, Spruce, Douglas Fir, CLT). Affects BOM material reporting and visualization. |
| **Name** | Copies the entity Name property. |
| **Beamtype** | Copies the Beamtype classification code used by hsbCAD to categorize structural roles. |
| **Isotropic** | Copies the isotropy flag of the source. When set to isotropic, hsbCAD treats the member as having equal material properties in all directions (relevant for steel or concrete members added to a timber model). |
| **hsbId** | Copies the internal hsbCAD database ID. **Use with extreme caution.** Duplicating an hsbId across multiple elements can cause database conflicts, incorrect BOM grouping, and data integrity issues. Leave this set to No unless you have a specific and deliberate reason to clone the ID. |
| **Group** | Copies all group assignments from the source to the targets. Group membership controls how elements appear in schedules and exports. |
| **Element Module** | Copies the Element Module assignment. Modules are used to subdivide elements into production or delivery units. |
| **Zone** | Copies the Zone assignment from the source to the targets. Both the source and each target must belong to a valid hsbCAD Element for this to take effect. Zones are used for fire protection zoning, acoustic zoning, or other subdivision schemes. |
| **Transparency** | Copies the display transparency percentage. Useful for matching the visual presentation of insulation or hidden layers. |
| **Line Weight** | Copies the line weight setting used when the element is drawn in 2D views. |
| **Notes** | Copies any notes attached to the source entity. |
| **Property Set** | Copies all attached AutoCAD Property Sets and their values. All property sets from the source are attached to each target and populated with the values from the source. Only property sets that contain at least one field are transferred. |
| **Render Material** | Copies the visual render material assignment (used in 3D renderings and presentations). |

### Beam Category

These properties apply only when the source entity is a Beam. They are ignored when the source is a Sheet or Sip.

| Property | Description |
|---|---|
| **Extrusion Profile** | Copies the custom extrusion profile assigned to the beam (for non-rectangular cross-sections such as I-beams or C-profiles). |
| **Texture** | Copies the texture style applied along the beam's length. |
| **Curved Style** | Copies the curved beam rendering style setting. |
| **Splinter Free** | Copies the CNC splinter-free machining flag. When enabled, the CNC machine applies an additional clean-up pass on the cut surface to prevent splintering. |
| **Width** | Copies the cross-section width (the Y-direction dimension of the beam). The target beam is resized to match the source width while keeping its existing axis and length. |
| **Height** | Copies the cross-section height (the Z-direction dimension of the beam). The target beam is resized to match the source height. |

### Sheet Category

These properties apply only when the source entity is a Sheet.

| Property | Description |
|---|---|
| **Thickness** | Copies the panel thickness (the height dimension of the sheet) from the source to all target sheets. |

### Sip Category

These properties apply only when the source entity is a Sip (Structural Insulated Panel).

| Property | Description |
|---|---|
| **Style** | Copies the full SIP style definition (panel build-up, layer configuration) from the source to all target Sip panels. |
| **SurfaceQualityTop** | Copies the top-face surface quality setting. If the source has a per-instance override set, that override is transferred. If not, the surface quality defined in the Sip style is applied. |
| **SurfaceQualityBottom** | Copies the bottom-face surface quality setting, using the same override-then-style logic as SurfaceQualityTop. |

---

## Right-Click Menu Options

`hsbMatchProperties` has no persistent right-click context menu options. The tool completes its work and erases itself during the insertion phase. It does not remain in the drawing as a selectable object.

---

## Tips and Notes

**The tool self-deletes after every run.** This is by design. `hsbMatchProperties` is a command-style tool: it performs a one-time action and then removes itself to keep the drawing clean. You do not need to delete it manually after use.

**Source and target types must match.** The entity type of the source determines which targets are selectable. If you click a Beam as the source, only Beams can be selected as targets. If you need to transfer similar attributes to both Beams and Sheets, you must run the tool twice — once with a Beam source and once with a Sheet source.

**Width and Height transfer resizes beams.** Setting Width or Height to Yes physically changes the cross-section dimensions of all target beams to match the source. This is a geometry change, not just a display attribute. Verify that resized beams remain structurally valid and that no clashes are created before proceeding.

**Zone transfer requires elements.** The Zone property can only be copied if both the source beam and each target beam belong to a valid hsbCAD Element (wall, floor, or roof). Loose beams not assigned to an Element are silently skipped for the Zone property even if it is set to Yes.

**Property Set transfer is additive.** When Property Set is set to Yes, the tool attaches all property sets from the source and populates their fields. If a target already has a property set of the same name with different values, those values are overwritten. Property sets that exist on the target but not on the source are left untouched.

**Avoid copying hsbId in most workflows.** The hsbId is a unique identifier used by hsbCAD's database layer to distinguish entities in BOM reports, shop drawings, and CNC output. Copying the same hsbId to multiple members makes those members indistinguishable in exported data. Only use this option if you are intentionally aliasing members for a specific report configuration and understand the consequences.

**Catalog-based silent mode is available.** If your office has saved standard property match configurations as hsbCAD catalog entries (for example, a preset that always copies Grade, Material, and Label), the tool can be launched with a catalog key to skip the dialog entirely. Contact your hsbCAD administrator or BIM coordinator to set up catalog entries for frequently repeated workflows.

**The command line summary confirms what was applied.** After every run, the command line displays the number of elements updated and the list of property names that were transferred. Review this output to confirm the operation completed as intended, especially when working on large selections.

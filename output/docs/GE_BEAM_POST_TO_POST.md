# GE_BEAM_POST_TO_POST

## Overview

**GE_BEAM_POST_TO_POST** is a one-time generator script that places one or more horizontal framing members (blocking, headers, or bridging) between two selected vertical posts. Once it runs, it creates the beams in the drawing and then removes itself -- the result is a set of standard `GenBeam` entities, not a persistent script object.

The script automatically reads from the project's lumber inventory to suggest correct beam dimensions, material, and grade. You can also override any of these values manually if your project requires a custom specification.

**Key capabilities:**
- Places one or more horizontal members between exactly two vertical posts in a single operation.
- Automatically trims the new beams flush to the face of the second post using a static cut.
- Distributes multiple beams Left to Right, Centered, or Right to Left across the post width.
- Pulls beam sizes, material, and grade from the hsbFramingDefaults inventory, with manual override fields for every value.
- Validates post orientation (must be vertical) and top-height alignment before creating anything.

**Version:** 1.3 (03 November 2013, David Rueda, hsbSOFT)

---

## Usage Environment

| Environment | Supported | Notes |
|-------------|-----------|-------|
| Model Space | Yes | Primary and only environment for this script. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | This script creates model geometry, not drawing details. |

**Script Type:** `O` (Object / Generator)
**Beams Required at Start:** None pre-selected. The script prompts you to select the two posts interactively during insertion.

---

## Prerequisites

Before running this script, ensure the following are in place:

- **Two vertical GenBeam posts** must already exist in the drawing. The posts must be:
  - Oriented vertically (parallel to the World Z axis).
  - Have their top ends at the same elevation (same Z height). If they differ, the script will abort.
- **hsbFramingDefaults Inventory** (`hsbFramingDefaults.Inventory.dll`) must be accessible via the hsbCAD installation path. This provides the list of available lumber items and their dimensions.
- The drawing must use a consistent unit system (millimeters or inches). The script uses `U()` conversion throughout, so it works in both.

---

## How to Use

### Step 1: Run the Script

Launch the script from the hsbCAD tool panel or by typing `TSLINSERT` at the AutoCAD command line and selecting `GE_BEAM_POST_TO_POST` from the list.

### Step 2: Select the First Post

The command line will prompt:

```
Select first post
```

Click on the first vertical post (GenBeam). The script checks that it is truly vertical. If it is not, an error message appears and the script cancels automatically.

### Step 3: Select the Second Post

The command line will prompt:

```
Select another post
```

Click on the second vertical post. The script then checks:
- That the second post is also vertical.
- That both posts have their tops at the same height.

If either check fails, a message is displayed and the script cancels without creating any beams.

### Step 4: Configure in the Dialog

After both posts are validated, a configuration dialog appears automatically. Set your desired options (see the Properties Panel section below for details). Click **OK** to proceed.

### Step 5: Beams Are Created

The script calculates positions and creates the horizontal beam(s) spanning from the first post to the second post. The beams are automatically cut flush to the face of the second post. Once the beams are placed, the script instance removes itself from the drawing.

> **Note:** It is normal for the script object to disappear after running. The horizontal beams it created remain in the drawing as regular GenBeam entities.

---

## Properties Panel (OPM Parameters)

These properties appear in the AutoCAD Properties Palette (OPM) when the dialog is shown after post selection. They can also be adjusted if you re-run the script.

### General Section

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Number of beams to place | Integer | 1 | How many horizontal beams to create between the two posts. All beams use the same size and are stacked side by side across the post width. |
| Distribution | Dropdown | Centered | Controls how the beams are positioned across the post width when placing multiple beams. Options: **Left to right** (starts from the left/front face of the post), **Centered** (distributes beams symmetrically about the post center), **Right to left** (starts from the right/back face of the post). |

### Beam Info -- Auto (from Inventory)

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Lumber item | Dropdown | First item in list | Selects a lumber product from the project's framing inventory. This sets the beam dimensions (width and height), material, and grade automatically. Change this to match the lumber you intend to use on-site. |

### Beam Info -- Manual (Override Values)

These fields override the values loaded from the inventory. Leave a field empty to use the inventory value. If **Beam size** is set to anything other than "From inventory", the manual values take priority for dimensions.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Beam size | Dropdown | From inventory | Selects the nominal lumber size. Options run from 2x1 through 2x16 (standard North American nominal sizes) plus **From inventory** which uses the dimensions from the selected Lumber item above. Width is always 38.1 mm (1.5 in) actual; only the height dimension changes with the nominal size selected. |
| Beam color | Integer | 32 | AutoCAD color index (ACI) for the new beams. Valid range is -1 to 255. If an out-of-range value is entered, it resets to 32 automatically. |
| Beam type | Dropdown | (index 12) | Sets the hsbCAD beam type category for classification purposes (for example: stud, plate, header, blocking). This affects BOM grouping and element type assignment. |
| Name | Text | (empty) | A custom name assigned to the beam entity. Leave blank to keep the default. |
| Material | Text | (from inventory) | The lumber material (for example: Douglas Fir-Larch, SPF). Overrides the inventory value when filled in. |
| Grade | Text | (from inventory) | The structural grade (for example: No.2, Select Structural). Overrides the inventory value when filled in. |
| Information | Text | (empty) | Additional free-text information field stored on the beam. |
| Label | Text | (empty) | The primary label printed on the beam in shop drawings and element views. |
| Sublabel | Text | (empty) | A secondary label for the beam. |
| Sublabel2 | Text | (empty) | A tertiary label for the beam. |
| Beam code | Text | (empty) | A custom code used for identification or scheduling purposes. |

### Nominal Size Reference

When **Beam size** is set to a manual nominal size, the actual dimensions used are:

| Nominal | Actual Width | Actual Height |
|---------|-------------|---------------|
| 2x1 | 38.1 mm / 1.50 in | 19.05 mm / 0.75 in |
| 2x2 | 38.1 mm / 1.50 in | 38.10 mm / 1.50 in |
| 2x3 | 38.1 mm / 1.50 in | 63.50 mm / 2.50 in |
| 2x4 | 38.1 mm / 1.50 in | 88.90 mm / 3.50 in |
| 2x6 | 38.1 mm / 1.50 in | 139.70 mm / 5.50 in |
| 2x8 | 38.1 mm / 1.50 in | 184.15 mm / 7.25 in |
| 2x10 | 38.1 mm / 1.50 in | 234.95 mm / 9.25 in |
| 2x12 | 38.1 mm / 1.50 in | 285.75 mm / 11.25 in |
| 2x14 | 38.1 mm / 1.50 in | 336.55 mm / 13.25 in |
| 2x16 | 38.1 mm / 1.50 in | 387.35 mm / 15.25 in |

---

## Right-Click Menu Options

This script has no right-click context menu options. It is a **generator** script: it runs once, creates the beam geometry, then erases itself. The resulting beams are plain GenBeam entities and can be edited with standard hsbCAD beam editing tools.

---

## Tips and Notes

**Fit check before creation**
The script checks whether the total width of the requested beams fits within the available face width of the post. The tolerance depends on the distribution mode: Centered mode allows up to two beam widths of overhang, while Left to Right and Right to Left allow one beam width. If the beams do not fit, the script displays a warning and cancels. Reduce the "Number of beams to place" or switch to a narrower beam size if this occurs.

**Both posts must be at the same top elevation**
The script checks that the tops of both posts are at the same Z height (within a tolerance of 0.001 mm / 0.0001 in). If you are working with posts of different heights -- for example, a raked roof condition -- this script is not suitable. Adjust post heights before running, or use a different approach.

**Only vertical posts are accepted**
The script checks that both selected GenBeams are parallel to the World Z axis. Diagonal or angled members will cause the script to abort immediately.

**Beam cut is applied to the second post face**
The horizontal beams are initially created with a nominal short length (50 mm / 2 in) centered at the first post. The script then applies a static cut tool at the near face of the second post, trimming each beam to the correct span automatically. You do not need to adjust the length manually.

**Inventory vs. manual sizing**
When "Beam size" is set to **From inventory**, the dimensions (width and height) come from the selected Lumber item. Material and Grade also come from the inventory, but can still be overridden by filling in the manual Material and Grade fields. When you choose a specific nominal size (for example, 2x6), both width and height switch to the fixed nominal-to-actual values shown in the reference table above, and Material and Grade are taken entirely from the manual fields.

**The script erases itself -- this is normal**
After the beams are created, the script removes its own instance from the drawing. This is by design. The beams it produced are independent GenBeam entities that remain in the drawing and can be freely selected, moved, modified, or deleted.

**Catalog-based defaults on first insert**
When first placed, the script applies project-level default property values from the catalog system (`setPropValuesFromCatalog`). This means your site-specific framing defaults (if configured in hsbFramingDefaults) will be pre-selected automatically.

**If the inventory DLL is missing**
If `hsbFramingDefaults.Inventory.dll` cannot be found at the expected installation path, the Lumber item dropdown will be empty. In this case, use the Manual section to specify beam size, material, and grade directly.

**Incomplete inventory data**
If the selected lumber item in the inventory has a width or height of zero, the script will display an error listing the missing values and cancel. Verify that the lumber item definition is complete in the hsbFramingDefaults editor.

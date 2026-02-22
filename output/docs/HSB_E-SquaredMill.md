# HSB_E-SquaredMill

## Overview

HSB_E-SquaredMill converts angled or diagonal milling cuts on timber beams into clean, rectangular (squared) pockets or through-cuts. When two beams in an element intersect at an angle, the standard milling profile follows the exact diagonal geometry of the crossing member. This script replaces that diagonal profile with a square-edged cut, adding an optional clearance gap to ensure the intersecting beam fits cleanly.

The script runs once, applies all required machining operations to the selected elements, and then removes itself from the drawing. It does not remain as a persistent entity.

**Key capabilities:**
- Identifies "milling beams" within an element by beam code (e.g., a ridge board or trimmer)
- Computes the intersection between milling beams and all other beams in the same element
- Applies a `BeamCut` (rectangular pocket or through-hole) to each intersecting beam
- Automatically adjusts the gap width based on the intersection angle so the milling beam always fits
- Optionally trims (squares off) the target beam at the shortest point of the intersection, using a `Cut` tool

**Version:** 1.11 (07 January 2022)
**Author:** Robert Pol (support.nl@hsbcad.com)
**Original author:** AS (pilot version 1.00, 01 July 2013)

---

## Usage Environment

| Setting | Value |
|---------|-------|
| Space | Model Space only |
| Script Type | Object (Type O) |
| Beams Required | None (0) |
| Persistent Entity | No - script erases itself after execution |

This script operates entirely in 3D Model Space. It is not applicable to Paper Space layouts or shop drawing viewports.

---

## Prerequisites

Before running this script, ensure the following conditions are met:

- **Elements must exist in the drawing.** The script processes hsbCAD Elements (walls, floors, or roof panels). It does not work on loose beams outside of an element.
- **The element must contain at least two different beam types:** one set of beams that will act as the milling tool (identified by beam code), and one set of beams that will receive the cut.
- **Know your beam codes.** You need the exact beam code of the beams that define the cut shape (e.g., `KK-05`). Beam codes are visible in the hsbCAD Properties Palette or the element's beam list.
- No external settings files or catalogs are required.

---

## How to Use

### Step 1: Insert the Script

Launch the script using the hsbCAD tool palette or by typing the script name in the command line. A properties dialog appears automatically before you select anything.

### Step 2: Configure the Properties

A dialog box opens showing all parameters. Set the values according to your project before proceeding:

- Set the **Beamcode** to match the beam code of the beams that will act as the cutting tool.
- Set the **Gap** value (in millimetres) for the clearance around the cut.
- Choose whether the cut should extend through the full depth of the end of the beam (`Mill at the end of the beam`).
- Choose whether the target beam should be shortened to its shortest intersection point (`Square off beam at shortest point`).
- Optionally, enter beam codes in the **Filter** field to exclude specific beams from being cut.

Click OK to proceed.

### Step 3: Select Elements

The command line prompts:

```
Select one or more elements
```

Click on one or more hsbCAD Elements in the drawing. You can use a window selection or click elements individually. The script processes each selected element in sequence.

### Step 4: Script Executes and Closes

The script automatically:
1. Finds all beams in each element matching the **Beamcode** (the milling beams).
2. Finds all other beams in the element that intersect with those milling beams.
3. Computes the exact intersection geometry.
4. Applies a rectangular `BeamCut` to each intersecting beam, sized to the milling beam plus the adjusted gap.
5. If **Square off beam at shortest point** is set to Yes, applies an additional `Cut` tool to shorten the beam at the closest intersection face.
6. Reports the number of cuts applied in the command line.
7. Erases itself from the drawing.

After execution, the script is gone. The cuts are now stored as permanent machining tools on the individual beams.

---

## Properties Panel (OPM Parameters)

These parameters appear both in the dialog on insertion and in the AutoCAD Properties Palette (OPM) if you select the script instance before it executes.

### Section: Squared Mill

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Beamcode | Text | `KK-05` | The beam code of the beams that act as the cutting tool. Beams in the element with this code define the shape and position of the cut. You can enter multiple beam codes separated by semicolons (e.g., `KK-05;KK-06`). |
| Gap | Number (mm) | `1` | Clearance added around the cut. The gap is automatically increased for shallow intersection angles using the formula: effective gap = Gap / sin(angle). For near-parallel beams the effective gap can be much larger than the value entered here. Use small values such as 1 mm for standard fits. |
| Mill at the end of the beam | Dropdown (Yes/No) | `Yes` | Controls the depth of the `BeamCut` in the beam axis direction. **Yes** extends the cut through the full depth of the beam end (a through-slot opening to the end). **No** limits the cut depth to the intersection volume only (a closed pocket in the middle of the beam). |
| Square off beam at shortest point | Dropdown (Yes/No) | `Yes` | Controls whether the target beam is axially shortened. **Yes** adds a `Cut` tool that trims the beam length at the shortest intersection face, creating a clean square end. **No** leaves the beam at its full length and applies only the pocket or slot. |

### Section: Filter

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| Filter beams with beamcode | Text | (empty) | Beam codes to exclude from processing. Beams in the element whose code matches any entry in this list will be ignored - they will not be cut, and they will not act as milling beams even if their code matches the Beamcode field. Separate multiple codes with semicolons (e.g., `STU;PLT`). Matching is case-insensitive. |

---

## Right-Click Menu Options

This script has no right-click context menu options. It erases itself immediately after execution and cannot be re-selected.

---

## Tips and Notes

**The gap expands at shallow angles.**
The script divides the entered Gap value by the sine of the intersection angle between the milling beam and the target beam. When two beams run nearly parallel (small angle), sin(angle) is very small, which makes the effective gap very large. This is intentional - it ensures the milling beam physically fits through the cut at any angle. If you see unexpectedly large pockets, check whether the beams intersect at a very shallow angle.

**Re-running the script.**
Because the script deletes itself after execution, you cannot simply double-click it to adjust settings. To change the cuts, you must:
1. Manually delete the `BeamCut` and `Cut` tools from the affected beams (visible in the beam's machining list).
2. Re-insert HSB_E-SquaredMill and run it again with the new settings.

**Processing multiple elements at once.**
You can select multiple elements in Step 3. The script creates a separate instance internally for each element and processes them all in one run. The command line will report the total number of mills corrected and which element number was processed.

**Beam code matching is case-insensitive.**
The script converts all beam codes to uppercase before comparing. `kk-05`, `KK-05`, and `Kk-05` are treated as the same code.

**Beams that are sheets.**
As of version 1.09 (November 2017), the milling beam can also be a sheet (panelling material such as OSB), not only a structural timber beam. The Beamcode field should contain the beam code or sheet designation accordingly.

**Minimum cut size.**
If the computed intersection volume has zero dimension in any direction (length, width, or height less than 0.001 mm), the script skips that intersection and does not apply a cut. This prevents degenerate cuts from being added to beams that barely touch.

**Filter vs. Beamcode interaction.**
If a beam code appears in both the Beamcode field and the Filter field, the Filter takes priority. That beam will be excluded from processing entirely.

**Catalog support.**
The script supports hsbCAD tool palette catalogs. If launched from a palette entry that includes a catalog name, the properties are loaded automatically from the catalog and the dialog is skipped. This allows standardised configurations to be saved and reused across projects.

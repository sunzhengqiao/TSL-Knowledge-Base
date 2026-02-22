# hsbLayout-AssignPosnum

## Overview

`hsbLayout-AssignPosnum` automatically assigns production position numbers (PosNum) to structural members and TSL instances that belong to a structural Element displayed in a selected Layout Viewport. Position numbers are used downstream in fabrication lists, shop drawings, and Bill of Materials exports to uniquely identify every piece in the assembly.

The script supports two independent numbering categories:

- **GenBeam** - covers all timber members derived from `GenBeam`: structural beams, sheets, and SIP panels.
- **TSL Instances** - covers hardware and connection scripts attached to the Element.

Each category has its own starting number and can be enabled or disabled independently. An optional Zone filter lets you restrict numbering to specific construction layers within the Element (e.g., only the stud zone or only the sheathing zone).

The script is placed once per drawing space and enforces a singleton rule: inserting it a second time automatically removes the first instance.

**Script version:** 1.4 (21 Jun 2019)

---

## Usage Environment

| Attribute | Value |
|---|---|
| Script type | O-Type (Object / stand-alone entity) |
| Insert space | Model Space |
| Viewport required | Yes - must target a Layout Viewport linked to a valid Element |
| Beams required at insert | 0 |
| Implicit insert | Yes (dialog shown automatically on insert) |
| Can be inserted twice | No - duplicate instances are erased automatically |
| Keywords | posnum, layout, genBeam, TSL |

Although the script reads viewport geometry from a Paper Space Layout tab, the TSL instance itself is placed in Model Space. The viewport it targets is selected interactively during insertion.

---

## Prerequisites

- A Layout tab (Paper Space) must already exist in the drawing with at least one **viewport** whose view is set to display a structural **Element** (Wall, Floor, or Roof element).
- The Element displayed in the viewport must contain at least one GenBeam (beam, sheet, or panel) if GenBeam numbering is enabled, or at least one TSL instance if TSL numbering is enabled.
- No prior instance of `hsbLayout-AssignPosnum` should exist in the same drawing space; if one does, it will be erased automatically when a new one is inserted.

---

## How to Use

### Step 1 - Insert the script

Run the hsbCAD script insert command and select `hsbLayout-AssignPosnum`, or use the dedicated command alias if configured:

```
^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbLayout-AssignPosnum")) TSLCONTENT
```

### Step 2 - Configure properties in the dialog

A properties dialog appears automatically before placement (implicit insert mode). Set the following options:

1. Under the **GenBeam** category, decide whether structural members should be numbered (Yes / No).
2. If Yes, set the **Start number** for GenBeam PosNum.
3. Optionally enter a **Zone** filter (see the Zone Filtering section below).
4. Under the **TSL** category, decide whether TSL instances should be numbered (Yes / No).
5. If Yes, set the **Start number** for TSL PosNum.
6. Under the **Display** category, set the **Text Height** for the label shown at the insertion point.

Press OK to proceed. You may also select a saved catalog entry instead of configuring properties manually.

### Step 3 - Select the viewport

```
Command Line: Select a viewport
```

Click on the Layout Viewport that displays the Element whose members you want to number. The viewport must be linked to a valid structural Element. If the viewport contains no valid Element, the script reports an error and erases itself.

### Step 4 - Place the script marker

```
Command Line: Pick a point outside of paperspace
```

Click anywhere in Model Space. This sets the anchor point where the script displays its name label. The actual numbering happens inside the targeted viewport/element, not at this point.

The script immediately runs the numbering calculation after placement and displays its name label at the chosen point.

---

## Properties Panel (OPM Parameters)

These properties are visible and editable in the AutoCAD Properties Palette after the script is placed. Changing any value automatically triggers a recalculation.

### GenBeam Category

| Property | Display Name | Type | Default | Description |
|---|---|---|---|---|
| `sNoYesGenBeam` | Numbering | Dropdown (No / Yes) | Yes | Enables or disables PosNum assignment for all GenBeam-derived entities (beams, sheets, SIP panels) in the Element. |
| `nStartPosNumGenBeam` | Start number | Integer | 1 | The first PosNum value to assign in the GenBeam numbering sequence. Members that already have a PosNum greater than 0 are skipped. |
| `sZone` | Zone | Text | (empty) | Semicolon-separated list of zone indices to include (e.g., `1;0;-1`). Leave empty to number all zones. See Zone Filtering below. |

### TSL Category

| Property | Display Name | Type | Default | Description |
|---|---|---|---|---|
| `sNoYesTSL` | Numbering | Dropdown (No / Yes) | Yes | Enables or disables PosNum assignment for TSL instances attached to the Element. |
| `nStartPosNumTSL` | Start number | Integer | 1 | The first PosNum value to assign in the TSL numbering sequence. TSL instances that already have a PosNum greater than 0 are skipped. |

### Display Category

| Property | Display Name | Type | Default | Description |
|---|---|---|---|---|
| `dTextHeight` | Text Height | Double (length) | 10 mm | Height of the script name label drawn at the insertion point in current drawing units. |

---

## Right-Click Menu and Double-Click Actions

| Action | Trigger | Description |
|---|---|---|
| Select View Port | Right-click context menu | Re-prompts you to pick a different Layout Viewport. The script immediately re-runs the numbering calculation against the newly selected viewport. |
| Select View Port | Double-click on the script entity | Same behavior as the context menu option - re-prompts viewport selection. |

The "Select View Port" trigger can also be invoked programmatically:

```
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey ("|Select View Port|") ("|Select a viewport|"))) TSLCONTENT
```

**Note:** When no viewport has been assigned yet, the script displays its name followed by "Add a viewport" at the insertion point as a visual reminder.

---

## Zone Filtering

Construction zones in hsbCAD represent layers within an Element cross-section, numbered from -5 to +5 (where 0 is typically the structural frame). If no zone is specified, all zones from -5 to +5 are processed.

To restrict numbering to specific zones, enter their indices in the **Zone** property, separated by semicolons:

| Zone entry example | Meaning |
|---|---|
| (empty) | All zones (-5 through +5) |
| `0` | Structural frame zone only |
| `1;0;-1` | Zones 1, 0, and -1 |
| `-3;-2` | Inner sheathing zones only |

**Legacy mapping:** Values 6 through 10 entered in the Zone field are automatically remapped to their negative equivalents (6 maps to -1, 7 maps to -2, 8 maps to -3, 9 maps to -4, 10 maps to -5) for backward compatibility with older zone numbering conventions. Values outside the valid range (-5 to +5 or the legacy 6-10 range) are silently removed and ignored.

**Note:** The Zone filter applies only to GenBeam numbering. TSL instance numbering operates on all TSL instances in the Element regardless of zone settings.

---

## Numbering Behavior

- **Skip already-numbered items:** Any GenBeam or TSL instance that already has a PosNum greater than 0 is not renumbered. This prevents overwriting numbers set by previous runs or other tools.
- **Equality check:** The `assignPosnum` call uses `bLookForEqual=true`, meaning geometrically identical members receive the same PosNum (matching duplicate or mirrored components).
- **Separate sequences:** GenBeam and TSL instances are numbered in two completely independent sequences with separate start numbers. They can overlap numerically unless you manually offset the start values.
- **Execution priority:** The script sets its own sequence number to 1, ensuring it runs before any other TSL recalculation in the drawing. This guarantees that position numbers are assigned before downstream scripts (such as shop drawing or BOM scripts) read them.
- **Catalog support:** The script supports catalog entries. If a catalog name is passed via the execute key during insertion, properties are loaded from that catalog entry. Otherwise, the most recently used settings are applied as a fallback.

---

## Tips and Notes

- **Auto-recalculation:** Changing the Start number, Numbering toggle, or Zone filter in the Properties Palette immediately triggers a new numbering pass without any additional user steps.
- **Singleton enforcement:** If you accidentally insert a second `hsbLayout-AssignPosnum` in the same drawing space, the previous instance is automatically erased. There is always at most one active instance per space.
- **Renumbering after design changes:** New members added to an Element after the initial numbering pass will receive new PosNums on the next recalculation, but existing numbered members are not changed. To fully renumber from scratch, you must first release the existing PosNums (use the Element's PosNum release function) before recalculating.
- **Viewport must be valid:** The script validates that the selected viewport is linked to a structural Element on every recalculation. If the viewport is deleted or its Element is removed, the script reports an error and erases itself.
- **Label placement:** The text label drawn at the insertion point is purely informational and does not affect the numbering. Move it freely after placement if needed.
- **Units:** The Text Height property respects the drawing's unit system via `U()` conversion. The default of 10 represents 10 mm in a metric drawing.
- **Debug mode:** A debug controller (`hsbTSLDebugController`) can be used by developers to enable verbose logging for this script. In debug mode, the singleton guard is disabled to allow testing without erasing previous instances.

---

## Troubleshooting

| Symptom | Likely Cause | Resolution |
|---|---|---|
| "no valid elements in the viewport" / script erases itself | The selected viewport has no linked structural Element, or the Element was deleted. | Reassign the viewport to display a valid Element, then insert the script again. |
| "no element found in the viewport" | The viewport exists but its Element reference is broken or invalid. | Recreate the viewport link to the Element and re-insert the script. |
| "no genBeam (beam, sheet or panel) found" | GenBeam numbering is enabled but the Element contains no beams/sheets/panels, or the Zone filter excludes all of them. | Check the Zone property and ensure the Element is not empty. Verify that the zone indices match the zones actually used in the Element. |
| Members do not get renumbered after design change | Existing members already have PosNums greater than 0 and are skipped. | Release the existing PosNums on the Element before running this script again. |
| Script disappears after re-insertion | The singleton rule deleted the previous instance. This is expected behavior - there is only one active instance per drawing space. | Check that the new instance is correctly placed and configured. |
| Text label is too small or too large | Text Height default may not suit the viewport scale. | Adjust the **Text Height** property in the Properties Palette. |
| Label shows "Add a viewport" | No viewport has been assigned to the script yet. | Double-click the entity or use the right-click menu to select a viewport. |

---

## Version History

| Version | Date | Author | Change |
|---|---|---|---|
| 1.4 | 21 Jun 2019 | marsel.nakuci@hsbcad.com | Report message if no element in viewport; fix bug in Yes/No index check |
| 1.3 | 28 Mar 2019 | thorsten.huck@hsbcad.com | Typo of property name fixed |
| 1.2 | 26 Mar 2019 | marsel.nakuci@hsbcad.com | Added TSL instance numbering and extended properties |
| 1.1 | 26 Mar 2019 | marsel.nakuci@hsbcad.com | Suggestions in HSBCAD-627 |
| 1.0 | 26 Mar 2019 | marsel.nakuci@hsbcad.com | Initial version |

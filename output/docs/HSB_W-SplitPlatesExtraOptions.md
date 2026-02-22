# HSB_W-SplitPlatesExtraOptions

## Overview

HSB_W-SplitPlatesExtraOptions is a wall framing automation tool that splits long horizontal plates in a stick-frame wall element into shorter pieces, ensuring that no single plate segment exceeds a user-defined maximum length. The script applies intelligent splitting logic that avoids creating joints directly over or within a set distance of wall modules (window or door openings) and individual studs. It also provides control over beam coding, splice block generation, alternating split patterns between plate rows, and the ability to reset plates to their original full lengths.

The script operates as an O-Type (Object) TslInst that attaches itself permanently to a selected wall element. Once attached, it recalculates automatically whenever the wall geometry changes, keeping the plate splits synchronized with any design updates. A dialog is shown on first insertion to configure all settings, after which all parameters remain accessible in the AutoCAD Properties Palette (OPM) for incremental adjustments without re-running the tool.

Current version: 1.11 (24 May 2022).

---

## Usage Environment

| Space | Supported |
|-------|-----------|
| Model Space | Yes |
| Paper Space | No |
| Shop Drawing | No |

The script targets `ElementWallSF` (stick-frame wall elements) in 3D model space. It cannot be applied to CLT panels, floor elements, or non-stick-frame wall types.

---

## Prerequisites

- The target wall must be a fully framed stick-frame wall element (`ElementWallSF`) containing horizontal plates (top plates, bottom plates, very top/bottom plates, blocking, locating plates) and vertical studs.
- The wall element must already exist in the drawing before the script is inserted.
- Only one instance of this script may be attached per wall element. Attempting to insert a second instance on the same wall will produce a warning message and cancel.
- If the configured maximum length is shorter than the minimum unavoidable non-split zone (for example, an opening that is wider than `Maximum length`), the script will report a warning and refuse to proceed.

---

## How to Use

### Step 1: Launch

`TSLINSERT` → `HSB_W-SplitPlatesExtraOptions.mcr`

Alternatively, if a toolbar button has been configured, use the preconfigured button command:

```
^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "HSB_W-SplitPlates_Enhanced")) TSLCONTENT
```

### Step 2: Configure Parameters in the Dialog

A settings dialog appears on first insertion. Configure all splitting parameters (see the OPM section below for full details). Click OK to confirm.

### Step 3: Select Wall Element(s)

The command line prompts:

```
Select element(s):
```

Select one or more stick-frame wall elements. The script attaches one instance to each selected wall. If a wall already has an instance attached, it is skipped with a warning in the command line.

### Step 4: Automatic Recalculation

After insertion the script calculates all split points, splits the plates in the model, and optionally creates splice blocks and assigns beam codes. No further manual steps are needed.

Whenever the wall design changes (studs move, openings are resized, etc.), the script recalculates automatically and updates all splits.

### Step 5: Manual Override (if required)

If the automatically calculated split points for different plate rows are too close together (within 1800 mm of each other), the script enters a manual positioning mode. In this mode:

- Colored grip markers appear on screen at each proposed split location.
- You can drag each grip point along the plate axis to a more suitable position.
- Right-click and choose **Accept Solution** to finalize the manually adjusted positions and perform the actual plate splits.

---

## Properties Panel (OPM Parameters)

All parameters are grouped into categories visible in the AutoCAD Properties Palette when the TSL instance is selected.

### General

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Maximum length | PropDouble | 4800 mm | The maximum permitted length for any individual plate segment. Plates longer than this value will be split. |
| Opening module dimensions greater than | PropDouble | 605 mm | Modules (window or door bays) with a span greater than this value are treated as large opening modules, using a wider clearance distance on each side. |
| Split distance to opening module | PropDouble | 269 mm | Minimum clearance from the edge of a large opening module within which no split is allowed. |
| Split distance to small module | PropDouble | 119 mm | Minimum clearance from the edge of a small module (span at or below the opening module threshold) within which no split is allowed. |
| Split distance to stud | PropDouble | 119 mm | Minimum clearance on each applicable side of a stud centerline within which no split is allowed for internal plate rows. |
| Side of Stud Clear Space | PropString | both | Controls which side of each stud is protected from splits. Options: `both` (clearance on left and right), `left` (clearance on left side only), `right` (clearance on right side only). |

### Additional Options

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Split Location | PropString | Opposite | Controls the horizontal offset relationship between splits in bottom plates and splits in top plates. `Same` places top and bottom splits at the same longitudinal positions. `Opposite` staggers top splits relative to bottom splits to avoid stacked joints. |
| Split on stud | PropString | No | When set to `Yes`, very top and very bottom plate splits (and blocking) are positioned at or over a stud location rather than in the open bay between studs. |
| Create splice blocks | PropString | Yes | When set to `Yes`, a short blocking member (labeled SPLICE BLOCK) is automatically created at each split point to reinforce the joint. The splice block inherits the material, grade, and color of the plate it is placed against, and is automatically stretched to span between the adjacent studs on either side of the split. |
| Set BeamCode | PropString | Left to Right | Controls whether sorted beam codes are assigned to all plate segments after splitting. `No` disables beam coding. `Left to Right` assigns letter suffixes (A, B, C...) from the left end of the wall to the right. `Right to Left` reverses the direction. |
| Write BeamCode suffix to Label | PropString | No | When set to `Yes`, the alphabetic position suffix assigned by beam coding is also written to the Label field of each plate segment, making it visible in shop drawings and element labels. |

### Reset

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Reset plates | PropString | No | When set to `Yes`, all previously split plate segments are joined back to their original full-length framing before any new splitting is applied. This is also triggered automatically when the Reset Plates right-click command is used. |

### Debug

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Preview mode | PropString | Yes | When `Yes`, the TSL instance remains attached to the wall after splitting, keeping all parameters editable and allowing recalculation after property changes. When `No`, the instance erases itself after executing, leaving only the modified plates in the model. |
| Show non split regions | PropString | Yes | When `Yes`, the protected no-split zones (derived from modules and studs) are drawn on screen as colored line segments for visual verification. Useful for understanding why a particular split location was or was not chosen. |

---

## Right-Click Menu Options

When an attached instance of this script is right-clicked in the model, the following context menu items appear:

| Menu Item | Action |
|-----------|--------|
| Split Plates | Forces an immediate recalculation of all split points and re-applies the splits. Equivalent to double-clicking the instance. |
| Reset Plates | Joins all previously split plates back to their original full lengths without removing the TSL instance. Split parameters remain available for future use. |
| Reset Plates And Delete | Resets all plates to their original full lengths and then removes the TSL instance from the wall. Preview mode is bypassed regardless of the current OPM setting. |
| Delete | Removes the TSL instance from the wall without resetting the plate splits. Any splits already made remain in the model. |
| Accept Solution | Appears only during manual positioning mode. Confirms the manually dragged grip point positions and executes the actual plate splits at those locations. |

---

## Tips & Notes

**Plate types handled.** The script processes the following beam types automatically: TopPlate, SFTopPlate, PanelTopPlate, SFVeryTopPlate, SFVeryTopSlopedPlate, PanelCapStrip, SFAngledTPLeft, SFAngledTPRight, BottomPlate, PanelBottomPlate, SFBottomPlate, SFVeryBottomPlate, SFBlocking, and LocatingPlate. Studs are detected separately and used only to define protected zones; they are never split themselves.

**Split point logic.** The script first identifies all protected (no-split) zones along the wall's horizontal axis: one zone per module (with its edges offset inward by either `Split distance to opening module` or `Split distance to small module` depending on the module width), and one zone per stud (offset by `Split distance to stud` on the applicable side(s)). Overlapping zones are automatically merged into single continuous exclusion regions. Split points are placed at the midpoint of each allowable gap between protected zones, ensuring resulting plate segments do not exceed `Maximum length`.

**Internal vs. external plate rows.** Bottom plates and top plates (the innermost horizontal members that directly contact the studs at their top and bottom faces) are classified as internal plates. Plates stacked outward beyond those (very top/bottom plates, additional blocking rows) are classified as external plates. Internal plates are split working from left to right; external plates are split in the opposite direction to create a naturally offset pattern. The `Split Location` property provides additional control over whether top-row and bottom-row internal splits are staggered relative to each other.

**Beam code format.** When `Set BeamCode` is active, each plate row is assigned a row prefix code: `B1`, `B2`, ... for bottom-side stacks (outermost = B1), `T1`, `T2`, ... for top-side stacks (outermost = T1), and `O1` for other long horizontal members such as blocking. Within each row, the individual split segments receive an alphabetic position suffix, resulting in codes such as `B1-A`, `B1-B`, `T1-A`, and so on. If more than 26 segments exist in a single row, the suffix continues with repeated letters (e.g., `ZA`, `ZB`).

**Splice block dimensions.** Created splice blocks are 50 mm long along the plate axis, with the same width and depth as the parent plate. They are automatically stretched to fit flush between the adjacent studs on either side of each split point.

**One instance per wall.** The script enforces a single-instance rule per wall element. If you need to change parameters significantly or recover from an unexpected state, use Reset Plates And Delete to remove the existing instance cleanly, then re-insert with new settings.

**Preview mode workflow.** Keep `Preview mode = Yes` while finalizing the design. This allows you to adjust `Maximum length`, clearance distances, or `Split Location` iteratively without removing the TSL: simply change a parameter value in the Properties Palette and the script recalculates on the next recalc event (or trigger via right-click > Split Plates). Once the splits are confirmed, switch `Preview mode` to `No` and trigger a final recalculation to commit the result and remove the TSL instance from the model.

**Unit compatibility.** All length parameters use the internal `U()` unit conversion function, so the script operates correctly in both metric (millimeter) and imperial (inch-based) drawing templates without any manual conversion.

**Avoiding studs causing split failures.** If the script is unable to find a valid split point on a long plate section, the most common cause is that the stud spacing is smaller than two times `Split distance to stud`, leaving no valid gap between adjacent stud protection zones. Try reducing `Split distance to stud` or changing `Side of Stud Clear Space` from `both` to `left` or `right` to free up valid split positions.

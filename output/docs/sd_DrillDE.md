# sd_DrillDE

## Overview

`sd_DrillDE` is a Shop Drawing annotation script that generates dimension lines and annotations for drill holes on timber beams. It is consumed by the hsbCAD Shop Drawing engine and creates detailed, configurable dimensioning output for all drill subtypes: perpendicular drills, rotated drills, tilted drills, head-end drills, and 5-axis drills.

For each drill found on a beam, the script generates one or more of the following:
- An X-position dimension line showing the drill's location along the beam axis
- A cross-section (YZ) offset dimension line showing the drill's position relative to the beam face
- A depth dimension (chain or text) for blind holes
- An optional diameter or radius annotation (as appendix text, standalone text, or radial dimension)
- Optional Japanese-style connection symbols for timber joint drawings

The script supports both German/European (DE) and Japanese shop drawing conventions. It is version 3.6 and designed to work in hsbCAD 2009 or later.

## Usage Environment

- **Script type:** E-Type (Element-type — attaches to a beam element)
- **Works in:** Shop Drawing (Paper Space, via Shopdrawing Engine / Multipage Ruleset)
- **Model Space use:** Not intended for direct Model Space use
- **Beams required:** 1

This script is not intended to be placed manually in the drawing. It is executed automatically by the hsbCAD Shopdrawing engine when it is listed in the active multipage ruleset. Direct insertion is supported only for testing.

## Prerequisites

- The target `GenBeam` (timber beam) must have one or more drill operations applied (via `DrillDistribution`, `hsbCLT-Drill`, `SimpleFastener`, or any hardware TSL that creates drills).
- The script must be registered in the ruleset of a Multipage Shopdrawing style.
- hsbCAD 2009 or later is required for dialog-driven option configuration.
- Stereotypes `Drill`, `SectionLeft`, and `LeftInfo` must be defined in the active Multipage style for dimension placement to work correctly. Optional stereotypes `SectionRight`, `LeftStart`, `LeftEnd`, `RightStart`, `RightEnd` enable advanced dimensioning layouts.

## How to Use

### Automatic use (standard workflow)

1. Open or create a Multipage Shopdrawing style.
2. In the ruleset, add `sd_DrillDE` as an entry for drill annotation.
3. Optionally append command modifiers to the execution key to preset options (see "Ruleset Command Modifiers" below).
4. Generate the shop drawing. The engine inserts and executes this script for each drill on each beam view.

### Manual insertion (for testing or configuration)

1. Type `TSLINSERT` on the AutoCAD command line and select `sd_DrillDE.mcr`.
2. At the prompt `Select beam:`, click the timber beam that has drill holes.
3. At the prompt `Select point near tool`, click a point close to the drill holes on the selected beam.
4. The script attaches to the beam and generates dimension requests for the Shop Drawing engine.

### Adjusting options after insertion

Right-click the inserted instance and choose **Properties** (or open the OPM Properties Palette). A configuration dialog appears showing all available options. Change settings and confirm. The script recalculates and updates all dimension lines.

## Properties Panel (OPM Parameters)

These options are displayed in a dialog when you right-click the entity and select Properties. Each option maps to an internal Map entry; only non-default values are stored.

| Property | Type | Default | Description |
|---|---|---|---|
| Show all in one dimline on left side | String (Yes/No) | No | Collects all drill dimension points on the left side into a single shared chain dimension using the stereotype `LeftStart`. When combined with "Add dimensions from Start and End", two dimlines are created on that side. |
| Show all in one dimline on right side | String (Yes/No) | No | Same as above but for the right side, using stereotype `RightStart`. |
| Add dimensions from Start and End | String (length value) | (empty) | When set to a length value greater than zero and less than the beam length, two separate dimension lines are created: one collecting drill points from the start toward the middle, and one from the end toward the middle. |
| Show 6 Sides | String (Yes/No) | No | Collects dimension points for all six possible viewing directions of the beam instead of only the default two (top and side). |
| Show Drill Axis View | String (dropdown) | parallel to view | Controls in which view direction the drill's X-position dimension is shown: **parallel to view** (0), **perpendicular to view** (1), **Side View** (2), **Top View** (3), or **do not display** (4). |
| Show Offset of Drill Axis | String (Yes/No) | No | Shows an offset dimension from the beam edge to the center of the drill axis in the cross-sectional view. |
| Show Drill Diameter | String (dropdown) | Diameter as appendix | Controls how diameter/radius is displayed: **Diameter as appendix to dimpoint** (0), **Radius as appendix to dimpoint** (1), **Diameter as text near drill** (2), **Radius as text near drill** (3), **Radius as angular dimension** (4), **do not display** (5). |
| Show Info Separate | String (Yes/No) | No | When Yes, diameter/radius appendix text is placed in a dedicated separate dimension line using the stereotype `LeftInfo` instead of being appended to the main dimension point. |
| Hide Drill in Section | String (Yes/No) | No | When Yes, the drill is not shown in the sectional (cross-section) view. |
| Show Diameter if equal | String (Yes/No) | No | When No (default), adjacent drills with the same diameter will show the diameter annotation only on the first one. When Yes, every drill point gets a diameter annotation regardless. |
| Show Japanese Symbols | String (Yes/No) | No | Enables Japanese-style graphical symbols for drill connections (arrows, offset angles, composite circles). Automatically enabled when the script is executed in Japanese style mode (via `sd_BmJP`). |
| Suppress Depth Display | String (Yes/No) | No | When Yes, depth dimensions are not generated for any drill, even for blind holes. Useful when depth is already documented elsewhere. |

## Ruleset Command Modifiers

These modifiers can be appended to the execution key of this script inside the Multipage ruleset definition to preset behavior without using the dialog:

| Command Modifier | Effect |
|---|---|
| `showIndividualAxisOffset` | Generates an individual dimension line for the drill axis offset. |
| `suppressDepth` | Suppresses depth display for all drills (same as setting the property to Yes). |
| `showJapaneseSymbols` | Enables Japanese graphical symbols. |
| `JapaneseStyle;<Off/On>` | Activates full Japanese-style dimensioning rules. In Japanese style: mortise/housing/dovetail groups show only the dovetail; point selection follows beam orientation (post = top point, horizontal = center point). |
| `showOffsetDrill;<0-3>` | 0 = individual offset dimline in view; 1 = offset near origin relative to beam edges in two dimlines; 2 = all offsets collected at start or end; 3 = no offset displayed. |
| `showDiameter;<0-5>` | Controls diameter display mode (same values as OPM dialog above). |
| `showDiameterIfEqual;<0-1>` | 0 = suppress repeated diameters; 1 = show diameter on every drill. |
| `hideDrillInSection;<0-1>` | 0 = show in section; 1 = hide in section. |
| `ShowDrillAxisView;<0-4>` | Sets the allowed viewing direction for X-position dimensions (same values as OPM dialog above). |
| `ShowInfoSeparate;<0-1>` | 0 = diameter info on main dimline; 1 = diameter info on separate dimline using stereotype LeftInfo/RightInfo. |

## Drill Subtypes Handled

The script detects the subtype of each analyzed drill and adjusts what it dimensions:

| Subtype | X-Position Dim | Axis Offset Dim | Depth | Notes |
|---|---|---|---|---|
| Perpendicular (`ADPerpendicular`) | Yes | Yes | Shown as chain dim | Groups same-side drills; shows diameter once per group if equal |
| Rotated (`ADRotated`) | Yes | Yes | Shown as text label | For angled-in-plane drills |
| Tilted (`ADTilted`) | Yes | Yes | Shown as text label | For drills at a bevel angle |
| Head-end (`ADHead`) | Yes | Yes | Shown as text label | Treated as parallel-to-axis; generates YZ cross-section dims |
| 5-Axis (`AD5Axis`) | Yes | Yes | Shown as text label | Both bevel and rotation angles shown in postfix |

## Stereotype Mapping

Stereotypes control where in the sheet layout each dimension line is placed. These must be configured in the Multipage style:

| Stereotype | Used for |
|---|---|
| `Drill` | Main X-position dimension line for drill location along beam axis |
| `SectionLeft` | Cross-section (YZ) offset dimension for drill position from beam edge; also used for depth chain |
| `SectionRight` | Same as SectionLeft for right-side views |
| `LeftInfo` | Separate diameter/radius appendix text dimension line (when ShowInfoSeparate = Yes) |
| `RightInfo` | Same as LeftInfo for right side |
| `LeftStart` | Left-side chain dimline collecting all drill points from beam start (when ShowAllInOneLeft = Yes) |
| `LeftEnd` | Left-side chain dimline collecting drill points from beam end |
| `RightStart` | Right-side equivalent of LeftStart |
| `RightEnd` | Right-side equivalent of LeftEnd |

## Tips and Notes

- **Through-holes do not get a depth dimension by default.** Depth is only generated when the drill is a blind hole or when composite drills (sinkholes stacked on a main bore) are present.
- **Composite drills** (a main bore with countersink or counterbore) are detected automatically. The diameter annotation will show all diameters in the group separated by `/` (e.g., `20/12` for a 20 mm bore with a 12 mm countersink).
- **Diameter annotations appear only once per group** when `showDiameterIfEqual` is off. Drills are sorted by X-position along the beam; drills at the same X-location with the same diameter will share one annotation.
- **Bevel and rotation angles** are automatically appended to the dimension text for tilted and 5-axis drills in the format `< 15°` or `< 15°/30°`.
- **Hip and valley rafters** are handled specially: the script detects these beam types and corrects the coordinate system so that projected views align correctly.
- **Japanese style** is automatically activated when this script is consumed by `sd_BmJP`. The `showJapaneseSymbols` property is then forced on. When consumed by `sd_BmDE`, Japanese symbols are off by default but can be individually enabled.
- **Dimension line placement direction** (left vs. right of the beam) alternates automatically for each view loop so that dimensions on opposite faces land on opposite sides of the shop drawing layout.
- **Zero at the reference point** is suppressed by default; only distances from the reference end are labeled.
- **Option changes are stored efficiently.** Only non-default values are written to the entity's Map, so global ruleset options remain effective for any setting not overridden at the entity level.

## FAQ

**Q: Drill dimensions are not appearing in the shop drawing at all.**
A: Check that the stereotype `Drill` is defined in the active Multipage style and that its layer is visible. Also verify that `Show Drill Axis View` is not set to `do not display` (value 4).

**Q: The diameter label appears only on the first hole of a group but not the rest.**
A: This is the expected behavior when `Show Diameter if equal` is set to No (default). If you need the diameter on every hole, set `Show Diameter if equal` to Yes.

**Q: I see dimension lines but no diameter or radius text.**
A: Check `Show Drill Diameter`. If it is set to `do not display` (value 5), no size annotation is generated. Also check whether `Show Info Separate` moved the text to the `LeftInfo` stereotype layer, which may be frozen.

**Q: The drill appears in the 3D model but is not annotated in the cross-section view.**
A: Check `Hide Drill in Section`. If it is set to Yes, the hole is intentionally excluded from the sectional dimension. Set it to No to restore the annotation.

**Q: Depth dimensions are missing for my blind holes.**
A: Check `Suppress Depth Display`. If it is set to Yes, all depth annotations are disabled. Set it to No to restore them.

**Q: The Japanese symbols (arrow lines, circles) are not appearing.**
A: Ensure `Show Japanese Symbols` is set to Yes in the Properties dialog, or append `showJapaneseSymbols` to the execution key in the ruleset. If using `sd_BmJP`, this should be activated automatically.

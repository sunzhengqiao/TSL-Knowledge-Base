# hsbFloorPlanDimension

## Overview

`hsbFloorPlanDimension` automatically generates parametric floor plan dimension lines for wall elements in hsbCAD. When placed on a floor, it detects all wall elements on that storey, groups parallel connected walls together, and creates individual dimension line instances for each wall or wall group. The resulting dimensions show framing points, opening locations, wall connections, wall splits, and wall extremes, all driven by configurable painter-based dimensioning strategies.

The script operates in two internal modes. Mode 0 (floor detection) analyzes the selected walls, determines their storey grouping, identifies parallel connected sets, and spawns individual dimension instances. Mode 1 (dimension mode) is used by each spawned instance to collect dimension points according to the assigned painter strategy and render the actual dimension line.

## Script Metadata

| Field | Value |
|-------|-------|
| Version | 1.8 |
| Date | 08 December 2020 |
| Author | thorsten.huck@hsbcad.com |
| Type | O (Object) |
| Beams Required | 0 |
| Keywords | Floorplan, Dimensioning, Grundriss |

## Version History

| Version | Date | Description |
|---------|------|-------------|
| 1.8 | 08 Dec 2020 | Bugfix for log wall detection (HSB-10023) |
| 1.7 | 07 Dec 2020 | Wall split references fixed (HSB-9969) |
| 1.6 | 07 Dec 2020 | Log wall support added (HSB-10023) |
| 1.5 | 20 Nov 2020 | New strategies for inner and outer extreme wall connections (HSB-9952) |
| 1.4 | 20 Nov 2020 | Strictly painter-based, painter strategy stored in subMapX of painter (HSB-9664) |
| 1.3 | 16 Nov 2020 | Group insertion support (HSB-9664) |
| 1.2 | 13 Nov 2020 | Full painter support (HSB-9664) |
| 1.1 | 12 Nov 2020 | Painter-based definitions extended, new grouping of parallel connected walls (HSB-9664) |
| 1.0 | 11 Nov 2020 | Initial version (HSB-9664) |

## Usage Environment

| Space | Supported |
|-------|-----------|
| Model Space | Yes |
| Paper Space | No |
| Shop Drawing View | No |

This script operates exclusively in Model Space. It reads and dimensions wall elements (ElementWall) in 3D. Paper Space and shop drawing views are not supported.

## Prerequisites

- At least one `ElementWall` must exist in the drawing before the script can generate dimension lines.
- The drawing must have a proper hsbCAD project structure with floor/storey groups defined so the script can discover all walls belonging to a given floor.
- A valid `PainterDefinition` collection named `PlanDimension` must be available. If it does not exist, the script creates the default painter entries automatically on first run.
- (Optional) A settings XML file `hsbFloorPlanDimension.xml` may be present at the company settings path or the hsbCAD installation path. This file defines named Configurations and Rules that control batch dimension group placement.

## How to Use

### Step 1: Launch

Type `TSLINSERT` in the AutoCAD command line and select `hsbFloorPlanDimension.mcr`, or use the hsbCAD script palette. Alternatively, use the LISP shortcut:

```
^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbFloorPlanDimension")) TSLCONTENT
```

An additional LISP shortcut is available to directly invoke the Set Reference Point trigger on an existing instance:

```
^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey "|Set Reference Point|" "|Select floor dimension line|")) TSLCONTENT
```

### Step 2: Configure Parameters in the Properties Dialog

As soon as you start the insertion, a properties dialog (OPM-based) appears. Set the dimensioning strategy, reference, display mode, dimension style, and optional description format. See the Properties Panel section below for the full parameter list.

If the settings XML file defines multiple named Configurations, an additional dialog appears asking you to select which dimension group configuration to apply. This is used for batch placement of multiple parallel dimension lines (for example, outer frame + openings + wall connections at once).

### Step 3: Select Wall Elements

The command line prompts:

> **Select elements** `<Enter> to insert a single dimline`

Select one or more wall elements (ElementWall) that you want to dimension. Press Enter to confirm. You may also press Enter immediately to insert a single dimension line without binding it to a specific element selection at this stage.

When a group configuration is available and elements are selected, the script immediately enters group insertion mode. The selected configuration's rules are applied, and one dimension instance per rule request is created for each wall or wall group.

### Step 4: Automatic Analysis and Placement

After element selection the script automatically:

1. Detects the floor group that the selected walls belong to by reading the element group hierarchy (first two levels of the group name).
2. Collects all walls on that storey from the floor group.
3. Builds a combined floor plan outline (PlaneProfile) from all collected wall outlines to determine interior vs. exterior placement.
4. Groups walls that run parallel and connect to each other into a single instance by testing profile intersection of their outlines.
5. Determines the correct side (interior or exterior) on which to place each dimension line. Exposed walls receive dimensions on the exterior face; non-exposed walls receive them on the interior face. This is computed by testing whether the wall midpoint lies inside or outside the combined floor plan profile.
6. Creates individual `hsbFloorPlanDimension` instances in dimension mode (mode 1) for each wall or wall group. The original placement instance (mode 0) is erased after all child instances are created.
7. Each child instance then draws its dimension line according to the selected strategy and painter.

For multi-storey projects, if walls from multiple storeys are selected, additional distribution instances (mode 0) are created automatically to handle each storey in sequence. The script removes processed walls from the element list and passes the remainder to a new mode 0 instance.

### Step 5: Adjust and Fine-Tune

After placement, select any dimension instance and use the AutoCAD Properties Palette (OPM) to change the dimensioning strategy, display mode, dimension style, or description format. The dimension line updates automatically.

Use right-click context menu options (see the Right-Click Menu Options section below) to interactively add or remove walls, add custom dimension points, set a reference point, or manage stacked dimension groups.

## Properties Panel (OPM Parameters)

### Strategy Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimensioning | String (dropdown) | First painter in `PlanDimension` collection | Selects which painter definition drives the primary dimension points. The available choices correspond to entries in the `PlanDimension` painter collection. Default painters include: Frame, Openings, Wall Connections Exterior, Wall Connections Interior, Wall Splits, Outer Wall Extremes, and Inner Wall Extremes. The list is sorted alphabetically. |
| Reference | String (dropdown) | `<Disabled>` | Optionally selects a second painter to act as the reference baseline for the dimension. When set to a painter name, its collected points are drawn as reference ticks at the start of the dimension line. Set to `<Disabled>` to suppress reference points. The dropdown contains the same sorted list of painters as the Dimensioning property, prepended with the `<Disabled>` option. |
| Section Height | Double | 0 mm | Defines the cut-plane height relative to the wall outline used to filter which members contribute dimension points. When set to 0 all members in the wall are included regardless of their vertical position. Set a positive value to restrict the section to a specific elevation, which is useful for walls with varying framing at different heights. Members whose envelope body has no area at the section plane are excluded. |

### Display Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimstyle | String (dropdown) | Current drawing default dim style | Selects the AutoCAD dimension style applied to the dimension line. All dim styles defined in the current drawing are available in the dropdown, sorted alphabetically. The text height used for collision avoidance and spacing calculations is derived from this style. |
| Delta/Chain Mode | String (dropdown) | `Parallel / Parallel` | Controls how dimension segments are displayed. The value is a combination of two modes separated by a slash. The first mode controls the delta (incremental) segments and the second controls the chain (cumulative) segments. Options for each: `Parallel` (dimension line parallel to the wall), `Perpendicular` (dimension line perpendicular to the wall), or `Disabled` (hide that segment type). The combination `Disabled / Disabled` is excluded from the dropdown since it would produce no visible output. Valid combinations include Parallel/Parallel, Parallel/Perpendicular, Parallel/Disabled, Perpendicular/Parallel, Perpendicular/Perpendicular, Perpendicular/Disabled, Disabled/Parallel, and Disabled/Perpendicular. |
| Format | String | (empty) | Defines an optional text label drawn adjacent to the dimension line. Leave blank for no label. You may use static text or dynamic format expressions such as `@(Strategy)` to automatically insert the active strategy name. The expression is first evaluated against the element using `formatObject`, and if any unresolved `@(...)` tokens remain, it is evaluated again against the TSL instance itself. The text is positioned outside the outermost dimension point, offset by one text height in the reading direction. |

## Dimensioning Strategies Explained

The **Dimensioning** property selects one of the painter-defined strategies. Each strategy instructs the script to collect a different set of dimension points from the wall. The strategy assignment is stored in the painter's subMapX under the key `Strategy`.

| Strategy Name | Internal Index | Painter Entity Type | Painter Filter | What It Dimensions |
|---------------|---------------|--------------------|-----------------|--------------------|
| Frame | 0 | Beam | `(Equals(ZoneIndex,0))and(Equals(IsDummy,'false'))` | Collects the left and right extents of structural beams (zone index 0, non-dummy) to dimension the overall framing span of the wall. This is the default strategy for basic wall length dimensioning. |
| Openings | 1 | Opening | (none) | Collects the left and right edges of each opening (door, window) in the wall to dimension opening widths and their positions along the wall. The instance is automatically erased if no openings are found in any of the associated walls. |
| Wall Connections Exterior | 2 | Sheet | `(Equals(IsDummy,'false'))` | Collects the sheet faces at the contact zones between the main wall and perpendicularly connected walls, focusing on the outer sheet layer positions. For exposed main walls, it dimensions the connection offsets at each perpendicular wall intersection. |
| Wall Connections Interior | 3 | Sheet | `(Equals(IsDummy,'false'))` | Collects the sheet faces at the contact zones between the main wall and perpendicularly connected interior walls. Behaves similarly to Wall Connections Exterior but targets the inner sheet layers. |
| Wall Splits | 4 | ElementWall | (none) | Collects the seam locations where the selected wall is split into multiple wall elements sharing the same run. Requires at least two wall elements to be associated with the instance. If only one wall is linked, the instance is erased. Only non-extreme split points are collected (start and end of the combined outline are excluded when construction exists). |
| Outer Wall Extremes | 5 | Sheet | `(Equals(IsDummy,'false'))` | Collects the outermost sheet or beam edge at the first and last perpendicular wall intersections along the main wall, to show the overall building footprint extremes on the exterior face of the connecting walls. |
| Inner Wall Extremes | 6 | Sheet | `(Equals(IsDummy,'false'))` | Collects the innermost sheet or beam edge at the first and last perpendicular wall intersections, to show the inner structural boundary at each end of the wall. |

### Log Wall Detection

When the PlanDimension painter collection does not yet exist and the drawing contains `ElementLog` entities, the script automatically switches to beam-based painter types instead of sheet-based types for the Wall Connections, Wall Splits, and Wall Extremes strategies. This is because log walls do not use sheets in their framing construction.

### Wall Connection Type Detection

The script internally classifies wall connections at the start and end of each main wall. The classification determines how dimension points from connecting walls are handled:

| Type Code | Connection | Description |
|-----------|-----------|-------------|
| 0 | Corner Male | One vertex of the connecting wall sits on the main wall outline, two vertices of the main wall sit on the connecting wall |
| 1 | Corner Female | Two vertices of the connecting wall sit on the main wall outline, one vertex of the main wall sits on the connecting wall |
| 2 | T-Connection Male | No vertices of the connecting wall sit on the main wall, but two vertices of the main wall sit on the connecting wall |
| 4 | Mitre | Two vertices from each wall sit on the other wall's outline |
| 5 | Parallel | The connecting wall runs parallel to the main wall |

This classification affects whether the script picks one contact point or both contact points from the connecting wall, and whether the point is added to the main dimension line or the wall connection dimension set.

## Right-Click Menu Options

Right-click on an existing `hsbFloorPlanDimension` instance to access the following context menu options:

| Menu Item | Scope | Description |
|-----------|-------|-------------|
| Set Reference Point | Root | Prompts you to click a point in the drawing. That point is added as a fixed reference grip on the dimension line, overriding the automatically calculated reference position. The reference point is stored as a vector relative to the insertion point and persists across recalculations. If a reference already exists, it is replaced. |
| Add Points | Root | Prompts you to click one or more points in the drawing. Each clicked point is added as an extra dimension tick (stored as a "grip" vector in the location map). Press Enter or Escape when done. These custom points appear alongside automatically detected dimension points. |
| Remove Point | Root | Activates a jig (interactive visual feedback) that displays existing custom grip points as circles on screen. Circles are drawn in red for regular grips and orange for the reference point. As you hover, the nearest grip highlights in green (color 3). Click near a grip to remove it. The jig runs in a loop until you press Escape or Enter. |
| Set Parent Dimline | Context | Prompts you to select one or more other `hsbFloorPlanDimension` instances to designate as parent dimension lines. The current instance will automatically offset itself perpendicular to the wall to avoid overlapping the parent's text areas. Parent instances are tracked via the entity reference list. |
| Remove Parent Dimline | Context | (Visible only when parent dimension lines are assigned.) Prompts you to select parent dimlines to detach from the current instance. Selected parents are removed from the entity reference list. |
| Add Walls | Root | Prompts you to select additional wall elements to add to the current instance's element set. The dimension line recalculates to cover the added walls. Only walls not already associated are appended. |
| Remove Walls | Root | (Visible only when more than one wall is associated.) Prompts you to select walls to remove from the current instance's element set. At least one wall always remains to keep the instance valid. |
| Hide Connection Delta Text / Show Connection Delta Text | Root | (Visible only for Wall Connections Exterior and Wall Connections Interior strategies, indices 2 and 3.) Toggles the visibility of the incremental delta text shown between wall connection ticks. When hidden, every other delta text segment is replaced with a space. Use "Hide" to suppress intermediate texts and show only cumulative lengths; use "Show" to restore all intermediate texts. The toggle state is stored in the Custom map under the key `DisableDeltaWallConnection`. If the strategy changes away from a wall connection type, this flag is automatically cleared. |
| Set Strategy of Painter `[name]` | Context | Opens a dialog listing all available dimensioning strategies plus `<None>`. Select a different strategy from the list to reassign the strategy stored in the painter definition's subMapX. Selecting `<None>` clears the strategy assignment entirely. This modifies the painter definition itself, so all instances using that painter are affected. |
| Setup Dimension Group | Context | Opens a workflow to define a named dimension group configuration. First, select additional `hsbFloorPlanDimension` instances in the drawing to include in the group. The script collects all selected instances, orders them by perpendicular offset from the wall face, calculates the base offset of the first instance and the relative text-height spacing between subsequent instances, and captures the property values of each instance. A dialog then prompts for a configuration name (from existing configurations or "Default") and a wall association type (Interior Walls, Exterior Walls, or Exterior and Interior Walls). If a rule already exists for the chosen association within the selected configuration, you are prompted whether to overwrite it. Once saved, the configuration is persisted in the MapObject dictionary and written to the settings XML. Future insertions using the group workflow will automatically create the entire stack of dimension lines in one step. |

## Settings Files

The script reads an optional XML configuration file named `hsbFloorPlanDimension.xml`. The file is searched in the following locations, in order:

1. `[Company Path]\TSL\Settings\hsbFloorPlanDimension.xml`
2. `[Installation Path]\Content\General\TSL\Settings\hsbFloorPlanDimension.xml`

If the file is found, it is read into a `MapObject` stored in the drawing dictionary under the key `hsbTSL\hsbFloorPlanDimension`. On subsequent recalculations, the cached MapObject is used directly (with a dependency set on it for automatic recalculation when the settings change). The Settings folder is created automatically under the company TSL path if it does not exist during insertion.

### Settings Structure

The settings file defines named Configurations containing Rules:

```
Configuration[]
  Configuration (name = "MyConfig")
    Rule[]
      Rule (name = "Exterior Walls")
        Exposed: 1
        Request[]
          Request
            baseOffset: [distance from wall face]
            scriptName: hsbFloorPlanDimension
            PropertyMap: [OPM property values]
            Custom: [custom map data]
          Request
            ...
      Rule (name = "Interior Walls")
        ...
  Configuration (name = "AnotherConfig")
    ...
GeneralMapObject
  Version: [integer]
```

Each Rule specifies:
- **Exposed**: Wall association type (0 = Interior Walls, 1 = Exterior Walls, 2 = Exterior and Interior Walls)
- **Request[]**: A list of dimension requests, one per stacked dimension line. Each request contains:
  - **baseOffset**: The perpendicular distance from the wall face (for the first line) or the relative offset from the previous line
  - **PropertyMap**: The complete set of OPM property values for that dimension line (strategy, reference, display mode, dim style, format)
  - **Custom**: Any custom map data (such as the DisableDeltaWallConnection flag)

When a settings file is present with one or more configurations, the insertion workflow changes: instead of placing a single dimension line, the script reads the rules and automatically creates an entire stack of dimension lines in one step, each offset from the previous.

### Version Validation

The script checks the installed version of the settings file against the version found on disk whenever a new instance is created (`_bOnDbCreated`). If the version numbers differ, a notice is reported in the command line. The notice includes both version numbers and the file paths for both the current dictionary version and the file-based version. This alerts the user to review the settings after an hsbCAD upgrade or after customizing the XML file.

## Painter System

The script relies entirely on the hsbCAD PainterDefinition system for point collection. All painters belong to the collection named `PlanDimension`.

### Default Painter Creation

On first use, the script checks whether the `PlanDimension` painter collection exists in the drawing. If any expected painter is missing, it is created automatically with:
- **Type**: The entity type to filter (Beam, Opening, Sheet, or ElementWall)
- **Filter**: A filter expression for the painter (e.g., zone index and dummy filters)
- **SubMapX**: A map under the script name containing the `Strategy` key

The seven default painters and their configurations are listed in the Dimensioning Strategies table above.

### Custom Painters

You can add custom painters to the `PlanDimension` collection via the hsbCAD Painter Manager. Any painter in this collection appears in the Dimensioning and Reference dropdowns. If no Strategy is set in the painter's subMapX, the painter uses strategy index 0 (Frame), which collects dimension points using `DimLine.collectDimPoints` with the left-and-right mode on the filtered entities.

## Automatic Collision Avoidance

When multiple `hsbFloorPlanDimension` instances are stacked as parent and child, each child instance automatically checks whether its text area overlaps with the combined text areas of its parent instances. Text areas are collected from the `Dim` object's `getTextAreas` method plus any description box, expanded by 25% of the text height.

If overlap is detected, the instance incrementally shifts outward (perpendicular to the wall) in steps of 25% of the text height until the overlap is resolved, up to a maximum of 20 iterations. The shifted position is persisted, and the script triggers a second execution loop to redraw at the new location. This ensures stacked dimension lines remain readable without manual adjustment.

### Parent Snapping

Even without collision detection, child instances snap to the nearest parent. The insertion point is adjusted so that the baseline sits one text height beyond the closest parent instance's origin, measured along the perpendicular direction. This snapping also occurs when certain properties change (display mode, dim style, or strategy), ensuring consistent spacing after property edits.

## Dimension Reading Direction

The script automatically determines the reading direction for dimension text. The dimension line's X-axis is flipped if it would produce text that reads from right-to-left or from top-to-bottom. Specifically, if the direction vector is codirectional with the negative Y-world axis, or if it is not parallel to the Y-world axis and its dot product with the X-world axis is negative, the direction is reversed. This ensures dimension text is always readable from left-to-right or bottom-to-top in the standard AutoCAD view orientation.

## Grip Point Management

Custom points added via Add Points and Set Reference Point are stored in the instance's map under the key `Loc[]` as named vectors relative to the world insertion point (`_PtW`). Each entry uses the key `grip` for regular custom points or `ref` for the reference point.

When the insertion point `_Pt0` is moved (detected by `_kNameLastChangedProp == "_Pt0"`), all grip positions are recalculated from their stored vectors. When an individual grip point is moved by the user, the corresponding vector in the location map is updated. This two-way binding ensures grip points move correctly with the instance and can also be repositioned independently.

## Dimension Point De-Duplication

When assembling the final dimension line, points from all sources (references, extremes, openings, wall connections, wall splits, and general dimension points) are added in a specific order. Before each point is appended to the dimension, the script checks whether any previously added point occupies the same position along the dimension axis (within a tolerance of 0.1 mm). Duplicate points are skipped. Additionally, if the first point in the entire sequence has zero distance from the start, its end text is suppressed (replaced with a space) to avoid displaying a zero-length segment at the beginning.

## Tips and Notes

- On first use in a drawing, the script creates the default `PlanDimension` painter collection entries automatically. These painters can be customized via the Painter Manager in hsbCAD to change their entity type filters if required for non-standard framing conditions.
- For log wall drawings, the script automatically detects log wall elements and switches to beam-based painter types instead of sheet-based types, because log walls do not use sheets in their framing construction.
- The dimension line is always placed on the correct side of the wall -- the exterior side for exposed walls and the interior side for non-exposed walls -- automatically. The side is determined by testing the wall midpoint against the combined floor plan profile. You can reposition it by dragging the insertion grip after placement.
- To dimension multiple parallel offset walls as a single span, select them all during element selection. The script groups them into a single instance and treats their combined outline as the dimension baseline.
- If the Openings strategy is selected and the wall has no openings, the instance is automatically erased to keep the drawing clean.
- The Format field supports dynamic expressions using `@(...)` syntax. For example, `@(Strategy)` inserts the current strategy name. The expression is resolved in two passes: first against the element, then against the TSL instance.
- Grip points added via Add Points are stored as vectors relative to the insertion point and move together with the dimension line if it is relocated.
- Version compatibility between the company settings file and the installation default is checked on every new instance creation. Always review the command line for version mismatch notices after upgrading hsbCAD.
- The script supports silent insertion via catalog names. If an execute key matching a catalog entry is provided, the properties are loaded from that catalog. Otherwise, the `_LastInserted` catalog is used.
- When inserting with a group configuration, the creator instance is erased immediately after distributing child instances. This is normal behavior and not an error.
- The Wall Splits strategy skips walls whose direction is perpendicular to the main wall, ensuring only colinear split segments are dimensioned.

## Common Issues

| Symptom | Cause | Solution |
|---------|-------|----------|
| Dimension line does not appear after insertion | The mode 0 (creator) instance erases itself after distributing dimension lines to individual walls. This is normal. | Check near the selected walls for individual dimension instances that were created. |
| Instance is erased immediately with no output | No valid `ElementWall` was found in the element reference, or no walls in the selected floor group passed the exposure filter when using a group rule. | Verify that wall elements are present and that the element selection was not empty. When using group rules, check whether the rule's association type matches the exposure state of the selected walls. |
| Painter not found error | The `PlanDimension` painter for the selected strategy does not exist and could not be created. | Ensure the hsbCAD Painter Manager is accessible and the drawing database is not locked or in read-only mode. The script reports "Unexpected Error, Painter not found." in this case. |
| Stacked dimension lines overlap | The collision avoidance loop reached its limit of 20 iterations without resolving the overlap. | Manually drag the insertion grip outward to increase the perpendicular offset. Then assign one instance as parent of the other using Set Parent Dimline so future recalculations maintain the correct spacing. |
| Wall Splits strategy creates no dimension | The Wall Splits strategy requires at least two wall element references associated with one instance. | Use Add Walls to attach additional wall segments before switching to this strategy. With only one wall, the instance erases itself. |
| Version mismatch notice in command line | The company-customized settings XML has a different version number than the installed default. | Review and align the settings files. Update the `Version` field in the `GeneralMapObject` section after any customization to suppress future notices. |
| Dimension points appear on wrong side of wall | The floor plan profile analysis produced an unexpected result, possibly due to incomplete wall geometry on the storey. | Drag the insertion grip to the desired side of the wall. The perpendicular direction is determined by the dot product of the wall's Z-axis with the vector from the wall midpoint to the insertion point. |
| Custom grip points not moving with the instance | The grip synchronization requires the property change name to be `_Pt0`. If the instance is moved by other means, grips may lag. | The script handles this on the next recalculation by detecting the `_Pt0` change and recomputing grip positions from stored vectors. Force a recalculation if needed. |
| Set Strategy of Painter changes all instances using that painter | The "Set Strategy of Painter" action modifies the painter definition itself, not just the current instance. | This is by design. All instances referencing the same painter share the strategy definition. To use a different strategy on one instance only, change the Dimensioning dropdown in the OPM instead. |

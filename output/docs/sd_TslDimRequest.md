# sd_TslDimRequest

## Overview

`sd_TslDimRequest` is a Shop Drawing automation script that acts as a **dimension request collector and dispatcher**. It scans the TSL instances and entities attached to a structural element (wall, floor, SIP panel, truss, etc.) and gathers their embedded dimension data, then passes those dimension requests to the hsbCAD Shop Drawing engine so that dimensions are automatically drawn in the generated layout views.

This script does **not** draw dimensions itself. Instead, it reads structured dimension data that other scripts (connection hardware, framing tools, etc.) have published into their Maps, and forwards those requests as `DimRequestPoint`, `DimRequestChain`, and `DimRequestRadial` objects to the Shop Drawing engine. The engine decides where and how to place the actual dimension annotations based on the active viewport geometry and the selected Stereotype.

Key capabilities:
- Collects global chain dimensions from attached TSL scripts and entity MapX data.
- Collects local chain dimensions (e.g., stud spacing or sub-element groupings).
- Collects radial/diameter dimensions for curved geometry.
- Supports dimension filtering by Stereotype name so different drawing sheets can show different levels of detail.
- Automatically snaps dimension witness lines to the outline of the parent entity for clean, accurate annotation.
- Supports description labels (text annotations) alongside dimension chains.
- Works with all major entity types: Elements (walls/floors/roofs), SIP panels, GenBeams, TslInst, MassGroups, MassElements, TrussEntities, and MetalPartCollections.

> **Important**: This script is executed automatically by the Shop Drawing engine as part of a Multipage Style ruleset. It should **not** be inserted manually in Model Space.

---

## Usage Environment

| Setting | Value |
|---|---|
| Script type | O-Type (Object) |
| Beams required | 0 |
| Execution context | Shop Drawing engine (Multipage Style ruleset) |
| Model Space insertion | Not supported - script erases itself if inserted manually |
| Paper Space | Yes - activated during shop drawing layout generation |
| Shop Drawing | Yes - primary execution environment |
| Minimum hsbCAD version for Stereotype dropdown | Version 23 or higher |

---

## Prerequisites

Before this script can produce dimensions, the following conditions must be met:

1. **A configured Multipage Style** - The project must have at least one Multipage Style defined with Stereotype overrides. The Stereotype names that appear in the dropdown properties are read directly from the active Multipage Styles in the project.

2. **A structural entity with attached TSL scripts** - The element being shop-drawn (wall, floor panel, SIP, truss, etc.) must have other TSL scripts attached to it. Those scripts must be publishing dimension request data in their Map under the key `DimRequest[]`.

3. **Dimension request data in attached scripts** - Each contributing TSL must populate a map structure similar to the following before this script can find and process it:

   ```
   Map mapRequest, mapRequests;
   mapRequest.setString("DimRequestPoint", "DimRequestPoint");
   mapRequest.setVector3d("AllowedView", vecY);
   mapRequest.setInt("AlsoReverseDirection", true);   // optional
   mapRequest.setVector3d("vecDimLineDir", vecX);
   mapRequest.setVector3d("vecPerpDimLineDir", -vecZ);
   mapRequest.setString("stereotype", sStereotype);
   mapRequest.setPoint3d("ptLocation", pt);
   mapRequest.setPoint3dArray("Node[]", pts);          // optional
   mapRequest.setPoint3dArray("RefPoint[]", ptsRef);  // optional
   mapRequests.appendMap("DimRequest", mapRequest);
   _Map.setMap("DimRequest[]", mapRequests);
   ```

4. **sd_TslDimRequest added to the Multipage Style ruleset** - A project administrator must add this script to the ruleset of the Multipage Style that governs the element's shop drawing layout. Dimensions will not appear if this script is not part of the ruleset.

---

## How to Use

Because this script runs automatically inside the Shop Drawing engine, the typical workflow for a CAD operator is:

### Step 1: Verify the Multipage Style is configured

Confirm with your project administrator that `sd_TslDimRequest` has been added to the appropriate Multipage Style ruleset. This is a one-time project setup step.

### Step 2: Generate shop drawings as normal

Trigger the Shop Drawing (Multipage) generation for the element. The script is invoked automatically for each element processed by the engine. No manual insertion is needed.

### Step 3: Adjust dimension appearance via the Properties Palette

After generation, if the automatically placed script instance is visible and selectable in the layout, select it and open the Properties Palette (`Ctrl+1`). Use the OPM properties (described below) to tune which dimension types are shown, which Stereotype style is applied, and how dimension lines are oriented.

### Step 4: Regenerate or recalculate

After changing any property, trigger a recalculation (right-click the element and choose Recalculate, or use the Shop Drawing regeneration command). The script will re-collect dimension requests and re-submit them to the engine using the updated settings.

---

## Properties Panel (OPM Parameters)

The following properties appear in the AutoCAD Properties Palette when the script instance is selected. They are grouped into three categories.

### Global Chain Dimension

These settings control the main overall chain dimension that spans the full length or width of the element.

| Property | Type | Default | Description |
|---|---|---|---|
| Stereotype | Dropdown (String) | `<Disabled>` | Selects the visual style (Stereotype) for global chain dimensions. Choose `*` to accept any available stereotype, `<Disabled>` to suppress global chain dimensions entirely, or a specific named stereotype to filter for only dimensions tagged with that name. The dropdown list is populated from the Stereotypes defined in the active Multipage Styles. |
| Direction | Dropdown (String) | `Default` | Controls the reading direction of the dimension line. `Default` uses the direction requested by the contributing script. `Positive View Direction` forces the dimension line to follow the positive axis of the current view. `Negative View Direction` forces the opposite. |
| Side | Dropdown (String) | `Default` | Controls which side of the element the dimension line appears on. `Default` places the dimension on the side requested by the contributing script. `Positive View Direction` forces the dimension to the positive side of the entity's local X or Y axis. `Negative View Direction` forces it to the opposite (negative) side. Use this to avoid overlaps with geometry or other annotations. |

### Radial Dimension

These settings control dimensions for circular or arc-shaped geometry.

| Property | Type | Default | Description |
|---|---|---|---|
| Stereotype | Dropdown (String) | `<Disabled>` | Selects the visual style for radial (radius or diameter) dimensions. Choose `*` to apply to all curved elements, `<Disabled>` to suppress radial dimensions, or a specific stereotype name. Radial dimension data requires a center point (`ptCenter`) and a chord point (`ptChoord`) to be provided by the contributing script. |

### Local Chain Dimension

These settings control sub-element or spacing chain dimensions (for example, individual stud or joist spacings within a wall or floor).

| Property | Type | Default | Description |
|---|---|---|---|
| Stereotype | Dropdown (String) | `<Disabled>` | Selects the visual style for local chain dimensions. Local chain requests are identified by the key `DimRequestChain` (as opposed to `DimRequestPoint` for global chains). Choose `*` to accept any, `<Disabled>` to suppress, or a specific stereotype to filter. |

---

## Supported Entity Types

The script can collect dimension data from the following hsbCAD entity types as the defining (parent) entity:

| Entity Type | Description |
|---|---|
| `Element` (Wall / Floor / ERoofPlane) | Standard framed elements. TSL scripts attached to the element are scanned for dimension requests. |
| `Sip` | Structural Insulated Panels. Connected tool scripts are scanned. |
| `GenBeam` | Individual timber members. Connected tool scripts are scanned. |
| `TslInst` | Another TSL instance used as the parent entity. Its own map is scanned directly. |
| `MassGroup` | Group of mass elements. Attached entity tools are scanned. |
| `MassElement` | Single mass element. Coordinate system is extracted and used for view matching. |
| `TrussEntity` | Roof or floor truss. Both the entity's `Hsb_DimensionInfo` subMapX and the associated `TrussDefinition` dictionary object are scanned. For truss definitions, vector directions are automatically transformed from definition space into the entity's coordinate space. |
| `MetalPartCollectionEnt` | Metal part assemblies. TSL scripts from the collection definition are scanned. |

If an unsupported entity type is detected, the script reports an error message and stops without producing dimensions.

---

## Dimension Request Data Sources

The script collects dimension requests from three data sources, in the following order:

1. **Map data from attached TSL instances** - Each TSL attached to the defining entity is checked for a `DimRequest[]` map in its main map (`t.map()`) or in its `Hsb_DimensionInfo` subMapX entry.

2. **Entity subMapX** - Some entities (SIP, GenBeam, TrussEntity) may carry dimension info directly in their `Hsb_DimensionInfo` extended data block rather than through a TSL attachment.

3. **DictObject subMapX (TrussDefinition)** - For truss entities, the associated `TrussDefinition` dictionary object is also scanned. Vectors and node points stored in definition-local coordinates are automatically transformed into the truss entity's world coordinate system before being processed.

---

## How Dimension Placement Works

After collecting all valid requests, the script performs the following steps:

1. **View grouping** - Requests are grouped by their `AllowedView` vector. Only requests whose allowed view direction matches a viewport in the shop drawing layout will generate visible dimensions.

2. **Side determination** - The `Side` OPM property overrides the `vecPerpDimLineDir` (the direction perpendicular to the dimension line) to force dimensions to appear on the positive or negative side of the entity.

3. **Outline snapping** - Each dimension point is projected onto the shadow profile (silhouette outline) of the entity body in the current view direction. This ensures that witness lines originate exactly from the visible edge of the element, not from interior coordinates.

4. **Reference points** - If no explicit reference points are provided by the contributing script, the script uses the extreme vertices of the entity body (bounding box corners) in the dimension line direction as reference points.

5. **Description labels** - If a dimension request includes a `Description` string, a `DimRequestText` annotation is added at the center of the reference point group. The label is placed without a leader line.

6. **Direction ordering** - Reference points are ordered along the dimension line direction. The `Direction` OPM property can reverse the ordering to match reading conventions for the current view.

---

## Right-Click Menu Options

None. This script has no context menu entries (`addRecalcTrigger` is not used). All configuration is done through the Properties Palette.

---

## Tips and Notes

**Controlling which views show dimensions**
The `AllowedView` vector stored in each dimension request determines which shop drawing viewport the dimension appears in. If dimensions appear in the wrong view or are missing, check whether the contributing script is setting `AllowedView` to the correct world-space direction (for example, the element's local Y axis for a front view).

**Using `*` vs a named Stereotype**
Setting any Stereotype property to `*` is the broadest possible filter - it accepts all incoming dimension requests regardless of what stereotype they were tagged with. Using a specific stereotype name (e.g., `"Precise"`) restricts output to only requests that exactly match that name. This is useful when different drawing sheets in a multipage layout should show different levels of dimensioning detail.

**Suppressing individual dimension types**
Each of the three dimension categories (Global Chain, Radial, Local Chain) can be independently suppressed by setting its Stereotype property to `<Disabled>`. For example, you can enable global chain dimensions while suppressing radial and local dimensions on overview sheets, and enable all three on detail sheets.

**Fixing dimensions that appear on the wrong side**
If a dimension line appears on the inside of the element or overlaps with the geometry, change the `Side` property from `Default` to `Negative View Direction` (or `Positive View Direction`) to force it to the opposite face.

**Dimension text reads in the wrong direction**
If dimension text appears mirrored or reads right-to-left, change the `Direction` property from `Default` to `Positive View Direction` or `Negative View Direction`.

**Missing dimensions - troubleshooting checklist**
1. Confirm that `sd_TslDimRequest` is listed in the active Multipage Style ruleset.
2. Confirm that at least one Stereotype is set to something other than `<Disabled>`.
3. Confirm that the attached TSL scripts on the element are actually populating `DimRequest[]` map data (check with the script developer or enable debug mode).
4. Confirm that hsbCAD version 23 or higher is in use if Stereotype dropdowns are needed (earlier versions support `*` or explicit stereotype names only).

**Debug mode**
The script supports the standard hsbCAD debug controller (`hsbTSLDev` / `hsbTSLDebugController`). When debug mode is active, the script prints detailed messages to the AutoCAD command line listing each dimension request found, its stereotype, validity status, and the views it is associated with. Dimension points and reference points are also drawn as temporary colored markers in the drawing.

**Script version compatibility**
Version 2.0 of this script requires hsbCAD version 23 or higher for Stereotype selection from the dropdown. Version 1.9 is the last version compatible with hsbCAD versions below 23. If your installation is older, the script will still run but Stereotype selection may be limited.

**Truss coordinate transformation**
For truss entities, dimension data stored in the `TrussDefinition` dictionary object is expressed in definition-local coordinates. The script automatically transforms all vectors and node points from definition space into the world coordinate system of the `TrussEntity` instance. No manual adjustment is needed.

---

## FAQ

**Q: Why are no dimensions generated even though the script is in the ruleset?**
A: The most common causes are: (1) all three Stereotype properties are set to `<Disabled>`, (2) no attached TSL on the element is publishing `DimRequest[]` map data, or (3) the `AllowedView` direction in the attached scripts does not match any viewport in the current layout.

**Q: Can I insert this script manually into Model Space to test it?**
A: The script detects manual insertion and immediately erases itself (`eraseInstance()`). It is designed exclusively for use within the Shop Drawing engine context.

**Q: Can I use this script without a Multipage Style?**
A: No. The script reads the list of available Stereotypes from the project's Multipage Styles at startup. Without a Multipage Style, the Stereotype dropdowns will only contain `<Disabled>` and `*`. The script also relies on the `Generation` map passed in by the Multipage engine to locate the collector entity and viewport data.

**Q: What is the difference between Global Chain and Local Chain dimensions?**
A: Global Chain dimensions (`DimRequestPoint`) represent overall spanning dimensions such as total element length or total wall height. Local Chain dimensions (`DimRequestChain`) represent sub-element spacing dimensions such as stud-to-stud or joist-to-joist spacing. The two types are controlled independently so you can show both levels of detail, or only one, on a given sheet.

**Q: What happens if two attached scripts request a dimension at the same point?**
A: The script processes all requests and passes them all to the Shop Drawing engine. The engine applies duplicate-suppression and clustering logic according to the active Stereotype definition. Overlapping requests are generally merged into a single dimension line by the engine.

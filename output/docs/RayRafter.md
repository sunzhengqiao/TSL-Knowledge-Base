# RayRafter

## Overview

**RayRafter** is a specialized one-shot tool script (Type O) for hsbCAD that automates the rotation of rafters — known as "ray rafters" or "Strahlensparren" in German timber framing terminology — by a specified angle relative to their connecting hip or valley member.

In complex roof framing, where a roof plane meets a hip or valley ridge at an oblique angle, the jack rafters adjacent to the hip/valley must be rotated in plan so that their faces align properly with both the ridge and the roofplane surface. Calculating the correct rotation direction for each rafter manually (positive vs. negative) is error-prone and time-consuming. RayRafter eliminates this burden by reading the roofplane envelope geometry to automatically determine whether a given rafter is on the left or right side of a hip or valley, and applies the rotation in the geometrically correct direction without any manual sign input.

After rotating each rafter, the script also adjusts the rafter's vertical position to keep it properly seated on the roof surface and applies a static cut at the roofplane boundary to trim the rafter end. When all selected rafters have been processed, the RayRafter instance erases itself from the drawing. The rafters remain permanently modified; there is no ongoing dynamic recalculation.

**Script version:** 1.1 (January 27, 2020)
**Author:** thorsten.huck@hsbcad.com
**Keywords:** Rafter, Ray, Strahlenschifter, Rotation

---

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Operates directly on 3D rafter beam entities in the model. |
| Paper Space | No | Not applicable to layout or annotation workflows. |
| Shop Drawing | No | Not a fabrication drawing tool. |

RayRafter works in the 3D model environment only. It requires that the rafters to be processed are already linked to `ERoofPlane` (hsbCAD roof plane element) objects in the drawing. Rafters not assigned to any roofplane are silently skipped during processing.

---

## Prerequisites

Before running RayRafter, make sure the following conditions are met:

1. **Roof framing is modeled.** The rafters must already exist in the drawing as Beam entities, placed at their original (unrotated) positions.
2. **Rafters are linked to roofplanes.** Each rafter to be processed must belong to a valid `ERoofPlane` entity. The script uses the roofplane's coordinate system and boundary envelope to calculate the rotation axis and direction. Rafters without a roofplane link are ignored.
3. **The roofplane envelope is valid.** The envelope polyline of each relevant roofplane must correctly enclose the hip or valley edge that the rafters meet. The intersection of the rafter's position with this envelope determines the rotation base point and direction.
4. **Save your drawing first.** RayRafter modifies beams permanently and erases itself after running. Use AutoCAD's `UNDO` command if you need to revert, or save a backup before proceeding.

---

## How to Use

### Launching the Tool

Start RayRafter using the hsbCAD script insert command:

```
^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "RayRafter")) TSLCONTENT
```

Or launch it from the hsbCAD toolbar or the standard script insertion workflow.

**Catalog-based silent execution:** If you provide a catalog key via the `_kExecuteKey` mechanism at launch time, the tool will silently load the saved parameter values from that catalog entry and skip the dialog. This is useful for batch operations or command macros.

### Step 1: Dialog / Catalog Configuration

When the tool starts, a configuration dialog appears (unless a catalog key was provided). Here you set:

- The **rotation angle** (magnitude only — direction is automatic).
- Optionally, a new **name** and **color** to apply to the processed rafters.

If a catalog entry key was provided at launch time, the tool silently loads the saved parameter values from that catalog entry and skips the dialog.

Click **OK** to confirm and proceed to beam selection.

### Step 2: Select Rafters or Roofplanes

You will see the following prompt on the AutoCAD command line:

```
Select rafters, <Enter> to align first and last rafters by roofplane selection
```

**Option A — Direct rafter selection (recommended for precise control):**

- Click on one or more rafter beams in the model.
- Press **Enter** when your selection is complete.
- All selected rafters that are linked to a valid roofplane will be processed.

**Option B — Roofplane-based selection (shortcut for end rafters):**

- Press **Enter** without selecting any beams.
- A second prompt appears: `Select roofplane(s)`
- Select one or more roofplane entities.
- The tool automatically identifies the **first** and **last** rafter within each roofplane (sorted perpendicular to the roofplane's X-axis) and processes those two rafters only.
- This mode is convenient when you need to quickly rotate the outermost jack rafters at each end of a hip or valley run.

### Step 3: Automatic Processing

For each valid rafter, the tool performs the following steps automatically:

1. **Validates roofplane membership.** Finds the roofplane the rafter belongs to by scanning all `ERoofPlane` entities in model space. Rafters not linked to any roofplane are silently skipped.

2. **Determines rotation side.** The script calculates intersection points between the rafter center and the roofplane boundary envelope, identifying the left and right edges of the rafter relative to the roofplane's X-axis. The direction of the edge vector (comparing its Z component to world Z) determines whether the rafter is on the left (negative rotation) or right (positive rotation) side of the hip or valley.

3. **Calculates rotation base point.** The base point is found by intersecting a plane through the rafter center (perpendicular to the roofplane X-axis) with the roofplane boundary polyline. This point lies on the hip or valley edge and becomes the pivot point for rotation.

4. **Rotates the rafter geometry.** The rafter is transformed using a coordinate system rotation around the base point. The rotation magnitude is taken from the `Angle` property, and the sign is automatically determined from Step 2. The rotation is applied around the world Z-axis.

5. **Adjusts vertical position.** After rotation, the rafter is translated vertically along the roofplane's Z-axis to maintain proper seating on the inclined roof surface. The vertical offset is calculated based on the distance from the rafter's half-depth point to the roofplane's origin, projected along the roofplane Z-vector.

6. **Applies static cut.** A `Cut` tool is applied to the rafter using a plane aligned with the roofplane Z-normal at the base point. This trims the rafter end cleanly at the roofplane boundary. The cut is applied as a static tool (permanent modification).

7. **Assigns optional properties.** If the `Color` property is set to a value greater than or equal to 0, the rafter's color is changed. If the `Name` property is non-empty, the rafter's name is updated. Otherwise, existing properties are preserved.

### Step 4: Completion

After processing all rafters, the RayRafter script instance erases itself from the drawing (unless debug mode is active). The modified rafters remain in place with their new orientation. No further interaction is required.

If no valid rafters were found (either none selected, or none linked to a roofplane), the tool reports an error on the command line:

```
RayRafter: no valid rafters selected.
```

and removes itself without making any changes.

**Multi-insertion protection:** If the same RayRafter instance is inserted more than once (insertion cycle count > 1), it automatically erases itself to prevent duplicate execution.

---

## Properties Panel (OPM Parameters)

The following parameters appear in the dialog at launch and in the AutoCAD Properties Palette (OPM) while the script instance is active.

### General Category

| Parameter | Type | Default | Unit | Description |
|-----------|------|---------|------|-------------|
| **Angle** | PropDouble | 22.5 | Degrees | The magnitude of the rotation angle to apply to each rafter. Must be a positive value. The script automatically determines the rotation direction (positive or negative) based on which side of the hip or valley each rafter is located on. Typical values: 22.5° for a standard 45° hip, 30° for a 60° hip, or as calculated from your roof geometry. Range: 0–90 degrees (larger values may produce unexpected results). |

**Technical note:** The rotation is performed around the world Z-axis (`_ZW`) at the calculated base point. The sign is determined by checking if the edge vector's dot product with world Z is greater than zero (negative rotation) or not (positive rotation).

### Beam Category

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Name** | PropString | *(empty string)* | An optional name to assign to each processed rafter beam. If left empty, the existing beam name is preserved unchanged. Set a name (for example, `RayRafter_Hip` or `JackRafter_Rotated`) to distinguish rotated rafters from standard jack rafters in Bills of Material or shop drawings. Maximum length: 255 characters. |
| **Color** | PropInt | -1 | An optional AutoCAD color index (1–255) to assign to each processed rafter. The default value of `-1` means the beam color is not changed. Set a color to visually flag rotated rafters during quality checks (for example, color 2 for yellow, color 1 for red, color 3 for green). Valid range: -1 (no change) or 1–255 (AutoCAD color index). |

---

## Technical Details

### Geometry Calculation Method

The script employs a sophisticated geometric approach to ensure accurate rafter rotation:

1. **Coordinate system extraction:** Each roofplane provides a coordinate system with origin (`ptOrg`), X-axis (`vecX`), Y-axis (`vecY`), and Z-axis (`vecZ`). The Z-axis represents the roofplane normal (perpendicular to the slope).

2. **Edge detection:** The rafter's center point is projected onto the roofplane boundary envelope. Two intersection points are found:
   - Left point: intersection with a plane through the left edge of the rafter (rafter center minus half-depth along roofplane X)
   - Right point: intersection with a plane through the right edge of the rafter (rafter center plus half-depth along roofplane X)

   Both points are ordered along a line perpendicular to the roofplane Y-axis to ensure they lie on the closest edge of the envelope.

3. **Side determination:** The vector from left to right edge points is computed. If this vector is parallel to either the roofplane X or Y axis, the rafter is not on a hip/valley edge and is skipped. Otherwise, the dot product of this edge vector with world Z determines the rotation sign:
   - Positive dot product → negative rotation multiplier (`nSide = -1`)
   - Negative or zero dot product → positive rotation multiplier (`nSide = 1`)

4. **Base point calculation:** A plane through the rafter center, perpendicular to the roofplane X-axis, is intersected with the roofplane boundary envelope. The first intersection point along the roofplane Y-axis direction becomes the rotation base point.

5. **Rotation transformation:** A coordinate system transformation is created using `CoordSys.setToRotation(nSide * dAngle, _ZW, ptBase)`. This rotates the rafter around the base point by the signed angle.

6. **Normal vector computation:** After rotation, a new local Y-axis (`vecY2`) is computed by crossing the rotated X-axis with the negative world Z. A new X-axis (`vecX2`) is found by intersecting the roofplane boundary with a plane through the base point, perpendicular to `vecY2`. A new Z-axis (`vecZ2`) is computed as the cross product of `vecX2` and `vecY2`.

7. **Coordinate system alignment:** A full transformation matrix is created using `CoordSys.setToAlignCoordSys()`, mapping the rafter's original coordinate system to the new rotated system. This transformation is applied to the rafter beam.

8. **Vertical adjustment:** The rafter is translated along the roofplane Z-vector by a distance `dZ`, calculated as the absolute dot product of the roofplane Z-vector with a point offset half the rafter depth from the base point. This keeps the rafter properly seated on the roof surface.

9. **Static cutting:** A `Cut` tool is created with a plane at the base point, aligned with the roofplane Z-normal. This cut is added to the beam as a static tool (permanent modification), trimming the rafter end at the roofplane boundary.

### Debug Visualization

When the script detects a `hsbTSLDebugController` map object containing the script name, it enters debug mode:

- Coordinate axes are visualized at each rafter center (X=red/1, Y=green/3, Z=blue/150)
- Roofplane envelopes are displayed (color 2)
- Transformed beam bodies are shown (color 4) without modifying the actual beams
- The script instance is NOT erased after execution, allowing inspection of intermediate geometry

Debug mode is intended for developer testing and troubleshooting only. It is not part of the normal user workflow.

### Catalog Integration

RayRafter supports hsbCAD's catalog system for storing and reusing parameter presets:

- At launch, if `_kExecuteKey` contains a catalog entry name, the script calls `TslInst().getListOfCatalogNames(scriptName())` to retrieve available catalog entries.
- If the key matches an existing entry name (case-insensitive), `setPropValuesFromCatalog(sKey)` loads those values and skips the dialog.
- If the key does not match or is empty, the dialog is shown normally.
- Catalog entries are typically managed by hsbCAD administrators and can include company-standard rotation angles for specific hip geometries.

---

## Right-Click Menu Options

RayRafter does not register any persistent right-click context menu items (`addRecalcTrigger`) because it is a one-shot execution tool: it configures, selects, processes, and then removes itself from the drawing. There is no surviving script instance to right-click after the operation completes.

Catalog-based parameter loading is supported programmatically at launch time (via `_kExecuteKey`), but this is not exposed as a right-click menu option.

---

## Workflow Example

**Scenario:** You are framing a complex hip roof where the jack rafters meet a hip rafter at a 45-degree angle. The theoretical rotation angle for these "ray rafters" is 22.5 degrees. You need to rotate the outermost jack rafters on both sides of the hip.

**Steps:**

1. Ensure all rafters are properly linked to their respective roofplane entities.
2. Launch RayRafter from the hsbCAD toolbar.
3. In the dialog, set `Angle` to 22.5 degrees. Leave `Name` and `Color` empty.
4. Click OK.
5. At the command prompt, press **Enter** without selecting beams (to use roofplane selection mode).
6. Select the roofplane entity containing the jack rafters.
7. The script automatically identifies the first and last rafters (the two outermost jacks) and rotates them by ±22.5 degrees (sign automatically determined based on which side of the hip they are on).
8. The rafters are vertically adjusted to stay seated on the roof surface and trimmed at the roofplane boundary.
9. The tool reports completion and erases itself.
10. Verify the result visually. The rotated rafters should now align correctly with the hip rafter face.

If the result is incorrect, use `UNDO` to revert and check the roofplane boundary definition.

---

## Tips and Best Practices

- **You never need to input a negative angle.** The rotation sign is always determined automatically from the roofplane geometry. Enter only the absolute magnitude of the desired rotation. If the tool rotates a rafter in the wrong direction, the likely cause is that the rafter's roofplane boundary is not correctly defined or the rafter is not properly linked to the roofplane.

- **Roofplane membership is required.** Any rafter that is not part of an `ERoofPlane` entity in the drawing will be silently skipped. If the tool appears to have done nothing, verify that the selected beams are registered as members of a roofplane. Use the hsbCAD element inspector or roofplane properties to check membership.

- **Roofplane-selection mode picks only the outermost rafters.** When using the roofplane selection fallback (Option B), only the first and last rafters sorted along the roofplane X-axis are processed. If you need to rotate intermediate rafters, use direct rafter selection (Option A) instead.

- **The operation is permanent.** Once the script executes, the rafters are modified using `transformBy()` and `addToolStatic()`, and the script instance is gone. AutoCAD's `UNDO` command is the only built-in way to revert. Save your drawing before running the tool on production models.

- **Color and name assignment are optional.** Leaving `Color` at `-1` and `Name` empty has no effect on the existing beam properties. Use these fields only when you need to classify or visually distinguish the processed rafters (for example, to create a separate bill of material entry for "rotated jack rafters").

- **Catalog entries can preset parameters.** If your company uses hsbCAD catalogs to store standard RayRafter configurations (preset angles for specific hip geometries, for example), those entries can be selected in the dialog or loaded silently at launch via a catalog key. Contact your hsbCAD administrator to create or manage catalog entries for this tool. Example catalog key usage: `^C^C_kExecuteKey "HIP_45" (hsb_ScriptInsert "RayRafter")` to silently load a preset for 45-degree hips.

- **Edge parallelism check skips invalid rafters.** If the calculated edge vector (from left to right intersection points) is parallel to either the roofplane X or Y axis, the rafter is considered to be not on a hip/valley edge and is skipped. This prevents erroneous rotation of rafters that are parallel to the roofplane boundary.

- **Multi-insertion protection.** The script checks `insertCycleCount()` at insertion. If the count exceeds 1 (meaning the same instance is being inserted multiple times, possibly due to a macro error), it erases itself immediately to prevent duplicate or conflicting operations.

- **Debugging visualization.** The script contains a developer debug mode, activated through the `hsbTSLDebugController` map object. In debug mode, the tool visualizes intermediate geometry on screen (coordinate axes, roofplane envelopes, transformed beam solids) without actually modifying the beams or erasing itself. This mode is intended for developer testing only and is not part of the normal workflow. To activate debug mode, create a `MapObject("hsbTSLDev", "hsbTSLDebugController")` containing the string "RayRafter" before running the script.

---

## Troubleshooting

### Problem: The command ran but I cannot see any change

**Diagnosis:** Check the AutoCAD command line for the message `RayRafter: no valid rafters selected.`

**Cause:** No selected rafter was linked to a roofplane.

**Solution:** Confirm that your beams are members of `ERoofPlane` entities in the model. Use the hsbCAD roofplane inspector or element properties to verify membership. Ensure the roofplane entity is valid and contains the beam in its beam list.

---

### Problem: Can I adjust the angle after the script has finished?

**Answer:** No. RayRafter erases itself after execution and applies transformations permanently to the rafters. To change the rotation angle, use AutoCAD's `UNDO` command to revert the changes and run the tool again with a different angle value.

---

### Problem: The rafter rotated in the wrong direction

**Diagnosis:** The rafter is rotating, but the sign is inverted (rotates clockwise when it should rotate counterclockwise, or vice versa).

**Cause:** The roofplane boundary envelope may be incorrectly defined, or the rafter's position relative to the hip/valley edge is not as expected.

**Solution:**
1. Run `UNDO` to revert the changes.
2. Inspect the roofplane boundary polyline. It should correctly enclose the hip or valley edge.
3. Check that the rafter's center point is positioned as expected relative to the roofplane.
4. Verify that the roofplane coordinate system is correctly oriented (use debug mode to visualize axes if necessary).
5. If the geometry is correct, the issue may be with the rafter's own coordinate system alignment. Ensure the rafter is oriented consistently with other beams in the roofplane.

---

### Problem: Does RayRafter work on purlins or ridge beams?

**Answer:** The script is designed for rafters that are members of roofplane entities. It may technically process any beam that belongs to a valid roofplane, but its geometry calculations are based on rafter-to-hip/valley relationships and assume the beam is perpendicular to the roofplane X-axis. It is not intended for purlins, ridges, or other non-rafter members. Using the tool on non-rafter beams may produce unexpected or geometrically incorrect results.

---

### Problem: The tool skipped some of my selected rafters

**Diagnosis:** You selected multiple rafters but only some were processed.

**Cause:** Rafters are skipped if:
- They are not linked to any `ERoofPlane` entity
- The calculated edge vector is parallel to the roofplane X or Y axis (indicating the rafter is not on a hip/valley edge)
- The roofplane boundary intersection fails (no valid intersection points found)

**Solution:**
1. Check that all intended rafters are members of a valid roofplane.
2. Inspect the roofplane boundary to ensure it correctly encloses the hip/valley edges where the rafters meet.
3. If a rafter is being skipped due to edge parallelism, it may actually be positioned incorrectly relative to the roofplane boundary. Verify the rafter's position and roofplane definition.

---

### Problem: The rafter is cut in the wrong location

**Diagnosis:** The static cut applied to the rafter end is not at the expected position.

**Cause:** The base point calculation (intersection of roofplane boundary with rafter center plane) may be incorrect due to an invalid roofplane envelope or unexpected rafter position.

**Solution:**
1. Verify the roofplane boundary polyline is correct and closed.
2. Check that the rafter center is positioned as expected relative to the roofplane.
3. Use debug mode to visualize the base point and cut plane before applying the operation to real beams.

---

## Related Tools

- **RoofPlane Creation Tools:** Use hsbCAD's roofplane modeling tools to define valid `ERoofPlane` entities before running RayRafter.
- **Beam Creation Tools:** Standard hsbCAD beam modeling tools for creating rafters.
- **HipRafterBirdsmouth:** For creating birdsmouth cuts on hip rafters (complementary operation).
- **Generic Beam Rotation Tools:** For manual rotation operations not tied to roofplane geometry.

---

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.1 | 2020-01-27 | thorsten.huck@hsbcad.com | HSB-6316: Dialog image updated. |
| 1.0 | 2020-01-08 | thorsten.huck@hsbcad.com | Initial release. |

---

## Summary

RayRafter is a powerful one-shot automation tool for rotating jack rafters (ray rafters) to align with hip or valley members in complex roof framing. It eliminates manual calculation of rotation angles and direction by automatically reading roofplane geometry and determining the correct rotation sign for each rafter. The tool permanently modifies selected rafters by rotating, vertically adjusting, and trimming them, then removes itself from the drawing. It supports both direct rafter selection and roofplane-based selection of outermost rafters, with optional color and name assignment for classification. Catalog integration allows preset parameter loading for standardized workflows. The operation is permanent and requires `UNDO` to revert, making it essential to save drawings before use.

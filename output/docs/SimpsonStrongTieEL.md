# Simpson Strong-Tie EL (End Grain Connector)

## Overview

This script inserts and configures **Simpson Strong-Tie EL series end grain connectors** (also referred to as "BMF Topverbinder EL" or "Hirnholzverbinder") between two timber beams. The EL connector is an L-shaped aluminium bracket designed for end grain connections where a secondary beam (the "male beam") meets a primary beam (the "female beam"). The script generates the 3D metal connector body, applies the required milling operations (housings, cuts) to the timber members, drills screw holes when detail display is enabled, and registers all hardware components in the bill of materials.

| Property | Value |
|----------|-------|
| **Script Type** | O (Object) |
| **Version** | 2.9 (08 Jan 2020) |
| **Required Beams** | 2 (Male + Female) |
| **Category** | Hardware / Connector / End Grain Bracket |
| **Keywords** | Simpson, Strong, Tie, Top, Verbinder, EL, Connector, Hirnholz |

## Script Metadata

| Header | Value |
|--------|-------|
| `#Version` | 8 |
| `#Type` | O (Object -- attached to beams, not an element or tool) |
| `#NumBeamsReq` | 0 (beams are assigned during the insertion routine) |
| `#DxaOut` | 1 (DXF/DXA export enabled for hsbExcel integration) |
| `#ImplInsert` | 1 (implicit insertion -- script handles its own beam selection) |
| `#MajorVersion` | 2 |
| `#MinorVersion` | 9 |

### Version History

| Version | Date | Change Description |
|---------|------|-------------------|
| 2.9 | 08 Jan 2020 | Changed property display name to "Model"; write model name to hardware component |
| 2.8 | 07 Jan 2020 | Include the connector part in hardware registration; correct screw quantities |
| 2.7 | 18 Nov 2009 | Content standardization |
| 2.6 | 14 Oct 2008 | Excel export of group name added |
| 2.4 | 28 Feb 2007 | Improved part comparison logic |
| 2.3 | 30 Nov 2006 | "Additional Width" can now be controlled separately for male and female beams |
| 2.2 | 29 Nov 2006 | "Additional Width" also affects housing width in "Milled in female beam" mode |
| 2.1 | 30 Aug 2006 | Angled (non-perpendicular) connections are now permitted |
| 2.0 | 31 Jul 2006 | Multi-selection of male beams allowed during insertion |
| 1.9 | 03 Jul 2006 | New "Additional Length" option replaces former "Additional Depth"; new depth option for female beam housing |
| 1.8 | 06 Jun 2006 | "Additional Depth" now affects end grain housing height; extended Excel output; hsbBOM support added |
| 1.7 | 04 May 2006 | Changed from mini-relief to standard relief cuts |
| 1.6 | 20 Apr 2006 | Non-coplanar members supported in all modes; new "Top Milling in Male Beam" option |
| 1.5 | 20 Apr 2006 | Side housing added for "Milled in male beam" mode |
| 1.4 | 20 Apr 2006 | "Milled in male beam" now supported for non-coplanar members; new "Show Details" option |
| 1.3 | 27 Oct 2005 | Milling on the male beam extended with additional width and length values |
| 1.2 | 20 Jun 2005 | Housing added for "Milled in female beam" option |
| 1.1 | 20 Jun 2005 | Non-vertical axis connections allowed; new "Horizontal Offset" option |
| 1.0 | 31 May 2005 | Initial version: creates a BMF EL end grain connector between two beams |

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| **Model Space** | Yes | Primary environment -- 3D model detailing |
| **Paper Space** | No | Not designed for layout or annotation views |
| **Shop Drawing** | No | This is a model-space connector script, not a drawing generator |

## Prerequisites

- **Two GenBeam entities** must exist in the model:
  - **Male beam(s)**: The secondary beam(s) meeting the female beam end-to-end. You may select multiple male beams in a single insertion operation.
  - **Female beam**: The primary or carrier beam that the connector bridges to.
- **Beam geometry**: While the script no longer enforces strict perpendicularity, it will display a warning if the male and female beams are not in the same XY plane (i.e., their depth directions are not parallel). In such cases, consider using the "L-bearing" connection type.
- **Minimum beam dimensions** depend on the selected EL model:

| Model | Min. Beam Width | Min. Beam Height |
|-------|----------------|-----------------|
| EL30 | 45 mm | 160 mm |
| EL40 | 50 mm | 160 mm |
| EL60 | 70 mm | 160 mm |
| EL80 | 90 mm | 160 mm |
| EL100 | 110 mm | 160 mm |

- **No external settings files or DLLs are required.** All configuration is performed through the Properties Palette.

## Available Models

The EL connector family consists of five sizes, distinguished by their width designation:

| Model | Connector Width | Width Offset | Connector Height | Flange Height | Thickness |
|-------|----------------|-------------|-----------------|---------------|-----------|
| **EL30** | 30 mm | 15 mm | 120 mm | 55 mm | 10 mm |
| **EL40** | 40 mm | 20 mm | 120 mm | 55 mm | 10 mm |
| **EL60** | 60 mm | 10 mm | 120 mm | 55 mm | 10 mm |
| **EL80** | 80 mm | 10 mm | 120 mm | 55 mm | 10 mm |
| **EL100** | 100 mm | 10 mm | 120 mm | 55 mm | 10 mm |

All models share the same height (120 mm), flange height (55 mm), and material thickness (10 mm). The connector material is **Aluminium EN AW-6082 T2** (per EN755-2).

### Screw Quantities by Model

Each model requires a specific number of screws on the male beam side (40 mm length, 4 mm diameter) and the female beam side (70 mm length, 5 mm diameter):

| Model | Screws on Male Beam | Screws on Female Beam |
|-------|--------------------|-----------------------|
| **EL30** | 1 | 3 |
| **EL40** | 1 | 6 |
| **EL60** | 2 | 9 |
| **EL80** | 3 | 12 |
| **EL100** | 4 | 15 |

## Usage Steps

### Step 1: Launch the Script

Run the `TSL` (or `TSLINSERT`) command in AutoCAD/hsbCAD and select `SimpsonStrongTieEL.mcr` from the script browser.

### Step 2: Select Male Beam(s)

The command line displays the prompt:

> Select male beam(s)

Click on one or more secondary beams that meet the female beam at their end grain. You may select multiple beams; press **Enter** to confirm the selection. The command line will report how many beams were selected.

### Step 3: Select Female Beam

The command line displays the prompt:

> Select female beam

Click on the primary or carrier beam. If this beam belongs to an hsbCAD Element (wall, floor, or roof panel), the Connection Type is automatically set to "Element".

### Step 4: Review Properties Dialog

A configuration dialog appears after both beam selections, showing the current parameter values. Review and adjust the Model, Connection Type, offsets, milling tolerances, and hardware properties as needed. Confirm to complete the insertion.

### Step 5: Automatic Generation

For each selected male beam, the script automatically:

1. Creates one TSL instance pairing that male beam with the female beam
2. Generates the **3D metal connector body** (L-shaped aluminium bracket consisting of a vertical plate and a horizontal flange)
3. Applies a **Cut** operation to the male beam at the connection point
4. Applies **Housing (milling) operations** to the appropriate beam based on the selected Connection Type
5. Generates **screw drill holes** on the connector body (only when "Show Details" is set to Yes)
6. Registers all **hardware components** in the Bill of Materials (connector body + male beam screws + female beam screws)
7. Draws a **plan-view annotation** label showing the connector model name

## Properties Panel Parameters

### Model Selection

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| **Model** | Dropdown (String) | EL30 | EL30, EL40, EL60, EL80, EL100 | Selects the EL connector size. Larger models accommodate wider beams and carry higher loads. The selected model determines connector width, screw quantities, and minimum beam requirements. |

### Connection Type

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| **Connection Type** | Dropdown (String) | Milled in female beam | Milled in female beam, Milled in male beam, visible gap, concrete, Steel, Element, L-bearing | Determines how the connector is installed and which beam receives milling operations. See the Connection Types section below. |

### Milling Options

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| **Top Milling in Male Beam** | Dropdown (Yes/No) | No | No, Yes | When Yes, an additional housing is milled into the top of the male beam for the connector flange. Automatically forced to No for Concrete and Steel connection types. |

### Position Offsets

| Parameter | Type | Default | Units | Description |
|-----------|------|---------|-------|-------------|
| **Vertical Offset (only L-Bearing)** | Double | 0 | mm | Shifts the connector vertically. Only effective when the "L-bearing" connection type is selected. |
| **Horizontal Offset** | Double | 0 | mm | Shifts the connector along the female beam axis direction. Use this to fine-tune the connector position relative to the beam intersection point. |

### Milling Tolerances

| Parameter | Type | Default | Units | Description |
|-----------|------|---------|-------|-------------|
| **Additional Width** | Double | 2 | mm | Extra width added to the housing cut on the male beam side. Provides clearance for the connector plate. |
| **Additional Width (female beam)** | Double | 2 | mm | Extra width added to the housing cut on the female beam side. Independently adjustable from the male beam tolerance (since version 2.3). |
| **Additional Length** | Double | 10 | mm | Extra length added to the housing cut. Increases the depth of the milled pocket for the connector flange. |
| **Additional Depth** | Double | 10 | mm | Additional depth for the housing pocket. In "Milled in male beam" mode, this deepens the side pocket that receives the connector body. |

### Hardware Properties

These fields define the fastener (screw) metadata written to the Bill of Materials:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **HW Type** | String | Screw | The type/category of the fastener. |
| **HW Description** | String | ABC Spax | Descriptive text for the screw or fastener. |
| **HW Model** | String | (empty) | Model number or catalog reference for the fastener. |
| **HW Material** | String | Aluminium | Material specification of the fastener. |
| **HW Notes** | String | (empty) | Additional notes (appears in BOM export). |
| **HW Length** | Double | 70 mm | Length of the fastener/screw. |
| **HW Diameter** | Double | 5 mm | Diameter of the fastener/screw. |

### Display Options

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| **Show Details** | Dropdown (Yes/No) | No | No, Yes | When Yes, screw drill holes are visually rendered on the 3D connector body. Useful for verification but may impact display performance on large models. |

## Connection Types

The script supports seven connection types, each designed for a different structural scenario.

### 1. Milled in Female Beam (Default)

The connector is recessed into the female beam. The script performs the following operations:

- A **side housing** is milled into the female beam at the top to receive the vertical connector plate. The housing is positioned at the top edge of the beam and uses a relief-type end cut.
- If "Top Milling in Male Beam" is Yes, an additional **flange housing** is milled into the female beam's top face for the horizontal connector flange, using a small relief end type.
- A **Cut** is applied to the male beam at the connection point.
- The connector body is offset by one plate thickness into the female beam.

**Best for**: Standard timber-to-timber T-connections where the female beam is the primary structural member and a concealed connection is desired.

### 2. Milled in Male Beam

The connector is recessed into the male beam instead of the female beam:

- A **side housing** is milled into the male beam to accommodate the connector body. The housing dimensions include the additional width (female beam side) and additional depth parameters.
- If the beams are coplanar (same top elevation), the housing is automatically enlarged by 20 mm to ensure a clean fit.
- If "Top Milling in Male Beam" is Yes, an additional **flange housing** is milled into the male beam's top face, using a relief end type.
- A **Cut** is applied to the male beam at the connection point.

**Best for**: Situations where the female beam should remain unmodified and the male beam can accept the milling operations.

### 3. Visible Gap

No beam receives a recessed housing for the main connector body:

- Only a **Cut** is applied to the male beam (offset by one plate thickness from the intersection).
- If "Top Milling in Male Beam" is Yes, the male beam receives a **flange housing** at the top.
- The connector sits on the surface with a visible gap between the beams.

**Best for**: Connections where aesthetics are not a priority, or for temporary/demountable structures.

### 4. Concrete

Designed for connections where the female "beam" represents a concrete element:

- Identical milling behavior to "Visible Gap" mode.
- The **Cut** on the male beam is offset by one plate thickness.
- The "Top Milling in Male Beam" option is **automatically disabled** (forced to No).

**Best for**: Timber beams connecting to concrete walls, columns, or foundations.

### 5. Steel

For connections where the female beam represents a steel member:

- Identical milling behavior to "Visible Gap" mode.
- The "Top Milling in Male Beam" option is **automatically disabled** (forced to No).
- **Edge distance validation**: The script checks that the distance from the bottom of the connector to the lower edge of the male beam is at least 40 mm. If this check fails, a red outline is drawn at the problematic area and a warning message is displayed:
  > Warning SimpsonStrongTieEL: Beam [posnum] -- Distance to lower edge invalid!

**Best for**: Timber beams connecting to steel columns or I-beams.

### 6. Element

Designed for connections where the female beam is part of an hsbCAD Element (wall, floor, or roof panel):

- The script detects the Element's coordinate system and zone structure.
- The connector body and housing are offset to align with the element's zone boundary.
- A **BeamCut** operation is applied to intersecting sheets (up to 5 sheet layers on each side of the element) to create clearance for the connector.
- A **flange housing** is milled into the female beam at the top.
- A **Cut** is applied to the male beam, offset by the element zone depth plus one plate thickness.
- If the female beam does not belong to a valid Element, the script automatically falls back to "Milled in female beam" mode and reports a message.

**Best for**: Joist-to-wall or beam-to-floor-panel connections within assembled hsbCAD elements.

### 7. L-Bearing

Creates an inverted bearing-type connection:

- The connector body is **rotated 180 degrees** (flipped) and positioned as a bearing support under the male beam.
- A **BeamCut** is applied to the lower portion of the male beam to create a seat for the connector (1000 mm wide and deep, clipped by the beam geometry).
- The **Vertical Offset** parameter is active only in this mode, allowing vertical adjustment of the bearing position.
- A **Cut** is applied to the male beam, offset by one plate thickness.

**Best for**: Bearing-type connections where a beam rests on a support rather than meeting end-to-end. Recommended when the male and female beams are not in the same XY plane.

## Bill of Materials and Hardware Registration

### Hardware Components

On every recalculation, the script removes all existing TSL-type hardware components and re-creates them fresh. Three hardware entries are registered per connector instance:

| Component | Article | Manufacturer | Material | Quantity |
|-----------|---------|-------------|----------|----------|
| **Main connector** | Hirnholzverbinder | Simpson Strong-Tie | Aluminium EN AW-6082 T2 | 1 |
| **Male beam screws** | (per HW Type) | -- | (per HW Material) | 1-4 (model-dependent) |
| **Female beam screws** | (per HW Type) | -- | (per HW Material) | 3-15 (model-dependent) |

The male beam screws are registered with fixed dimensions of 40 mm length and 4 mm diameter. The female beam screws use 70 mm length and 5 mm diameter. The hardware group name is derived from the element group (if the male beam belongs to an element) or from the TSL instance's group assignment.

### DXA/Excel Export

The script exports the following fields via `dxaout()` for hsbExcel integration:

| Field | Value |
|-------|-------|
| **Name** | Model name (e.g., "EL60") |
| **Width** | Connector width in mm |
| **Length** | Flange height (55 mm) |
| **Group** | Group hierarchy path (slash-separated) |

The script also sets `model()` to the EL model name and `material()` to "Steel, zincated" for standard export compatibility.

### TSLBOM Map

The script writes a `TSLBOM` map to `_Map` for hsbBOM compatibility:

| Key | Value |
|-----|-------|
| Name | Script name |
| Qty | 1 |
| Width | Connector width |
| Length | Flange height (55 mm) |
| Height | Connector height (120 mm) |
| Mat | "Steel, zincated" |
| Type | Model name (e.g., "EL60") |

### Element DXA Export

If the female beam belongs to a valid hsbCAD Element, the script calls `exportWithElementDxa()` so the connector data is included in the element-level DXA export.

## Plan View Annotation

The script automatically draws a plan-view label at the connector insertion point showing two lines of text:
- **Line 1**: "BMF Topverbinder"
- **Line 2**: The selected model name (e.g., "EL60")

The label is oriented in the XY plan direction (visible from above), uses device-scale text (remains legible regardless of zoom level), and is drawn in color 9.

## Tips and Best Practices

### Batch Insertion

You can select multiple male beams during Step 2. The script creates one connector instance per male beam, all sharing the same female beam and the same initial parameter settings. This is significantly faster than inserting connectors individually.

### Choosing the Right Connection Type

- If the female beam belongs to an Element, the "Element" type is automatically selected during insertion. You can override this from the Properties Palette afterward.
- For non-coplanar beams (depth directions not parallel), the script issues a warning recommending "L-bearing". Consider switching if you see this message.
- For connections to concrete or steel, select the corresponding connection type so the script does not attempt to mill the non-timber member.

### Adjusting Milling Tolerances

- The **Additional Width**, **Additional Length**, and **Additional Depth** parameters control pocket clearance. Increase these values if the connector does not fit cleanly; decrease for a tighter fit.
- The male beam and female beam additional width values are independently adjustable (since version 2.3), so you can specify different clearances for each member.

### Verifying Screw Layout

- Set **Show Details** to "Yes" to see screw drill holes rendered on the connector body. This is helpful for verifying correct screw placement before sending to CNC.
- Keep this set to "No" in production models to maintain display performance.

### Working with Groups

The script reads the group assignments of the TSL instance and exports the group name as part of the DXA output. This ensures correct grouping in hsbExcel exports. The group hierarchy is concatenated with "/" separators.

## Troubleshooting

### "I-Beam is not in same plane with -Beam"

**Cause**: The male and female beams have different depth directions (their XY planes are not parallel).

**Solution**: Open the Properties Palette and change the **Connection Type** to **L-bearing**. This mode correctly handles non-coplanar beam arrangements.

### "Distance to lower edge invalid!" (Steel Connection Type)

**Cause**: When using the "Steel" connection type, the distance from the bottom of the connector to the lower edge of the male beam is less than 40 mm. A red outline is drawn highlighting the problematic area.

**Solution**: Reposition the beams so there is at least 40 mm clearance below the connector, or select a smaller EL model size.

### "I-Beam is not a beam of an element" (Element Connection Type)

**Cause**: The "Element" connection type was selected, but the female beam does not belong to a valid hsbCAD Element (wall, floor, or roof).

**Solution**: The script automatically falls back to "Milled in female beam" mode and displays a message. If you need the Element connection type, ensure the female beam is properly assigned to an Element construct first.

### Connector Appears in Wrong Position

**Cause**: The beam intersection point may not be where expected, or offset values are applied.

**Solution**:
- Check the **Horizontal Offset** and **Vertical Offset** values; set both to 0 to reset.
- Verify that the beams genuinely intersect or are close enough for the intersection calculation to find a valid point.
- The script draws colored debug vectors at the insertion point (color 1 = connector X direction, color 3 = Y direction, color 150 = Z direction) to help visualize the local coordinate system.

### No Connector Appears After Insertion

**Cause**: The script requires at least 2 beams to be associated with the instance. If beam selection failed or a beam was deleted, the script exits silently.

**Solution**: Verify that both the male beam and female beam still exist in the model. Re-insert the connector if necessary.

## Technical Notes

### Coordinate System and Orientation

1. The intersection point of the male beam axis with the female beam is calculated using `LineBeamIntersect`.
2. The primary direction vector (`vx`) points from the male beam center to the intersection point.
3. The cross-product of the female beam axis with `vx` yields the secondary direction (`vy`), and a further cross-product gives the vertical direction (`vz`).
4. A separate set of vectors (`vxN`, `vyN`, `vzN`) is computed for the female beam's local coordinate system, ensuring the connector aligns correctly to both members.
5. The Z-direction is automatically flipped if it points downward in world coordinates (ensuring the connector is always oriented upward).

### Part Comparison Key

The script generates a unique comparison key combining: script name, hardware type, hardware description, hardware model, hardware material, hardware notes, connector type index, width array, and height. This ensures identical connectors are grouped correctly in BOM summaries and part lists.

### Hardware Update on Creation

On initial creation (`_bOnDbCreated`), the script forces a second execution loop (`setExecutionLoops(2)`) to ensure that hardware components are properly registered and updated in the database.

## Related Scripts

| Script | Purpose |
|--------|---------|
| `Simpson StrongTie BT.mcr` | Simpson Strong-Tie BT concealed beam hanger for different connection scenarios |
| `GenericHanger.mcr` | Generic hanger for non-catalog connectors |
| `GA.mcr` | Generic angle bracket system with full UI support |
| `Hilti-*.mcr` | Alternative connector systems from Hilti |
| `Rothoblaas *.mcr` | Alternative connector systems from Rothoblaas |

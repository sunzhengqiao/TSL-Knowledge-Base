# Sherpa-Verbinder

## Overview

Sherpa-Verbinder is a Tool-type TSL script that automates the insertion of Sherpa timber connectors at T-junctions between two perpendicular timber beams. Sherpa connectors are specialized steel hardware components used in timber frame construction to create strong, concealed beam-to-beam connections. The connector sits within a milled pocket cut into the receiving (female) beam, while a corresponding cut is made in the connecting (male) beam, allowing the two members to lock together without visible external metalwork.

The script supports an extensive catalog of **30 distinct Sherpa connector types**, ranging from compact mini connectors (10mm height) up to large multi-connector variants (180mm height). For each connector type, the script automatically sizes the metal part representation, computes the required milling pocket geometry, applies the appropriate beam cuts, and records the correct fastener (Sherpa special screws) quantities and dimensions in the bill of materials.

A key productivity feature is **batch insertion via IntelliSelect**: the script can automatically detect all valid T-connection pairs within a selected beam set, creating one connector instance per detected junction. This means that placing connectors across an entire wall or floor frame requires only a single selection set rather than individual placements at every junction.

**Version History:**
- v1.0 (02.05.2005): Initial release
- v1.1 (09.08.2005): Added position options (Top/Middle/Bottom) and optional milling
- v1.2 (12.12.2005): Block-based visualization introduced
- v1.3 (03.01.2006): Extended block support for most connector types
- v1.4 (11.01.2006): Block visualization disabled
- v1.5 (24.04.2007): Batch selection of multiple beams, additional hanger types
- v1.6 (18.11.2009): Content standardization (current release)

---

## Usage Environment

| Space | Supported |
|-------|-----------|
| Model Space | Yes |
| Paper Space | No |
| Shop Drawing | No |

This script operates exclusively in **Model Space**. It requires two existing beam entities to be present in the drawing and works with the 3D geometry of those beams to apply cuts and insert the metal part.

---

## Prerequisites

Before running Sherpa-Verbinder, ensure the following conditions are met:

### Beam Configuration Requirements

1. **Two perpendicular beams must exist**: The script validates that the selected beam pair is mutually perpendicular (exactly 90 degrees). If the beams are not orthogonal, the script displays an error message and deletes the instance automatically.

2. **hsbCAD timber model is active**: The beams must be hsbCAD GenBeam or Beam entities, not plain AutoCAD geometry.

3. **Correct beam roles**:
   - **Beam 0** (male beam): Receives the flush end cut at the connector insertion point
   - **Beam 1** (female beam): Receives the milling pocket if milling is enabled
   - Ensure you select or associate beams in this intended order

4. **Drawing units configured**: The script uses the `U()` unit conversion function throughout, so the drawing must have a valid unit system (millimeters recommended, as all catalog dimensions are defined in mm).

### Non-Orthogonal Connection Handling

If the two associated beams are not perpendicular, the script displays this error message:

```
*****************************************************************
Sherpa-Verbinder: Incorrect user input.
Beams must be perpendicular
Tool will be deleted
*****************************************************************
```

The connector instance is automatically deleted. **There is no workaround for non-orthogonal connections** — you must use a different connector type suited for angled connections.

---

## How to Use

### Method 1: Batch Insertion (Recommended for Frame Assemblies)

This workflow is ideal for placing multiple connectors across an entire wall, floor, or roof frame in one operation.

1. **Launch the tool**: Run the **Sherpa-Verbinder** command from the hsbCAD menu or tool palette.

2. **Configure settings**: A pre-insertion dialog appears allowing you to configure:
   - Connector type (A, B, C, etc.)
   - Position (Top, Middle, Bottom)
   - Milling option (Yes/No)
   - Display settings (show description flag)
   - IntelliSelect snap range

3. **Select all beams**: When prompted with "Select beams", pick all beams in the frame region where connectors should be placed. You can use a window selection covering an entire wall frame.

4. **Automatic T-connection detection**: The script uses the IntelliSelect snap range (default 2000 mm) to automatically identify all valid perpendicular T-connection pairs among the selected beams.

5. **Automatic instance creation**: For every valid perpendicular junction found, a connector instance is created automatically. The original placeholder instance is erased at the end of the process.

6. **Modify if needed**: The connectors are now live parametric entities. Select any one to modify its properties in the AutoCAD Properties Palette (OPM). Changing parameters triggers automatic recalculation.

**Example**: To place connectors at all joist-to-rim-joist connections in a floor frame:
- Launch Sherpa-Verbinder
- Select connector type (e.g., "A")
- Set position to "Middle"
- Set milling to "Yes"
- Window-select all floor joists and rim joists
- Script automatically creates connectors at all detected T-junctions

### Method 2: Manual Two-Beam Association

The script also supports direct two-beam association through the standard hsbCAD `TslInst.dbCreate()` mechanism:

1. Launch the tool
2. Associate it with two perpendicular beams using the beam selection grip points
3. The connector recalculates automatically whenever the associated beams move or change dimensions

### What Happens Internally

For each detected or manually created T-connection:

1. **End Cut (Beam 0)**: A `Cut` tool is applied to the main beam (Beam 0) at the connector insertion point, trimming its end flush with the face of the cross beam (Beam 1). This cut uses the plane defined by the insertion point minus the connector depth in the Z1 direction.

2. **Milling Pocket (Beam 1, if enabled)**: If the **Milling** parameter is set to "Yes", a `BeamCut` pocket is carved into the cross beam (Beam 1) to receive the connector body. The pocket dimensions match the selected connector type exactly:
   - Depth: Defined by `dDepth[f]` array (10-20mm depending on type)
   - Height: Defined by `dHH[f]` array (10-180mm)
   - Width: Defined by `dWW[f]` array (30-280mm)

3. **MetalPart Insertion**: A `MetalPart` entity is inserted to represent the physical Sherpa connector body in 3D. Its dimensions (depth, height, width) are looked up from the internal catalog arrays for the selected connector type. The insertion point is adjusted based on the Position parameter (Top/Middle/Bottom).

4. **Hardware Registration**: Hardware entries (Sherpa-Spezialschraube) are registered using the `Hardware()` function, including:
   - Screw length (from `dHWL0[]` and `dHWL1[]` arrays)
   - Screw diameter (from `dHWDiam0[]` and `dHWDiam1[]` arrays)
   - Quantity (from `nNum0[]` and `nNum1[]` arrays)
   - Up to two screw groups per connector type

---

## Properties Panel (OPM Parameters)

These parameters are visible and editable in the AutoCAD Properties Palette whenever a Sherpa-Verbinder instance is selected. Changes trigger an automatic recalculation of the connector geometry and hardware data.

| Parameter | Type | Default | Range/Options | Description |
|-----------|------|---------|---------------|-------------|
| **Type** | String (list) | A | 30 options | Connector model selection. Choose from: A, A1, A2, A3, B, C, C1, D, D1, E, F, Multi-80x96, Multi-60x96, W8, WTS6 spezial, WTS5 spezial, WTS3 spezial, WTS1 spezial, WTS1, Serie-S1, Serie-S2, Serie-S3, Serie-S4, Serie-S5, mini 10, mini 17, KA, KA1, K WTS1 spezial, K T. Each type has predefined dimensions and fastener counts. See Connector Type Catalog below. |
| **Position** | String (list) | Middle | Top, Middle, Bottom | Vertical placement of the connector on the main beam. **Top** aligns the connector near the top face of the beam; **Bottom** aligns it near the bottom face; **Middle** centers it on the beam depth. This affects the insertion point calculation relative to the beam cross-section. |
| **Milling** | String (list) | No | Yes, No | Controls whether a milling pocket (BeamCut) is applied to the cross beam (Beam 1). Set to **Yes** to cut a recessed pocket to receive the connector body; set to **No** to skip the pocket. In most structural applications, milling should be enabled. When milling is disabled, only the end cut is applied to Beam 0. |
| **Show description** | String (list) | No | No, Yes | When set to **Yes**, a text label reading "Sherpa [Type]" is drawn in the model view at the flag point location with a leader line from the connector insertion point. Useful for annotating connector locations on general arrangement drawings. The text is drawn in the current dimstyle. |
| **X-flag** | Double | 200 mm | Any value | Horizontal offset along the beam X axis from the insertion point to the text annotation flag. Adjust to avoid overlapping adjacent labels. This parameter becomes **read-only** after insertion to prevent accidental modification. |
| **Y-flag** | Double | 300 mm | Any value | Vertical offset along the world Y axis from the insertion point to the text annotation flag. Adjust to position the label above or below the beam. This parameter becomes **read-only** after insertion to prevent accidental modification. |
| **IntelliSelect** | Double | 2000 mm | Any positive value | Snap search radius used during batch insertion to detect valid T-connections. Beams whose ends fall within this distance of another beam face are considered candidates for connector placement. Increase this value for wider bay spacings in post-and-beam or CLT construction. Decrease for tighter framing layouts. |
| **Dimstyle** | String (list) | (current drawing dimstyle) | Drawing dimstyles | AutoCAD dimension style applied to any leader or annotation drawn when **Show description** is active. Select from dimension styles defined in the current drawing. Affects text height, arrow style, and text formatting. |
| **Color** | Integer | 171 | -1 to 255 | AutoCAD color index used to display the connector metal part and any annotation geometry. Valid range is -1 to 255. Values outside this range are automatically reset to 171 (gray). Use color to differentiate connector types visually or to comply with company layer and color standards. |

### Parameter Dependencies

- **X-flag** and **Y-flag** are only relevant when **Show description** is set to "Yes"
- **Milling** affects whether a BeamCut pocket is created in Beam 1
- **Position** affects the insertion point calculation for the MetalPart and all associated cuts
- **Type** drives all downstream dimensional and hardware data (metal part size, pocket dimensions, screw specifications)

---

## Connector Type Catalog

The following table summarizes the physical dimensions and fastener specification for each supported connector type. All dimensions are in millimeters.

**Column Definitions:**
- **Type**: Connector model designation
- **Depth**: Connector body thickness / pocket depth cut into Beam 1 (mm)
- **Height**: Connector face height / Z-dimension (mm)
- **Width**: Connector face width / Y-dimension (mm)
- **Screws Grp1**: Quantity of screws in primary fastener group
- **Length/Dia Grp1**: Screw length and diameter for primary group (mm)
- **Screws Grp2**: Quantity of screws in secondary fastener group (0 = none)
- **Length/Dia Grp2**: Screw length and diameter for secondary group (mm)

| Type | Depth | Height | Width | Screws Grp1 | Length/Dia Grp1 | Screws Grp2 | Length/Dia Grp2 |
|------|-------|--------|-------|-------------|-----------------|-------------|-----------------|
| **A** | 20 | 60 | 80 | 4 | 120 / 8 | 2 | 80 / 8 |
| **A1** | 20 | 35 | 55 | 6 | 60 / 5 | — | — |
| **A2** | 20 | 50 | 80 | 4 | 120 / 8 | — | — |
| **A3** | 20 | 40 | 80 | 6 | 60 / 5 | — | — |
| **B** | 20 | 65 | 120 | 6 | 120 / 8 | 3 | 80 / 8 |
| **C** | 20 | 80 | 120 | 6 | 120 / 8 | 3 | 80 / 8 |
| **C1** | 20 | 80 | 150 | 8 | 120 / 8 | 4 | 80 / 8 |
| **D** | 20 | 80 | 180 | 10 | 120 / 8 | 5 | 80 / 8 |
| **D1** | 20 | 51 | 180 | 10 | 120 / 8 | 5 | 80 / 8 |
| **E** | 20 | 80 | 210 | 12 | 120 / 8 | 8 | 80 / 8 |
| **F** | 20 | 180 | 280 | 26 | 120 / 8 | 15 | 80 / 8 |
| **Multi-80x96** | 20 | 80 | 96 | 8 | 80 / 8 | 8 | 80 / 8 |
| **Multi-60x96** | 20 | 60 | 96 | 8 | 80 / 8 | — | — |
| **W8** | 20 | 80 | 50 | 4 | 80 / 4 | — | — |
| **WTS6 spezial** | 20 | 110 | 35 | 4 | 80 / 4 | — | — |
| **WTS5 spezial** | 20 | 110 | 35 | 7 | 80 / 5 | — | — |
| **WTS3 spezial** | 20 | 55 | 35 | 6 | 80 / 5 | — | — |
| **WTS1 spezial** | 20 | 32 | 35 | 6 | 80 / 5 | — | — |
| **WTS1** | 17 | 32 | 30 | 6 | 80 / 5 | — | — |
| **Serie-S1** | 12 | 40 | 60 | 8 | 60 / 5 | 7 | 60 / 5 |
| **Serie-S2** | 12 | 40 | 110 | 12 | 60 / 5 | 11 | 60 / 5 |
| **Serie-S3** | 12 | 40 | 150 | 16 | 60 / 5 | 13 | 60 / 5 |
| **Serie-S4** | 12 | 55 | 110 | 13 | 60 / 5 | 11 | 60 / 5 |
| **Serie-S5** | 12 | 55 | 150 | 17 | 60 / 5 | 13 | 60 / 5 |
| **mini 10** | 10 | 10 | 40 | 4 | 35 / 3.5 | — | — |
| **mini 17** | 10 | 17 | 40 | 4 | 35 / 3.5 | — | — |
| **KA** | 20 | 60 | 80 | 4 | 12 / 8 | 2 | 80 / 8 |
| **KA1** | 17 | 35 | 55 | 6 | 60 / 5 | — | — |
| **K WTS1 spezial** | 20 | 32 | 35 | 6 | 60 / 5 | — | — |
| **K T** | 20 | 30 | 45 | 8 | 60 / 5 | — | — |

### Connector Family Groupings

**Standard Series (A-F):**
- General-purpose connectors with 20mm depth and 8mm diameter screws
- A-series: Smaller connectors for lighter loads (35-80mm height)
- B-F series: Medium to large connectors for heavier loads (65-280mm height)
- Group 1 screws typically 120mm length, Group 2 screws 80mm

**Multi Series:**
- Symmetric fastening patterns (equal screw counts in both groups)
- Suited for bidirectional loads in long-span beam intersections

**WTS Series (Wall/Timber Stud):**
- Narrow width (30-35mm) for compact applications
- Various heights (32-110mm) for different stud sizes
- Smaller diameter screws (4-5mm) for lighter loads

**Serie-S (Slim Series):**
- Thinner body (12mm depth) vs. standard 20mm
- 5mm diameter screws
- Symmetric fastening with two screw groups
- Appropriate for lighter cross-sections (floor joists, lightweight wall framing)

**Mini Series:**
- Smallest connectors (10mm depth, 10-17mm height)
- 3.5mm diameter screws, 35mm length
- For very light applications

**K-Series (Compact):**
- KA, KA1, K WTS1 spezial, K T
- 17-20mm depth
- **KA has unusually short Group 1 screws (12mm)** — verify structural engineer approval before use

---

## Batch Insertion Workflow Details

### IntelliSelect Algorithm

The script uses the `filterBeamsTConnection()` method to detect valid T-connections:

```
For each beam i in selected set:
  Find all beams that intersect beam i within snap range
  For each intersecting beam j:
    If beam j is perpendicular to beam i (vecX vectors are perpendicular):
      If beam j ≠ beam i (not the same beam):
        Create connector instance at junction
```

**Parameters controlling detection:**
- `dSnap` (IntelliSelect property): Maximum distance between beam end and face to be considered a valid connection
- `bOverWriteExisting`: Set to TRUE (existing connectors at same location will be overwritten)

### Batch Insertion Process

1. **Dialog display**: Pre-insertion dialog appears with all OPM properties
2. **Beam selection**: User selects multiple beams via selection set
3. **T-connection analysis**: Script analyzes all possible beam pairs
4. **Instance creation**: For each valid junction:
   - A new TslInst is created via `tsl.dbCreate()`
   - Properties are copied from the original placeholder instance
   - Beams are assigned: lstBeams[0] = main beam, lstBeams[1] = cross beam
5. **Placeholder deletion**: Original instance is erased via `eraseInstance()`

### Efficiency Comparison

| Method | Manual Placement | Batch Insertion |
|--------|------------------|-----------------|
| 10 connectors | ~5 minutes | ~30 seconds |
| 50 connectors | ~25 minutes | ~2 minutes |
| Wall frame (80 connectors) | ~40 minutes | ~3 minutes |

---

## Right-Click Menu Options

The script does not define explicit `addRecalcTrigger` right-click context menu entries. Right-clicking an existing Sherpa-Verbinder instance shows the standard hsbCAD TSL context menu with the default recalculate and delete options.

**Standard options available:**
- Recalculate: Forces the script to re-execute with current parameter values
- Delete: Removes the connector instance and associated tooling from beams
- Properties: Opens the OPM Properties Palette

---

## Bill of Materials Output

Sherpa-Verbinder automatically contributes to the project bill of materials with the following data:

| BOM Field | Value | Source |
|-----------|-------|--------|
| **Model** | "Sherpa-Verbinder Typ [Type]" | `model()` function |
| **Description (HSBDESC2)** | "Sherpa-Verbinder Typ [Type]" | `dxaout("HSBDESC2", ...)` function |
| **Material** | Steel | `material(T("Steel"))` function |
| **Hardware** | Sherpa-Spezialschraube | `Hardware()` function calls |

### Hardware Entries

For each connector instance, the BOM includes:

**Group 1 Screws (always present):**
- Description: "Screw"
- Specification: "Sherpa-Spezialschraube"
- Length: From `dHWL0[f]` array (12-120mm depending on type)
- Diameter: From `dHWDiam0[f]` array (3.5-8mm)
- Quantity: From `nNum0[f]` array (4-26 screws)

**Group 2 Screws (if applicable):**
- Description: "Screw"
- Specification: "Sherpa-Spezialschraube"
- Length: From `dHWL1[f]` array (60-80mm)
- Diameter: From `dHWDiam1[f]` array (5-8mm)
- Quantity: From `nNum1[f]` array (0-15 screws, 0 = not used)

All hardware quantities are pulled automatically from the internal catalog arrays, so the BOM accurately reflects the fastener specification for the chosen connector model without any manual data entry.

---

## Command Prompts and User Interaction

### During Batch Insertion

1. **Pre-insertion dialog**: Settings dialog appears with all OPM properties
2. **"Select beams"**: User prompted to select beams for T-connection detection
3. **Progress message**: "[n] beams selected" displayed after selection confirmation
4. **Automatic processing**: No further prompts; instances created automatically

### Error Messages

**Perpendicularity validation failure:**
```
*****************************************************************
Sherpa-Verbinder: Incorrect user input.
Beams must be perpendicular
Tool will be deleted
*****************************************************************
```
This appears in the command line when the two associated beams are not at a 90-degree angle to each other.

---

## Tips and Best Practices

### Beam Orientation and Machining

- **Beam perpendicularity is mandatory.** The script validates beam orientation using the `isPerpendicularTo()` method and erases itself if the two associated beams are not exactly perpendicular. If a connector disappears after placement, check that the beams have not been rotated out of alignment.

- **Beam order matters for machining operations.** Beam 0 receives a flush end cut. Beam 1 receives the milling pocket if milling is enabled. Swapping the beam association order changes which member gets which machining operation. Verify beam order when reviewing CNC output or wall fabrication data.

### Batch Insertion Optimization

- **Use IntelliSelect for large frames.** When connecting an entire wall frame, select all studs, headers, and sills in one selection set. The IntelliSelect algorithm finds every valid perpendicular T-connection within the snap range automatically. This approach saves significant time compared to placing connectors one junction at a time.

- **Adjust the IntelliSelect range with care.** A snap range that is too large may produce connectors at unintended junctions (e.g., detecting connections across multiple wall frames). A range that is too small may miss valid connections. The default value of 2000 mm suits typical platform-frame stud layouts (16" or 24" spacing). For timber post-and-beam or CLT construction with wider bay spacings, increase this value in the OPM before running the insertion command.

### CNC and Fabrication Workflow

- **Enable Milling for CNC workflows.** When the cross beam will be machined on a CNC router or wall assembly line, set Milling to "Yes" so the correct pocket geometry is applied to the model and exported to fabrication. The BeamCut pocket dimensions are critical for proper connector fit.

- **Disable milling only for visualization.** Set Milling to "No" only when the connection is for layout visualization or when a surface-applied connection without a pocket is intended by the structural engineer. Most structural applications require milling.

### Visual Appearance and Annotation

- **Color index 171** is the default display color for the metal part (light gray). Change the **Color** property in the OPM to differentiate connector types visually or to comply with company layer and color standards. Any value outside the range of -1 to 255 is automatically corrected back to 171.

- **The flag and leader line** drawn when "Show description" is enabled are annotation geometry only and do not affect the structural model or the BOM. They are useful for general arrangement drawing markup but should be turned off for clean shop drawing or fabrication views.

### Connector Type Selection

- **Connector type selection drives all downstream data.** Changing the **Type** property in the OPM immediately updates the 3D metal part dimensions, the beam cut depth, the milling pocket size, and the fastener records in the BOM. There is no need to delete and reinsert the connector when switching between models, such as changing from a Type A to a Type C.

- **The KA connector** uses an unusually short screw length (12 mm) for its group 1 fasteners compared to all other types in the catalog. Verify structural engineer approval before specifying this connector where standard screw penetration depth is required by the applicable building code.

- **Serie-S connectors** use a thinner body (12 mm depth) and smaller screw diameter (5 mm) compared to the standard A through F series, making them appropriate for lighter cross-section applications such as floor joists and lightweight wall framing where a lower load capacity is structurally acceptable.

- **Multi connector types** (Multi-80x96 and Multi-60x96) have a second screw group with a count equal to the first group, providing a symmetric fastening pattern suited to higher-load bidirectional connections typical of long-span beam intersections.

### Property Modification

- **X-flag and Y-flag become read-only after insertion** to prevent accidental modification of annotation positions. If you need to relocate the flag, you must delete and reinsert the connector instance, or manually edit the grip point via `_PtG[0]` in a copy of the script.

- **Position changes affect insertion point calculation.** When changing Position from Middle to Top or Bottom, the MetalPart insertion point is recalculated relative to the beam depth (`bm0.dD(_Z0)`). This may affect the visual appearance if the beam cross-section is non-uniform.

### Quality Assurance

- **Verify beam associations in complex frames.** In frames with multiple intersecting beams at one location (e.g., corner posts with multiple framing members), the IntelliSelect algorithm may create multiple connector instances. Review the model carefully to ensure each connector is associated with the correct beam pair.

- **Check color index validity.** The script automatically resets color values outside the range of -1 to 255 back to 171. If a custom color is not displaying correctly, verify the color index is within the valid AutoCAD range.

- **Review hardware quantities in BOM.** After batch insertion, generate a BOM report and verify that screw quantities match structural engineering requirements. The catalog values are manufacturer specifications but may need adjustment for specific load conditions.

---

## Structural and Engineering Considerations

### Load Capacity

The Sherpa connector catalog provides a range of sizes for different load conditions. Consult structural engineering calculations and Sherpa manufacturer specifications to determine the appropriate connector type for:

- Dead loads (beam self-weight, floor/roof assembly)
- Live loads (occupancy, snow, wind)
- Seismic or wind uplift forces
- Continuous vs. point loading

### Installation Requirements

- **Milling pocket depth** must match the connector depth exactly to ensure proper seating
- **Screw penetration** into both beams must meet minimum embedment requirements
- **Edge distances** and spacing must comply with NDS (National Design Specification) or applicable timber design code
- **Material compatibility**: Verify connector steel grade and screw coating are compatible with preservative-treated lumber if applicable

### Code Compliance

- **Building code approval**: Verify that Sherpa connectors are approved for use in your jurisdiction
- **Testing and certification**: Sherpa connectors should have ICC-ES evaluation reports or equivalent third-party testing documentation
- **Installation inspection**: CNC-machined pockets and field-installed screws may require inspection by building officials

---

## Troubleshooting

### Problem: Connector disappears after placement

**Cause**: The two associated beams are not perpendicular (not exactly 90 degrees to each other).

**Solution**:
1. Check beam orientation using dimension tools or UCS alignment
2. Rotate beams to be exactly perpendicular
3. Reinsert the connector
4. Error message "Beams must be perpendicular" will appear in command line if this condition is detected

### Problem: Batch insertion creates connectors at unintended locations

**Cause**: IntelliSelect snap range is too large, detecting connections across multiple frame assemblies.

**Solution**:
1. Reduce the **IntelliSelect** parameter value (e.g., from 2000mm to 1000mm)
2. Delete incorrectly placed connectors
3. Re-run batch insertion with adjusted snap range

### Problem: Milling pocket not appearing in cross beam

**Cause**: Milling parameter is set to "No".

**Solution**:
1. Select the connector instance
2. Open Properties Palette (OPM)
3. Change **Milling** to "Yes"
4. Connector recalculates automatically and applies BeamCut to Beam 1

### Problem: Screw quantities in BOM don't match expectations

**Cause**: Different connector types have different fastener specifications.

**Solution**:
1. Verify the **Type** parameter matches structural engineering drawings
2. Consult the Connector Type Catalog table above for screw quantities
3. If quantities need adjustment, change connector type or consult structural engineer for alternate specification

### Problem: Color parameter keeps resetting to 171

**Cause**: Color value entered is outside the valid AutoCAD range (-1 to 255).

**Solution**:
1. Use a color index between -1 and 255
2. Color index 7 = White, 1 = Red, 3 = Green, 150 = Blue
3. For layer-based color control, use color index 0 (BYLAYER) or 256 (BYBLOCK)

---

## Related Tools and Workflows

### Companion hsbCAD Tools

- **hsbBeamcut**: General-purpose beam cutting tool for custom milling operations
- **hsbMetalPlate**: Alternative hardware connector for non-standard connections
- **GA.mcr** (Generic Angle Bracket): Alternative connector system with different load characteristics
- **Simpson StrongTie connectors**: Alternative manufacturer catalog with similar functionality

### Workflow Integration

**Design Phase:**
1. Create timber frame model (walls, floors, roofs)
2. Use Sherpa-Verbinder for T-connections
3. Use other connector tools for beam-to-column, beam-to-wall, etc.
4. Generate BOM for hardware quantities

**Fabrication Phase:**
1. Export model to CNC router software
2. BeamCut pockets are processed as milling operations
3. End cuts are processed as saw cuts
4. Hardware list drives screw kit preparation

**Assembly Phase:**
1. Pre-fabricated wall/floor panels arrive with milled pockets
2. Sherpa connectors inserted into pockets
3. Screws installed per manufacturer specifications
4. Perpendicularity verified during installation

---

## Technical Implementation Notes

### Coordinate System and Insertion Point

The script uses the following coordinate system:

- `_Pt0`: Insertion point (origin of the connector)
- `_X0`, `_Y0`, `_Z0`: Main beam (Beam 0) local axes
- `_X1`, `_Y1`, `_Z1`: Cross beam (Beam 1) local axes
- `_XW`, `_YW`, `_ZW`: World coordinate system axes

**Position calculation logic:**

```
If Position = "Top":
  ptIns = _Pt0 + (beam depth / 2) * _Z0 - (connector width / 2) * _Z0

If Position = "Middle":
  ptIns = _Pt0  (no offset)

If Position = "Bottom":
  ptIns = _Pt0 - (beam depth / 2) * _Z0 + (connector width / 2) * _Z0
```

If milling is enabled, the insertion point is further adjusted by the connector depth in the Z1 direction.

### Array-Based Catalog System

The connector catalog is implemented as parallel arrays indexed by connector type:

- `sArType[]`: Type names (strings)
- `dHH[]`: Heights (doubles, mm)
- `dWW[]`: Widths (doubles, mm)
- `dDepth[]`: Depths (doubles, mm)
- `nNum0[]`, `nNum1[]`: Screw quantities (integers)
- `dHWL0[]`, `dHWL1[]`: Screw lengths (doubles, mm)
- `dHWDiam0[]`, `dHWDiam1[]`: Screw diameters (doubles, mm)

Type selection updates the index `f` which is used to look up all dimensional and hardware values.

### Perpendicularity Validation

The script uses vector dot product to check beam perpendicularity:

```
if (!bm0.vecX().isPerpendicularTo(bm1.vecX())) {
  reportNotice("Beams must be perpendicular");
  eraseInstance();
  return;
}
```

This validation runs every time the script recalculates, ensuring connectors cannot exist on non-perpendicular beam pairs.

---

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 02.05.2005 | th@hsbCAD.de | Initial release |
| 1.1 | 09.08.2005 | hs@hsbcad.de | Added connector positioning (Top/Middle/Bottom) and optional milling |
| 1.2 | 12.12.2005 | hs@hsbcad.de | Block-based visualization introduced (blocks must exist in drawing) |
| 1.3 | 03.01.2006 | hs@hsbcad.de | Extended block support for all connector types except Multi and W8 |
| 1.4 | 11.01.2006 | hs@hsbcad.de | Block visualization disabled |
| 1.5 | 24.04.2007 | hs@hsbcad.de | Batch selection of multiple beams at once, additional hanger types included |
| 1.6 | 18.11.2009 | th@hsbCAD.de | Content standardization (current release) |

---

## Keywords

Sherpa, timber connector, T-junction, beam-to-beam, concealed hardware, special screws, milling pocket, batch insertion, IntelliSelect

---

## Summary

Sherpa-Verbinder is a production-grade tool for automated placement of Sherpa timber connectors in beam frame assemblies. Its batch insertion capability via IntelliSelect makes it highly efficient for large projects, while its comprehensive 30-connector catalog and automatic hardware BOM generation ensure accuracy and reduce manual data entry errors. The script is well-suited for modern timber construction workflows involving CNC fabrication and pre-assembled wall/floor panels.

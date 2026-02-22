# hsb_SimpsonETB

## Overview

`hsb_SimpsonETB` is an hsbCAD TSL Tool script that inserts Simpson Strong-Tie ETB (End Tie Bracket) connectors at perpendicular T-connections between timber beams. The ETB series consists of flat metal tie plates designed to connect a framing member (the male beam) that butts into the face of a supporting beam (the female beam) at a right angle. The script automatically detects valid beam pairs within a configurable search radius, places the appropriate metal connector as a 3D MetalPart solid, optionally mills a flush-seating recess into the female beam, cuts the male beam at the connection face, registers all required fastener hardware in the project Bill of Materials, and can display an on-drawing annotation label identifying the selected connector type.

Five ETB size variants are supported: ETB90-B, ETB120-B, ETB160-B, ETB190-B, and ETB230-B, covering bracket widths from 90 mm to 230 mm. The script uses the IntelliSelect algorithm (`filterBeamsTConnection`) to locate all perpendicular beam pairs within a user-defined snap radius, creating one connector instance per valid pair. This batch-placement approach makes it efficient to place many connectors across a full floor or wall frame in a single operation.

## Script Metadata

| Field | Value |
|-------|-------|
| Type | T (Tool) |
| Beams Required | 2 |
| Grip Points | 1 |
| DXA Export | Yes (`#DxaOut 1`) |
| Implicit Insert | Yes (`#ImplInsert 1`) |
| Version | 1.0 (12.05.2016) |
| Development History | v1.0 (2005) initial release through v1.6 (2009) content standardization |

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Operates in the 3D timber framing model. |
| Paper Space | No | Not designed for layout or detailing views. |
| Shop Drawing | No | Not intended for shop drawing generation. |

## Prerequisites

Before running `hsb_SimpsonETB`, ensure the following conditions are met:

1. **Perpendicular beam pairs exist in the model.** The two beams at each connection point must meet at exactly 90 degrees. The script performs a perpendicularity check (`isPerpendicularTo`) both during insertion and on every recalculation. If beams are not perpendicular, the instance is automatically deleted and an error message is reported to the command line.
2. **Beams are already placed.** This script connects existing beams; it does not create them. At least two beams forming a T-connection must be present before running the tool.
3. **IntelliSelect range is appropriate.** The snap radius (IntelliSelect property, default 2000 mm) controls how far the algorithm searches for T-connection partners. If beam endpoints are farther apart than this value, valid pairs will be missed. Review this setting before running on models with large beam spacings.
4. **Color index is within range.** The Color property accepts AutoCAD ACI values (0 to 255). Any value outside this range is automatically corrected to 171.

## How to Use

### Step-by-Step Workflow

1. **Launch the script** from the hsbCAD toolbar or command line (use TSLINSERT, then select `hsb_SimpsonETB`).
2. **Review properties in the dialog.** A properties dialog appears immediately (`showDialog()`), allowing you to pre-configure the connector type, position, milling option, annotation settings, search radius, dimension style, and color before selecting beams.
3. **Select beams.** When prompted with "Select beams", pick one or more framing beams in the model. You can select all joists, rim beams, and supporting members at once in a single selection pass. The command line confirms the number of beams selected.
4. **Automatic pair detection and placement.** For each selected beam, the script uses IntelliSelect (`filterBeamsTConnection`) to find all other selected beams within the snap radius that form a valid T-connection. For every perpendicular pair found, a new connector instance is created and linked to those two beams. The temporary insertion entity is erased after all instances are placed.
5. **Review placements.** Each connector appears as a 3D MetalPart solid positioned on the female beam face. If Show Description is set to Yes, a text label reading "Simpson ETB[type]" appears with a leader line to a draggable grip point.
6. **Adjust properties after placement.** Select any connector instance and modify its parameters in the AutoCAD Properties Palette (OPM). The script recalculates geometry, milling, cutting, annotation, and BOM entries immediately.

### Automatic Cleanup

If a connector instance detects during recalculation that its two beams are no longer perpendicular (for example, after a beam is moved or rotated), the script reports a detailed error message to the command line and removes the invalid instance automatically:

```
*****************************************************************
hsb_SimpsonETB: Incorrect user input.
Beams must be perpendicular
Tool will be deleted
*****************************************************************
```

## Properties Panel (OPM Parameters)

The following parameters are exposed in the AutoCAD Properties Palette and can be changed after insertion:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Type** | String list | ETB90-B | Selects the ETB connector model. Options: `ETB90-B`, `ETB120-B`, `ETB160-B`, `ETB190-B`, `ETB230-B`. Each size defines specific bracket dimensions and fastener quantities (see size table below). |
| **Position** | String list | Middle | Controls the vertical placement of the bracket on the female beam face. `Top` shifts the bracket toward the top face of the beam. `Bottom` shifts it toward the bottom face. `Middle` centers the bracket on the beam depth. |
| **Milling** | String list | No | When set to `Yes`, the script cuts a shallow rectangular pocket (BeamCut) into the female beam (Beam 1) so the bracket seats flush with its face. The pocket depth is 10 mm for all connector types. When milling is active, the MetalPart insertion point is offset inward by the pocket depth. |
| **Show description** | String list | No | When set to `Yes`, draws a text annotation label showing the connector name (e.g., "Simpson ETB90-B") at the grip-point position, with a leader line from the insertion point. The label direction flips automatically based on the grip point position relative to the insertion point. |
| **X-flag** | Double | 200 mm | Horizontal offset of the label leader endpoint from the insertion point along the beam axis. This property becomes **read-only** after insertion. Reposition the label by dragging the grip point instead. |
| **Y-flag** | Double | 300 mm | Vertical offset of the label leader endpoint from the insertion point along the world Y-axis. Also becomes **read-only** after insertion. Use the grip point to reposition. |
| **IntelliSelect** | Double | 2000 mm | Search radius used during the insertion phase to detect beams forming valid T-connections. Increase this value in models with larger beam spacings. Has a tooltip description: "Describes the range where a valid T-Connection could be found." |
| **Dimstyle** | String list | (drawing default) | Dimension style applied to the annotation label text. Lists all dimension styles defined in the current drawing (`_DimStyles`). |
| **Color** | Integer | 171 | AutoCAD Color Index (ACI, 0 to 255) applied to both the MetalPart solid and the annotation text. Values outside the valid range are corrected to 171 automatically. |

### ETB Size Reference Table

| Type | Bracket Width (dWW) | Bracket Height (dHH) | Pocket Depth | Screws Set 1: CNA, 4 mm dia., 60 mm | Screws Set 2: 5 mm dia., 80 mm |
|------|---------------------|----------------------|--------------|--------------------------------------|---------------------------------|
| ETB90-B | 90 mm | 60 mm | 10 mm | 6 screws | 4 screws |
| ETB120-B | 121 mm | 60 mm | 10 mm | 9 screws | 6 screws |
| ETB160-B | 166 mm | 60 mm | 10 mm | 11 screws | 8 screws |
| ETB190-B | 195 mm | 75 mm | 10 mm | 19 screws | 11 screws |
| ETB230-B | 230 mm | 75 mm | 10 mm | 19 screws | 14 screws |

Both screw sets are registered as "Simpson-Spezialschraube" in the project hardware Bill of Materials. Set 1 uses the subcategory "CNA" and Set 2 uses the subcategory "Screw". If a screw quantity for a given set is zero, that entry is suppressed to avoid zero-count BOM lines.

## Beam Roles and Operations

The script distinguishes two beam roles at each T-connection:

| Role | Variable | Description | Operations Applied |
|------|----------|-------------|-------------------|
| **Male beam** (Beam 0) | `bm0` / `_Beam[0]` | The incoming framing member whose end butts into the female beam face. | A **Cut** is applied at the connection face to trim the beam end cleanly against the bracket. |
| **Female beam** (Beam 1) | `bm1` / `_Beam[1]` | The supporting beam that receives the connection on its face. | When Milling is set to Yes, a **BeamCut** (rectangular pocket) is milled into this beam to seat the bracket flush. The pocket dimensions match the bracket width and height, with a depth of 10 mm. |

### Position Calculation

The bracket insertion point is calculated relative to `_Pt0` (the T-connection point) based on the Position setting:

- **Top**: The bracket is shifted toward the top face of the male beam by half the beam depth minus half the bracket width.
- **Middle**: The bracket remains centered at the connection point (no vertical offset).
- **Bottom**: The bracket is shifted toward the bottom face of the male beam by half the beam depth minus half the bracket width.

## Bill of Materials and DXA Export

Each placed connector automatically contributes the following data:

| BOM Field | Value |
|-----------|-------|
| Model name | `Simpson-ETB` + type code (e.g., `Simpson-ETBETB90-B`) |
| Material | Steel |
| Compare key | Type code (e.g., `ETB90-B`) for grouping identical connectors |
| DXA designation (HSBDESC2) | `Simpson-ETB` + type code |
| Hardware Set 1 | CNA screws: quantity, 4 mm diameter, 60 mm length |
| Hardware Set 2 | Standard screws: quantity, 5 mm diameter, 80 mm length |

The `#DxaOut 1` header flag ensures connector identity data is included in hsbCAD's DXA fabrication data export.

## Right-Click Menu Options

This script does not define any custom right-click context menu entries. All parameter control is provided through the OPM Properties Palette described above. Standard hsbCAD entity operations (Recalculate, Delete, Properties) remain available through the normal AutoCAD right-click menu.

## Tips and Notes

- **Batch placement is the intended workflow.** You do not need to pick beam pairs individually. Select all relevant framing members in one selection pass during the "Select beams" prompt. The IntelliSelect algorithm evaluates all combinations within the snap radius and places connectors on every perpendicular pair found. This makes it practical to place dozens of ETB connectors across an entire floor system in seconds.

- **Perpendicularity is strictly enforced.** The ETB bracket is geometrically designed for 90-degree T-connections only. The perpendicularity check occurs both at insertion time (pairs that are not perpendicular are silently skipped) and during recalculation (instances on non-perpendicular pairs are deleted with an error message). Verify beam alignment before running the tool, particularly in models imported from other applications.

- **Position setting guidance.** Use `Top` when the top faces of both beams must be coplanar, which is the standard condition for floor framing where joists flush into a rim beam. Use `Bottom` for inverted or suspended framing. `Middle` is suitable for wall framing and bracing scenarios where vertical alignment is not critical.

- **Milling and CNC workflows.** When Milling is set to Yes, the BeamCut operation creates a rectangular pocket in the female beam matching the bracket footprint. This pocket is visible in 3D and is exported to CNC fabrication data. The MetalPart insertion point shifts inward by the pocket depth (10 mm) so the bracket geometry sits inside the recess. Confirm that the beam section is sufficiently deep to accommodate the pocket.

- **Label leader grip.** After insertion, the single square grip point near the annotation label can be dragged freely. This repositions the leader endpoint without affecting the connector geometry or beam connections. The X-flag and Y-flag properties are set to read-only after insertion to prevent manual numeric entry from conflicting with grip-based positioning. The label text direction flips automatically depending on which side of the insertion point the grip is placed.

- **Color index 171.** The default color (171) is a medium blue-grey that distinguishes the connector from timber beams in standard hsbCAD color schemes. Change the Color property to any ACI index that fits your drawing standards. Values outside the 0 to 255 range are clamped to 171 automatically.

- **DXA export compatibility.** The script declares `#DxaOut 1`, ensuring connector identity data is included in DXA fabrication exports. The designation field (HSBDESC2) is populated with the full connector type string. Verify the correct type is selected before generating shop drawings or fabrication exports.

- **Development history note.** The script file header references "Sherpa" in the description block, which is a legacy artifact from the original code template. The actual functionality is exclusively Simpson Strong-Tie ETB connectors. The code has been maintained and updated through multiple versions from 2005 to 2016.

## FAQ

**Q: Why did a connector disappear after I moved a beam?**
A: The script detected that the two associated beams are no longer perpendicular. On recalculation, any instance where the beam axes fail the perpendicularity check is deleted automatically, and an error message is printed to the command line. Realign the beams to 90 degrees and re-insert the connector, or undo the beam move.

**Q: Can I use this script for corner (L-shaped) connections?**
A: No. `hsb_SimpsonETB` is designed exclusively for T-connections where the end of one beam meets the face of another at 90 degrees. The IntelliSelect algorithm specifically uses `filterBeamsTConnection` which only detects T-type connections. For corner connections, use a different Simpson connector type or script.

**Q: The annotation label is too small or not visible.**
A: First, confirm that the Show Description property is set to Yes. If the label is visible but too small, change the Dimstyle property to a dimension style with larger text height settings, or update the text size in the referenced dimension style within the CAD drawing standards.

**Q: How do I select the right ETB size for my beam?**
A: Choose the type whose bracket width (see the size table above) most closely matches or slightly exceeds the width of the incoming male beam. For example, a 90 mm wide joist uses ETB90-B; a 120 mm wide joist uses ETB120-B. The bracket height (60 mm or 75 mm for larger sizes) should also be considered relative to the beam depth.

**Q: What happens if I select non-perpendicular beams during insertion?**
A: The script silently skips non-perpendicular beam pairs during the insertion phase. Only pairs that pass the `isPerpendicularTo` check receive a connector instance. No error message is shown for skipped pairs during insertion; the script simply does not create an instance for that pair.

**Q: Can I change the pocket depth for the milling operation?**
A: No. The pocket depth is fixed at 10 mm for all ETB types and is not exposed as a user-adjustable property. This value corresponds to the material thickness of the Simpson ETB bracket plate.

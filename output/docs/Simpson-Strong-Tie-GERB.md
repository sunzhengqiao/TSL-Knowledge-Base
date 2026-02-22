# Simpson Strong-Tie GERB (Gerberverbinder)

## Overview

Places Simpson Strong-Tie Gerberverbinder (GERB series) beam splice connectors between two parallel, collinear timber beams of identical cross-section. The script automatically determines the correct connector model based on beam height, applies gap cuts to both beams, generates the 3D metal part geometry, and writes hardware components (connector and nails) to the Bill of Materials.

Product reference: Simpson Strong-Tie GERB series (GERB125 through GERB220).

## Usage Environment

| Space | Supported |
|-------|-----------|
| Model Space | Yes |
| Paper Space | No |
| Shop Drawing | No |

**Script type**: O-Type (Object)

## Prerequisites

- At least two parallel beams with the same cross-section, aligned on the same axis
- Beam height must match one of the supported GERB sizes: 125, 150, 160, 175, 180, 200, or 220 mm
- Only connections aligned with the World Z-axis (_ZW) are supported

## Usage Steps

### Workflow A: Automatic Pair Detection

1. Launch the script via `TSLINSERT` and select `Simpson-Strong-Tie-GERB`.
2. A dialog appears. Select connector type (default: Automatic), nailing pattern, and nail type. Click OK.
3. At the prompt "Select beam(s)", select all beams that should receive splice connections.
4. The script scans every beam pair for valid end-to-end connections. For each valid pair found (parallel, same axis, same section, gap within tolerance), a connector instance is created automatically.

### Workflow B: Manual Split with Point Selection

If no valid beam pair is detected among the selected beams (e.g., a single continuous beam), the script prompts:

1. "Select the Point" -- click a location along the beam where the splice should occur.
2. The beam is split at that point. All parallel beams in the selection that intersect the cutting plane are also split.
3. A connector is placed at each split location.

## Properties Panel Parameters

### General

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | Dropdown (read-only) | Automatic | Connector model. Automatically determined from beam height. Values: Automatic, GERB125, GERB150, GERB160, GERB175, GERB180, GERB200-DE, GERB220. |
| Gap | Length | 10 mm | Clearance between beam ends at the splice. Controls the cut positions on both beams. |

### Nailing

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Nailing Pattern | Dropdown | Full Nailing | Nail density. "Full Nailing" uses the maximum number of nails per the product specification. "Part Nailing" uses a reduced count. |
| Nail type | Dropdown | CNA4,0x40 | Nail product. Options: CNA4,0x40, CNA4,0x50, CNA4,0x60. |

## Right-Click Context Menu

| Menu Item | Action |
|-----------|--------|
| Swap X-(-X) | Mirrors the connector about the YZ plane (flips left/right along the beam axis). Also triggered by double-clicking the connector. |

## Behavior Details

- **Automatic model selection**: The script matches beam height (in the connection's Z-direction, aligned with World Z) against the GERB product table. If no exact match is found, the tool reports "Invalid geometry" and deletes itself.
- **Gap enforcement**: During insertion, beam pairs whose end gap exceeds the defined Gap value are skipped.
- **Beam cuts**: Both beams receive stretch-type cuts at the splice point, maintaining the defined gap.
- **Duplication prevention**: On creation, the script checks all existing instances in Model Space. If a connector already exists for the same beam pair, the new instance is erased.
- **Compare key**: Position number assignment uses the combination of script name, connector type, nailing pattern, and nail type.
- **Hardware BOM output**: Each instance writes two hardware components -- one for the GERB connector (manufacturer: Simpson StrongTie, material: S 250 GD +Z 275 per DIN EN 10346) and one for the nails with computed quantity.

## Catalog / Silent Insert

The script supports catalog-based insertion via `_kExecuteKey`. If a matching catalog entry name is found, properties are loaded from that catalog entry. Otherwise, the last-inserted configuration is applied.

## Tips

- Use "Automatic" type to let the script pick the correct GERB model; manually overriding is not needed unless beam geometry is unconventional.
- Ensure beams are truly collinear -- even small offsets in Y or Z will cause the script to reject the pair.
- After placement, you can drag the insertion point (_Pt0) along the beam axis to reposition the splice, provided it stays within the valid range of both beams.
- Double-click the connector for a quick mirror flip instead of using the context menu.
- The "Type" property is read-only in the Properties palette; it is determined by geometry and cannot be changed manually after insertion.

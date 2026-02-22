# Simpson Strong-Tie GERW -- Gerber Connector

## Overview

This tool places **Simpson Strong-Tie GERW series Gerber connectors** (Gerberverbinder) at beam-to-beam splice joints. GERW connectors are steel side-plates that bridge two collinear beams of identical cross-section, transferring shear loads across the joint. The script automatically detects valid beam pairs from a selection, sizes the connector to the beam depth, creates the gap cut between beams, and generates a 3D metal part with full hardware component data for BOM output.

**Manufacturer**: Simpson Strong-Tie
**Product reference**: [Gerberverbinder GERW](https://www.strongtie.de/products/detail/gerberverbinder/539)

| Property | Value |
|----------|-------|
| Script type | O (Object) |
| Version | 1.2 (2023-09-01) |
| Environment | Model Space |

## Prerequisites

- At least **one beam** must be selected (two collinear beams of equal cross-section are required for a valid connection).
- Beams must be **parallel**, **on the same axis** (aligned in Y and Z), and have **identical cross-section dimensions**.
- The gap between beam ends must not exceed the user-defined Gap value.

## Workflow

### 1. Insert the Script

Run the command to insert `Simpson-Strong-Tie-GERW`. A dialog appears where you can select a catalog preset or accept the default settings.

### 2. Select Beams

```
Prompt: "Select beam(s)"
```

Select all beams that should receive Gerber connections. The script will automatically find valid pairs among the selection.

### 3. Automatic Pair Detection

The script iterates through the selected beams and checks each potential pair for:

- Parallel beam axes
- Collinear alignment (same Y/Z position)
- Equal cross-section (width and depth)
- End gap within the specified tolerance

For every valid pair found, a connector instance is created automatically.

### 4. Manual Point Selection (if no pair found)

If no valid pair is detected among the selected beams, the script prompts:

```
Prompt: "Select the Point"
```

Click a point along the beam axis. The script will **split the beam** at that location, creating two beams with a gap, and then place the connector across the new joint. All parallel beams in the selection that can also be split at this plane are processed together.

## Properties Panel

### General

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| **Type** | Dropdown | Automatic | Automatic, GERW90, GERW120, GERW140, GERW160, GERW180, GERW200, GERW220, GERW240, GERW260, GERW280, GERW300, GERW320, GERW340, GERW360, GERW380, GERW400, GERW420 | Connector model. "Automatic" selects the largest model that fits with a 20 mm recommended gap below the beam depth. |
| **Gap** | Length | 10 mm | -- | Gap distance between the two beam ends at the splice joint. |

### Nailing

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| **Nailing Pattern** | Dropdown | Full Nailing | Full Nailing, Part Nailing | Full Nailing uses all nail holes; Part Nailing uses a reduced pattern. |
| **Nail type** | Dropdown | CNA4,0x40 | CNA4,0x40, CNA4,0x50, CNA4,0x60 | Simpson CNA nail specification. All nail diameters are 4.0 mm; lengths are 40, 50, or 60 mm. |

## Right-Click Context Menu

| Command | Description |
|---------|-------------|
| **Swap Z-(-Z)** | Mirrors the connector to the opposite face of the beam (flips across the YZ plane of the connection). Also triggered by double-clicking the instance. |

## Automatic Type Selection Logic

When **Type** is set to "Automatic", the script selects the connector based on beam depth:

- It calculates the beam dimension in the direction aligned with the world Z axis.
- It picks the largest GERW model whose height (A dimension) is at least 20 mm smaller than the beam depth.
- Example: For a beam depth of 240 mm, the script selects GERW220 (A = 220 mm, leaving a 20 mm gap).

If you set a specific model manually, no automatic sizing is performed.

## Connector Dimensions

Each GERW model has fixed dimensions:

- **A** (connector height): Matches the model number (e.g., GERW200 has A = 200 mm).
- **B** (connector width/horizontal): 140 mm for GERW90; 180 mm for GERW120 and above.
- **C** (bottom flange depth): 20 mm for all models.
- **T** (plate thickness): 2 mm for all models.

The connector consists of two symmetrical side plates (left and right), each with a bottom return flange.

## Hardware / BOM Output

The script generates two hardware components per instance:

1. **Connector** -- Article number matches the Type (e.g., "GERW200"), manufacturer "Simpson StrongTie", material "S 250 GD +Z 275" per DIN EN 10346. Quantity: 1.
2. **Nails** -- Article number matches the selected Nail type. Quantity depends on the nailing pattern and connector size (e.g., GERW200 with Full Nailing requires 104 nails total on both sides).

Hardware components are assigned to the element group of the first beam when available.

## Insertion Point Behavior

- By default, the insertion point is placed at the midpoint of the gap between the two beam ends.
- You can move the insertion point along the beam axis by editing `_Pt0`. The script validates that the new position keeps sufficient material on both sides (minimum distance B from beam ends).
- Moving `_Pt0` causes the script to re-cut both beams at the new location.

## Tips

- **Batch placement**: Select many beams at once. The script pairs them automatically and creates one connector per valid pair.
- **Orientation**: If the connector appears on the wrong face, use **Swap Z-(-Z)** from the right-click menu or double-click the instance.
- **Automatic mode recommended**: The default "Automatic" type ensures correct sizing with the 20 mm recommended clearance between connector edge and beam edge.
- **Catalog presets**: You can save parameter combinations as catalog entries and recall them by name during insertion, which is useful for standardized connections.

## Validation and Error Messages

| Message | Cause |
|---------|-------|
| "Beams are not parallel." | Selected beams have non-parallel axes. |
| "Beams are not on the same axis." | Beams are parallel but offset in Y or Z. |
| "Beams are not of same section." | Beam cross-sections differ in width or depth. |
| "Invalid geometry" | No suitable GERW model fits the beam dimensions (beam too small for smallest connector). |
| "Select at least one beam" | No beams were selected during insertion. |

When any validation fails, the tool instance is deleted automatically.

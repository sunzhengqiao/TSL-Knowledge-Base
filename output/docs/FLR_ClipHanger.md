# FLR_ClipHanger.mcr

## Overview
Generates parametric metal clips or hangers to connect a "male" beam (e.g., a joist or rafter) to a "female" beam (e.g., a rim band or top plate) using standard catalog sizes.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script creates 3D MetalPart entities at beam intersections. |
| Paper Space | No | Not intended for 2D detailing or view generation. |
| Shop Drawing | No | Generates model content only. |

## Prerequisites
- **Required Entities**: `GenBeam`, `Element` (Wall or Floor).
- **Minimum Beam Count**: 2 (One male beam to be supported, one female supporting beam).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT`
**Action:** Browse and select `FLR_ClipHanger.mcr`, then click Open.

### Step 2: Select Male Beam(s)
```
Command Line: Select male beam(s)
```
**Action:** Click on the joist(s) or beam(s) that need to be supported.
- *Note:* You can select multiple beams. Press **Enter** to confirm your selection.

### Step 3: Select Female Beam
```
Command Line: Select female beam
```
**Action:** Click on the single supporting beam (e.g., the rim joist or ledger) that the male beams intersect.
- *Result:* The script will generate clip instances at all valid intersections between the selected male beams and the female beam.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Clip | dropdown | 1.5x1.5x5 | Selects the hardware profile from the catalog (e.g., 1.5x1.5x5). Changing this updates all dimensions automatically. |
| Attachment Face | dropdown | Outside | Sets which side of the female beam the clip attaches to. Options: `Outside`, `Inside`. |
| Leg 1 | number | 1.5 | The vertical height/depth of the connector along the male beam. (Read-only) |
| Leg 2 | number | 1.5 | The horizontal width/depth into the female beam. (Read-only) |
| Width | number | 5 | The gauge width of the metal connector. (Read-only) |
| Type | text | Clip | Classification of the hardware for reports/scheduling. (Read-only) |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script uses standard OPM (Object Property Model) properties. No custom context menu items are added. |

## Settings Files
- **Filename:** None
- **Location:** N/A
- **Purpose:** N/A (All settings are embedded in the script properties).

## Tips
- **Bulk Selection:** You can select multiple joists in Step 2 to install hangers on an entire row at once.
- **Flipping Orientation:** Use the **Attachment Face** property in the Properties Palette to toggle the clip between "Outside" and "Inside" without re-running the command.
- **Auto-Update:** If you move or modify the connected beams, the clip geometry will automatically update to match the new intersection.
- **Read-Only Dimensions:** Do not try to manually type values for Leg 1, Leg 2, or Width. Instead, select a different **Clip** size from the dropdown to change dimensions.

## FAQ

- **Q: Why did my clip disappear from the model?**
  **A:** The script will erase the clip instance if the connected beams are deleted, if the beams no longer intersect properly, or if the female beam is removed from its Element (Wall/Floor).

- **Q: Can I create a custom size clip not in the dropdown list?**
  **A:** No. The script uses a predefined catalog. You must select one of the available options (e.g., 1.5x1.5x5) which sets the geometry.

- **Q: The "Leg" and "Width" fields are greyed out. How do I change them?**
  **A:** These are calculated automatically based on the **Clip** property. Change the "Clip" selection to the desired catalog part, and these values will update accordingly.
# SimpsonStrongTieSPF.mcr

## Overview
This script generates 3D geometry and production data for Simpson Strong-Tie SPF series purlin anchors. It connects two intersecting timber beams (such as a rafter to a purlin) with standardized metal plates and optional nail hardware.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for beam selection and 3D geometry generation. |
| Paper Space | No | This script does not generate 2D details or layout views. |
| Shop Drawing | No | This is a modeling script, not a drawing generation tool. |

## Prerequisites
- **Required Entities**: At least two timber beams (GenBeams).
- **Minimum Beam Count**: 2 (A supporting beam and the beam to be connected).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Select `SimpsonStrongTieSPF.mcr` from the file dialog.

### Step 2: Select Supporting Beam
```
Command Line: Select First Beam
Action: Click on the primary beam (e.g., the purlin) that supports the connection.
```

### Step 3: Select Secondary Beam
```
Command Line: Select Second Beam
Action: Click on the secondary beam (e.g., the rafter) that intersects the first beam.
```

### Step 4: Configure Properties
1.  After selection, the script generates the default geometry.
2.  Select the newly created element and open the **Properties Palette** (Ctrl+1).
3.  Adjust parameters (e.g., Type, Offsets, Nail count) as required.

## Properties Panel Parameters

### General & Geometry
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Purlin anchor | dropdown | SPF170 | Selects the Simpson Strong-Tie model profile (e.g., SPF170, SPF210). |
| Article | text | | Commercial article number for the metal plate. |
| Material | text | Stahl, feuerverzinkt | Material specification for the plate. |
| Metalpart Notes | text | | Additional manufacturing notes for the plate. |
| Show description | dropdown | Yes | Toggles the visibility of the product label/flag in the model. |

### Position & Configuration
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Offset purlin anchor front | number | 0.0 | Vertical adjustment (mm) for the front plate relative to the beam intersection. |
| Offset purlin anchor back | number | 0.0 | Vertical adjustment (mm) for the back plate relative to the beam intersection. |
| Side | dropdown | Front | Determines which side is used when "On One Side" is active. |
| On One Side | dropdown | No | If Yes, creates a single plate instead of two mirrored plates. |
| Switch Purlin anchor | dropdown | No | If Yes, flips the orientation of the plates across the beam axis. |
| Four purlin anchor | dropdown | No | If Yes, creates a 4-sided connection (double anchors). |

### Label Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| X-flag | number | 200.0 | Horizontal distance (mm) of the label leader line from the insertion point. |
| Y-flag | number | 300.0 | Vertical distance (mm) of the label leader line from the insertion point. |
| Dimstyle | dropdown | _DimStyles | The dimension style used for the label text. |
| Color | number | 171 | Color index for the generated geometry. |

### Fasteners (Nails)
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Nail Model | text | Kammnagel | Model type of the nail. |
| Article | text | | Commercial article number for the nails. |
| Material | text | Stahl, verzinkt | Material specification for the nails. |
| Nail Diameter | number | 4.0 | Diameter of the nails (mm). |
| Nail Length | number | 40.0 | Length of the nails (mm). |
| Number of nails | number | 0 | Total quantity of nails to generate. Set > 0 to create hardware. |
| Metalpart Notes | text | | Additional notes for the fasteners. |

## Right-Click Menu Options
No specific custom context menu options are defined for this script. Use the standard AutoCAD/hsbCAD Properties Palette to modify settings.

## Settings Files
No external settings files (XML/TXT) are required for this script.

## Tips
- **Change Size Quickly**: You can change the anchor type (e.g., from SPF170 to SPF250) directly in the Properties Palette after insertion without re-running the script.
- **Move the Label**: After insertion, select the anchor and use the **Grip Point** (square handle) to drag the product label to a desired location. This updates the visual position immediately.
- **Single vs. Double Sided**: Use the **On One Side** property if you only want the plate on one face of the beam. Use **Four purlin anchor** for heavy-duty connections requiring double plating.
- **Nail Visualization**: Nails will only appear in the 3D model if the **Number of nails** property is set to a value greater than 0.

## FAQ
- **Q: How do I rotate the plate to the other side of the beam?**
  A: Change the **Side** property to "Front" or "Back". If you need to flip the orientation entirely, set **Switch Purlin anchor** to "Yes".
- **Q: Why don't I see any nails?**
  A: Check the **Number of nails** property in the Properties Palette. It defaults to 0. Increase this value to generate the nail hardware.
- **Q: The plate is sitting too high/low on the beam.**
  A: Use the **Offset purlin anchor front** or **Offset purlin anchor back** properties to shift the plate vertically.
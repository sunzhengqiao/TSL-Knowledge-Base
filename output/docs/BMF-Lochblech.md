# BMF-Lochblech.mcr

## Overview
Generates BMF perforated metal plate connectors (Lochblech) for connecting 2 or 3 timber beams. It supports splice connections (parallel beams) and corner/T-junctions, with options to recess the plate into the wood or define custom dimensions.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D beam interaction. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | Not applicable. |

## Prerequisites
- **Required Entities**: At least 2 Timber Beams.
- **Minimum Beam Count**: 2.
- **Required Settings**: None (uses internal catalog).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `BMF-Lochblech.mcr` from the file dialog.

### Step 2: Select Primary Beams
```
Command Line: Select first Beam
Action: Click on the first timber beam to connect.
```
```
Command Line: Select second Beam
Action: Click on the second timber beam.
```

### Step 3: Define Plate Location
*The script detects if the beams are parallel or intersecting.*

**If beams are PARALLEL (Splice):**
```
Command Line: [Point Prompt]
Action: Click a point in the model to locate the plate along the splice.
```

**If beams are INTERSECTING (Corner/T-Junction):**
```
Command Line: Select optional beam
Action: Click a third beam if present, or press Enter to finish with two beams.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Type** | Dropdown | 40x120x2,0 BMF-Lochblech | Select a standard plate size from the BMF catalog. |
| **Free Steel Plate** | Dropdown | No | Set to **Yes** to unlock custom dimensions below. |
| **Length** | Number | 3000 | Custom plate length (mm). Active only if Free Steel Plate is Yes. |
| **Width** | Number | 1300 | Custom plate width (mm). Active only if Free Steel Plate is Yes. |
| **Thickness** | Number | 2.0 | Custom plate thickness (mm). Active only if Free Steel Plate is Yes. |
| **Duplex** | Dropdown | Yes | If **Yes**, creates two mirrored plates (one on each side). |
| **Side** | Dropdown | Left | Selects side for a single plate. Locked if Duplex is Yes. |
| **Offset** | Number | 0 | Shifts the plate along the beam axis (mm). |
| **Stretch** | Dropdown | Yes | If **Yes**, automatically cuts the timber beams to fit the plate. |
| **Article1** | String | [Empty] | ERP Article number for the plate. |
| **Material1** | String | Stahl, feuerverzinkt | Material specification for the plate. |
| **NumNail** | Number | 8 | Number of nails associated with one plate. |
| **Mod2** | String | Kammnagel | Model name for the nail/fastener. |
| **Article2** | String | [Empty] | ERP Article number for the nails. |
| **Material2** | String | Stahl, feuerverzinkt | Material specification for the nails. |
| **Description** | Dropdown | Yes | Toggle visibility of the dimension label text. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Re-calculate** | Refreshes the script geometry if parameters change. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script uses an internal array (`sArType`) for standard BMF sizes. No external XML configuration file is required.

## Tips
- **Custom Sizes**: To create a plate not in the standard list, set **Free Steel Plate** to **Yes**. You can then manually enter Length, Width, and Thickness.
- **Moving the Plate**: You can slide the plate along the beam after insertion by changing the **Offset** property or using the visible grip point.
- **Double-Sided Joints**: Use **Duplex = Yes** to automatically generate plates on both sides of the joint. This is faster than inserting two separate scripts.
- **Hiding Labels**: If the model gets too cluttered with text, set **Description** to **No** to hide the dimension label.

## FAQ
- **Q: How do I cut a recess into the wood for the plate?**
- **A:** Set the **Stretch** property to **Yes**. This will apply a machining operation (Cut) to the selected beams.
- **Q: Why can't I change the Side property?**
- **A:** The Side property is locked when **Duplex** is set to **Yes**, because the script automatically generates plates on both sides. Change Duplex to **No** to select a specific side.
- **Q: Can I use this for non-90 degree connections?**
- **A:** Yes, the script calculates the intersection plane based on the selected beams, supporting corners and T-junctions at various angles.
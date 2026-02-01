# GH-Verbinder Top OV

## Overview
This script generates a GH-OV (Gluhlam Verbinder Oberseite) metal connector plate for T-, L-, or parallel timber beam connections. It automatically creates the necessary wood recesses (milling), places the 3D hardware representation, and optionally adds positioning drills and no-nail areas to the linked floor element.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for inserting the connector on 3D beams. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: At least two Timber Beams (GenBeam) or Structural Members. Optionally, a Floor/Wall Element linked to the main beam if using element drilling features.
- **Minimum Beam Count**: 2 (Script logic adapts for T-connections vs. End-to-End or Parallel connections).
- **Required Settings**: Standard Production State settings (Plant vs. Construction Site) determine specific drilling/milling strategies (e.g., Weinmann drills).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `GH-Verbinder Top OV.mcr`.

### Step 2: Configure Initial Settings
```
Dialog: Configuration
Action: Select the Connector Type (e.g., Type 60), Relief style, and Connection Type (T, Length, or Parallel) in the initial dialog. Click OK.
```

### Step 3: Select Beams
The prompts vary based on the Connection Type selected in Step 2.

**Scenario A: T-Connection**
```
Command Line: Select beams:
Action: Click on the intersecting beams. The script will automatically detect the intersection and assign Main (Female) and Secondary (Male) roles.
```

**Scenario B: Length or Parallel Connection**
```
Command Line: Select beam 1:
Action: Click the first beam.

Command Line: Select beam 2:
Action: Click the second beam.

Command Line: (If Parallel) Specify reference point:
Action: Click a point along the beams to define exactly where the connector should be placed.
```

### Step 4: Finalize Insertion
Action: The script instance is inserted at the calculated intersection. Open the **Properties Palette** (Ctrl+1) to fine-tune offsets, gaps, or quantity if needed.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **sType** | dropdown | Type 40 | Size of the connector plate (Width: 40/60/80/100mm). |
| **sRelief** | dropdown | rounded | Corner treatment of the milled slot (Sharp, Rounded, or Relief cuts). |
| **sConType** | dropdown | T-Connection | Geometric relationship between beams (T, Length, Parallel). |
| **sElemDrill** | dropdown | No | Adds a positioning drill hole in the linked floor element. |
| **dOffset** | number | 0 | Moves the connector along the main beam axis. |
| **dCenterOffset** | number | 0 | Moves the connector sideways relative to the main beam center. |
| **nQty** | integer | 1 | Number of connectors (1 or 2). |
| **dAxisOffset** | number | 0 | Distance between connectors if Quantity is 2. |
| **dGap** | number | 0 | Vertical air gap created between beams. |
| **sGapIn** | dropdown | Male beam | Determines which beam moves to create the gap (Male, Female, or Both). |
| **dScrewHT** | number | 100 | Screw length for the Female (Main) beam (BOM only). |
| **dScrewNT** | number | 100 | Screw length for the Male (Secondary) beam (BOM only). |
| **dSnap** | number | 200 | IntellSnap detection radius during insertion. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Seite wechseln | Flips the connector orientation to the opposite side of the beam centerline or intersection vector. |

## Settings Files
- **Production State Config**: Controlled by global hsbCAD settings (`Werk`, `Baustelle`, `Teilmontage`).
- **Purpose**: Determines if specific Weinmann drills are enabled or disabled based on the assembly location (Plant vs. Site).

## Tips
- **Double Connectors**: Use `nQty = 2` combined with `dAxisOffset` to quickly create pairs of connectors without inserting the script twice.
- **Element Assembly**: If `sElemDrill` is set to "Yes" but no hole appears, check that your Main Beam is correctly grouped to a floor element in the model structure.
- **Parallel Connections**: When using "Parallel connection", ensure you pick a clear reference point near the desired location to avoid the connector snapping to the wrong end of the beam.

## FAQ
- **Q: Why is the connector not sitting flush with the beam top?**
  A: Check the `dGap` parameter. If a gap is applied, ensure `sGapIn` is set correctly to move the intended beam (Male or Female).
- **Q: Can I switch from a T-connection to a Parallel connection after inserting?**
  A: Yes, change `sConType` in the Properties Palette. You may need to adjust the `dOffset` or re-select beams if the intersection vectors differ significantly.
- **Q: The script is creating drilling operations in the element that I don't want.**
  A: Set `sElemDrill` to "No" in the Properties Palette. This will remove the element tooling and no-nail areas.
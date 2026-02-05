# Pitzl SPP-Verbinder.mcr

## Overview
This script inserts a Pitzl SPP Shear Plate Connector to join timber beams. It automatically generates the required CNC toolpaths (milling and drilling) and assigns necessary hardware (connectors, screws, rods) to the Bill of Materials.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates on 3D beams in the model. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Does not generate 2D annotations directly. |

## Prerequisites
- **Required Entities**: At least one "Male" beam and one "Female" beam (GenBeam).
- **Minimum Beam Count**: 2 (1 Male, 1 Female).
- **Required Settings**: None required for basic execution.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Pitzl SPP-Verbinder.mcr` from the list.

### Step 2: Configure Connector (Dialog)
```
Dialog: Dynamic Properties Dialog
Action: Select the Article number (Connector Type) and Screw Length from the dropdowns. Click OK to confirm.
```
*Note: If the script is run from a catalog, this step may be skipped and settings loaded automatically.*

### Step 3: Select Male Beam
```
Command Line: Select male beam(s)
Action: Click on the beam(s) that will host the shear plate (the main beam). Press Enter to finish selection.
```

### Step 4: Select Female Beam
```
Command Line: Select female beam(s)
Action: Click on the intersecting beam(s) that will receive the rod/tension connection (if applicable). Press Enter to finish selection.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **A - Article** | dropdown | 88710.0000 | Selects the specific Pitzl SPP product model (defines dimensions and material). |
| **B - Screw Length** | dropdown | 120 | Length of the wood screws used to attach the shear plate to the male beam (mm). |
| **C - Additional mill depth** | number | 0 | Adjusts how deep the connector pocket is milled into the male beam (mm). |
| **D - Oversize mill** | number | 2 | Extra clearance diameter added to the top plate milling (mm). |
| **E - Offset Lateral** | number | 0 | Shifts the connector sideways (along the beam width) from the calculated intersection (mm). |
| **F - Offset Vertical** | number | 0 | Shifts the connector vertically (along the beam height) from the calculated intersection (mm). |
| **G - Tools in female beam** | dropdown | No | If set to "Yes", adds drilling and hardware to the female beam. |
| **H - Extra depth sink hole** | number | 10 | Additional depth for the counterbore on the female beam side to recess the nut/washer (mm). |
| **I - Oversize sink hole** | number | 4 | Extra clearance diameter for the counterbore on the female beam side (mm). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **TslDoubleClick** | Double-clicking the connector instance in the model re-opens the Properties dialog to allow quick changes. |

## Settings Files
- **Filename**: None required (Internal Catalogs may be used).
- **Location**: N/A
- **Purpose**: The script relies on internal dimensions based on the selected Article number. No external user settings file is mandatory.

## Tips
- **Beam Orientation**: The script automatically skips parallel beams. Ensure your male and female beams actually cross each other.
- **Positioning**: If the connector calculates slightly off due to complex geometry, use the **Offset Lateral (E)** and **Offset Vertical (F)** properties to nudge it into place without moving the beams.
- **Female Tooling**: Remember to set **Tools in female beam (G)** to "Yes" if you need the threaded rod and nut machining on the intersecting beam.

## FAQ
- **Q: Why did the script skip a beam pair I selected?**
  **A**: The script automatically ignores pairs where the beams are parallel or where the intersection point is outside the physical length of the female beam.
- **Q: How do I change the connector size after insertion?**
  **A**: Double-click the connector instance in the model and select a different Article number from the dropdown.
- **Q: The hardware isn't showing up in my BOM?**
  **A**: Ensure the TSL instance is not on a frozen layer and that you have updated your BOM list. If female hardware is missing, check if "Tools in female beam" is enabled.
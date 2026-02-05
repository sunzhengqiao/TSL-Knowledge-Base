# Jane-TU.mcr

## Overview
This script automates the generation of Simpson Strong-Tie Jane-TU top-flange timber hangers. It calculates the required 3D geometry, creates pocket cutouts in the supporting beam, applies drilling to the joists, and adds shop floor markings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Geometry and machining are applied to 3D beams. |
| Paper Space | No | This script does not generate 2D details or drawings. |
| Shop Drawing | No | Machining is applied directly to the model entities. |

## Prerequisites
- **Required Entities**: At least two beams (one joist/male and one support/female).
- **Minimum Beam Count**: 2 (1 Male, 1 Female).
- **Required Settings**: None specific (uses internal manufacturer dimensions).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Jane-TU.mcr` from the file list.

### Step 2: Initial Configuration
A configuration dialog or property prompt may appear (depending on version settings). You can accept defaults or set them later in the Properties Panel.

### Step 3: Select Joist (Male) Beams
```
Command Line: Select male beams
Action: Click on the joist beam(s) that will carry the load into the hanger.
```

### Step 4: Select Support (Female) Beams
```
Command Line: Select female beam(s)
Action: Click on the supporting beam(s) where the hangers will be mounted.
```

### Step 5: Placement
After selection, the script instance is created. The visual representation and machining will update automatically.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | Dropdown | JANE-TU 12 | Selects the manufacturer SKU (12, 16, 20, 24, or 28), defining dimensions and load capacity. |
| bottom closed | Dropdown | Yes | Determines if the pocket in the female beam has a closed bottom ("Yes") or is open ("No"). |
| Normal | Dropdown | No | If "Yes", the slot cut aligns with the face of the male beam (useful for non-90° connections). If "No", it is orthogonal to the female beam. |
| Beam End Lap | Dropdown | Yes | Controls if the end of the male beam is cut ("Yes" or "No") or left uncut ("None"). |
| Drill Face | Dropdown | Side 1 | Selects which side of the male beam is drilled for the dowels (Side 1 or Side 2). |
| Marking | Dropdown | Marking | Determines the text/line marking style on the female beam (Text, Text & Desc, Text & PosNum, None). |
| Depth Female | Number | 0 | Depth of the pocket/housing cut into the female beam (0 = surface mount). |
| Gap | Number | 20 | Clearance allowance (in mm) around the connector within the female beam pocket. |
| Txt Height | Number | 20 | Height of the marking text on the beam. |
| Y-Offset Axis | Number | 0 | Lateral offset of the connector along the width of the female beam. |
| Z-Offset Axis | Number | 0 | Vertical offset of the connector relative to the default placement. |
| Color | Number | 8 | Sets the display color index (ACI) for the metal connector body. |
| DimStyle | String | <Current> | Specifies the dimension style used for any generated dimensions. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the geometry and machining to reflect changes in beam positions or property values. |
| Erase | Removes the script instance and cleans up generated elements. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script uses hardcoded manufacturer dimensions for Simpson Strong-Tie Jane-TU connectors; no external XML configuration file is required.

## Tips
- **Angled Connections**: If your joist meets the support beam at an angle other than 90°, set the **Normal** property to "Yes" to ensure the pocket cut aligns correctly with the joist face.
- **Concealed Hangers**: To recess the hanger into the support beam for a flush look, increase the **Depth Female** value.
- **Visualizing Drilling**: The **Drill Face** property allows you to switch drilling sides instantly. Use this to ensure dowels do not conflict with other hardware or joinery.

## FAQ
- **Q: How do I change the hanger size after inserting the script?**
  - A: Select the script instance in the model, open the **Properties Palette (Ctrl+1)**, and change the **Type** dropdown to the desired SKU (e.g., JANE-TU 24). The machining will update automatically.
- **Q: Why is there a gap around my hanger?**
  - A: Check the **Gap** property. It defaults to 20mm to provide clearance. Set this to 0 for a tighter fit, or adjust based on your fabrication tolerances.
- **Q: The drill holes are on the wrong side of the joist.**
  - A: Change the **Drill Face** property from "Side 1" to "Side 2" in the Properties Panel.
# SimpsonStrongTieEL.mcr

## Overview
Inserts a Simpson Strong-Tie EL top connector (BMF Topverbinder) to join a joist (male beam) perpendicular to a main beam (female beam). It generates the 3D metal plate geometry, required timber millings/cuts, and hardware list entries for production.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D beams and bodies in the model. |
| Paper Space | No | Not designed for layout views or annotations. |
| Shop Drawing | No | Does not generate shop drawings directly (model only). |

## Prerequisites
- **Required Entities**: Two `GenBeam` entities (beams).
- **Minimum Beam Count**: 2 (1 Male beam and 1 Female beam).
- **Required Settings**: None specific (script uses internal logic).

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT`
**Action:** Browse and select `SimpsonStrongTieEL.mcr`, then click Open.

### Step 2: Select Male Beam(s)
```
Command Line: Select joist(s)/Male beam(s):
Action: Click on one or multiple beams that will be attached (the joists). Press Enter when finished.
```

### Step 3: Select Female Beam
```
Command Line: Select main beam/Female beam:
Action: Click on the single main beam that the joists will connect to.
```

### Step 4: Configure Properties
**Action:** A configuration dialog will appear. Adjust the Model (Size), Connection Type, and Offsets as needed. Click **OK** to confirm.

### Step 5: Generation
**Action:** The script automatically creates a connector instance for every selected Male Beam at its intersection with the Female Beam.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Model | dropdown | EL30 | Selects the Simpson Strong-Tie size (EL30, EL40, EL60, EL80, EL100). Affects plate width, cut depth, and screw count. |
| Connection Type | dropdown | Milled in female beam | Select installation method: Milled (in female/male), Visible gap, Concrete, Steel, Element, or L-bearing. |
| Top Milling | dropdown | No | If "Yes", creates a horizontal slot on the top face of the male beam. |
| Vertical Offset | number | 0 | Moves the connector up or down (Z-axis) relative to the female beam. |
| Horizontal Offset | number | 0 | Moves the connector along the length of the female beam (X-axis). |
| Add Width | number | 2 | Extra clearance added to the milling width (Male beam). |
| Add Width 2 | number | 2 | Extra clearance added to the milling width (Female beam). |
| Add Length | number | 10 | Extra clearance added to the milling length (Male beam). |
| Add Depth | number | 10 | Extra clearance added to the milling depth (Female beam). |
| HW Type | text | Screw | Hardware type for BOM (e.g., Screw). |
| HW Model | text | ABC Spax | Screw model description. |
| HW Length | number | 70 | Length of the screw. |
| HW Diameter | number | 5 | Diameter of the screw. |
| Show Details | dropdown | No | Toggles visualization of helper coordinate system lines for debugging. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Erase | Removes the connector instance from the model. |
| Recalculate | Updates the geometry based on current beam positions or property changes. |
| Properties | Opens the Properties Palette to edit parameters listed above. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script uses internal lookup arrays for dimensions and does not require external XML settings files.

## Tips
- **Multi-Selection**: You can select multiple joists (Male beams) in Step 2 to connect them all to the same main beam at once.
- **L-Bearing Mode**: If your beams are not on the exact same plane (e.g., one is slightly higher), change the **Connection Type** to "L-bearing" to handle the vertical step correctly.
- **Clearances**: If the timber is swelling or if you want a looser fit on site, increase the **Add Width/Length/Depth** values before generating.
- **Visual Debugging**: If the connector appears in the wrong orientation, set **Show Details** to "Yes" to see the local coordinate axes (Red/Green/Blue) to understand how the script is calculating the intersection.

## FAQ
- **Q: I got a message saying "I-Beam is not in same plane." What do I do?**
- **A:** The beams are likely misaligned vertically. Open the Properties Palette, find **Connection Type**, and change it to **L-bearing**. This adjusts the geometry to handle the height difference.
- **Q: Can I use this to connect to a concrete wall?**
- **A:** Yes. Set the **Connection Type** to **Concrete**. This will generate the plate without timber millings on the female side.
- **Q: The script warned me about "Element" connection type and reset it. Why?**
- **A:** The "Element" mode only works if the beams belong to an hsbCAD Element construct. If they are standard standalone beams, the script automatically falls back to "Milled in female beam" to ensure valid geometry.
# Simpson Strong Tie GERG

## Overview
This script generates the 3D geometry and hardware data for Simpson Strong-Tie GERG Gerber joist hangers. It is designed to structurally connect two timber beams end-to-end (butt joint) by automatically selecting the correct bracket size based on the beam dimensions or user specifications.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script performs 3D operations and creates solid bodies. |
| Paper Space | No | Not designed for 2D layout or detailing views. |
| Shop Drawing | No | This is a model generation script, not a 2D processing script. |

## Prerequisites
- **Required Entities**: At least two Timber Beams (`GenBeam`) to connect.
- **Minimum Beam Count**: 2 (must be parallel, collinear, and have the same cross-section).
- **Required Settings**: None (uses internal dimension tables for Simpson Strong-Tie parts).

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Browse and select `Simpson-Strong-Tie-GERG.mcr`.

### Step 2: Configure Properties (Dialog)
Upon launching, a dynamic dialog will appear automatically (unless run from a specific catalog entry).
-   **Type**: Select the specific connector model (e.g., `GERG120/180-B`) or leave as `Automatic` to let the script decide based on beam height.
-   **Gap**: Define the distance (mm) between the two beam ends (default is 10.0mm).
-   **Nailing**: Select the nailing pattern (`Full Nailing` or `Part Nailing`) and the nail type (`CNA4.0xl` or `CSA5.0xl`).
-   Click **OK** to proceed.

### Step 3: Select Beams
```
Command Line: Select beam(s)
Action: Click on the first beam, then the second beam you wish to connect. Press Enter to confirm selection.
```
**Note**: Ensure the two beams are perfectly aligned in a straight line and have the same width and height. If they are not parallel or aligned, the script will skip the connection.

### Step 4: Completion
The script will generate the steel hanger body, apply cuts to the timber beams to accommodate the gap, and add the hardware to the Bill of Materials (BOM).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Type** | Dropdown | `Automatic` | Selects the Simpson Strong-Tie model number. Choose 'Automatic' to match the beam height, or select a specific code (e.g., GERG120/180-B). |
| **Gap** | Number | `10.0` | Sets the physical gap between the two beam ends in millimeters. |
| **Nailing Pattern** | Dropdown | `Full Nailing` | Determines the quantity of fasteners calculated in the BOM. 'Full' uses all holes; 'Part' uses a reduced quantity. |
| **Nail type** | Dropdown | `CNA4,0xl Kammnageln` | Specifies the fastener product (e.g., nails or screws) to be reported in the BOM. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Swap X-(-X)** | Flips the connector orientation 180 degrees. This is useful if you need the specific face of the bracket to point in the opposite direction along the beam axis. |

## Settings Files
- **Filename**: None used.
- **Note**: This script relies on internal hard-coded dimension arrays for the Simpson Strong-Tie product range. It does not require external XML configuration files.

## Tips
- **Automatic Mode**: For the fastest workflow, keep the Type set to `Automatic`. This ensures the hanger size updates instantly if you change the timber beam size later.
- **Grip Editing**: You can click on the inserted connector and drag the grip point (`_Pt0`) to slide the joint along the beams. The cuts and hardware will follow.
- **Validation**: If the connector does not appear, check the Properties Palette for errors or ensure your selected beams have the exact same Height and Width properties.

## FAQ
- **Q: The script skips my beams and doesn't create a connector. Why?**
  A: The beams must be parallel, lie on the same centerline (collinear), and have identical cross-section dimensions. If they are slightly rotated or different sizes, the script will reject the pair.
  
- **Q: How do I change the nail size without deleting the connector?**
  A: Select the connector in the model, open the Properties Palette (Ctrl+1), and change the "Nail type" dropdown. The BOM will update automatically.

- **Q: Can I use this for non-Simpson brackets?**
  A: No, the geometry and dimensions are specifically coded for the Simpson Strong-Tie GERG series. Using it for other brands would result in incorrect geometry.
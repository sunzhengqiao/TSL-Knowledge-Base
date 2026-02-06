# Sherpa-Verbinder.mcr

## Overview
Automates the insertion and configuration of Sherpa brand timber connectors at T-junctions between perpendicular beams. It handles the creation of steel plates, milling pockets in the timber, and the assignment of the correct screws.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model to connect beams. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required entities**: Two or more Timber Beams (`GenBeam`).
- **Minimum beam count**: 2 beams forming a T-junction (perpendicular).
- **Required settings**: Dimension Styles (`_DimStyles`) must exist in the drawing for labels to display correctly.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Sherpa-Verbinder.mcr`

### Step 2: Configure Connector
```
Command Line: (Dialog appears)
Action: Choose the Connector Type (e.g., A, B, Multi), Position, and Milling options in the dialog box. Click OK to confirm.
```

### Step 3: Select Beams
```
Command Line: |Select beams|
Action: Click on the beams in the model where you want to install connectors. You can select multiple beams at once.
Note: The script will automatically detect perpendicular intersections (T-junctions) based on the Snap Distance setting.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | dropdown | A | Select the model code of the Sherpa connector (e.g., A, B, C, Multi, etc.). This determines plate size and screw type. |
| Position | dropdown | Top | Vertical alignment on the main beam. Options: Top, Middle, Bottom. |
| Milling | dropdown | Yes | Cuts a pocket (mortise) into the secondary beam to fit the plate. Select "No" to place the plate on the surface. |
| Show description | dropdown | No | Toggles the visibility of the text label and leader line identifying the connector. |
| Offset X (dxFlag) | number | 200 | Horizontal distance from the connector to the text label anchor point (in mm). |
| Offset Y (dyFlag) | number | 300 | Vertical distance from the connector to the text label anchor point (in mm). |
| Snap Distance (dSnap) | number | 2000 | Maximum gap allowed for the script to recognize a valid T-connection (in mm). |
| DimStyle | text | _DimStyles | The dimension style used for the text label (controls font and size). |
| Color | number | 171 | The display color index for the connector and label (0-255). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Update | Recalculates the connector geometry after changing properties in the Properties Panel. |

## Settings Files
- **Filename**: None (Internal)
- **Location**: Script Internal Logic
- **Purpose**: Dimension data and screw mappings are handled internally by the script lookup tables based on the selected "Type".

## Tips
- **Batch Processing**: Select a large array of beams at once. The script loops through them and only inserts connectors where valid T-junctions exist within the Snap Distance.
- **Label Positioning**: You can drag the label grip point in the model view to adjust the `dxFlag` and `dyFlag` offsets visually.
- **Perpendicular Check**: Ensure your beams are exactly perpendicular (90 degrees). If the beams are at a different angle, the tool will delete itself to prevent errors.

## FAQ
- **Q: Why did the connector disappear after I updated the properties?**
  **A:** The script validates that the connected beams are perpendicular. If they are not 90 degrees apart, the tool automatically erases itself.
- **Q: Can I use this for connections that are not touching?**
  **A:** Yes, if there is a gap between the beams, increase the `Snap Distance` (dSnap) property to ensure the tool recognizes the intersection.
# hsb_SimpsonETB.mcr

## Overview
Inserts a Simpson Strong-Tie ETB (End Transfer Bracket) to connect two perpendicular beams at a T-connection. It supports vertical positioning adjustment and optional milling to flush-mount the bracket.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model. |
| Paper Space | No | Not designed for layout or detailing views. |
| Shop Drawing | No | Not intended for shop drawing generation. |

## Prerequisites
- **Required Entities**: At least two Beams.
- **Minimum Beam Count**: 2 beams forming a T-connection (perpendicular).
- **Required Settings**: None (uses internal dimension tables and standard CAD DimStyles).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SimpsonETB.mcr` from the list.

### Step 2: Configure Properties
```
Command Line: Properties Palette appears
Action: Adjust the desired bracket Type, Position, and Milling options before selecting beams.
```
*(The Properties Palette will display allowing you to preset the connector specifications.)*

### Step 3: Select Beams
```
Command Line: Select beams:
Action: Click on the beams you wish to connect (e.g., a rim beam and several joists).
Action: Press Enter to confirm selection.
```
*(The script will automatically search for T-connections within the specified snap range and insert the connectors.)*

### Step 4: Adjust Annotation (Optional)
```
Action: Click and drag the square grip point visible near the connector label.
Action: Move to a clear location to avoid overlapping other text.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | dropdown | ETB90-B | Selects the Simpson Strong-Tie model number (ETB90-B to ETB230-B). Determines dimensions and screw layout. |
| Position | dropdown | Middle | Vertical alignment of the bracket on the beam face: Top, Middle, or Bottom. |
| Milling | dropdown | Yes | If 'Yes', cuts a pocket into the secondary beam for a flush-mounted bracket. If 'No', the bracket sits on the surface. |
| Show description | dropdown | Yes | Toggles the visibility of the connector label and leader line. |
| X-flag | number | 200 | Horizontal offset distance for the annotation text from the connection point (mm). |
| Y-flag | number | 300 | Vertical offset distance for the annotation text (mm). |
| IntelliSelect | number | 2000 | The search radius (in mm) used to automatically find intersecting beams when selecting. |
| Dimstyle | dropdown | *Current* | Selects the CAD dimension style to control text size and arrowheads for the label. |
| Color | number | 171 | The AutoCAD color index for the connector model and text. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the connector geometry based on current property changes or beam movements. |
| ShowDialog | Re-opens the properties dialog to quickly edit parameters. |

## Settings Files
- **Filename**: None specified
- **Location**: N/A
- **Purpose**: This script uses internal look-up tables for bracket dimensions. It does not rely on external XML files for configuration.

## Tips
- **Batch Processing**: You can select multiple beams at once during the selection prompt. The script will loop through them and find valid T-connections automatically.
- **Grip Editing**: Instead of typing coordinates for `X-flag` and `Y-flag`, simply select the script in the model and drag the blue square grip to move the label.
- **Milling Depth**: If "Milling" is set to "Yes", ensure your beam is wide enough to accommodate the pocket without compromising structural integrity.

## FAQ
- **Q: Why did the connector disappear after I moved a beam?**
  - A: The script likely detected that the beams are no longer perpendicular. Check the connection angle and use `Recalculate` or ensure the beams meet at 90 degrees.
- **Q: Can I use this for L-shaped corners?**
  - A: No, this script is designed specifically for T-connections (end of one beam meeting the face of another).
- **Q: The text label is too small to read.**
  - A: Change the `Dimstyle` property to a style with larger text settings, or increase the text size in your active CAD dimension style.
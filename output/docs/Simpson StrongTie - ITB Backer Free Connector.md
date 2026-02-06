# Simpson StrongTie - ITB Backer Free Connector

## Overview
This script generates the 3D geometry and machining for Simpson Strong-Tie ITB Backer-Free timber connectors. It is designed to connect a joist perpendicular to a carrying member (header/rim beam) without requiring a backing block.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script creates 3D solids and applies beam cuts. |
| Paper Space | No | This script does not create 2D annotations. |
| Shop Drawing | No | This is a connection generation script for the 3D model. |

## Prerequisites
- **Two Beams**: You must have two `GenBeam` entities (beams).
- **Geometry**: The beams must be perpendicular (90° angle) to each other.
- **Alignment**: The bottom faces of both beams must be on the same level (coplanar).
- **Dimensions**: Beam dimensions must fall within the supported ITB range (Width: 38mm–97mm; Height: approx. 145mm–302mm).

## Usage Steps

### Step 1: Launch Script
Execute the command `TSLINSERT` (or use the hsbCAD insert menu) and select `Simpson StrongTie - ITB Backer Free Connector.mcr`.

### Step 2: Select Male Beam
```
Command Line: Select male beam
Action: Click on the joist (the beam being supported) that will sit inside the hanger.
```

### Step 3: Select Female Beam
```
Command Line: Select female beam
Action: Click on the header or rim beam (the supporting beam) that the hanger will attach to.
```

*Note: Once the second beam is selected, the script automatically calculates the correct Simpson Strong-Tie model based on the beam dimensions and generates the connector.*

## Properties Panel Parameters

After inserting the connector, you can modify these parameters via the AutoCAD Properties Palette (Ctrl+1).

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Model | Dropdown (Calculated) | *Auto-detected* | The specific Simpson Strong-Tie catalog number (e.g., ITB200/40). This is determined automatically based on beam sizes. |
| Male Tolerance | Number | 0 | Allows adjustment if the male beam (joist) width is undersized. Increases the acceptable range for the joist width. |
| Female Tolerance | Number | 0 | Allows adjustment if the female beam (header) height is undersized. Increases the acceptable range for the header height. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add specific custom items to the right-click context menu. Use the Properties Palette to adjust parameters. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external XML settings files. All connector data is embedded within the script.

## Tips
- **Alignment**: Ensure the joist and header are perfectly perpendicular before running the script. If they are slightly off, the script will fail with an error message.
- **Undersized Timber**: If your timber is machined slightly smaller than nominal size and the script reports "Male beam doesn't fit," try increasing the **Male Tolerance** property to force a fit.
- **Visual Check**: After insertion, verify that the hanger flanges sit flush against the side of the joist and the bottom plate is correctly seated.

## FAQ

- **Q: The script says "Beams must be perpendicular." What do I do?**
  A: Use the `Rotate` or `Align` command in AutoCAD to ensure the male beam is exactly 90 degrees relative to the female beam.

- **Q: The script says "Beams bottom faces are not coplanaries."**
  A: Move the beams vertically so that their bottom faces are exactly level with each other. The ITB connector requires the bottom of the joist to be level with the bottom of the header.

- **Q: It says "Female beam doesn't fit in hanger."**
  A: The height of your header beam is likely too tall for the available ITB sizes. Check the Simpson Strong-Tie catalog for maximum heights, or verify you selected the correct beam. If the timber is just slightly undersized, use the **Female Tolerance** property.
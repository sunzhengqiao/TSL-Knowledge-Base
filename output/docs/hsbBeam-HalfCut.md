# hsbBeam-HalfCut

## Overview
Creates a custom angled slot or trench (HalfCut) on a beam face based on user-picked points. It allows precise control over the cut depth, bevel angle, and saw blade thickness alignment (kerf).

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates in the 3D environment. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This is a model generation tool. |

## Prerequisites
- **Required Entities**: A single existing timber beam (GenBeam).
- **Minimum Beam Count**: 1
- **Required Settings**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbBeam-HalfCut.mcr`

### Step 2: Select the Beam
```
Command Line: Select the Beam
Action: Click on the beam in the model where you want to apply the cut.
```

### Step 3: Define Start Point
```
Command Line: Select first point
Action: Click on the beam face to define the start position of the cut.
```

### Step 4: Define End Point
```
Command Line: Select second point
Action: Click on the beam face to define the end position of the cut.
```

*Note: The UCS Z-axis should generally align with the face you are working on for best results.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Depth | number | 70 mm | Defines how deep the cut goes into the material (perpendicular to the face). |
| Angle | number | 0° | Defines the bevel/tilt angle of the cut along its axis. Valid range is -80° to 80°. |
| Side | dropdown | middle | Determines how the 6mm saw blade thickness aligns with the drawn line. Options: `middle` (centered on line), `left`, or `right` (offset to edge of line). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| change direction of cut depth | Flips the cut to the opposite side of the surface plane. This also updates the position of the depth grip. (Can also be triggered by double-clicking the element). |

## Settings Files
- **Filename**: None detected.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Grip Editing**: After insertion, use the visual grips to adjust the cut. Drag the Start/End points to resize the slot, and drag the Depth Handle (Grip 2) to change the depth.
- **Flipping the Cut**: You can quickly flip the cut direction by double-clicking the script entity or using the right-click context menu.
- **Saw Kerf**: If you need the cut to align perfectly with an adjacent part, change the "Side" property to `left` or `right` to offset the 6mm saw blade thickness.
- **Angle Limits**: The system prevents angles greater than +/- 80 degrees to maintain geometric validity. If you enter a larger value, it will automatically reset to 80 degrees.

## FAQ
- **Q: Can I change the cut angle after insertion?**
  - A: Yes, select the element and change the "Angle" property in the Properties Palette (OPM).
- **Q: What happens if I drag the depth grip too far?**
  - A: If you drag the depth grip past the surface plane (through the beam), the cut orientation will automatically flip to the other side.
- **Q: Why did my angle change to 80?**
  - A: The script restricts angles to a maximum of +/- 80 degrees. Any value entered outside this range is automatically clamped.
# FrustrumMill.mcr

## Overview
This script creates a conical (frustum) milling operation on a selected timber beam. It is used to machine tapered counterbores or recesses, typically for seating hardware like cast-in steel shoes or conical anchors.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the 3D model. |
| Paper Space | No | Not applicable for layouts. |
| Shop Drawing | No | This is a model/CNC tooling script. |

## Prerequisites
- **Required Entities**: A single GenBeam (structural timber beam).
- **Minimum Beam Count**: 1.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
```
Command: TSLINSERT
Action: Select FrustrumMill.mcr from the file dialog.
```

### Step 2: Select Reference Beam
```
Command Line: Select GenBeam:
Action: Click on the timber beam you want to apply the mill to.
```

### Step 3: Select Face
```
Action: Move your cursor over the Top or Bottom face of the beam. A preview highlights the valid face.
Click to confirm the face (Top or Bottom) where the mill will be applied.
```

### Step 4: Set Location
```
Action: Move your cursor to position the mill on the face.
- Yellow graphic: Valid position (within beam bounds).
- Red graphic: Invalid position (outside beam bounds).
Click to set the insertion point and finish the placement.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| dDiameter1 | Number | 100 mm | The entry diameter of the mill (width of the hole on the beam surface). |
| dDiameter2 | Number | 120 mm | The base diameter at the bottom of the cut depth. If different from Diameter 1, it creates a conical shape. |
| dDepth | Number | 40 mm | The distance the mill penetrates into the beam perpendicular to the selected face. |
| sFace | String | Bottom Face | Specifies which side of the beam the mill is on (Top Face or Bottom Face). |
| nToolIndex | Integer | 0 | The CNC tool identifier number from your machine's tool library. |
| dToolDiameter | Number | 40 mm | The physical diameter of the cutter used to calculate the toolpath. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Side | Instantly toggles the mill between the Top Face and Bottom Face of the beam. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Visual Feedback**: Pay attention to the color during placement. Yellow indicates the tool is fully inside the material; Red means it is partially or fully outside the beam contour and will be purged.
- **Grip Editing**: You can select the inserted mill and drag the grip point to move it to a new location on the beam face.
- **Undercuts**: Setting Diameter 2 smaller than Diameter 1 creates a tapered hole. Setting Diameter 2 larger than Diameter 1 creates an undercut (wider recess at the bottom).

## FAQ
- **Q: Why did the tool disappear after I placed it?**
  A: The tool likely turned red during placement, indicating it was outside the beam's contour. Ensure the insertion point is placed sufficiently away from the beam edges so the entire diameter fits within the material.
- **Q: Can I mill into the side of the beam?**
  A: No, this script is designed to work only on the Top or Bottom faces relative to the beam's local coordinate system.
- **Q: How do I change the mill from a cylinder to a cone?**
  A: Change the value of `dDiameter2` so it is different from `dDiameter1`.
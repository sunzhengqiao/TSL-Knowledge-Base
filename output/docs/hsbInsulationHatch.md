# hsbInsulationHatch.mcr

## Overview
Generates a 2D graphical representation of insulation hatching (zig-zag pattern) in Model Space. The insulation is automatically trimmed to fit inside a selected bounding polyline (e.g., a wall or roof cross-section).

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script is designed for detailing 3D models or sections in Model Space. |
| Paper Space | No | Not supported for layout viewports. |
| Shop Drawing | No | Not intended for manufacturing outputs. |

## Prerequisites
- **Required Entities**: A closed **Polyline** (existing in the drawing) that will act as the boundary/mask for the insulation.
- **Minimum Beam Count**: 0 (This script works independently of structural beams).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or your company's custom script insert command) → Select `hsbInsulationHatch.mcr`.

### Step 2: Configure Properties (Dialog)
A dialog will appear automatically upon insertion.
- **Action**: Set the desired **Width**, **Side**, **Linetype**, and **Color**.
- **Action**: Click **OK** to confirm.

### Step 3: Set Base Point
```
Command Line: Select base point
Action: Click in the drawing to set the starting corner of the insulation area.
```

### Step 4: Set Direction
```
Command Line: Next point (Defines Direction)
Action: Click a second point to define the length and angle of the insulation strip.
```

### Step 5: Select Boundary
```
Command Line: Select the bounding polyline
Action: Click on the closed polyline (e.g., the wall outline) that defines the area where the insulation should be visible. The hatch will be clipped to this shape.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Width of Insulation | Number | 100 | Sets the physical thickness/width of the insulation strip. If the insulation extends beyond the bounding polyline, it is trimmed. |
| Side | Dropdown | Right | Determines which side of the direction line (defined by the two grip points) the insulation is drawn on. Options: Left, Right. |
| Linetypes | Dropdown | *System Default* | Sets the visual line style for the hatch edges (e.g., Continuous, Hidden). |
| Color | Number | 134 | Sets the AutoCAD color index (ACI) for the insulation pattern. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Side | Toggles the insulation to the opposite side of the grip line (switches between Left and Right). This also updates the 'Side' property automatically. |

## Settings Files
- None used by this script.

## Tips
- **Grip Editing**: You can select the insulation and drag the blue grip points to adjust the start position, length, or direction. The hatch will automatically recalculate.
- **Dynamic Updates**: If you modify the geometry of the selected bounding polyline, the insulation hatch will automatically update to match the new shape.
- **Performance**: Using complex custom linetypes for the insulation pattern may slow down calculation time. For large projects, stick to standard linetypes like "Continuous".

## FAQ
- **Q: Why is my insulation not showing up?**
  **A**: Ensure that the area defined by your width and direction points actually intersects with the bounding polyline you selected. If the insulation area is completely outside the polyline, it will be clipped entirely.
- **Q: How do I make the insulation thicker?**
  **A**: Select the insulation, open the **Properties** palette (Ctrl+1), and increase the value for "Width of Insulation".
- **Q: Can I change the side after inserting?**
  **A**: Yes. You can either right-click the insulation and select "Flip Side", or change the "Side" property in the Properties palette.
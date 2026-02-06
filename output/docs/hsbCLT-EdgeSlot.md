# hsbCLT-EdgeSlot

## Overview
This script creates a parametric slot (groove or housing) on the edge of a CLT panel. It is designed to accommodate connecting members, fittings, or floor joists by machining a precise void into the panel geometry.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script modifies the 3D model geometry directly. |
| Paper Space | No | Not intended for 2D drawings. |
| Shop Drawing | No | Not an annotation script. |

## Prerequisites
- **Required Entities**: A CLT Panel (Sip entity) must exist in the model.
- **Minimum Beam Count**: 0
- **Required Settings**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or `TSLCONTENT` if using a catalog)
Action: Browse and select `hsbCLT-EdgeSlot.mcr`.

### Step 2: Configure Properties
**Dialog:** Properties Dialog
Action: Define the initial dimensions of the slot (Width, Depth, Length) and click OK.
*Note: If using a Catalog Entry, this dialog may be skipped or pre-filled.*

### Step 3: Select Location
```
Command Line: Select panel and insertion point
Action: Click on the desired CLT Panel edge where the slot should be placed.
```
The script will automatically project the slot onto the selected edge.

### Step 4: Adjust Geometry (Optional)
Action: Use the on-screen grip points to fine-tune the position or modify dimensions via the Properties palette.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Width | Number | 8 mm | The width of the slot opening (usually matches the thickness of the material being inserted). |
| Depth | Number | 100 mm | How far the slot penetrates into the panel from the edge surface. |
| Length | Number | 0 mm | The linear length of the slot along the edge. Set to **0** for automatic maximum length. |
| Alignment | Dropdown | Center | Positions the slot relative to the insertion point. Options: Left, Center, Right. |
| Angle | Number | 0° | Applies a slant or bevel to the slot perpendicular to the edge. Must be between -90° and 90°. |
| Rotation | Number | 0° | Rotates the slot around the perpendicular axis. Use **90°** to create a slot parallel to the edge (dado/housing). |
| Axis Offset | Number | 0 mm | Shifts the slot linearly along the edge axis from the clicked point. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| TslDoubleClick | Opens the Properties dialog to allow you to load or save catalog configurations for the slot. |

## Settings Files
- **Filename**: None specified
- **Location**: N/A
- **Purpose**: This script operates using internal properties and standard catalogs.

## Tips
- **Full Length Slot:** Leave the **Length** property set to `0` to automatically calculate the longest possible slot for the selected edge.
- **Edge Housing:** Set **Rotation** to `90°` to machine a slot parallel to the edge, rather than perpendicular.
- **Interactive Editing:**
    - Drag the **Depth Grip** (usually displayed perpendicular to the edge) to change penetration depth.
    - Drag the **Length Grips** (displayed along the edge) to stretch the slot. The insertion point will automatically center between these grips.
- **Angle Limits:** The script will automatically reset the **Angle** to `0` if you enter a value outside the valid range (-90° to 90°).

## FAQ
- **Q: I cannot move the slot along the edge after insertion. Why?**
  **A:** This happens if **Rotation** is set to 90° and **Length** is set to 0 (Auto). In this mode, the slot calculates the full edge length automatically and fixes the position. To enable movement, set a specific **Length** or change the Rotation.
- **Q: How do I create a wedge-shaped slot?**
  **A:** Use the **Angle** property. A positive or negative value (e.g., 5°) will tilt the slot profile.
- **Q: The script disappeared after I clicked.**
  **A:** Ensure you clicked on a valid Sip (CLT) panel. The script deletes itself if the reference entity is invalid.
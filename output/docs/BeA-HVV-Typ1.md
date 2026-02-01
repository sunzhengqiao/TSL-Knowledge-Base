# BeA-HVV-Typ1.mcr

## Overview
This script automates the insertion and configuration of the BeA HVV Type 1 angle bracket for timber beam connections. It supports T-connections between beams, multi-sided wrapping configurations, and attachment to existing detail components.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in 3D Model Space to generate solid bodies and beam cuts. |
| Paper Space | No | Not designed for 2D layout or detailing views. |
| Shop Drawing | No | Does not generate shop drawing views or labels. |

## Prerequisites
- **Required entities**: Timber Beams or existing TslInst entities (specifically `DetailGenBeam`).
- **Minimum beam count**: 1 (However, a T-connection typically requires at least 2 intersecting beams to generate geometry correctly).
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `BeA-HVV-Typ1.mcr` from the file dialog.

### Step 2: Configure Properties
A properties dialog (or the Properties Palette) will appear allowing you to pre-configure the bracket size and insertion mode before selecting objects.

### Step 3: Select Beams
```
Command Line: |Select beams|
Action: Click on the primary timber beam(s).
```
- **If multiple beams are selected**: The script will automatically detect T-connections (perpendicular intersections) and insert brackets at valid intersection points.
- **If a single beam is selected**: The script enters a special mode attaching to that beam, waiting for further logic or manual connection definition.
- **If a TslInst is selected**: The script attaches to the existing detail component, using its dimensions for placement.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Side** (nSide) | dropdown | 1 | Defines the mounting face orientation (Top, Right, Bottom, Left) relative to the beam's cross-section. |
| **Model** (sModel) | dropdown | (First Item) | Selects the specific SKU/size of the bracket (format: Height x Length x Thickness x Width, e.g., 40 x 40 x 2 x 20). |
| **multiple Insertion** (sMulti) | dropdown | |Single Side| | Determines the wrapping configuration: Single Side, Two opposite Sides, Two neighbouring Sides, Three Sides, or Four Sides. |
| **dSnap** | number | 20 | The detection tolerance (in mm) for IntelliSnap to find connecting beams. |
| **sDimStyle** | text | Current Standard DimStyle | Sets the CAD dimension style used if dimensions are generated. |
| **nColor** | number | 254 | Sets the display color index (0-255) for the 3D bracket body. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Assign to...** | Switches the logical assignment of the hardware between the Main beam, the Female (connecting) beam, or their parent Elements/Groups. Updates the BOM hierarchy. |
| **Update** | Forces a manual recalculation of the script. Use this if the underlying beam geometry has changed and the hardware has not updated automatically. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external XML settings files; all configuration is handled via OPM properties.

## Tips
- **Batch Processing**: Select multiple beams at once during insertion to automatically generate brackets for all T-junctions in the selection set.
- **Adjusting Orientation**: If the bracket appears on the wrong side of the beam, change the `Side` property in the Properties Palette to rotate it 90 degrees around the beam axis.
- **Corner Connections**: Use the `multiple Insertion` property set to "Two neighbouring Sides" or "Three Sides" when connecting columns or posts where brackets wrap around the corner.

## FAQ
- **Q: I selected beams, but no brackets appeared. Why?**
  A: The beams may not form a valid T-connection within the `dSnap` tolerance. Ensure the secondary beam physically intersects the main beam. Try increasing the `dSnap` value or moving the beams closer together.
- **Q: How do I change the bracket size after insertion?**
  A: Select the script instance in the drawing, open the Properties Palette (Ctrl+1), and choose a different size from the `Model` dropdown list.
- **Q: Can I use this for non-perpendicular connections?**
  A: This script is optimized for T-connections (perpendicular beams). Results on acute or obtuse angles may be unpredictable.
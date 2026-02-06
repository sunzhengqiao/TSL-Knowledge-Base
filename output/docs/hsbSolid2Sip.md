# hsbSolid2Sip.mcr

## Overview
Converts imported 3D solid geometries (typically from architectural software like Revit or ArchiCAD) into intelligent hsbCAD Structural Insulated Panels (SIPs). The script automatically detects dimensions, orientation, and machining features such as drills and cuts.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D solid selection and panel creation. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities:** A 3DSOLID entity (imported geometry) must exist in the drawing.
- **Minimum beam count:** 0 (This script creates new panels from solids; it does not modify existing beams).
- **Required settings:**
  - `hsbPanelDrill.mcr`: Required for the detection and creation of circular drill holes.
  - **Sip Styles (Panel Styles):** A catalog of predefined panel styles (e.g., thickness, material makeup) must be configured in the hsbCAD environment.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbSolid2Sip.mcr`

### Step 2: Configure Properties
```
Dialog: Properties
Action: Set the Panel Style, Surface Quality (Grade), and Label as needed. Click OK.
```

### Step 3: Select Geometry
```
Command Line: Select entity
Action: Click on the imported 3DSOLID (wall or roof) you wish to convert.
```

### Step 4: Define Orientation
```
Command Line: Specify normal of reference side
Action: Click a point in space to indicate which side of the panel is the "Reference" or "Top" side.
```
*Note: The script calculates the panel's local coordinate system based on this selection. If the panel is created upside down, you can flip it later in the properties.*

### Step 5: Finalize Conversion
```
Action: Right-click on the new Sip entity.
Menu Item: Accept Conversion
```
*This removes the temporary script instance and leaves the finished parametric panel in the model.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Panel Style (sStyleName) | Dropdown | Dynamic | Selects the construction makeup (layers, material) of the SIP. "Dynamic" attempts to auto-select based on the solid's thickness. |
| Surface Quality (sGrade) | Dropdown | Auto | Defines the finish grade (e.g., Visible, Non-Visible, Reference side). Affects visual representation and labels. |
| Label (sLabel) | Text | [Empty] | Production identifier or part number for the panel. |
| Set X-Direction | Vector | Auto-detected | Forces the panel's local X-axis (longitudinal axis) to align with a specific vector direction. |
| Flip Reference Side | Toggle | Unflipped | Swaps the Reference side with the Opposite side. Use this if the panel orientation is inverted. |
| Rotate X-Axis 90 | Toggle | 0 Degrees | Rotates the panel's local coordinate system 90 degrees, effectively swapping the Length and Width. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Accept Conversion | Finalizes the process. It erases the temporary script instance and the original solid reference, leaving only the finished parametric SIP. |
| Properties | Opens the AutoCAD Properties palette to adjust Style, Orientation, and Labels. |

## Settings Files
- **Filename**: `hsbPanelDrill.mcr`
- **Location**: hsbCAD Application path (TslScripts folder)
- **Purpose**: Provides the logic for detecting circular holes in the original solid and converting them into intelligent drill instances on the new panel.
- **Filename**: Sip Styles (Catalog)
- **Location**: Company database or hsbCAD Install path
- **Purpose**: Defines the available options in the "Panel Style" dropdown (thickness, material codes).

## Tips
- **Dynamic Style:** Use the "Dynamic" option for Panel Style if you want the script to automatically match a style based on the thickness of the imported solid.
- **Orientation:** If the panel is generated with the wrong face as the "Top," use the **Flip Reference Side** property instead of re-running the script.
- **Rotation:** Use **Rotate X-Axis 90** to quickly swap the length and width if the panel comes in "sideways."

## FAQ
- Q: Why are my drill holes not appearing on the panel?
  A: Ensure `hsbPanelDrill.mcr` exists in your TSLScripts folder and that the holes in the original solid are perfect cylinders/circles.
- Q: The panel is too thin or too thick compared to the solid.
  A: Check the **Panel Style** property. It may have forced a specific thickness that overrides the solid's dimensions. Select a style that matches the imported geometry.
- Q: How do I align the panel with a specific wall line?
  A: Use the **Set X-Direction** property. Click the picker button and select two points on the line you want to align with.
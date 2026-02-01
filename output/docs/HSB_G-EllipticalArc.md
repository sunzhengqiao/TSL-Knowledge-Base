# HSB_G-EllipticalArc.mcr

## Overview
This script generates a 3D elliptical arc geometry within the hsbCAD model. It is used to create visual references for curved wall plates, roof edges, or other architectural features, with options to define the horizontal span and vertical rise.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates in the 3D model environment. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | This is a model generation tool. |

## Prerequisites
- **Required Entities**: None (Optional: An existing Element if placing relative to one).
- **Minimum beam count**: 0
- **Required settings files**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-EllipticalArc.mcr` from the file dialog.

### Step 2: Define Placement Context
```
Command Line: |Place arc in in Element or <World> UCS|
Action: 
- Type 'E' and press Enter to place the arc inside a specific Element (e.g., a wall or roof).
- Press Enter directly to place the arc in the World Coordinate System (global origin).
```

### Step 3: Select Element (Conditional)
*Only appears if you typed 'E' in the previous step.*
```
Command Line: |Select an element|<Enter> |to place the arc in world ucs|.
Action: Click on the desired Element in the model.
```

### Step 4: Position the Arc
```
Command Line: |Select a position|
Action: Click a point in the drawing area to define the start/anchor point of the arc.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Width** | Number | 1500 mm | The horizontal projection length (major axis) of the elliptical arc. |
| **Height** | Number | 400 mm | The vertical rise (minor axis) of the arc relative to its chord. |
| **Show helper lines** | Dropdown | Yes | Toggles the visibility of red, green, and blue construction lines/circles used to calculate the arc geometry. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add custom items to the right-click context menu. Use standard AutoCAD grips to move the arc. |

## Settings Files
- **Filename**: None required
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Visualizing Geometry**: If the arc does not appear as expected, set "Show helper lines" to **Yes** in the properties. This will display the construction circles and tangent points used to generate the curve, helping you understand how the Width and Height values interact.
- **Quick Adjustments**: You can change the Width and Height immediately after insertion by selecting the arc and typing `PROPERTIES` (or double-clicking the object) to open the Properties Palette.
- **Moving the Arc**: Use the standard AutoCAD **Move** command or drag the visible grips to relocate the arc to a new position.

## FAQ
- **Q: Can I change the arc to fit onto an angled wall?**
  - A: Yes. During insertion (Step 2), type 'E' and select the Element. The script will align the geometry to that Element's local coordinate system.
- **Q: What do the colorful lines represent?**
  - A: These are construction helper lines. They show the geometric calculation of the ellipse. You can hide them by changing "Show helper lines" to **No** in the Properties panel.
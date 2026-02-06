# hsbCLT-X-Fix-L.mcr

## Overview
Automates the creation and detailing of 'X-Fix-L' timber connections (specific dovetail or spline-like joints) between two CLT panels, including geometric cutouts, hardware assignment, and shop drawing annotations.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary environment for creating geometry and assigning hardware. |
| Paper Space | No | Not a layout script. |
| Shop Drawing | No | Generates DimRequests for shop drawings but runs in Model Space. |

## Prerequisites
- **Required Entities**: Two GenBeams (CLT Panels) or an Element containing them.
- **Minimum Beam Count**: 2
- **Required Settings**: `hsbCLT-X-Fix-L.xml` (Loaded from Company or Install path).

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT` (or specific icon) → Select `hsbCLT-X-Fix-L.mcr`

### Step 2: Select Panels
```
Command Line: Select element/beam:
Action: Select the first CLT panel if not pre-selected, then select the second adjacent panel to connect.
```

### Step 3: Position Connection
```
Command Line: Specify location:
Action: Move your cursor along the joint intersection. A dynamic preview (red/yellow profiles) will show the cutout position. Click to place the connection.
```

### Step 4: Configure Properties
```
Action: After placement, the Properties Palette (OPM) opens automatically. Select the desired 'Type' preset or adjust dimensions (Width, Depth) as needed.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | String | `<_Default>|` | Selects the predefined configuration preset (e.g., specific size or profile variant) from the XML settings. |
| Shape | Geometry | Current Shape | Defines the 2D cross-sectional geometry of the cutout. Select "Select Shape" to load a custom profile. |
| MaxLength | Number | from settings | The maximum allowed length of the connection along the panel edge. |
| XWidth | Number | from settings | The width of the connection profile measured perpendicular to the joint direction. |
| ZDepth | Number | from settings | The depth of the cut into the timber panel (penetration depth). |
| ToolIndex | Number | from settings | Reference to a specific tool catalog entry or hardware variant index. |
| TextHeight | Number | U(60) | Height of the dimension/label text in shop drawings. |
| YOffsetText | Number | dTextHeight | Vertical offset distance from the center of the connection to the text label in shop drawings. |
| ColorText | Number | nc | Display color of the text label (AutoCAD Color Index). |
| HiddenLine | Boolean | from settings | Toggles visibility of projected lines (edges behind the panel) in specific views. |
| ColorHidden | Number | from settings | Color assigned to hidden projection lines. |
| LineType | String | from settings | Linetype (e.g., Dashed, Hidden) used for projection lines. |
| ShowTooling | Boolean | True | If True, displays 3D tool bodies. If False, generates 2D polylines (shadows) for drawings. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Setup | Opens the configuration dialog to modify script settings or presets. |
| Update | Recalculates the connection geometry based on current panel positions. |
| Erase | Removes the script instance and associated geometry. |

## Settings Files
- **Filename**: `hsbCLT-X-Fix-L.xml`
- **Location**: Company or Install path
- **Purpose**: Contains presets for different connection types, defining default dimensions (MaxLength, XWidth, ZDepth), tool indices, and shape profiles.

## Tips
- **Moving the Connection**: Select the script instance in the model and use the square grip point to slide the connection along the panel edge without deleting and re-inserting.
- **Shop Drawings**: If the 3D tool body interferes with your view, set `ShowTooling` to False. The script will generate clean 2D polylines in the shop drawing views instead.
- **Custom Profiles**: Use the `Shape` property to browse for a custom `.pf` (PlaneProfile) file if the standard presets do not meet your design requirements.

## FAQ
- **Q: Why are my cutouts not appearing?**
  - A: Check if the `ShowTooling` property is set to False. If set to False, the 3D geometry is hidden, but lines will appear in generated shop drawings.
- **Q: Can I connect panels that are not perfectly aligned?**
  - A: The script supports parallel, mitred, or T-connected panels. Ensure you select the correct two panels during the insertion phase.
- **Q: How do I change the hardware description?**
  - A: Modify the `Type` property to load a different preset, or manually adjust the `ToolIndex` if you know the specific catalog number required.
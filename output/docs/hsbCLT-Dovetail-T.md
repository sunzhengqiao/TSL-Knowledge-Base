# hsbCLT-Dovetail-T.mcr

## Overview
This script creates a dovetail joint or butterfly spline connection between timber panels (CLT or solid timber) arranged in a T-configuration. It mechanically joins intersecting walls or floors by cutting corresponding male and female profiles or pockets for spline inserts.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script generates 3D geometry and cuts directly on the panels. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Does not generate drawing views or dimensions. |

## Prerequisites
- **Required Entities**: At least two Panels (Sip entities).
- **Minimum Count**: 1 Male panel and 1 Female panel (must intersect).
- **Settings Files**: None required.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-Dovetail-T.mcr`

### Step 2: Select Male Panel(s)
```
Command Line: |Select male panel(s)
Action: Click on the panel(s) that will form the first part of the connection (typically the "through" or "main" part). Press Enter to confirm.
```

### Step 3: Select Female Panel(s)
```
Command Line: |Select female panel(s)
Action: Click on the intersecting panel(s) that will receive the connection (typically the "stopped" part). These must be perpendicular to the male panels.
```

### Step 4: Configure Properties
After selection, the script inserts. Open the **Properties Palette** (Ctrl+1) to adjust dimensions, gaps, and connection type.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| (A) Width | Number | 50 | Defines the width of the connection (lap depth). Set to 0 for automatic 50% of panel thickness. |
| (B) Depth | Number | 20 | Defines how deep the cut goes into the panel thickness. |
| (C) Angle | Number | 0 | Defines the dovetail angle. 0° creates a rectangular spline; higher angles create a locking dovetail. |
| (D) Gap | Number | 0 | Adds clearance in the depth direction (e.g., for glue tolerance). |
| (E) Axis Offset X | Number | 0 | Shifts the connection horizontally along the intersection line. |
| (F) Bottom Offset | Number | 0 | Stops the cut before the bottom edge (0 = cut all the way through). |
| (G) Open Tool Side | Dropdown | bottom | Determines how the tool handles different panel heights: `bottom`, `top`, or `Both` (full overlap). |
| (H) Connection Type | Dropdown | Dovetail | Switches between `Dovetail` (Male/Female cut) or `Butterfly Spline` (Pockets on both sides + hardware). |
| (I) Chamfer (Ref) | Number | 0 | Adds a chamfer on the reference side of the joint. |
| (J) Chamfer (Opp) | Number | 0 | Adds a chamfer on the opposite side of the joint. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add specific custom items to the right-click context menu. Edit properties via the palette. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Automatic Width**: If you are unsure of the exact width needed, set **Width** to `0`. The script will automatically calculate 50% of the panel's thickness.
- **Butterfly Spline**: When switching to **Butterfly Spline** mode, the script automatically generates an "X-fix L" hardware component in the BOM.
- **Vertical Alignment**: If your intersecting panels have different heights, use the **Open Tool Side** property. Set to `Both` to ensure the cut spans the entire overlapping area.
- **Angle**: Use a non-zero **Angle** (e.g., 5-10 degrees) if you want a mechanically interlocking dovetail that resists pull-out.

## FAQ
- **Q: Why did my joint not generate?**
  - **A**: Ensure the selected panels are perpendicular (T-shape). Parallel panels or panels that do not physically intersect will be filtered out.
- **Q: What is the difference between Dovetail and Butterfly Spline modes?**
  - **A**: **Dovetail** mode cuts a tenon on the male panel and a mortise on the female panel. **Butterfly Spline** mode cuts a mortise (pocket) on *both* panels and generates a separate spline hardware piece for connection.
- **Q: How do I prevent the cut from going all the way through the panel?**
  - **A**: Increase the **Bottom Offset** value. This stops the tool the specified distance from the bottom edge of the panel.
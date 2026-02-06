# hsbPanelBeamcut.mcr

## Overview
Automatically creates cutouts or openings in structural timber panels (SIPs/CLT) to accommodate intersecting beams or tooling solids. This script handles both notches (partial cuts) and through-holes, with configurable clearance gaps to ensure proper fit.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D Panel and Beam geometry. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Not applicable. |

## Prerequisites
- **Required Entities**: At least one Panel (Sip) and one intersecting Entity (GenBeam or Tooling Solid).
- **Minimum Beams**: 1 intersecting beam or solid.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbPanelBeamcut.mcr` from the file dialog.

### Step 2: Configure Properties
```
Command Line: (Properties Dialog appears)
Action: Adjust the Tool Mode and Clearance Gaps in the dialog that appears, then click OK.
```
*Note: If launched via a catalog key, this step may be skipped.*

### Step 3: Select Panels
```
Command Line: Select Panel(s)
Action: Click on the panel(s) (Sip) where you want the cutout to occur and press Enter.
```

### Step 4: Select Tooling Solids
```
Command Line: Select Tooling Solid(s)
Action: Click on the beam or solid that passes through the panel and press Enter.
```
The script will now calculate the intersection and apply the cut to the panel.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Tool Mode | dropdown | Auto | Determines how the cut is applied.<br>**Auto**: Detects if the cut goes fully through the panel (Vertex Adjustment) or is a partial notch (Beamcut).<br>**Beamcut**: Forces a standard rectangular notch.<br>**Vertex Adjustment**: Forces a modification of the panel's envelope edges (for through-holes). |
| Gap X | number | 0 | Clearance on the Positive side of the Beam's Local X-axis (length direction). |
| Gap Y | number | 0 | Clearance on the Positive side of the Beam's Local Y-axis (width direction). |
| Gap Z | number | 0 | Clearance on the Positive side of the Beam's Local Z-axis (height direction). |
| Gap -X | number | 0 | Clearance on the Negative side of the Beam's Local X-axis (length direction). |
| Gap -Y | number | 0 | Clearance on the Negative side of the Beam's Local Y-axis (width direction). |
| Gap -Z | number | 0 | Clearance on the Negative side of the Beam's Local Z-axis (height direction). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are added by this script. Use the Properties Palette to modify settings. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Use "Auto" Mode**: Keep the Tool Mode set to "Auto" to let the script intelligently decide between creating a through-hole (Vertex Adjustment) or a notch (Beamcut) based on whether the beam penetrates the entire panel.
- **Asymmetric Gaps**: You can set different values for positive (+X) and negative (-X) gaps. This is useful if you need a tight fit on one side of the beam but extra clearance on the other.
- **Moving Geometry**: If you move the beam or the panel using AutoCAD grips or the Move command, the script will recalculate and update the cutout automatically.

## FAQ
- **Q: What is the difference between "Beamcut" and "Vertex Adjustment"?**
  - A: "Beamcut" adds a separate cutting object (like a router toolpath) to the panel, typically used for notches where the beam doesn't go all the way through. "Vertex Adjustment" physically reshapes the panel's 3D body, typically used for holes where the beam passes completely through.
- **Q: Why did my panel not get cut?**
  - A: Ensure the beam or tooling solid actually physically intersects the 3D volume of the panel. If they are just touching or have a gap without intersection, the script will not generate a cut.
- **Q: Can I use this for circular beams?**
  - A: Yes, the script calculates based on the intersection body, so it handles generic solid shapes, not just rectangular beams.
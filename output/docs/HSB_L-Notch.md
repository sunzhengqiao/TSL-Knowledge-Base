# HSB_L-Notch

## Overview
Automates the connection between structural beams (joists, purlins, or rafters) and a log wall. It creates a precise L-notch on the beam and cuts a matching hole in the log wall, automatically splitting the logs if the remaining material is too narrow.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script modifies 3D beam geometry and must be used in the model. |
| Paper Space | No | Not designed for 2D drawing generation. |
| Shop Drawing | No | Not a shop drawing annotation script. |

## Prerequisites
- **Required Entities**: One `Element` (representing the log wall) and one or more `Beam` entities (the beams to be inserted).
- **Minimum Beam Count**: 1.
- **Geometric Constraint**: The selected beams must generally intersect the log wall perpendicularly for the tool to calculate the intersection correctly.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_L-Notch.mcr` from the catalog or file list.

### Step 2: Configuration (Optional)
If the script is run manually (without a predefined catalog entry), a dialog box may appear asking for default Notch and Gap dimensions. If run from a catalog, these settings are loaded automatically.

### Step 3: Select Log Wall
```
Command Line: Select element:
Action: Click on the log wall (Element) where the beam will be inserted.
```

### Step 4: Select Beams
```
Command Line: Select beams:
Action: Select the beam(s) (e.g., joists or purlins) that need to be notched and fitted into the wall. Press Enter to confirm selection.
```

### Step 5: Processing
The script will automatically calculate the intersection, notch the selected beams, and apply cuts or splits to the log wall logs.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| dDepthLeft | Double | 7 mm | Depth of the horizontal shoulder cut on the left side of the beam. |
| dDepthRight | Double | 7 mm | Depth of the horizontal shoulder cut on the right side of the beam. |
| dDepthTop | Double | 7 mm | Depth of the vertical shoulder cut at the top of the beam. |
| dDepthBottom | Double | 7 mm | Depth of the vertical shoulder cut at the bottom of the beam. |
| dDepthFront | Double | 0 mm | Additional penetration depth into the wall towards the "front" (local -X). |
| dDepthBack | Double | 0 mm | Additional penetration depth into the wall towards the "back" (local +X). |
| offsetBeamCutBottomLeft | Double | 0 mm | Reduces the width of the bottom cutout starting from the left edge. |
| offsetBeamCutBottomRight | Double | 0 mm | Reduces the width of the bottom cutout starting from the right edge. |
| dGapLeft | Double | 1 mm | Clearance space between the beam and the hole on the left side. |
| dGapRight | Double | 1 mm | Clearance space between the beam and the hole on the right side. |
| dGapTop | Double | 1 mm | Clearance space between the beam and the hole at the top. |
| dGapBottom | Double | 1 mm | Clearance space between the beam and the hole at the bottom. |
| dSplitMargin | Double | 15 mm | Minimum remaining material width required in the log to prevent splitting. If material is thinner than this, the log is split. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Update | Recalculates the notch and wall cuts based on current property values or beam positions. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A (All settings are managed via the Properties Panel).

## Tips
- **Perpendicularity**: Ensure the beams intersect the log wall element as close to 90 degrees as possible. If the script fails to find an intersection, check the alignment.
- **Tolerances**: Use the `Gap` properties (Left, Right, Top, Bottom) to account for wood shrinkage or to ensure easier assembly on site.
- **Splitting vs. Holes**: If you want the log wall to remain as continuous beams where possible, increase the `dSplitMargin`. If you prefer the logs to be cut through for better stability, decrease it.
- **Offsets**: Use `offsetBeamCutBottom...` parameters if you need to reduce the bearing surface width at the bottom of the notch without changing the main depth dimensions.

## FAQ
- **Q: Why did the script split my log wall beam instead of just cutting a hole?**
  **A**: The script calculates the remaining material width next to the notch. If this width is smaller than the `dSplitMargin` property (default 15mm), it automatically splits the log to prevent leaving a fragile sliver of wood.
- **Q: The script reports "Not possible to find intersection". What is wrong?**
  **A**: Ensure the beam actually passes through the volume of the log wall Element and that the beam is roughly perpendicular to the wall surface.
- **Q: How do I make the notch go deeper into the wall?**
  **A**: Increase the `dDepthFront` and `dDepthBack` properties. This extends the notch length along the beam axis into the wall.
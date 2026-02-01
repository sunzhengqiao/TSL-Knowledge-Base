# DrillPatternDimension.mcr

## Overview
This script automates the dimensioning of drill hole patterns on beams, multipages, and shop drawings. It provides tools to display hole spacing (Delta) or cumulative distances (Chain) and supports manual adjustments for optimal layout.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Can dimension GenBeams directly. |
| Paper Space | Yes | Can dimension Multipages and Shop Drawings. |
| Shop Drawing | Yes | Fully compatible with Element and ChildPanel entities. |

## Prerequisites
- **Required Entities**: `GenBeam`, `Element`, `Multipage`, or `ChildPanel`.
- **Minimum Beam Count**: 0 (Selection depends on the target entity type).
- **Required Dependencies**: `hsbGeoPattern.dll` must be available.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `DrillPatternDimension.mcr`

### Step 2: Select Entity
```
Command Line: Select genbeams, multipages or childpanels
Action: Click on the beam, multipage sheet, or childpanel you wish to dimension.
```

### Step 3: Adjust Configuration
```
Action: After selection, the script generates the dimension lines. Use the Properties Palette to adjust scale, text height, or direction vectors.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| DeltaOnTop | Integer | 0 | Toggles dimension mode. **0** displays cumulative distances (Chain), **1** displays individual spacing (Delta). |
| vecDir | Vector | Calculated | Sets the primary direction vector for the dimension line alignment. |
| vecPerp | Vector | Calculated | Sets the perpendicular vector (offset) controlling the distance of the dimension line from the holes. |
| Scale | Double | 1.0 | Scales the dimension components (arrows, text) to match the drawing scale. |
| textHeight | Double | 0 | Overrides the default text height (in mm). Set to 0 to use the standard dimension style settings. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Delta <> Chain | Toggles between displaying individual hole spacing and cumulative chain dimensions. |
| Reset Modifications | Clears any manually removed points or drill locations, restoring the full pattern. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not use external XML settings files; it relies on entity properties and internal logic.

## Tips
- **Drawing Clarity**: If dimension lines appear cluttered, try setting `DeltaOnTop` to 1 to show individual spacings, or use `Scale` to adjust the size of annotations relative to the view.
- **Paper Space**: When working in shop drawings, ensure the script is inserted onto the correct `Element` or `ChildPanel` to capture the specific drill pattern for that view.
- **Offset Adjustments**: If the dimension text overlaps the beam geometry, modify the `vecPerp` vector to push the dimension line further away from the material.

## FAQ
- **Q: Can I use this script on a standard beam in Model Space?**
  A: Yes, you can select a `GenBeam` directly in Model Space to dimension its drill patterns.

- **Q: What happens if I change the scale of my drawing?**
  A: Update the `Scale` property in the Properties Palette to ensure the dimension text and arrows remain legible at the new scale.

- **Q: How do I restore a drill point I accidentally deleted from the dimension?**
  A: Right-click the script instance and select **Reset Modifications** to restore all points.
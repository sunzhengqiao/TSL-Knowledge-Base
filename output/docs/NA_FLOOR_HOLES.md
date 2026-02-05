# NA_FLOOR_HOLES

## Overview
This script creates customized cutouts, holes, and text labels on floor sheathing (sheets). It includes options to automatically drill through underlying floor joists and snap to joist centerlines for precise placement.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for selecting Floor Elements and placing points. |
| Paper Space | No | Script operates on 3D model entities. |
| Shop Drawing | No | Modifications occur in the model, which update drawings automatically. |

## Prerequisites
- **Required Entities**: A Floor Element containing Sheets (sheathing).
- **Minimum Beam Count**: 0 (Script works on sheets, but optional joist drilling requires joists).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or custom alias) → Select `NA_FLOOR_HOLES.mcr`

### Step 2: Configure Hole Settings
```
Interface: Dynamic Dialog
Action: Select the desired Hole Type, Orientation, and Drill settings. Click OK to confirm.
```

### Step 3: Select Floor Element
```
Command Line: Select an floor element
Action: Click on the Floor Element (panel) where you want to place the hole.
```

### Step 4: Select Insertion Point
```
Command Line: Select insertion point
Action: Click on the surface of the floor to place the hole. The script will automatically project the point onto the floor plane.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Hole type | dropdown | 2-1"Drills Spaced at 3-3/4" | Select the profile for the cutout. Options include Drill pairs, Circles, Ellipses, Diamonds, Rectangles, Squares, or Text labels. |
| Orientaion of Hole | dropdown | Joist Direction | Aligns the hole rotation relative to the floor joists. Options: "Joist Direction" or "Perpendicular to Joist Direction". |
| Additional Rotation | number | 0 | Fine-tunes the angle of the hole in degrees (0-360). |
| Text Output | text | TEXT | The text string to display on the sheet when "Text" is selected as the Hole type. |
| Add Drill to Joist | dropdown | Yes | If "Yes", the script searches for joists beneath the hole and adds a drill operation to them. |
| Drill Diameter | number | 1.5 | The diameter (in inches) of the hole to drill through the joists (if enabled). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | This script does not use specific right-click context menu triggers. All modifications are made via the Properties Palette or Grip Editing. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Snapping to Joists**: If you drag the script's insertion point (Grip Edit) after placement, it will automatically snap to the centerline of the nearest floor joist.
- **Switching to Text**: If you only need a label and not a physical hole, change "Hole type" to "Text" and update the "Text Output" property.
- **Perpendicular Adjustments**: Use the "Orientaion of Hole" property to quickly rotate the cutout 90 degrees relative to the joists without calculating angles manually.

## FAQ
- **Q: The hole appears in the sheet but not the joist. Why?**
- **A:** Check the "Add Drill to Joist" property in the palette. It must be set to "Yes". Also, ensure the insertion point is actually intersecting a joist (try dragging the point to trigger the snap).
- **Q: Can I use this for circular HVAC vents?**
- **A:** Yes, select one of the "Circular Hole" options in the "Hole type" dropdown.
- **Q: How do I rotate a rectangular hole?**
- **A:** Use the "Additional Rotation" property to specify a specific angle, or change "Orientaion of Hole" to toggle between the two main axes.
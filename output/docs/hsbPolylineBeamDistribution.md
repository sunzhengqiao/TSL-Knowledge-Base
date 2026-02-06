# hsbPolylineBeamDistribution.mcr

## Overview
Generates a distribution of structural beams (such as rafters or joists) spanning between two user-selected polylines. It accommodates non-parallel boundaries and variable angles, automatically calculating end cuts to match the wall lines.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script generates new beams directly in the 3D model. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: Two Polylines existing in the Model Space to define the boundaries.
- **Minimum Beam Count**: 0.
- **Required Settings**: None (script properties can be set manually or via catalog).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbPolylineBeamDistribution.mcr` from the list.

### Step 2: Select Boundary Polylines
```
Command Line: Select 2 polylines
Action: Click on the first polyline in your drawing that defines one side of the roof or floor area.
```

### Step 3: Select Second Polyline
```
Command Line: Select second polyline
Action: Click on the second polyline that defines the opposite boundary.
```

### Step 4: Define Direction
```
Command Line: Select point in rafter direction
Action: Click a point in the model to define the direction the beams should run towards (this sets the vector for the distribution).
```

### Step 5: Configure Properties
A dialog will appear (if not using a catalog preset) to set initial dimensions. You can also modify these later in the Properties Palette.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Width** | Number | 60 | The cross-sectional width (thickness) of the individual beams (mm). |
| **Height** | Number | 200 | The cross-sectional height (depth) of the individual beams (mm). |
| **Interdistance** | Number | 500 | The spacing (center-to-center) between adjacent beams (mm). |
| **Mode** | Dropdown | Even Distribution | **Even Distribution**: Divides the total span into equal parts based on the interdistance.<br>**Fixed Distribution**: Places beams strictly at the specified interdistance, potentially leaving a remainder at the end. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | No specific context menu options are defined for this script. Use the Properties Palette to modify settings. |

## Settings Files
- **Filename**: *None specified*
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Automatic Updates**: This script uses "dependency" logic. If you use AutoCAD grips to stretch or move the input polylines, the beams will automatically update their length and end cuts to match.
- **Grip Editing**: You can select the script instance to view its origin and direction grips. Moving these allows you to rotate or reposition the entire distribution layout.
- **Mode Selection**: Use "Even Distribution" when you need the beams to fill the space exactly without a small partial gap at the end. Use "Fixed Distribution" if strict spacing (e.g., standard joist spacing) is more important than filling the exact width.

## FAQ
- **Q: What happens if I change the Width property?**
  A: The script recalculates the layout. Since the beam width is subtracted from the span, increasing the width reduces the available space for spacing.
- **Q: Can I use this for curved walls?**
  A: Yes. The script calculates intersections based on the polylines, so if the polylines are curved or angled, the beams will be generated with matching end cuts.
- **Q: My beams disappeared after I changed a property.**
  A: This usually happens if the new settings (like Interdistance) result in zero beams fitting in the space, or if the Interdistance is set to 0 or negative. Check the Property values and ensure the boundaries are still valid.
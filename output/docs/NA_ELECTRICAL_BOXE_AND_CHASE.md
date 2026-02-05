# NA_ELECTRICAL_BOXE_AND_CHASE.mcr

## Overview
Automates the placement and milling of electrical boxes (outlets, switches, vents) and vertical wiring chases within timber framing beams or walls. It generates 3D visual representations, applies milling operations to the structure, and can automatically create reinforcement blocking for heavy fixtures.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Must be used on structural beams or studs in 3D model. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Not applicable for drawings. |

## Prerequisites
- **Required entities**: GenBeam (e.g., Wall studs, floor joists, rafters).
- **Minimum beam count**: 1.
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `NA_ELECTRICAL_BOXE_AND_CHASE.mcr`

### Step 2: Select Structural Beam
```
Command Line: Select element
Action: Click on the wall stud or beam where you want to install the electrical box.
```

### Step 3: Select Electrical Type
```
Command Line: [Dialog Appears]
Action: Select the fixture type from the list (e.g., "Std receptacle", "Dryer", "Switch", "Fan").
Note: This selection automatically sets the default dimensions (width, height) and elevation.
```

### Step 4: Position and Configure
```
Action: The script inserts based on default logic. Use the Properties Palette to fine-tune the position (Elevation), Side (which face of the beam), and Chase direction (Up/Down).
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **strType** | Dropdown | *Varies* | Select the electrical category (e.g., Receptacle, Switch, Dryer). Changing this updates width, height, and elevation automatically. |
| **dWidhts** | Number (inch) | 2.0 | The horizontal width of the electrical box opening. |
| **dHeights** | Number (inch) | 3.0 | The vertical height of the electrical box opening. |
| **dElevations** | Number (inch) | 16.0 | Height of the box from the floor (positive) or ceiling (negative). |
| **nReferencePoints** | Integer | -1 | Reference point for Elevation (-1=Bottom of box, 0=Center, 1=Top of box). |
| **dDistanceFromBm** | Number (inch) | 0 | Setback from the face of the beam (positive = out, negative = in). |
| **nChaseDir** | Integer | 0 | Direction of the wiring chase (-1 = Down, 0 = None, 1 = Up). |
| **dChaseRadius** | Number (inch) | 0.5 | Radius of the vertical wiring chase hole. |
| **nSide** | Integer | 0 | Index of the beam face where the box is mounted. |
| **dBlockL** | Number (inch) | *Variable* | Length of the blocking beam (used for Dryer/Range reinforcement). |
| **dBodyDepth** | Number (inch) | 3.0 | Visual depth of the 3D box representation. |
| **dSpecialHoleDiameter** | Number (inch) | 1.0 | Diameter for simple pass-through holes (used for Exterior GFI/Brick). |
| **nDirFromBeam** | Integer | 1 | Orientation along the beam length (1 or -1). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Create Blocking** | Manually inserts a solid lumber blocking beam (1.5" wide) to reinforce the opening. Typically used for Dryers, Ranges, or Valences where the box requires structural support. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: Uses internal logic and defaults; no external XML settings file required.

## Tips
- **Elevation Logic**: If you enter a positive `dElevations`, it measures from the bottom plate up. If you enter a negative value, it measures from the top plate down.
- **Visual Geometry**: The script draws an Octagon shape for "Stucco" or "Interior Light Fix" types, and a Rectangle for standard receptacles.
- **Exterior Fixtures**: For "Exterior GFI" or "Brick" types, the script mills a simple round hole instead of a full rectangular box pocket.
- **Updating Types**: If you change the `strType` property after insertion, the dimensions (Width/Height/Elevation) will update to match the new standard, but manual overrides will be lost.

## FAQ
- **Q: Why didn't the script create a blocking beam?**
  - **A:** Blocking is only created automatically during insertion for specific types like "Dryer", "Range", or "Valence". If you need it for other types, right-click the script instance and select "Create Blocking".
- **Q: Can I adjust the box size manually?**
  - **A:** Yes. Modify `dWidhts` or `dHeights` in the Properties Palette. Note that if you subsequently change the `strType`, your manual values will be overwritten by the type's defaults.
- **Q: The wire chase isn't going through the top plate.**
  - **A:** Ensure `nChaseDir` is set to `1` (Up) and verify that the `dChaseRadius` is large enough. The chase drills relative to the selected beam; if the plate is a separate beam, ensure alignment or check if the drill depth reaches the intersection.
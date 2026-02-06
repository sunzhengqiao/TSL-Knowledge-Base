# Stellbrett Verteilung

## Overview
Generates blocking (nogging) between rafters or cuts grooves into them. It positions the elements relative to a roof plane and a reference boundary defined by a wall, plate, or point.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Requires 3D geometry (Roof Planes, Beams). |
| Paper Space | No | Not designed for 2D layouts. |
| Shop Drawing | No | Not a shop drawing annotation script. |

## Prerequisites
- **Roof Plane**: An existing `ERoofPlane` entity.
- **Rafters**: Structural beams (GenBeam) representing the rafters.
- **Reference Object**:
  - Mode "Wall or Polyline": An Element (Wall) or Polyline.
  - Mode "Plate": A GenBeam acting as a plate.
  - Mode "Point": A 3D point in space.
- **Settings**: No specific settings files required.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Stellbrett Verteilung.mcr`

### Step 2: Configure Properties
A dialog appears automatically upon insertion.
Action: Set initial parameters like **Thickness**, **Mode**, and **Height of Blocking**. Click OK to proceed.

### Step 3: Select Roof Plane
```
Command Line: select roofplane
Action: Click on the ERoofPlane entity that defines the roof slope.
```

### Step 4: Select Rafters
```
Command Line: select rafter(s)
Action: Select the rafters (GenBeams) where blocking is needed. You can select multiple rafters.
```

### Step 5: Select Reference Object
The prompt changes based on the **sMode** property selected in Step 2.
```
Mode: Wall or Polyline
Command Line: select wall or polyline
Action: Click a wall element or a polyline defining the start edge.

Mode: Plate
Command Line: select plate
Action: Click the plate beam (GenBeam) defining the start edge.

Mode: Point
Command Line: Point
Action: Click a specific 3D point in the drawing to define the start location.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **sMode** | dropdown | Wall or Polyline | Determines how the start position is defined. Options: Wall or Polyline, Plate, Point. |
| **dWidth** | number | 19 mm | Thickness of the blocking timber. |
| **dDepth** | number | 4 mm | Depth of the groove cut into the rafters. |
| **dGapAtSide** | number | 1 mm | Lateral clearance between the blocking and rafters. |
| **dGapLength** | number | 1 mm | Longitudinal clearance at the ends of the blocking. |
| **dOffset** | number | 0 mm | Displacement of the blocking along the roof slope from the reference. |
| **dTrauf** | number | 0 mm | Thickness of the eaves/sheathing layer (Traufschalung). |
| **dBlockingHeight** | number | 190 mm | Height of the blocking element. |
| **sCalcBlocking** | dropdown | No | If 'Yes', calculates blocking height automatically based on geometry. |
| **sOrient** | dropdown | Perpendicular to RCS | Reference axis for height. 'Perpendicular to RCS' is plumb to roof; 'Perpendicular to WCS' is true vertical. |
| **sToBeams** | dropdown | No | If 'Yes', creates real structural beams (GenBeams). If 'No', creates visual bodies and cuts grooves. |
| **sName** | text | Stellbrett | Name assigned to generated beam entities. |
| **sMat** | text | Dreischicht | Material specification. |
| **sGrade** | text | BC | Timber grade/strength class. |
| **nColor** | number | 170 | Display color index of the generated elements. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the script geometry based on current property values or changes in linked elements (Roof/Rafters). |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies on internal properties and drawing geometry; no external settings file is required.

## Tips
- **Converting to Beams**: To generate actual timber pieces for production/BOM, set the **sToBeams** property to 'Yes'. This replaces the script instance with individual beam elements.
- **Mode Limitations**: After inserting the script, you can only switch the **sMode** to 'Point'. Switching back to 'Wall' or 'Plate' mode is blocked by the script logic.
- **Automatic Height**: Use **sCalcBlocking** set to 'Yes' to let the script determine the correct blocking height based on the roof plane, which helps avoid errors on complex roof pitches.
- **Clearance**: Use **dGapAtSide** and **dGapLength** to ensure easy assembly by adding slight tolerances to the cut grooves.

## FAQ
- **Q: The script reports "Height of Blocking invalid". What should I do?**
  A: Check the **dBlockingHeight** value. Ensure it is positive and large enough for the geometry. Alternatively, enable **sCalcBlocking** to calculate it automatically.
- **Q: Why can't I switch to 'Plate' mode in the properties palette?**
  A: The script allows switching to 'Point' mode after insertion to allow adjustments, but switching back to Wall/Plate requires re-inserting the script or specific link handling which is restricted.
- **Q: The blocking is cutting through my rafters incorrectly.**
  A: Verify the **dDepth** (groove depth) and **dWidth** (thickness) settings. Ensure the rafters are actually intersecting the calculated reference plane.
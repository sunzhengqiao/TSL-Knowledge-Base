# HSB_W-Lifting.mcr

## Overview
This script automates the calculation and generation of lifting points for Wall and Roof elements. It calculates the optimal number of lifting points based on element weight/length, applies drilling or cutout operations to studs and plates, and generates visualizations of the lifting ropes in 3D.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for geometry generation and 3D visualization. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: One or more hsbCAD Wall or Roof Elements containing structural members (studs/plates).
- **Minimum Beams**: At least one stud or plate matching the filter criteria.
- **Required Settings**: None (Script uses internal logic and properties).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_W-Lifting.mcr` from the list.

### Step 2: Select Elements
```
Command Line: Select a set of elements
Action: Click on the Wall or Roof elements you wish to process and press Enter.
```

### Step 3: Configure and Visualize
Once inserted, the script will automatically:
1. Filter the studs/plates based on default or user-set properties.
2. Calculate 2 or 4 lifting points based on the element's weight and length.
3. Generate dynamic lines in the model representing the lifting ropes.
4. Apply the selected tooling (drills or cuts) to the beams.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Pos 1 (TSL Identifier) | String | - | A unique identifier for this script instance. Change this if you get a duplicate error. |
| Filter beams with beamcode | String | - | Only studs/plates with this BeamCode/Label will be processed. Leave empty to include all. |
| Tooling | Dropdown | Drill Stud and Topplate | Selects how the lifting points are applied: Drill Stud and Topplate, Drill Stud only, Side Cuts (rectangular notches), or None. |
| Centerpoint for drills | Dropdown | Element Center | Determines the reference origin for lifting points. Can be the Element center or a specific Beam center. |
| Beamcode to center drills | String | - | If Centerpoint is set to "Beam", enter the code of the specific beam to use as the reference. |
| Symmetric/Asymmetric | Dropdown | Symmetric | Sets the calculation logic. Symmetric places points evenly from the center; Asymmetric allows for offset variations. |
| Offset from center point | Number | Calculated | The distance from the reference center to the lifting points. |
| Horizontal offset drill | Number | 0 | Lateral shift of the drill hole/cut relative to the stud center. |
| Vertical offset drill | Number | Calculated | Vertical height of the hole relative to the beam reference. |
| Stud drill reinforcement | Yes/No | No | If Yes, generates reinforcement plates at the drill locations on studs. |
| Reinforcement Width | Number | Auto (0) | Width of the reinforcement plate. 0 uses the stud width. |
| Reinforcement Height | Number | Auto (0) | Height of the reinforcement plate. 0 uses the vertical offset distance. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Update / Recalculate | Refreshes the lifting point calculations based on current property values or element changes. |
| Grip Edit | (If enabled) Allows dragging the lifting points manually in the model view to custom locations. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: This script operates entirely based on Element geometry and Properties Palette settings.

## Tips
- **Heavy Elements**: The script automatically switches to 4 lifting points for elements that exceed specific weight or length thresholds.
- **Avoiding Collisions**: If your drill holes are missing or intersecting incorrectly, try adjusting the "Horizontal offset drill" or "Vertical offset drill" properties.
- **Custom Lifting**: If the automatic calculations don't suit a specific situation, you can use the Grip Edit points (visible when selecting the element in some configurations) to manually move the lifting loops.

## FAQ
- **Q: I get an error "Script detected an existing instance with the same identifier."**
  - **A:** Another instance of this script is already attached to the element with the same ID. Go to the Properties Palette and change the "Pos 1" value to a unique name.
  
- **Q: No drills or cuts are appearing on my studs.**
  - **A:** Check the "Filter beams with beamcode" property. If it contains text, ensure your studs actually have that code assigned. Alternatively, check the "Tooling" property to ensure it isn't set to "None".

- **Q: The reference point is in the wrong location.**
  - **A:** Change "Centerpoint for drills" from "Element" to "Beam" and specify the correct "Beamcode to center drills" (e.g., a bottom plate) to anchor the calculations correctly.
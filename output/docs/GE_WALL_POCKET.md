# GE_WALL_POCKET.mcr

## Overview
This script automates the creation of structural wall pockets (openings) in stud-framed walls to accommodate passing beams. It generates the necessary framing (king and jack studs), handles plate cutting, creates sheathing fillers, and applies CNC milling operations based on the selected geometry.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment. |
| Paper Space | No | Not designed for 2D layout or shop drawing generation. |
| Shop Drawing | No | Not a multipage or drawing generation script. |

## Prerequisites
- **Required Entities**: A Stud Framed Wall (`ElementWallSF`) must exist in the model.
- **Optional Entities**: Structural beams intersecting the wall (can be selected to auto-calculate dimensions).
- **Minimum Beam Count**: 0 (Can be used by defining dimensions manually).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse to and select `GE_WALL_POCKET.mcr`.

### Step 2: Select Wall
```
Command Line: Select a wall:
Action: Click on the Stud Framed Wall where the pocket is required.
```

### Step 3: Define Geometry (Beam or Point)
```
Command Line: Select beam(s) or [Enter] for point:
```
**Option A: Select Beam(s) (Recommended)**
1. Select one or multiple beams that pass through the wall.
2. The script automatically calculates the **Pocket Width** and **Elevation** based on the beam's geometry and sets the reference to "Bottom of Wall".
3. If beams are not parallel or do not intersect correctly, a warning "Beam selection is not correct" will appear.

**Option B: Select Point / Press Enter**
1. Press Enter or click a point on the wall to set the insertion location.
2. The script uses the default or previously configured property values for width and height.

### Step 4: Configure Properties
After selection, the **Properties Palette** (OPM) opens automatically.
1. Adjust parameters like Stud Sizes, Gaps, or King Stud locations.
2. The geometry updates dynamically to reflect changes.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Pocket Stud Size | Dropdown | 2x | Selects the nominal size of the jack/trimmer studs supporting the beam. |
| Custom Stud Width | Number | 1.5" | Sets the actual width of the stud if "Custom" is selected for size. |
| Overshoot Pocket | Dropdown | No | If "Yes", enlarges the pocket width to ensure jack studs fit without compression. |
| Pocket Width (pkW) | Number | 3.0" | The horizontal clear opening width required for the beam. |
| King Stud Location | Dropdown | Auto | Places full-height king studs (Auto, Both, Left, Right). |
| Extra King Stud Location | Dropdown | Auto | Places a second set of king studs for extra support. |
| Pocket Elevation (pkH) | Number | 9.25" | The vertical elevation of the beam seat relative to the reference. |
| Calculation Reference | Dropdown | Top of Wall | Reference datum for the elevation (Top of Wall or Bottom of Wall). |
| Side Gap | Number | 0.0" | Additional horizontal clearance on each side of the beam. |
| Bottom Gap | Number | 0.0" | Additional vertical clearance below the beam. |
| Sheet Filler | Dropdown | No | Fills vertical gaps between the beam and studs with sheathing material. |
| Add Bearing Plate | Dropdown | Yes | Adds a horizontal bearing plate beneath the beam. |
| End Studs Handling | Dropdown | to be kept full | Controls whether existing wall plates are cut or kept whole. |
| Milled Zones | String | (Empty) | Specifies which wall layers (cladding zones) require CNC milling (e.g., "1;2"). |
| Tooling Index | Number | 0 | Identifier for the CNC machine tool. |
| Milling Side | Dropdown | Left | The side of the wall geometry the milling is referenced from. |
| Milling Turn | Dropdown | Against course | Machining direction relative to material grain. |
| Overrun Tool | Dropdown | No | Enables the tool to overrun geometry boundaries for a clean cut. |
| Vacuum | Dropdown | No | Activates vacuum hold-down annotations for CNC. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Re-calculate Pocket | Forces a full refresh of the script logic, regenerating studs and cuts based on current property values. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external settings files; all configurations are managed via the Properties Panel.

## Tips
- **Quick Setup**: Use the "Select Beam(s)" option in Step 3 to let the script auto-calculate the correct pocket width and height. This saves manual entry.
- **Wall Splitting**: If you split the wall after creating the pocket, the script attempts to detect the change and stay attached to the correct wall segment.
- **Plate Cutting**: If a plate spans the entire pocket width, the script automatically splits it into two pieces. If it only touches one side, a single cut is applied.

## FAQ

- **Q: I see the error "Not a proper Stickframe Element selected." What does this mean?**
  A: You must select a valid Stud Framed Wall (`ElementWallSF`). Standard 3D solids or other wall types will not work.

- **Q: I selected a beam, but I get "Beam selection is not correct."**
  A: Ensure the selected beams actually pass through the wall and are parallel to each other. The script cannot calculate a pocket for intersecting or non-parallel beams.

- **Q: How do I add extra structural support around the beam?**
  A: In the Properties Panel, change **King Stud Location** to "Both" or "Left/Right" as needed, and set **Extra King Stud Location** to add a second layer of studs.
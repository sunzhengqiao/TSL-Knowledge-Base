# hsb_GableLadder.mcr

## Overview
Generates a gable ladder assembly (verge framing) consisting of vertical cross rails, tiling battens, structural rails, firestops, and soffit supports based on a selected roof plane and bounding beam.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script generates 3D geometry in the model. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not a shop drawing script. |

## Prerequisites
- **Required Entities**:
  - **Beam**: A bounding beam to define the ladder's position.
  - **ERoofPlane**: A roof plane to define the slope and geometry (auto-detected if connected to the beam).
  - **Element**: An element to associate the generated geometry with.
- **Minimum Beams**: 1 (The bounding beam).
- **Required Settings**: 
  - A valid current Group with specific Name Parts is required only if you intend to use the **Component Name** property to create a manufacturing component.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT`
**Action**: Browse and select `hsb_GableLadder.mcr`.

### Step 2: Select Bounding Beam
```
Command Line: Select bounding Beam
Action: Click on the beam that defines the gable end or the boundary for the ladder.
```

### Step 3: Select Roofplane
```
Command Line: Select Roofplane
Action: 
- If the script automatically detects a roof plane connected to the selected beam, you can skip this.
- If prompted, click on the specific Roofplane (ERoofPlane) that defines the slope for this gable.
```

### Step 4: Select Element
```
Command Line: Select Element
Action: Click on the Element (usually a wall or roof assembly) to which the ladder belongs.
```

### Step 5: Configure Properties
**Action**: The Properties Palette will appear automatically. Adjust dimensions, material, and spacing as needed. The ladder will update dynamically.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Component Name | Text | [Empty] | If entered, creates a manufacturing component. Requires a valid current Group. |
| Notes | Text | [Empty] | Adds general notes to the assembly. |
| Dimstyle | Dropdown | _DimStyles | Specifies the dimension style for the component. |
| Treated/White | Dropdown | Treated | Sets the material grade (White or Treated). |
| Color | Number | 171 | Sets the AutoCAD color index for the generated beams. |
| Height Frontcut | Number | 100 mm | Vertical drop from the eave line where the front cut is applied. |
| Distance from Top | Number | 120 mm | Distance from the ridge to the center of the top-most cross rail. |
| Distance from Bottom | Number | 500 mm | Distance from the eave to the center of the bottom-most cross rail. |
| Width Batten | Number | 75 mm | Thickness of the cross rails (battens). |
| Height Batten | Number | 35 mm | Depth of the cross rails perpendicular to the roof. |
| Width Tiling Batten | Number | 100 mm | Thickness of the tiling batten fixed to the rafter. |
| Height Tiling Batten | Number | 22 mm | Depth of the tiling batten. |
| Width Inside Rail | Number | 35 mm | Thickness of the internal structural rail. |
| Height Inside Rail | Number | 97 mm | Depth of the internal structural rail. |
| Width Outside Rail | Number | 35 mm | Thickness of the external structural rail. |
| Height Outside Rail | Number | 97 mm | Depth of the external structural rail. |
| Width Outside Rail Packer | Number | 35 mm | Thickness of the packer for the outside rail. |
| Height Outside Rail Packer | Number | 44 mm | Depth of the packer for the outside rail. |
| Width Soffit Support Batten A | Number | 35 mm | Thickness of Soffit Support Batten A. |
| Height Soffit Support Batten A | Number | 44 mm | Depth of Soffit Support Batten A. |
| Width Soffit Support Batten B | Number | 35 mm | Thickness of Soffit Support Batten B. |
| Height Soffit Support Batten B | Number | 44 mm | Depth of Soffit Support Batten B. |
| External Leaf Thickness | Number | 106 mm | Thickness of the external leaf (affects positioning). |
| Width Firestop | Number | 50 mm | Thickness of the firestop material. |
| Height Firestop | Number | 35 mm | Depth of the firestop material. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom right-click menu options are added by this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external settings files.

## Tips
- **Group Context**: If you fill in the "Component Name" field, ensure you have a current Group with valid Name Parts (usually Floor and Section) before running the script. If not, the script will report an error and erase itself.
- **Roofplane Detection**: The script attempts to find the roof plane automatically from the connected entities of the first beam you select. This saves time, but be ready to select it manually if the beams are not connected correctly in the logical model.
- **Batten Distribution**: The script tries to space intermediate battens at fixed intervals (600mm). If the roof run is too short to accommodate these intervals, it defaults to creating exactly two battens based on the "Distance from Top" and "Distance from Bottom" settings.

## FAQ
- **Q: The script deleted itself after I ran it. Where is my ladder?**
  - A: This is normal behavior for generation scripts. The script instance (the TSL) erases itself after creating the physical beams or the component macro in the model. Check the location where you inserted the script to find the generated wood beams.
- **Q: I get an error saying "Make a floor group current".**
  - A: You have entered a name in the **Component Name** property, but you are not working inside a valid Group. Either make a floor group current or clear the "Component Name" field to generate loose beams instead of a component.
- **Q: How do I change the size of the rails after insertion?**
  - A: Since the script instance erases itself, you typically cannot double-click it to edit. You would usually delete the generated beams and run the script again with the correct settings, or manually edit the beam properties if minor adjustments are needed.
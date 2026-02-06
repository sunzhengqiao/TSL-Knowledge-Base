# hsbMetal-BeamChildRelation.mcr

## Overview
This script establishes a mechanical link between a "Driver Beam" and a group of selected elements, forcing them to rotate and move together around a user-defined pivot point. It is ideal for assemblies where secondary parts must maintain their alignment relative to a main beam during structural adjustments.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D entities and geometry. |
| Paper Space | No | Not designed for 2D drawings or layouts. |
| Shop Drawing | No | Not applicable for detailing views. |

## Prerequisites
- **Required Entities**: At least one Beam (Driver) and one or more additional Entities (Children/Dependents).
- **Minimum Beam Count**: 1
- **Required Settings**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbMetal-BeamChildRelation.mcr`

### Step 2: Select Driver Beam
```
Command Line: Select Beam
Action: Click on the main beam that will control the movement. This beam acts as the "parent."
```

### Step 3: Select Child Entities
```
Command Line: Select Entities
Action: Select one or more entities (beams, plates, etc.) that you want to attach to the driver beam. Press Enter when finished.
```

### Step 4: Define Pivot Point
```
Command Line: Specify pivot point
Action: Click in the model to define the center of rotation. All linked elements will orbit around this point when the driver beam rotates.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Pt0 | Point (3D) | User Defined | The pivot point (center of rotation) for the entire group. Changing this location alters the axis around which child elements rotate. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add Dependency | Prompts you to select new entities to add to the group. These new entities will automatically follow the driver beam's movement. |
| Remove Dependency | Prompts you to select entities currently in the group to remove them. They will stop moving automatically and will be left in their current position. |

## Settings Files
None. This script does not use external settings files.

## Tips
- **Pivot Location**: Choose your pivot point carefully. If you place it far from the assembly, rotating the beam will cause the child elements to swing in a large arc.
- **Visual Symbol**: The script draws a circle with axis lines at the pivot point to help you visualize the center of rotation.
- **Adjustments**: You can grip-edit the Driver Beam normally; the script will automatically calculate and move the child entities to match.
- **Re-aligning**: If you need to change the pivot point, you can manually edit the `Pt0` coordinates in the Properties Palette.

## FAQ
- **Q: Why did the script disappear?**
  A: The script automatically deletes itself if the Driver Beam or all Child Entities are erased from the model.
- **Q: Can I move the driver beam to a new location?**
  A: Yes, provided the script was initialized with the 'COPYERASE' functionality enabled (usually automatic in newer environments), moving the beam will move the children relative to the pivot.
- **Q: How do I stop a specific part from moving?**
  A: Right-click the script instance, select "Remove Dependency," and click on the specific part you want to detach.
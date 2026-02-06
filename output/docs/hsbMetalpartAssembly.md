# hsbMetalpartAssembly.mcr

## Overview
This script groups selected entities (such as beams, fasteners, and mass groups) into a single logical assembly. It is primarily used to organize components for manufacturing output and provides a visual 3D marker to represent the assembly's local coordinate system.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script runs in the 3D model to group entities. |
| Paper Space | No | Not designed for 2D layout. |
| Shop Drawing | No | While it controls shop drawing generation, the script itself is a model-space definition object. |

## Prerequisites
- **Required Entities**: At least one entity with a solid body (GenBeam, FastenerAssemblyEnt, MassGroup, or any Entity with a Solid Body).
- **Minimum Beam Count**: 0 (It works with any combination of valid solid entities).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbMetalpartAssembly.mcr` from the list.

### Step 2: Select Entities
```
Command Line: |Select entities|
Action: Select the beams, fasteners, or other components you want to include in this assembly group. Press Enter to confirm selection.
```

### Step 3: Specify Insertion Point
```
Command Line: Specify point
Action: Click in the model to set the origin point (0,0,0) for the assembly's local coordinate system.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Create Nested Shopdrawings | dropdown | No | Determines whether the system automatically generates a separate shop drawing (detail view) for this specific assembly group. |
| Show ECS Marker | dropdown | No | Toggles the visibility of the 3D orientation marker (compass/axes) at the insertion point. |
| Scale | number | 1 | Adjusts the visual size of the coordinate system marker. This does not change the size of the actual parts, only the helper graphics. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add Entity | Prompts you to select an additional entity from the model to append to the current assembly. |
| Remove Entity | Prompts you to select an entity currently in the assembly to remove it from the group. |

## Settings Files
None required. This script relies on entity properties and user input.

## Tips
- **Rotate the Assembly**: Use the triangular grips (X, Y, or Z) visible on the ECS marker to rotate the assembly's orientation graphically.
- **Troubleshooting**: If the script disappears immediately after insertion, ensure you selected at least one object that has a physical volume (solid body).
- **Visualization**: If the marker is too small or too large to grab easily, increase the `Scale` property in the Properties Palette.

## FAQ
- **Q: Why did the script vanish after I placed it?**
- **A:** The script requires at least one "solid" entity in the selection set. If you selected only points or lines without volume, the script will self-delete. Ensure you select beams or solid objects.
- **Q: Does changing the Scale property resize my beams?**
- **A:** No, the `Scale` property only affects the size of the visual coordinate marker (the compass/arrows), not the actual timber or steel parts.
- **Q: How do I group additional parts later?**
- **A:** Right-click on the assembly instance in the model and select "|Add Entity|", then pick the new part you wish to include.
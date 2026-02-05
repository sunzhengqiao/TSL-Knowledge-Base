# HSB_T-Drill.mcr

## Overview
This script allows you to add a configurable drill hole or slotted mortise to timber beams. It is used for creating connections (bolts/dowels), service penetrations, or hardware mounting points.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model. |
| Paper Space | No | Cannot be inserted in Layout views. |
| Shop Drawing | No | This is a model machining script, not a 2D drawing annotation tool. |

## Prerequisites
- **Required Entities**: At least one `GenBeam` (Timber Beam).
- **Minimum Beam Count**: 1.
- **Required Settings**: None strictly required, though a Catalog Entry for "HSB_T-Drill" can be used to save presets.

## Usage Steps

### Step 1: Launch Script
Command: Type `TSLINSERT` (or use the hsbCAD insert tool) and select `HSB_T-Drill.mcr`.

### Step 2: Configure Properties (Optional)
- If a specific catalog preset was not selected, the Properties dialog may appear automatically.
- **Action**: Adjust the default dimensions (Diameter, Depth, Length) or Offsets if necessary, then click OK.
- *Note: You can also change these later via the Properties Palette.*

### Step 3: Select Beams
```
Command Line: Select a set of beams
Action: Click one or multiple timber beams to apply the tool to.
```

### Step 4: Select Position
```
Command Line: Select a position
Action: Click a point on the beam face where you want the center of the hole/slot to be located.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Position** | Group | - | Separator for location settings. |
| Offset X | Number | 0 | Moves the hole along the length of the beam from the clicked point. |
| Offset Y | Number | 0 | Moves the hole across the width of the beam from the clicked point. |
| **Size** | Group | - | Separator for dimensions. |
| Depth | Number | 10 | Depth of the hole. Set to **0** to drill completely through the beam. |
| Diamter/width | Number | 20 | The diameter of a round hole or the width of a slot. |
| Length | Number | 100 | The length of the slot (along the beam axis). |
| Corners for slotted hole | Dropdown | Square | Shape of the slot ends: **Square** (milled) or **Rounded**. |
| **Rotation** | Group | - | Separator for rotation settings. |
| Angle | Number | 0 | Rotates the hole/slot on the beam surface plane (in degrees). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | This script uses standard AutoCAD/hsbCAD commands. Select the instance and use the Properties Palette to modify values. |

## Settings Files
- **Catalog Entry**: `HSB_T-Drill`
- **Location**: hsbCAD Catalog (Company or Project specific).
- **Purpose**: Allows you to pre-define common sizes (e.g., "M10 Bolt Hole" or "Cable Slot") to skip manual property entry.

## Tips
- **Creating a Round Hole**: Set the **Diamter/width** equal to the **Length** and ensure **Corners** is set to **Rounded**.
- **Through Drilling**: To ensure the hole goes all the way through regardless of beam height changes, set the **Depth** to `0`.
- **Moving the Hole**: After insertion, select the script instance (usually visible as a point or cross on the beam) and use the **Grip** point to drag it to a new location. The X/Y offsets will be applied relative to this new grip location.
- **Slots**: If the Length is larger than the Width, the script automatically creates a slotted mortise instead of a simple drill hole.

## FAQ
- **Q: Why did my script disappear after I selected the position?**
  - A: This is normal behavior. The "Master" script erases itself after spawning "Satellite" instances on the selected beams. You can select the individual holes on the beams to edit them.
- **Q: How do I switch from a slot to a circle?**
  - A: Select the hole, open Properties, and make sure the **Diamter/width** and **Length** are identical, then set **Corners** to "Rounded".
- **Q: What happens if I set a negative depth?**
  - A: The script treats values less than or equal to 0 as "Through" drilling.
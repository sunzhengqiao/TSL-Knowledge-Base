# HSB_E-FloorDrillDistribution.mcr

## Overview
This script automatically distributes drill holes and milling cuts along a user-defined polyline path across selected floor elements. It is designed to create penetrations for utilities (such as cables or pipes) through both floor sheeting and underlying structural beams.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in the 3D hsbCAD model. |
| Paper Space | No | Not applicable in 2D layouts. |
| Shop Drawing | No | This script modifies physical 3D geometry, not drawing views. |

## Prerequisites
- **Required Entities:**
  - An `Element` (Floor cassette or panel).
  - A `Polyline` (Path defining the center line of the distribution).
- **Required Settings:**
  - `HSB_G-Distribution.mcr` must be loaded in the drawing to calculate point positions.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-FloorDrillDistribution.mcr`

### Step 2: Define Distribution Path
```
Command Line: Select polyline:
Action: Click on the polyline in the model that represents the path where holes should be placed.
```

### Step 3: Select Floor Elements
```
Command Line: Select elements:
Action: Select one or more floor elements. The script will apply holes only where the distribution path intersects with these elements.
```

### Step 4: Configuration
After selection, the script attaches to the elements. You can now adjust parameters using the **Properties Palette** (Ctrl+1) while the element is selected.

## Properties Panel Parameters

### Distribution Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Distribution Distance | Number | 300 | The spacing between the centers of drill holes along the path (mm). |
| Offset First Point | Number | 0 | Distance from the start of the polyline to the first hole (mm). |
| Offset Last Point | Number | 0 | Distance from the end of the polyline to the last hole (mm). |
| Distribution Type | Dropdown | Left | Anchors the pattern: **Left** (from start), **Right** (from end), or **Center** (middle alignment). |
| Distribute Evenly | Yes/No | No | If **Yes**, divides the path length equally, using the Distribution Distance as the *maximum* gap allowed. |

### Beam Drilling Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Drill Beams | Yes/No | Yes | Enables or disables drilling into structural beams. |
| Beam Drill Diameter | Number | 5 | Diameter of the hole in the beam (mm). |
| Drill Depth | Number | 75 | Depth of the hole drilled from the top surface downwards (mm). |
| Tooling Index Beam | Number | 1 | CNC tool reference number for beam drilling. |
| Reference Zone | Number | 2 | The construction zone index used to determine the top Z-level for drilling. |

### Sheet Milling Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Mill Sheets | Yes/No | Yes | Enables or disables milling of floor sheeting/panels. |
| Mill Diameter | Number | 10 | Diameter of the milling cutter for sheeting (mm). |
| Included Zones | String | (Empty) | Specific sheeting zones to mill (e.g., "1;3"). Leave empty to mill all positive zones. |
| Tooling Index Sheet | Number | 1 | CNC tool reference number for sheet milling. |

## Right-Click Menu Options
Select the element instance in the model, right-click, and choose from the following:

| Menu Item | Description |
|-----------|-------------|
| **Reset positions** | Clears all manual edits (added/deleted holes) and recalculates the entire pattern based on current polyline and spacing parameters. |
| **Delete drill** | Prompts you to click near a specific hole to remove it from the pattern. |
| **Add drill** | Prompts you to click a location to add a new drill/mill hole manually at that specific point. |

## Settings Files
- **Filename**: `HSB_G-Distribution.mcr`
- **Location**: Must be loaded in the current drawing.
- **Purpose**: This helper script is responsible for the mathematical calculation of point coordinates along the polyline based on the spacing and offset settings provided.

## Tips
- **Polyline Editing:** If you use grips to move or stretch the distribution polyline after the script is inserted, the holes will not update automatically until you run the **Reset positions** context command.
- **Selective Milling:** Use the *Included Zones* parameter to target specific layers of a floor build-up. For example, if you only want to mill through the decking but not a finish layer, specify only the deck zone number.
- **Uneven Spacing:** If the polyline length is not an exact multiple of the spacing distance, enable **Distribute Evenly** to ensure the holes are spaced consistently with smaller gaps at the ends, rather than one large final gap.

## FAQ
- **Q: Why do I get an error "Drills could not be distributed"?**
  **A:** This usually means the helper script `HSB_G-Distribution.mcr` is not loaded in your drawing. Use the TSL Load command to add it and try again.
  
- **Q: The holes appear in the sheeting but not in the beams. Why?**
  **A:** Check the **Drill Beams** property in the palette. If it is set to "No", beams will be ignored. Also, ensure the path actually crosses the centerline of the structural beams.

- **Q: Can I have different spacing for different elements?**
  **A:** No. Since a single script instance controls the distribution along one polyline, the spacing is uniform for all elements attached to that instance. If you need different spacing, use separate polylines and script instances.
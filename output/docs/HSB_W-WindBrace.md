# HSB_W-WindBrace.mcr

## Overview
This script automatically generates a structural wind brace (K-brace configuration) within a selected timber wall element. It creates diagonal timber struts, a central vertical post, steel connection gusset plates, and optional structural sheathing panels to provide lateral stability.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script generates 3D physical entities (beams, sheets, metal plates). |
| Paper Space | No | Not applicable for 2D layout generation. |
| Shop Drawing | No | This is a modeling script for 3D construction. |

## Prerequisites
- **Required entities**: A valid Wall Element containing vertical GenBeams (studs) and horizontal GenBeams (top/bottom plates).
- **Minimum beam count**: 4 beams (to form a valid bay bounded by two studs and two plates).
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `HSB_W-WindBrace.mcr` from the file list.

### Step 2: Select Wall Element
```
Command Line: Select wall element
Action: Click on the wall element (or a beam belonging to it) where you want to install the brace.
```

### Step 3: Select Position
```
Command Line: Select a position
Action: Click inside the specific bay (the space between two vertical studs) where you want the center of the wind brace to be located.
```

### Step 4: Configure (Optional)
Action: If the configuration dialog appears, adjust the initial dimensions or material settings as needed and click OK. The brace will then generate.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Frame beams** | | | |
| Frame beam width | Number | 25 mm | The width (thickness) of the diagonal timber beams. |
| Frame beam height | Number | 25 mm | The height/depth of the diagonal timber beams. |
| Frame beam color | Number | 1 | The display color index of the diagonal beams. |
| **Supporting beam** | | | |
| Center beam width | Number | 25 mm | The width (thickness) of the central vertical post (king post). |
| Center beam height | Number | 25 mm | The height/depth of the central vertical post. |
| Center beam position | Dropdown | Center | Sets the alignment of the center post: Front, Center, or Back. |
| **Steel plates** | | | |
| Steel plate width | Number | 25 mm | The width of the steel gusset plates. |
| Steel plate height | Number | 25 mm | The height of the steel gusset plates. |
| Steel plate thickness | Number | 25 mm | The material thickness of the steel plates. |
| Steel plate center offset | Number | 10 mm | Shifts the steel plates along the length of the wall (Y-axis). |
| **Positioning** | | | |
| Frame side offset | Number | 5 mm | Lateral offset of the brace assembly from the insertion point. |
| Brace position | Dropdown | Center | Sets the alignment of the diagonal beams: Front, Center, or Back. |
| **Sheeting** | | | |
| Sheet thickness | Number | 10 mm | Thickness of the structural sheathing (plywood/OSB) filling the brace area. |
| Sheet description | Text | - | Text description for reports (e.g., "OSB 18mm"). |
| Sheet color | Number | 1 | The display color index of the sheathing panels. |
| **Display** | | | |
| Color | Number | 8 | The display color index of the 2D symbol in plan views. |
| Symbol size | Number | 80 mm | The scale/size of the 2D brace symbol. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Deletes the currently generated beams and sheets and regenerates them based on current properties and wall geometry. This is also triggered by double-clicking the script instance. |
| Delete | Removes the TSL instance and all generated geometry (beams, plates, sheets) from the model. |

## Settings Files
- None used.

## Tips
- **Valid Bay Requirement**: The script will delete itself if you do not click inside a valid bay. Ensure the point is clearly bounded by vertical studs and horizontal top/bottom plates.
- **Positioning**: Use the `Brace position` and `Center beam position` properties to handle layer conflicts. For example, set the brace to "Back" if you need to avoid clashing with services in the front of the wall.
- **Quick Update**: Simply double-click the generated brace symbol or instance to force a recalculation if the wall shape changes.

## FAQ
- **Q: Why did the script disappear immediately after I selected a point?**
  **A**: The script could not find a valid boundary (Top Plate, Bottom Plate, Left Stud, Right Stud) at the location you clicked. Ensure you are clicking inside a regular stud bay.
- **Q: Can I use this on curved walls?**
  **A**: The script is designed for standard linear wall elements. It relies on finding intersecting beams which may not function predictably on complex curved geometry.
- **Q: How do I change the size of the steel plates?**
  **A**: Select the script instance, open the Properties palette (OPM), and modify the `Steel plate width`, `height`, or `thickness` values under the "Steel plates" category. The 3D model will update automatically.
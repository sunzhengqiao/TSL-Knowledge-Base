# HSB_W-Blocking.mcr

## Overview
This script automatically generates blocking members (noggings) or integrated tooling cuts between structural beams based on a user-defined path. It calculates intersections with existing elements to place blocking at specific offsets, skipping areas with openings or segments shorter than the minimum length.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates in the 3D model environment and requires an Element context. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | This is a model generation script, not a detailing script. |

## Prerequisites
- **Required Entities**: An existing hsbCAD Element containing GenBeams (studs/joists).
- **Minimum Beam Count**: The Element must contain enough Zone 0 beams to define the bounding geometry for calculations.
- **Required Settings Files**:
  - `HSB_G-FilterGenBeams.mcr`: Required if using advanced beam filtering.
  - `HSB_T-IntegratedTooling.mcr`: Required if using the "Integrated beam" type with a specific catalog.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Select `HSB_W-Blocking.mcr` from the file dialog.

### Step 2: Select Element
```
Command Line: |Select an element|
Action: Click on the structural element (wall or floor) where you want to add blocking.
```

### Step 3: Define Path
```
Command Line: |Select start point|
Action: Click a point in 3D space to define the start of the blocking line.
```

```
Command Line: |Select end point|
Action: Click a second point to define the direction and length of the blocking path.
```

## Properties Panel Parameters

After insertion, select the script instance in the model to edit parameters in the Properties Palette.

### Filter
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Filter beams with beamcode | Text | | Filters which structural beams are considered for intersection/cutting based on their beam code. |
| Filter definition | Dropdown | | Applies a pre-defined filter set (configured in HSB_G-FilterGenBeams). |

### Blocking
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Beam width | Number | 45 | The width (thickness) of the blocking member. |
| Beam height | Number | 170 | The height (depth) of the blocking member. |
| Side | Dropdown | Front | Sets the placement side (Front or Back) relative to the reference. |
| Material | Text | C14 | The material grade assigned to the blocking beams. |
| Name | Text | Blocking | The name/identifier for the generated beams. |
| Minimum blocking length | Number | 40 | Blocking segments shorter than this value will not be created. |
| Gap | Number | 0 | The distance between the ends of the blocking and the intersecting beams. |

### Positioning
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Reference point | Dropdown | Bottom (up) | The base geometric reference: Bottom, Middle, or Top of the bounding beams. |
| Offset from reference point | Text | 0 | Distance from the reference point. Use `;` to specify multiple positions (e.g., `500; 1000`). |
| Rotation | Number | 0 | The rotation angle of the blocking beams. |

### Style
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | Dropdown | Blocking | **Blocking**: Creates physical beams. **Integrated beam**: Cuts holes in existing studs rather than adding new beams. |
| Draw line | Dropdown | Yes | If Yes, draws a visual line indicating the blocking path. |
| Integrated tooling catalog | Dropdown | | Specifies the tooling catalog to use when "Type" is set to "Integrated beam". |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the blocking geometry based on the current properties and any changes to the surrounding structural beams. |
| Erase | Removes the script instance and all generated blocking. |

## Settings Files
- **Filename**: `HSB_G-FilterGenBeams.mcr`
- **Purpose**: Defines complex logic for filtering which beams in the element should be intersected or ignored by the blocking script.

## Tips
- **Multiple Rows**: You can generate multiple rows of blocking at once by separating offset values with a semi-colon (e.g., `500;1000;1500`).
- **Integrated vs. Blocking**: Use the **Integrated beam** type when you want to cut holes in existing studs (for services) rather than adding solid timber blocking between them.
- **Openings**: The script automatically detects Element openings (windows/doors) and will not generate blocking segments that fall inside them.
- **Grip Editing**: You can drag the Start and End grip points in the model to adjust the blocking line length or angle after insertion.

## FAQ
- **Q: The script reports "No intersecting beams found".**
  - A: This usually means the line drawn by your start/end points does not cross the path of any structural beams in the filtered set. Try adjusting the **Offset from reference point** or rotate the path to ensure it crosses studs/joists.
- **Q: Why are small gaps in the blocking missing?**
  - A: Check the **Minimum blocking length** property. If the space between structural studs is smaller than this value, the script will skip that segment to avoid creating tiny, unusable pieces.
- **Q: Can I use this to cut holes for pipes instead of adding blocking?**
  - A: Yes. Set the **Type** property to **Integrated beam** and select your desired **Integrated tooling catalog**.
# hsb_Split Walls

## Overview
Automatically splits long timber walls into shorter, manufacturable segments based on a defined maximum length. It ensures structural integrity by maintaining specific clearances around wall openings (windows/doors) and wall edges, and optionally generates the framing for the new segments immediately.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D wall elements. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Intended for model preparation, not drawing creation. |

## Prerequisites
- **Required entities**: Wall Elements (Element type).
- **Minimum beam count**: 1 (At least one wall must be selected).
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `hsb_Split Walls` (or via `TSLINSERT` → select `hsb_Split Walls.mcr`)

### Step 2: Configure Properties (Optional)
Before selecting elements, you can adjust the splitting parameters in the **Properties Palette** (if available) or rely on the script's default values.

### Step 3: Select Elements
```
Command Line: Please select the elements
Action: Click on the wall(s) you wish to split in the 3D model. Press Enter to confirm selection.
```

### Step 4: Execution
The script will process the selected walls, splitting them according to the `Max. Wall Length` while respecting the exclusion zones defined by the `Min. Distance` properties. The script instance will then erase itself automatically.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Max. Wall Length | Number | 3600mm | The target maximum length for a single wall panel. The script will attempt to split walls at intervals equal to this length. |
| Min. Distance to Opening | Number | 300mm | The minimum safety margin required between a split cut and any opening (windows/doors). The split point will be shifted if it falls within this zone. |
| Min. Distance to Wall Edge | Number | 300mm | The minimum allowable length for the start or end segment of a wall. Prevents creating tiny wall slivers at the ends. |
| Frame walls after split | Dropdown | Yes | Determines if the software should automatically calculate and insert structural framing (studs/plates) into the newly split walls immediately. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No context menu options are defined for this script. |

## Settings Files
None required.

## Tips
- **Why isn't the wall splitting exactly at 3600mm?**  
  The script automatically overrides the `Max. Wall Length` if a calculated split point falls too close to a window, door, or wall end. If you see a segment longer than your maximum, it likely means the standard split point was inside a "no-split zone" defined by your `Min. Distance` settings.
- **Batch Processing**: You can select multiple walls at once during the prompt; the script will process all of them in a single operation.
- **Undo**: If the results are not as expected, use the standard AutoCAD `Undo` command to revert the splits and adjust your parameters before running the script again.

## FAQ
- **Q: Can I split walls that are already generated/framed?**
  A: Yes, but you may need to regenerate the framing afterwards if the geometry changes significantly. It is often best practice to split walls before detailed framing generation.
- **Q: What happens if a wall is shorter than the `Max. Wall Length`?**
  A: The script will detect this and skip the wall, leaving it unmodified.
- **Q: The script reported "No Valid Split Location found". What does this mean?**
  A: This occurs if the exclusion zones (distances to openings and edges) are so large that there is no valid space left to cut the wall. Try reducing the `Min. Distance` values or the `Max. Wall Length`.
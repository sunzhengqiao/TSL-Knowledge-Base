# ElementBeamSplit

## Overview
This script automatically splits timber beams within a construction element or a manually selected group based on geometric intersections with other beams or trusses. It functions as a geometric cutter, dividing "female" beams wherever they intersect with "male" (cutting) beams, with options to add clearance gaps.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment. |
| Paper Space | No | Not intended for 2D layouts or drawings. |
| Shop Drawing | No | Not intended for manufacturing views. |

## Prerequisites
- **Required Entities**: 
  - An `Element` (e.g., a wall or roof panel) containing beams, OR
  - Specific sets of `GenBeam` (timber beams) or `TrussEntity` (trusses).
- **Minimum Beam Count**: At least 2 beams (one to cut, and one to be cut) must exist or be selected.
- **Required Settings**: 
  - (Optional) Painter Definition collection named `ElementBeamSplit` in the project for advanced filtering.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Browse and select `ElementBeamSplit.mcr`

### Step 2: Choose Selection Method
```
Command Line: Select elements or <Enter> to select beams manually
Action: 
  Option A (Automatic): Select one or more Elements (e.g., a wall). The script will process all beams inside based on the Property Filters.
  Option B (Manual): Press Enter.
```

### Step 3: Manual Selection (If Option B chosen)
```
Command Line: Select splitting beams or/and trusses
Action: Select the beams or trusses that will act as the "cutters" (Male entities). Press Enter when done.
```

### Step 4: Select Target Beams (If Option B chosen)
```
Command Line: Select beams to split
Action: Select the beams that you want to be cut/modified by the splitting beams selected in the previous step.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **sMaleSelection** | String | Y-Parallel | Determines which beams act as the "cutting" tools. <br>Options: <br>- `X-Parallel`: Beams parallel to Element local X-axis.<br>- `Y-Parallel`: Beams parallel to Element local Y-axis (e.g., Wall Plates).<br>- `[PainterDef Name]`: Use a specific Painter Definition name for complex filtering. |
| **sFemaleSelection** | String | `<Default>` | Determines which beams are cut. <br>Options: <br>- `<Default>`: All other beams in the Element/Selection.<br>- `[PainterDef Name]`: Use a specific Painter Definition name to select only specific beams (e.g., only "Studs"). |
| **dGap** | Double (Length) | 0 | A clearance distance applied around the cutting volume. <br>Example: `5` adds a 5mm gap on all sides between the cut beam and the cutting beam, preventing physical overlap. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Re-runs the split operation. Useful after changing Property Panel parameters (like Gap or Filters) or if geometry has changed. |

## Settings Files
- **Name**: Painter Definition collection `ElementBeamSplit`
- **Location**: hsbCAD Project Database (Catalogue)
- **Purpose**: Stores custom logical queries (queries) that allow you to filter beams by complex criteria (e.g., Material, Name, Layer) to define exactly which beams are "Male" (cutters) and which are "Female" (to be cut).

## Tips
- **Standard Walls**: For standard walls, keep `sMaleSelection` as `Y-Parallel` (Plates) and `sFemaleSelection` as `<Default>` (Studs). This will trim the studs to the plates.
- **Tolerance**: If you see graphical "flickering" or Z-fighting where beams touch, set `dGap` to `1` or `2` mm to create a tiny visual separation.
- **Trusses**: This script supports TrussEntities. You can use a truss to cut through a standard beam set by selecting the truss as the Male entity in Manual Mode.
- **Manual Override**: If the automatic Element mode is too aggressive (cutting things you don't want), use the Manual Mode (Press Enter at start) to select exactly which beams interact.

## FAQ
- **Q: Why did my beams disappear?**
  **A:** The script deletes the original beams and replaces them with the split segments. If the split results in a very small segment (smaller than your system tolerances), it might be filtered out. Check the `sFemaleSelection` filter to ensure you aren't accidentally cutting beams that shouldn't be cut.
- **Q: Can I use this to create tenons or joinery?**
  **A:** No. This script performs a geometric split (Boolean cut). It does not add machining operations or specific woodworking joints; it simply cuts the beam into shorter lengths.
- **Q: What does "Painter Definition" mean in the properties?**
  **A:** It refers to a saved set of selection rules. You must create these definitions in your hsbCAD Catalogue first. If you type a name that doesn't exist, the script will report an error.
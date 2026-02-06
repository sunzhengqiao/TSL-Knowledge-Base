# SplitBeamByType.mcr

## Overview
Automatically resolves beam intersections by splitting beams in Model Space based on a user-defined hierarchy of beam types. It ensures structural members with lower priority values (e.g., Top Plates) remain continuous ("Male"), while intersecting members with higher values (e.g., Studs) are cut ("Female").

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on all beams found in the 3D model. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This script modifies model geometry, not drawing views. |

## Prerequisites
- **Required Entities**: Beams (GenBeam) must exist in the model.
- **Minimum Beam Count**: At least 1 beam is required to select as an anchor during insertion.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `SplitBeamByType.mcr` from the file browser.

### Step 2: Configure Priorities
```
Dialog: Properties
Action: Define the beam types and their hierarchy.
1. Use the "Type X" dropdowns to select beam types (e.g., Rafter, Stud, Purlin).
   Note: The list is filtered to show only types currently present in your drawing.
2. Assign a "Priority value type X" to each.
   - 0 = Dominant (Beam remains continuous/cuts others).
   - 1, 2, 3... = Recessive (Beam gets cut by lower numbers).
3. Set a Type to "Disabled" if you do not wish to use that priority slot.
4. Click OK.
```

### Step 3: Select Anchor Beam
```
Command Line: Select beam
Action: Click on any beam in the model to attach the script instance.
Note: Although you select one beam, the script will process intersections for all beams in the Model Space matching the configured types.
```

## Properties Panel Parameters

These parameters are available in the AutoCAD Properties Palette (OPM) after insertion.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type 1 | dropdown | Dynamic | Select the beam type for the 1st priority tier. |
| Priority value type 1 | Integer | 0 | Rank for Type 1 (Lower numbers are dominant). |
| Type 2 | dropdown | Dynamic | Select the beam type for the 2nd priority tier. |
| Priority value type 2 | Integer | 0 | Rank for Type 2 (Lower numbers are dominant). |
| Type 3 | dropdown | Dynamic | Select the beam type for the 3rd priority tier. |
| Priority value type 3 | Integer | 0 | Rank for Type 3 (Lower numbers are dominant). |
| Type 4 | dropdown | Dynamic | Select the beam type for the 4th priority tier. |
| Priority value type 4 | Integer | 0 | Rank for Type 4 (Lower numbers are dominant). |
| Type 5 | dropdown | Dynamic | Select the beam type for the 5th priority tier. |
| Priority value type 5 | Integer | 0 | Rank for Type 5 (Lower numbers are dominant). |
| Type 6 | dropdown | Dynamic | Select the beam type for the 6th priority tier. |
| Priority value type 6 | Integer | 0 | Rank for Type 6 (Lower numbers are dominant). |
| Type 7 | dropdown | Dynamic | Select the beam type for the 7th priority tier. |
| Priority value type 7 | Integer | 0 | Rank for Type 7 (Lower numbers are dominant). |
| Type 8 | dropdown | Dynamic | Select the beam type for the 8th priority tier. |
| Priority value type 8 | Integer | 0 | Rank for Type 8 (Lower numbers are dominant). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Re-runs the intersection logic. Use this after changing beam types or priority values in the Properties palette. |
| TslDoubleClick | Triggers the script to update the geometry, similar to Recalculate. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Dynamic Lists**: When first inserting the script, the "Type" dropdowns are smart-filtered to show only beam types that currently exist in your drawing, saving you time scrolling through unused catalogs.
- **Hierarchy Logic**: You can skip numbers in the priority values (e.g., use 0, 5, and 10). The logic simply checks: *If Beam A Priority < Beam B Priority, Beam A cuts Beam B.*
- **Safe Updates**: The script uses body geometry operations without extrusion to ensure that when it splits beams, it doesn't create unwanted static tooling or leftover cuts on the "Female" (cut) beams.

## FAQ
- **Q: The script didn't cut my beams. Why?**
  **A:** Check that you have assigned different Priority Values to the intersecting beam types. If both types have a priority value of 0, neither will cut the other.
- **Q: Can I use this for complex truss systems?**
  **A:** Yes, but ensure your beam types are assigned correctly in the catalog before running the script.
- **Q: What happens if I delete the beam I selected as the anchor?**
  **A:** The script instance will detect the deletion and report that one beam is needed. You may need to delete the script instance and re-insert it or select a new anchor if supported by your workflow.
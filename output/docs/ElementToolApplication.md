# ElementToolApplication.mcr

## Overview
This script automates the generation of nail lines or visualizes glue areas on a timber element (such as floor sheathing or roof boarding) based on its contact with underlying beams or trusses. It handles rotated layouts, edge set-backs, and merges fragmented contact zones into continuous fastening lines.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates directly on 3D model entities (Elements, GenBeams, Trusses). |
| Paper Space | No | Not intended for 2D drawings or shop layouts. |
| Shop Drawing | No | This is a fabrication/modeling tool, not a detailing tool. |

## Prerequisites
- **Required Entities**: One primary Element (e.g., a CLT panel or board) and at least one GenBeam or Truss positioned underneath it.
- **Minimum Beam Count**: 1 (the underlying structural member).
- **Required Settings**: None specific (uses standard hsbCAD Nail Catalog).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `ElementToolApplication.mcr`

### Step 2: Select Element
```
Command Line: Select Element:
Action: Click on the panel or boarding element (the parent) where you want to apply nails or glue.
```

### Step 3: Select Supporting Entities
```
Command Line: Select beams/trusses (or press Enter to auto-detect):
Action: Select the GenBeams or Trusses supporting the element. If the script supports auto-detection, you may press Enter to find beams immediately below the element.
```

### Step 4: Configure Parameters
```
Action: Press Esc to finish selection. The script will calculate preview lines.
Open the Properties Palette (Ctrl+1) to adjust parameters such as spacing, offsets, or tool type.
```

### Step 5: Commit Changes
```
Action: Right-click on the script instance and select "Create Naillines" from the context menu to finalize the generation of physical nail entities in the database.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **sToolType** | dropdown | Nail | Select **Nail** to create physical nail lines or **Glue** to create visual rectangular profiles only. |
| **nZoneB** | index | 0 | The construction zone (color/layer) assigned to the generated nail line entity. |
| **nToolIndex** | index | 0 | The specific nail catalog index (tool number) defining the nail type and size. |
| **dSpacing** | double (mm) | 150.0 | The distance between individual nails along the line (pitch). |
| **dToolWidth** | double (mm) | 0.0 | The width of the glue area (used only if ToolType is **Glue**). If 0, a simple line is drawn. |
| **dOffsetA** | double (mm) | 0.0 | Set-back distance from the start of the contact surface. Use this to avoid nailing too close to the beam end. |
| **dOffsetB** | double (mm) | 0.0 | Set-back distance from the end of the contact surface. Use this to avoid nailing too close to the beam end. |
| **dMerge** | double (mm) | 1.0 | The gap tolerance. If contact surfaces are closer than this distance, they will be merged into one continuous line. |
| **nZoneA** | index | 0 | The display zone for preview/visual calculation elements. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Create Naillines** | Commits the previewed geometry to the database as physical NailLine entities. |
| **Add/Remove Entities** | Allows you to modify the selection of beams or trusses associated with the element without re-inserting the script. |
| **Recalculate** | Refreshes the script based on current geometry or property changes (usually automatic, but available here). |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies on the standard hsbCAD Nail Catalog and does not require external XML settings files.

## Tips
- **Merging Lines**: If you see multiple short nail lines where you expect one long line, increase the **dMerge** value.
- **Edge Safety**: Use **dOffsetA** and **dOffsetB** to prevent nails from being placed too close to the edge of the beam or the element, which might be required by engineering standards.
- **Rotated Systems**: The script supports trusses with rotated coordinate systems; ensure the beams are generally perpendicular to the element plane for accurate detection.
- **Visualization**: Switch **sToolType** to **Glue** temporarily to visualize the exact contact area as a solid block if you are unsure where the nails are being placed.

## FAQ
- **Q: The script reports "nothing to nail". Why?**
  **A:** Ensure the beams or trusses are actually physically touching (overlapping) with the Element in 3D space. Also, ensure the beams are generally perpendicular to the element face; skewed beams may be filtered out.
  
- **Q: How do I switch between nailing and gluing?**
  **A:** Change the **sToolType** property in the Properties Palette. **Glue** mode draws visuals only; **Nail** mode creates production data.

- **Q: My nail lines are too short or don't cover the whole beam.**
  **A:** Check your **dOffsetA** and **dOffsetB** values. If they are too high, they might be cutting off the nail lines. Also, check if the beam is fully underneath the element.
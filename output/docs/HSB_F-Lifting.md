# HSB_F-Lifting

## Overview
This script automatically generates a grid of lifting positions on floor or roof elements. It creates drill holes in both structural beams and sheeting, and adds visual lifting symbols that can be adjusted using grip points.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script runs on Element objects in 3D. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | Generates CNC tools (Drills) directly on the model. |

## Prerequisites
- **Required Entities**: An Element containing beams (joists/rafters) and sheeting.
- **Minimum Beam Count**: At least 1 structural beam (rafter) is required to snap the lifting column.
- **Required Settings**: `HSB_G-FilterGenBeams` (optional, used if beam filtering is active).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_F-Lifting.mcr`

### Step 2: Configure Properties
- If running the script manually (without a preset Catalog Key), the Properties Dialog will appear.
- Adjust settings such as **Lifting side**, **Number of lifting rows**, and **Drill diameters**.
- Click **OK** to confirm.

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the floor or roof elements to add lifting points to.
```
- The script will verify that the element is valid.
- It will automatically check for existing instances of this script with the same **Pos 1 (Identifier)** and remove them to prevent duplicates.

### Step 4: Adjust Grid (Post-Insertion)
- After insertion, the script calculates an initial grid based on the element bounding box.
- **Grip Points** appear in the model representing the columns (main lifting lines) and rows.
- **Action**: Click and drag the square grip points to reposition the lifting lines.
  - **Column Grips**: Snap to the center of the nearest rafter/joist.
  - **Row Grips**: Distribute along the span.
- Moving these grips will automatically update the drill positions and symbols.

## Properties Panel Parameters

### General
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Pos 1 | text | (space) | Unique identifier. Only one script with this ID can exist per element. |

### Lifting Grid
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Lifting side | dropdown | Allign with joist | Orientation of the grid relative to joists (Align or Perpendicular). |
| Number of lifting rows | dropdown | 2 | Number of rows across the element span (2, 3, or 4). |
| Number of lifting columns | number | 2 | Number of columns (fixed at 2). |
| Minimum distance from the edge of the element | number | 100 | Safety margin from element edges (mm). |

### Drill in Beam
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Filter beamcodes | text | (empty) | Beam codes to exclude from drilling (comma-separated). |
| Drill diameter beam | number | 30 | Diameter of the hole in structural beams (mm). |

### Drill in Sheeting
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Drill sheeting in zone | dropdown | 1 | Material zone index of the sheeting layer to drill. |
| Offset drill sheeting | number | 30 | Offset from beam center to sheeting drill center (mm). |
| Drill diameter sheeting | number | 30 | Diameter of the hole through the sheeting (mm). |
| Extra depth drill sheeting | number | 1 | Additional depth added to the drill operation (mm). |
| Tool index drill sheeting | number | 1 | CNC machine tool number for sheeting. |

### Lifting Symbol
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Assign to zone | dropdown | 0 | Visual layer height for the symbol. |
| Symbol width | number | 100 | Width of the visual symbol (mm). |
| Symbol height | number | 100 | Height of the visual symbol (mm). |
| Symbol color | number | 2 | Color index of the symbol. |
| Hatch pattern | dropdown | <First...> | Pattern used to fill the symbol. |
| Hatch scale | number | 1 | Scale of the hatch pattern. |
| Description | text | (empty) | Text label displayed next to the symbol. |
| Text size | number | 100 | Height of the description text (mm). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (Standard Script Options) | Standard options like *Recalculate* or *Erase* are available via the right-click context menu. No custom specific triggers are defined. |

## Settings Files
- **Filename**: `HSB_G-FilterGenBeams`
- **Location**: Project/TSL folder
- **Purpose**: Allows the script to filter specific beam codes (e.g., blocking or trimmers) so they are not drilled.

## Tips
- **Grip Editing**: Use the grips to fine-tune the position of lifting holes to avoid blocking or hardware conflicts.
- **Orientation**: Use the **Lifting side** property to switch the grid axis if the default orientation does not match your joist direction.
- **Filtering**: Use **Filter beamcodes** to prevent the script from drilling into short trimmer or blocking beams that are not meant to carry lifting loads.
- **Duplication**: The script automatically removes old instances if you insert it again on the same element with the same **Pos 1** identifier.

## FAQ
- **Q: The script exits saying "No closest beam found!"**
  - A: Ensure the element has structural beams (rafters/joists) running in the direction defined by the **Lifting side** property. The script needs beams to snap to.
- **Q: My lifting points are too close to the edge.**
  - A: Increase the **Minimum distance from the edge of the element** value in the properties.
- **Q: It drilled through a blocking beam I wanted to keep solid.**
  - A: Enter the beam code of that blocking piece into the **Filter beamcodes** property and recalculate the script.
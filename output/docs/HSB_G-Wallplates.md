# HSB_G-Wallplates

## Overview
This script automates the joining of wall plates within a roof plane, splits them into standard transport lengths, assigns them to production groups, and distributes anchors with specific spacings to create production-ready wall plates.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Operates in 3D model environment only. |
| Paper Space | No | Not designed for 2D layouts or shop drawings. |
| Shop Drawing | No | Does not generate views or layouts. |

## Prerequisites
- **Required Entities**: `ElementRoof` entities and `GenBeams` (wall plates).
- **Minimum Beam Count**: 0 (Logic processes beams found within selected elements).
- **Required Settings**:
    - The script `HSB_T-Anchor.mcr` must be available.
    - The script `HSB_D-Aligned.mcr` must be available.
    - Drawing must contain Anchor blocks with names containing 'BK', 'ANKER', or 'HSB'.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_G-Wallplates.mcr`

### Step 2: Configuration Dialog
```
Command Line: (Dialog appears)
Action: Configure initial settings (e.g., Split lengths, Groups) or click OK to accept defaults.
```

### Step 3: Select Elements
```
Command Line: Select elements:
Action: Click on the `ElementRoof` entities in the model that contain the wall plates you wish to process. Press Enter to confirm selection.
```

### Step 4: Select Insertion Point
```
Command Line: Specify insertion point:
Action: Click a location in the model space to place the script instance (visualization symbol).
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Name | Text | "hsbCAD Wallplates" | Identifier for the script instance in the project tree. |
| Delete Old Beams | Yes/No | No | If "Yes", generated wall plates are deleted when the source element is removed or unframed. |
| Beam Codes to Join | Text | (Empty) | Filter to select specific wall plates based on Material Code (e.g., "C24"). |
| Beam Names to Join | Text | (Empty) | Filter to select specific wall plates based on Beam Name. |
| Assign to Group | Text | (Empty) | Target group name (Floor/Element) for the generated wall plates to appear on loose material lists. |
| Default Split Length | Number | 5100 mm | Target length for wall plates based on transport constraints. |
| Minimum Split Length | Number | 2700 mm | Shortest allowable length for a wall plate segment to prevent unusable offcuts. |
| Split Gap | Number | 0 mm | Physical separation (gap) between split beam segments. |
| Script Name Anchor | Text | "HSB_T-Anchor" | The specific TSL script used to generate the anchor instances. |
| Apply Anchor 2 | Yes/No | No | Enables the configuration and insertion of a second type of anchor. |
| Link Dimension to Objects | Yes/No | Yes | If "Yes", dimensions automatically update if geometry moves. If "No", dimensions are static. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate all | Re-runs the entire script logic (joining, splitting, and anchoring) based on current properties and geometry. |
| Recalculate dimensions | Redraws dimension lines only, without recalculating the wall plate geometry. |
| Erase | Removes the script instance from the drawing. |

## Settings Files
- **Script Dependencies**: `HSB_T-Anchor.mcr`, `HSB_D-Aligned.mcr`
- **Location**: hsbCAD standard TSL folder.
- **Purpose**: These sub-scripts are called by the main script to generate anchor details and dimension lines respectively.

## Tips
- **Filtering**: Use the *Beam Codes* and *Beam Names* fields to process only specific types of wall plates (e.g., only top plates) within a complex roof element.
- **Transport Lengths**: Adjust the *Default Split Length* to match your supplier's maximum transport length to optimize cutting lists.
- **Minimum Lengths**: Ensure the *Minimum Split Length* is set appropriately; the script will automatically adjust the previous cut to ensure the last segment is not too short.
- **Manual Anchor Adjustment**: After insertion, you can select individual anchor instances and use grip edits to move them manually if the automatic distribution does not suit specific constraints.

## FAQ
- **Q: Why does the script report "No element selected"?**
  A: Ensure you are selecting `ElementRoof` entities, not individual beams or lines, during the selection prompt.
- **Q: Why are my wall plates not being split?**
  A: Check if the beams are longer than the *Default Split Length*. Also, verify that the *Beam Codes to Join* or *Beam Names to Join* filters are not excluding your specific beams.
- **Q: Why are no anchors appearing?**
  A: Verify that your drawing contains blocks with 'BK', 'ANKER', or 'HSB' in their names. The script searches for these blocks to use as anchor definitions.
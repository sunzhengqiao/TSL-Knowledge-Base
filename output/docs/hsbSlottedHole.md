# hsbSlottedHole.mcr

## Overview
This script creates customizable slotted holes (mortises) or rows of holes in structural timber beams. It supports various shapes, including rectangular and rounded ends, and allows for complex distribution patterns along the beam axis for connections or ventilation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Machining is defined in the model and reflected in drawings automatically. |

## Prerequisites
- **Required Entities**: At least one Beam (GenBeam) must exist in the model.
- **Minimum Beam Count**: 1.
- **Required Settings**: None (defaults to internal properties or Catalog settings).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbSlottedHole.mcr` from the list.

### Step 2: Select Beam
```
Command Line: Select beam(s)
Action: Click on the beam(s) where you want to add the slot. Press Enter to confirm selection.
```

### Step 3: Configure Geometry
If no specific Catalog entry is triggered, the Properties Palette (OPM) or a dialog will appear.
- Adjust parameters like **Length**, **Width**, and **Depth**.
- Select the desired **Shape** (e.g., Rectangular, Round, Rounded).
- *Note: Set Depth to `0` for a through-hole.*

### Step 4: Define Placement
The script prompts change based on the **Interdistance** property relative to the **Width**.

**Option A: Create a Distribution Row (if Interdistance > Width)**
```
Command Line: Pick first point of distribution along beam axis.
Action: Click the start position for the row of holes.
```
```
Command Line: Pick second point <Enter> to insert a single tool
Action: Click the end position. The script will fill the space based on your quantity settings, or press Enter to place just one at the start.
```

**Option B: Single Slot (if Interdistance <= Width)**
```
Command Line: Pick point
Action: Click the exact center location for the single slot.
```

### Step 5: Adjust (Post-Insertion)
Once placed, you can drag the **Grips** (diamond shapes) in the model to adjust the start/end points of the distribution or the center position of the slot.

## Properties Panel Parameters

### Geometry
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| (A) Length | Number | 80 mm | The longitudinal dimension of the slot. |
| (B) Width | Number | 20 mm | The width of the slot (perpendicular to length). |
| (C) Depth | Number | 0 mm | The depth of the cut. `0` creates a through-hole. |
| (F) Shape | Dropdown | Rectangular | Shape of the slot ends: *Rectangular, Round, Rounded, Explicit Radius*. |
| (R) Radius | Number | 0 mm | Corner radius. Only active when Shape is set to *Explicit Radius*. |

### Alignment
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| (D) Offset from Axis | Number | 0 mm | Moves the slot center perpendicular to the beam axis. |
| (E) Angle | Number | 0 deg | Rotates the slot around its insertion point. |
| (J) Alignment | Dropdown | UCS | Defines orientation plane: *UCS* or *Perpendicular to UCS*. |

### Distribution
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Interdistance | Number | 0 mm | Distance between slot centers. `0` implies a single slot or manual placement. |
| Distribution Mode | Dropdown | Fixed | *Fixed*: Keeps spacing constant, changes quantity. *Even*: Keeps quantity constant, adjusts spacing. |
| Quantity | Integer | 1 | Total number of slots to generate. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Change Face | Flips the orientation of the slot 90 degrees relative to the beam surface (swaps local Y and Z axes). |
| Delete | Removes the slotted hole script from the beam. |

## Settings Files
- **Catalog Entries**: Standard hsbCAD Catalogs (`.catalog`)
- **Purpose**: Store predefined sizes and settings for quick insertion (e.g., "M20 Slot for Steel Plate").

## Tips
- **Through Holes**: Always leave **Depth** as `0` unless you specifically require a blind pocket.
- **Rounded Corners**: For standard stadium slots (fully rounded ends), select the **Rounded** shape. Use **Explicit Radius** if you need a specific corner radius that differs from half the width.
- **Adjustable Patterns**: Insert a row of slots using the **Distribution** steps above. After insertion, select the script and drag the diamond-shaped **Grips** in the model to stretch or shrink the row. The slots will automatically recalculate based on your **Distribution Mode** (Fixed or Even).
- **Flip Orientation**: If the slot is cutting into the wrong face of the beam, select the tool, right-click, and choose **Change Face**.

## FAQ
- **Q: Why does the command line ask for two points sometimes?**
  - **A**: This happens when the **Interdistance** property is set larger than the **Width**. The script assumes you want to create a row of slots distributed along a path.
- **Q: How do I rotate the slot?**
  - **A**: Use the **(E) Angle** property in the palette, or change the **(J) Alignment** to rotate it 90 degrees to the current UCS.
- **Q: The tool vanished after I changed the size.**
  - **A**: Ensure **(A) Length** and **(B) Width** are greater than 0.1 mm. The script deletes itself if the geometry is too small to generate.
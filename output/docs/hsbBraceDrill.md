# hsbBraceDrill.mcr

## Overview
This script automates the creation of bolted connections for diagonal braces. It creates through-holes and counterbores (sinkholes) on both the brace and the receiving beam, and automatically applies an end cut to the brace to ensure a tight fit.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for generating 3D geometry and modifications. |
| Paper Space | No | Not designed for 2D layouts. |
| Shop Drawing | No | Not a shop drawing annotation script. |

## Prerequisites
- **Required Entities**: GenBeam or Beam elements.
- **Minimum Beam Count**: 2 (One brace and one connected beam/column).
- **Required Settings Files**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbBraceDrill.mcr` from the list.

### Step 2: Select Beams
```
Command Line: |Select construction|
Action: Select the diagonal brace and the beam(s) or column(s) it connects to. Press Enter to confirm.
```
*Note: The script will automatically detect which beams are braces (Type 8) and which are receiving beams.*

### Step 3: Configure Properties
After insertion, select the newly created connection instance and adjust the drill dimensions (diameter, depth, offsets) in the Properties Palette (OPM) if the default values do not match your requirements.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Diameter** | Number | 12 | The diameter of the main through-hole (bolt size). |
| **Diameter** (Sinkhole) | Number | 50 | The diameter of the counterbore (sinkhole) for washers/nuts. |
| **Depth** (Sinkhole) | Number | 15 | The depth of the counterbore on the receiving beam. |
| **Depth on brace** (Sinkhole) | Number | 15 | The depth of the counterbore on the brace beam. |
| **Drill alignment** | Dropdown | To brace center | Determines if the hole aligns with the brace center or the receiving (female) beam center. |
| **Lateral** (Offset) | Number | 0 | Shifts the drill hole laterally relative to the connection point. |
| **Normal** (Offset) | Number | 0 | Shifts the drill hole in/out relative to the surface. |
| **Maker** | Text | - | The name of the hardware manufacturer (e.g., Simpson). |
| **Product name** | Text | - | The specific name or code of the hardware product. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Double Click** | **Deletes** the TSL instance and removes all associated drills and hardware from the beams. |

## Settings Files
- None.

## Tips
- **Alignment**: If your brace is wider than the column it connects to, change the **Drill alignment** to "To female center" to ensure the bolt passes through the center of the column.
- **Batch Processing**: You can select multiple braces and their connected beams in one go during Step 2. The script will create a separate connection instance for each valid pair found.
- **Deletion**: Since double-clicking deletes the connection, be careful not to double-click accidentally. You can also use the `ERASE` command to remove the specific connection instance.

## FAQ
- **Q: The script disappeared after I ran it. Is that normal?**
  - **A:** Yes. This is a "distributor" script. It processes your selection, creates the individual connection instances on the beams, and then deletes itself to clean up the drawing.
- **Q: How do I change the bolt size after insertion?**
  - **A:** Select the connection instance (usually visualized near the intersection), open the Properties Palette (Ctrl+1), and change the **Diameter** value.
- **Q: What if the hole is in the wrong position?**
  - **A:** Adjust the **Lateral** or **Normal** offset values in the Properties Palette to fine-tune the position without moving the beams.
# Knapp-Walco-V60-80.mcr

## Overview
Inserts a Walco V60 or V80 shear wall connector with a KS screw between two parallel timber studs. The script automatically generates the required slotting, drilling, and Bill of Materials (BOM) entries for production.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script runs in 3D model environment. |
| Paper Space | No | Not designed for 2D layouts. |
| Shop Drawing | No | Machining is applied directly to the beams. |

## Prerequisites
- **Required Entities**: Two `GenBeam` entities (typically vertical studs or posts).
- **Minimum Beam Count**: 2
- **Beam Orientation**: Beams must be parallel to each other and vertical (parallel to the Z-axis).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Navigate to the folder containing `Knapp-Walco-V60-80.mcr` and select it.

### Step 2: Configure Connector
Upon selection, the Properties dialog appears. Configure the following before selecting beams:
- **Type**: Choose "Walco V60" or "Walco V80".
- **Quantity**: Enter the number of connectors.
  - **Note**: If you enter `1`, you will be asked to pick an insertion point later. If you enter `>1`, the script will distribute them automatically.
- **Offset Bottom/Top**: Define the allowed range for the connectors.

### Step 3: Select Beams
1. **Command Line**: `Select first beam`
   - **Action**: Click on the first timber stud.
2. **Command Line**: `Select second beam`
   - **Action**: Click on the second parallel timber stud.

### Step 4: Define Position
- **If Quantity = 1**: 
  - **Command Line**: `Select insertion point`
  - **Action**: Click on the intersection area where you want the connector placed.
- **If Quantity > 1**:
  - The script automatically calculates the spacing based on the top and bottom offsets and inserts the connectors immediately.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Type | Dropdown | Walco V60 | Selects the connector model (V60 is 60x60mm, V80 is 80x80mm). This updates dimensions, screw sizes, and BOM data. |
| Quantity | Integer | 1 | Number of connectors to insert. Value > 1 triggers automatic distribution along the beam height. |
| Offset Bottom | Number | 0.0 | Distance from the bottom edge of the beam intersection to the first connector. |
| Offset Top | Number | 0.0 | Distance from the top edge of the beam intersection to the last connector. |
| Width Gap | Number | 0.0 | Tolerance adjustment for the slot width. Positive values make the slot wider (looser fit). |
| Offset dY | Number | 0.0 | Lateral offset of the connector along the width of the beam (Y-axis). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Side | Swaps the machining between the two beams. The slot (BeamCut) moves to the other beam, and the drill hole moves to the first. This updates all connectors attached to the same beam pair. |

## Settings Files
- No specific settings files are required for this script.

## Tips
- **Distribution Logic**: To place multiple connectors evenly, set the **Quantity** to the desired number (e.g., 4). Use **Offset Bottom** and **Offset Top** to define the start and end boundaries of the distribution area.
- **Remote Updates**: If you modify **Width Gap** or **Offset dY**, the script automatically updates all other connectors linking the same two beams to match the new setting.
- **Beam Validation**: Ensure the beams are strictly vertical. If the script disappears immediately after insertion, check that the beams are parallel and have a valid geometric intersection area.

## FAQ
- **Q: Why did the connector disappear after I selected the beams?**
  - **A**: The beams might not be parallel to the World Z-axis, or they might not overlap vertically. Ensure both studs are vertical and share a common height area.
  
- **Q: Can I move a single connector after insertion?**
  - **A**: Yes. Use the standard AutoCAD `Move` command on the script instance (TSL entity), or modify the insertion point coordinates in the properties if available. For distributed connectors, modify the offsets.

- **Q: What is the difference between V60 and V80?**
  - **A**: The V60 uses a 60x60mm plate (Article K102) with specific screws, while the V80 uses an 80x80mm plate (Article K103) with larger screws for higher load capacity.
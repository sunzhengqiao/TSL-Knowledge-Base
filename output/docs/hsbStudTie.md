# hsbStudTie

## Overview
This script automatically generates and places VUETRADE single-sided stud tie connectors on wall frames. It supports applying these connectors to entire wall elements (based on stud layout) or to specific beam intersections.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script runs exclusively in the 3D model. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Does not generate 2D drawings or details. |

## Prerequisites
- **Required Entities**: Wall Elements (`ElementWall`) or structural Beams.
- **Minimum Beams**: 0 (Wall Element mode); 1 Male and 1 Female beam (Beam mode).
- **Required Settings**: None specific.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or via the hsbCAD toolbar) → Select `hsbStudTie.mcr`

### Step 2: Select Insertion Mode
```
Command Line: Select insertion mode [Element/Beams]:
Action: Press Enter for default (Element) or type "Beams" and press Enter.
```

### Step 3A: Element Mode (Default)
1. The properties dialog appears. Configure the distribution, position, and side settings.
2. Click OK to confirm.
3. **Prompt**: `Select elements:`
4. **Action**: Click on the Wall Elements in the model to apply the ties.
5. Press Enter to finish selection.

### Step 3B: Beams Mode
1. The properties dialog appears (options are limited to Side and Zone).
2. Click OK to confirm.
3. **Prompt**: `Select male beams:`
4. **Action**: Select the primary beams (e.g., studs) and press Enter.
5. **Prompt**: `Select female beams:`
6. **Action**: Select the secondary beams (e.g., plates) intersecting the male beams and press Enter.
7. The script automatically validates intersections and places the connectors.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Distribution | Dropdown | Every Stud | Determines which studs receive the tie (Every, Odd, or Even). Only available in Element mode. |
| Position | Dropdown | Both | Sets the vertical placement of the tie (Both, Top Plate, or Bottom Plate). Only available in Element mode. |
| Side | Dropdown | Left | Defines the side of the stud relative to the wall axis (Left, Right, or Both). |
| Zone | Dropdown | 1 | Selects the wall face/zone where the tie is applied (1, -1, or Both). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Swap Side | Toggles the connector between the Left and Right sides. (Only visible if "Side" is not set to Both). |
| Swap Zone | Toggles the connector between Zone 1 and Zone -1 (e.g., Interior to Exterior face). (Only visible if "Zone" is not set to Both). |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies on internal logic and standard hsbCAD catalogs; no external settings file is required.

## Tips
- **Beam Mode Logic**: When using Beam mode, ensure the male and female beams actually intersect. The script will silently skip pairs that are parallel or do not overlap.
- **Quantity Calculation**: Setting "Side" or "Zone" to "Both" will double the number of hardware components generated.
- **Catalog References**: The script automatically assigns the correct VUETRADE model codes (VTSTLH for Left, VTSTRH for Right) to the BOM.

## FAQ
- **Q: Why didn't the connector appear on my beam in Beam mode?**
  **A:** The script requires the beams to physically intersect and not be parallel. Check if the male beam axis passes through the female beam body.
- **Q: Can I use this for shop drawings?**
  **A:** No, this script is designed for 3D model representation and BOM data generation only.
- **Q: How do I apply ties to only the top plate of a wall?**
  **A:** Use Element mode, select the wall, and change the "Position" property to "Top Plate".
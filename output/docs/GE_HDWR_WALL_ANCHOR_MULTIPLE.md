# GE_HDWR_WALL_ANCHOR_MULTIPLE.mcr

## Overview
Automates the placement and engineering of wall anchorage hardware (such as ATC rods, adhesive anchors, and screws) along a wall bottom plate. It distributes anchors based on specified spacing rules while automatically avoiding wall openings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D Wall Elements. |
| Paper Space | No | Not applicable for detailing views. |
| Shop Drawing | No | Not applicable for 2D drawing generation. |

## Prerequisites
- **Required Entities:** A valid Wall Element (`ElementWallSF`).
- **Minimum Beam Count:** 1 (The script acts on the selected wall element).
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_HDWR_WALL_ANCHOR_MULTIPLE.mcr`

### Step 2: Select Wall
```
Command Line: Select a Wall
Action: Click on the desired Wall element in the model.
```

### Step 3: Specify Engineering Type
```
Command Line: Specify Engineering Type: 1= 1/2 ATC; 2= 1/2 ATC+Anchor; ... 10= None
Action: Type the number corresponding to the desired hardware scenario and press Enter.
```
*Note: You can change this later via the Properties Palette.*

### Step 4: Configuration
Once inserted, the script generates the hardware. You can adjust parameters via the Properties Palette (Ctrl+1) while the script instance is selected.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Scenario | Dropdown | 1/2" ATC Engineering | Selects the engineering pattern or hardware type (e.g., ATC rods, Adhesive Anchors, J-Bolts, etc.). |
| Spacing | Number | 48.0 | Sets the maximum on-center distance between anchors in inches. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Re-distribute | Recalculates anchor positions based on the current Spacing and Scenario settings. Use this if the wall geometry has changed. |
| Remove Existing | Removes all child hardware instances attached to the wall but keeps the main script instance active. |

## Settings Files
- **Filename:** None
- **Location:** N/A
- **Purpose:** This script does not rely on external XML settings files.

## Tips
- **Second Floor Walls:** If a wall has an elevation greater than 59 inches (typically a second floor), the script automatically sets the Scenario to "None" to prevent unwanted hardware placement.
- **Opening Avoidance:** The script automatically places anchors 5 inches away from any wall openings to ensure proper installation clearances.
- **Dynamic Updates:** Changing the "Spacing" or "Scenario" in the Properties Palette immediately erases old hardware and generates new ones.
- **Visual Marker:** A small circle with an "E" is drawn at the start of the wall to indicate that this engineering script is attached to it.

## FAQ
- **Q: Why did no anchors appear when I inserted the script?**
- **A:** This likely happens if the wall elevation is higher than 59 inches (defaulting to "None") or if the "Scenario" property is set to "None". Check the Properties Palette to adjust the Scenario.
- **Q: Can I use this on curved walls?**
- **A:** The script is designed for standard linear wall elements. Complex geometries may require manual adjustment.
- **Q: What happens if I insert the script twice on the same wall?**
- **A:** The script detects duplicates and will automatically erase the newer instance to prevent conflicts.
- **Q: How do I switch from ATC rods to Adhesive Anchors?**
- **A:** Select the script instance (look for the "E" marker), open the Properties Palette (Ctrl+1), and change the "Scenario" dropdown to "Adhesive Anchor". The anchors will update automatically.
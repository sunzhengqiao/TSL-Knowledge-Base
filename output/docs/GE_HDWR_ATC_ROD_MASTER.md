# GE_HDWR_ATC_ROD_MASTER.mcr

## Overview
Automates the distribution and insertion of Continuous Rod Tie-Down (ATC) hardware and screw anchors along the bottom plate of a selected wall. It calculates placement based on engineering types and spacing, handling different hardware configurations like 1/2" rods, 3/8" rods, or cup anchors.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in 3D model context. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Not applicable for generating 2D outputs. |

## Prerequisites
- **Required Entities**: A standard Wall (`ElementWallSF`).
- **Required Settings**: The sub-script `GE_HDWR_ATC_ROD_ANCHORS.mcr` must be present in the TSL search path.
- **Minimum Beams**: N/A (Operates on Wall Elements).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_HDWR_ATC_ROD_MASTER.mcr` from the file dialog.

### Step 2: Select a Wall
```
Command Line: Select a Wall
Action: Click on the desired wall element in the Model Space.
```

### Step 3: Specify Engineering Type
```
Command Line: Specify Engineering Type
1=1/2 ATC 2=1/2 ATC+ANCHOR 3=CUP 4= 3/8 ATC 5=None[1/2/3/4/5] <3>
Action: Type the number corresponding to the required engineering scenario and press Enter.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Scenario | Dropdown | "1/2" ATC Engineering" | Defines the hardware configuration to apply. Options include 1/2" ATC, 1/2" ATC + Anchor, CUP, 3/8" ATC, or None. |
| Spacing | Number | 48" | The on-center spacing between the primary hold-down rods. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Re-distribute | Recalculates rod and anchor positions based on current wall length, openings, and properties. Useful after modifying the wall geometry. |
| Remove Existing | Deletes all hardware sub-scripts currently attached to the wall, effectively removing the rods and anchors while keeping the Master script active. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Upper Floor Logic**: This script automatically checks the wall elevation. If the wall bottom is higher than ~59 inches (typically an upper floor), the Scenario automatically defaults to "None" to prevent engineering hardware from being placed where it isn't needed.
- **Map Data Override**: If the wall element has specific map data attached (Key "TYPE"), it will override the Scenario selected in the properties or command line.
- **Updating Geometry**: If you change the length of the wall or add/remove window/door openings, use the **Re-distribute** right-click option to update hardware locations without re-running the script.
- **Spacing Impact**: When "Scenario" is set to "1/2" ATC & Anchor" (Type 2), anchors are placed at half the spacing specified in the properties, offset between the main rods.

## FAQ
- **Q: I ran the script, but no hardware appeared. Why?**
  **A:** Check the **Scenario** property in the Properties Palette. If the wall is on an upper floor (elevation > 59"), the script automatically sets the scenario to "None". You can manually change this back if required, though it usually indicates the wall is not a shear wall.
  
- **Q: How do I change the spacing between rods?**
  **A:** Select the wall or the script instance, open the Properties Palette (Ctrl+1), locate the **Spacing** parameter, and change the value. The script will automatically recalculate.

- **Q: What happens if I select "None" as the Scenario?**
  **A:** The script will remain attached to the wall but will not generate any physical hardware or sub-scripts. This is useful for temporarily disabling engineering without deleting the configuration.
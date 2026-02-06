# StackEntity.mcr

## Overview
This script simulates the loading of timber packages onto transport trucks to verify spatial fit and calculate logistics data. It manages 3D visualizations of truck loads, calculates axle loads based on weight distribution, and validates dimensions against truck configurations.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used for 3D visualization and placement of the truck loading area. |
| Paper Space | No | Not applicable for 2D drawings. |
| Shop Drawing | No | Not intended for manufacturing drawings. |

## Prerequisites
- **Required entities:** None (Inserts as a standalone entity).
- **Minimum beam count:** 0.
- **Required settings files:** `TslUtilities.dll` must be available. (Optional: XML configuration files for saving/loading truck settings).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `StackEntity.mcr`

### Step 2: Pick Insertion Point
```
Command Line: Pick insertion point.
Action: Click in the Model Space to place the StackEntity (truck base).
```

*(Note: After insertion, the script runs automatically. Further configuration is done via the Properties Palette and Right-Click Context menus.)*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Length | Double | 13600.0 | The usable length of the truck bed in mm. |
| Width | Double | 2480.0 | The usable width of the truck bed in mm. |
| Height | Double | 2700.0 | The maximum allowed height for the loaded truck in mm. |
| Tara | Double | 0.0 | The unladen weight (curb weight) of the vehicle in kg. |
| Gross Weight | Double | 0.0 | The maximum legally permissible total weight (Truck + Cargo) in kg. |
| Number | Integer | 0 | A fixed unique number used for identification or formatting. |
| Color Rule | String | byLayer | Determines visual color coding for stacked items (options: byLayer, byPackNumber, byStackLayer). |
| Asynchronous Oversize Width | Boolean | False | Toggles how width-wise packaging clearances are calculated relative to the stack. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Remove Items** | Allows you to select items currently in the stack to remove them. Prompts for a new location to place the removed items. |
| **Settings** | Opens a dialog box to configure display preferences, such as the Color Rule. |
| **Asynchronous/Synchronous Oversize Width** | Toggles the calculation mode for oversize widths without opening the full settings dialog. |
| **Export Settings** | Saves the current truck configuration (dimensions, weights, etc.) to an XML file. |
| **Import Settings** | Loads a truck configuration from a previously saved XML file. |

## Settings Files
- **Filename**: User-defined (e.g., `TruckConfig.xml`)
- **Location**: User-specified directory path.
- **Purpose**: Stores truck definition parameters (Length, Width, Height, Tara, Gross Weight) and display settings to ensure consistency across different loading plans without manual re-entry.

## Tips
- **Visualizing Layers:** Change the "Color Rule" property to `byStackLayer` or `byPackNumber` in the Properties Palette to visually distinguish different groups of timber in the 3D model.
- **Weight Validation:** The script calculates axle loads based on the Center of Gravity (COG). If you are exceeding weight limits, try redistributing the packages closer to the center of the truck.
- **Reuse Configurations:** If you frequently use the same truck type, use "Export Settings" once to save it, and then use "Import Settings" on new StackEntity instances to save time.

## FAQ
- **Q: How do I put timber packages onto the truck?**
- **A:** This script defines the truck boundary and logic. You typically attach your timber packages (elements) to this StackEntity using your standard production workflow or nesting tools.
- **Q: What do the load dimensions (Length, Width, Height) represent?**
- **A:** These define the maximum allowable volume for the truck. The script will visualize the load relative to these boundaries to check for clearance.
- **Q: What happens if I change the "Tara" property?**
- **A:** Updating the "Tara" (curb weight) will immediately recalculate the Net Cargo Weight and Axle Loads, helping you determine how much more material you can legally load.
# StackPack

## Overview
This script organizes timber elements into transport stacks and packages for logistics planning. It visualizes packing constraints using color coding and manages configuration settings for production and shipping.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used to organize and visualize 3D stacks of timber elements. |
| Paper Space | No | Not intended for 2D layout or drawing generation. |
| Shop Drawing | No | Does not generate manufacturing drawings. |

## Prerequisites
- **Required Entities**: GenBeam or Element objects existing in the model.
- **Minimum Beam Count**: 1.
- **Required Settings**:
  - `TslUtilities.dll` (must be available in the hsbCAD Utilities path).
  - Truck Definition configurations (required for dimension validation).

## Usage Steps

### Step 1: Launch Script
```
Command: TSLINSERT
Action: Browse and select 'StackPack.mcr'.
```

### Step 2: Select Elements
```
Command Line: Select elements / beams
Action: Select the GenBeams or Elements you wish to group into a stack package from the model.
```

### Step 3: Place Visualization
```
Command Line: Insertion point
Action: Click in the Model Space to define the location for the stack visualization or bounding box.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Color Rule (Item) | dropdown | byLayer | Determines how individual timber items are colored. Options: byLayer, byPackNumber, byStackLayer. |
| Color Rule (Pack) | dropdown | byPackNumber | Determines how the Pack/Stack container is colored. Options: byPackNumber, byStackLayer. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Color Rules | Opens a dialog to configure the visual color coding for both individual Items and Packs (e.g., coloring by layer vs. pack number). |
| Import Settings | Loads script configuration (Color Rules, etc.) from an external XML file. |
| Export Settings | Saves the current script configuration to an external XML file for reuse. |

## Settings Files
- **Filename**: Defined by `sFullPath` (variable inside script).
- **Location**: User-specified path or default project folder.
- **Purpose**: Stores and retrieves configuration data (such as Color Rules) to ensure consistency across different StackPack instances or projects.

## Tips
- Use the **Color Rules** feature to quickly identify which items belong to which shipping layer or package directly in the 3D model.
- Save your preferred configuration using **Export Settings** and use **Import Settings** to apply the same standards to other StackPack instances in the project.
- Ensure your Truck Definitions are up to date, as the script uses these to validate stack dimensions.

## FAQ
- **Q: How do I change the color of the beams in the stack?**
  A: Select the StackPack object, open the Properties Palette (Ctrl+1), and change the "Color Rule" property for Items. Alternatively, right-click and select "Color Rules".
  
- **Q: Can I share my stack settings with a colleague?**
  A: Yes. Right-click the StackPack object, choose "Export Settings" to create an XML file, and send it to your colleague. They can then use "Import Settings" to load your configuration.

- **Q: Why didn't the script generate a stack?**
  A: Ensure you have selected valid GenBeam or Element objects and that a valid Truck Definition is configured in your environment.
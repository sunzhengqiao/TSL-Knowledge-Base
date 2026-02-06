# truckImporter.mcr

## Overview
This script visualizes a logistics plan by generating a 3D truck model loaded with specific timber packages or elements. It is used to verify that timber packs fit within the truck's load space and to check the visual arrangement of the cargo.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script generates 3D geometry (Bodies) in the model. |
| Paper Space | No | Not designed for 2D layout or shop drawings. |
| Shop Drawing | No | Does not interact with detailing views. |

## Prerequisites
- **Required Entities**: The drawing must contain the Elements or GenBeams referenced in the load manifest. If these are missing, only placeholder boxes will be drawn.
- **Minimum Beam Count**: 0.
- **Required Settings Files**: A Map structure named `truckLoad` must exist within the drawing. This map acts as the configuration file, containing truck dimensions, axle layouts, and a list of items to load.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or select from hsbCAD menu)
Action: Select `truckImporter.mcr` from the file browser.

### Step 2: Automatic Execution
Action: Upon insertion, the script automatically reads the `truckLoad` Map.
- If the Map exists and contains valid data, the 3D truck and load will appear immediately.
- If the Map is missing or empty, no geometry will be generated.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | **Note:** This script does not expose parameters in the Properties Palette. All configuration is handled via the `truckLoad` Map in the drawing. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | No custom context menu options are defined for this script. |

## Settings Files
- **Filename**: `truckLoad` (Internal Map)
- **Location**: Stored within the drawing's internal `_Map` structure.
- **Purpose**: This data structure defines the truck geometry (chassis, wheels, cab) and the manifest of timber elements to be loaded. It includes coordinates, stack positions, and entity references to specific Elements or GenBeams.

## Tips
- **Missing Geometry**: If you insert the script and see nothing, check that the `truckLoad` Map has been correctly populated in the drawing.
- **Real vs. Placeholder**: The script attempts to draw the actual timber geometry for every item on the truck. If an item cannot be found (invalid handle), it will draw a grey placeholder box instead.
- **Cab Position**: The script automatically calculates where to place the truck cab based on the position of the cargo; you do not need to measure this manually.

## FAQ
- **Q: Can I resize the truck using the Properties Palette?**
  **A:** No. You must modify the dimensions inside the `truckLoad` Map structure (usually handled by another script or export tool).
- **Q: Why are my packages showing as grey boxes instead of actual timber?**
  **A:** The script cannot find the specific Element or GenBeam referenced in the load list. Ensure the source entities exist in the current drawing and have not been erased.
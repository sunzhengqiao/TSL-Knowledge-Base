# hsbTileEdge.mcr

## Overview
This script calculates and visualizes the layout of roof tiles along a roof intersection (valley, hip, or ridge) defined by two roof planes. It performs quantity takeoff and generates 3D bodies representing the tile coverage.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script requires 3D ERoofPlane entities to define the geometry. |
| Paper Space | No | Does not support direct creation in Paper Space. |
| Shop Drawing | No | This is a detailing/modeling script, not a drawing generator. |

## Prerequisites
- **Required Entities**: At least two adjacent `ERoofPlane` entities in the model.
- **Structural Elements** (Optional but recommended): `GenBeam` (Laths) or `ElementRoof` entities to define the exact nailing height.
- **Required Settings**: A valid `TileMap` (catalog containing tile dimensions like width, length, and thickness) must be available in the project.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbTileEdge.mcr` from the list.

### Step 2: Configure Initial Properties
Before or immediately after insertion, use the Properties Palette (Ctrl+1) to set:
- **Part Start/End**: Define specific tiles for the beginning and end of the run (e.g., half-tiles).
- **Allow Edit**: Set to "Yes" if you plan to manually modify individual tiles later.
- **Group**: Assign a group name for organization.

### Step 3: Select Roof Planes
```
Command Line: Select ERoofPlane 1/2 <Exit>:
Action: Click on the first roof plane defining the intersection.
```
```
Command Line: Select ERoofPlane 2/2 <Exit>:
Action: Click on the second adjacent roof plane.
```
*Note: If you do not select two valid planes, the script instance will be automatically erased.*

### Step 4: Define Structural Height (Optional)
Once the script is inserted, you can refine the tile elevation to match the battens.
1. Select the `hsbTileEdge` instance in the model.
2. Right-click and choose the option to select structural elements (e.g., "Select Laths" or similar context menu item).
3. Select the `GenBeam` or `ElementRoof` laths in the model.
4. The tile geometry will update to sit on top of these elements.

### Step 5: Interactive Editing (If Enabled)
If **sAllowEdit** was set to "Yes":
1. Select the script instance.
2. Use the specific Right-Click menu option to start the edit Jig (e.g., "Modify Tiles").
3. Click on individual tiles or regions to delete them or swap their type based on your catalog options.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sPartStart | Text | "" | The catalog name of the special tile used at the start of the edge (e.g., Starter Tile). |
| sPartEnd | Text | "" | The catalog name of the special tile used at the end of the edge. |
| sGroup | Text | "" | Organizational path for the instance in the model browser (e.g., "Roof\Tiles"). |
| sAllowEdit | Enum | No | Controls if the user can interactively add/remove tiles after insertion. (Options: Yes, No). |
| sDimStyle | Text | _DimStyles | The dimension style used for any annotations or measurements drawn by the script. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Select Structural Elements | Allows you to pick GenBeam laths or roof elements to set the correct Z-height for the tiles. |
| Modify / Edit Tiles | (Only available if sAllowEdit is Yes) Enters an interactive mode to select and remove specific tiles or change their properties. |
| Recalculate | Refreshes the tile layout based on current geometry or property changes. |

## Settings Files
- **Filename**: `TileMap` (varies by project configuration)
- **Location**: Defined in your hsbCAD configuration or project folder.
- **Purpose**: Contains the geometric definitions (width, height, length) for the available tile types. The script reads this to generate accurate 3D bodies and quantities.

## Tips
- **Plane Intersection**: Ensure the two roof planes you select physically intersect in 3D space. If they are parallel or do not meet, the calculation will fail.
- **Accuracy**: Always select the structural laths (GenBeams) in the Right-Click menu if available. This ensures the tiles visualize exactly where they will be nailed, rather than just floating on the theoretical roof plane.
- **Quantities**: The script generates quantity data (how many standard, start, and end tiles) which can be exported for BOM/estimating.

## FAQ
- **Q: Why did the script disappear immediately after I selected the planes?**
  **A**: You likely selected fewer than two valid ERoofPlane entities, or the planes selected do not form a valid intersection. The script is designed to erase itself if the geometry is invalid.
- **Q: How do I remove a tile to make room for a chimney?**
  **A**: Set the **sAllowEdit** property to "Yes" in the Properties Palette. Then, right-click the script instance, select the edit/modify option, and click the specific tile(s) you wish to remove.
- **Q: The tiles are floating above the battens. How do I fix this?**
  **A**: Use the Right-Click menu option to select the Structural Elements (Laths) and pick the beams underneath. The script will adjust the tile elevation to match the top of the beams.
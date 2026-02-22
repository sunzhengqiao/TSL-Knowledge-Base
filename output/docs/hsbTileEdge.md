# hsbTileEdge

Roof tile edge distribution tool for ridge, hip, and valley intersections between two roof planes.

## Overview

The **hsbTileEdge** script calculates and visualizes the distribution of roof tiles along the intersection line (edge) between two roof planes. It automatically detects the type of intersection (ridge, hip, or valley) and distributes tiles accordingly. The tool supports multiple tile types, allows manual modification of individual tiles, and provides quantity takeoffs for material ordering.

## Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary workspace. Requires 3D ERoofPlane entities. |
| Paper Space | No | Not designed for Paper Space operations. |
| Shop Drawing | No | This is a modeling/detailing script. |

**Version**: 1.4
**Unit System**: Millimeters (mm)

## Prerequisites

Before using this tool, ensure the following conditions are met:

1. **Two Roof Planes Required**: You must have at least two `ERoofPlane` elements that share a common edge (ridge, hip, or valley line).
2. **Roof Laths or Elements** (Optional but Recommended): For accurate tile plane positioning, append roof laths or roof elements to the script after insertion.
3. **Tile Configuration**: The script uses an internal `Tile` map with dimensional parameters (LMin, LMax, WMin, WMax, H) for each tile type.

## Usage

### Step-by-Step Workflow

1. **Insert the Script**
   - Run the `hsbTileEdge` command or insert the script from your TSL library.
   - A properties dialog will appear for initial configuration.

2. **Select Two Roof Planes**
   - When prompted with "Select 2 roofplanes", click on two adjacent roof planes that form a ridge, hip, or valley intersection.
   - The script automatically identifies the common edge between the planes.

3. **Append Reference Geometry** (Recommended)
   - Right-click the script instance and select **"append roof laths"** or **"append roof elements"** to provide accurate tile plane positioning.
   - Without this step, a warning message "append laths or roof elements" will be displayed.

4. **Review the Result**
   - The script displays:
     - A preview line along the tile edge with directional indicators
     - Individual tile outlines in plan view
     - A 3D tile body representation
     - Color-coded tiles by type (standard vs. special)

5. **Modify Tiles as Needed**
   - Use the context menu options to delete, add, or modify individual tiles.

## Parameters

### Properties Panel (OPM)

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Dimstyle** | String | (Current) | Dimension style used for text display and measurements. |
| **Grip edit** | Selection | No | Enable or disable grip editing. Options: "No", "Yes". |
| **Auto group tsl** | String | "" | Automatically assigns the script instance to a group hierarchy. Separate levels with backslash (e.g., "Roof\Tiles\Ridge"). |
| **Additional part Start** | String | "" | Tile type code for special start piece at the beginning of the edge. |
| **Additional part End** | String | "" | Tile type code for special end piece at the end of the edge. |

### Tile Configuration

The script reads tile specifications from an internal Map structure with the following properties per tile type:

| Property | Description |
|----------|-------------|
| **LMin** | Minimum tile length |
| **LMax** | Maximum tile length |
| **WMin** | Minimum tile width |
| **WMax** | Maximum tile width |
| **H** | Tile height/thickness |

Standard tiles (type "0") define the base distribution parameters. Special tile types can be assigned to individual positions.

## Menu

Right-click the script instance to access the context menu:

| Menu Item | Description |
|-----------|-------------|
| **Update** | Recalculates the tile distribution based on current geometry. |
| **append roof laths** | Prompts you to select roof lath beams to define the tile plane accurately. |
| **append roof elements** | Prompts you to select roof elements (with zone data) for tile plane positioning. |
| **delete tiles** | Allows you to click on tiles to mark them as deleted. Supports single-click or multi-point selection. |
| **add tiles** | Restores previously deleted tiles at selected positions. |
| **modify tile** | Changes the tile type at selected positions. Enter the new type index when prompted (0 = default). |

### Tile Selection Methods

When using delete/add/modify functions:
- **Single Click**: Affects one tile at the clicked location.
- **Multiple Points**: Click multiple points to create a selection polygon; all tiles intersecting the polygon are affected.
- **Two Points**: Creates a line selection; all tiles crossed by the line are affected.

## Tips

1. **Edge Type Detection**: The script automatically identifies the intersection type:
   - **Valley** (color 151): Sloped intersection going downward
   - **Ridge** (color 152): Horizontal intersection at roof peak
   - **Hip** (color 153): Sloped intersection going upward

2. **Accurate Positioning**: Always append roof laths or roof elements after insertion for precise tile plane alignment. The script uses the top surface of laths or elements zone 5 as the tile reference plane.

3. **Grouping**: Use the "Auto group tsl" property to organize multiple tile edge instances. Example: "Roof\Ridge Tiles\North Wing" creates a three-level group hierarchy.

4. **Material Takeoff**: The script automatically counts tiles by type and stores the data in the `TileData` map, accessible for reporting or scheduling.

5. **Special Pieces**: Use "Additional part Start/End" properties to add special starter or termination tiles (e.g., end caps) that differ from the standard distribution.

6. **Visual Feedback**:
   - Standard tiles display in color 151
   - Special tiles (type > 0) are marked with an additional line below the tile plane
   - Start/End pieces display in their respective type colors

7. **Grip Points**: The script creates two grip points at the start and end of the tile edge line. When "Grip edit" is set to "Yes", you can drag these points to adjust the edge extent.

8. **Invalid Selection**: If you select fewer than two valid roof planes or planes that do not form a valid intersection, the script instance will be automatically erased.

## FAQ

**Q: Why did the script disappear immediately after I selected the planes?**
A: You likely selected fewer than two valid ERoofPlane entities, or the planes selected do not form a valid intersection. The script erases itself if the geometry is invalid.

**Q: How do I remove a tile to make room for a chimney or vent?**
A: Right-click the script instance, select "delete tiles", then click on the specific tile(s) you wish to remove.

**Q: The tiles are floating above the battens. How do I fix this?**
A: Use the "append roof laths" or "append roof elements" context menu option and select the structural elements. The script will adjust the tile elevation to match the top of those elements.

**Q: How do I change a single tile to a different type?**
A: Right-click and select "modify tile", then click on the tile position. Enter the new type index (0 = default standard tile).

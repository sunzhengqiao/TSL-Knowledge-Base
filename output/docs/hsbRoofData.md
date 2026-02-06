# hsbRoofData

## Overview
This script automatically calculates specific construction areas (Eave, Inner, and Total Roof) based on 3D roof planes. It visualizes these calculations with hatching and labels and can generate a schedule table for documentation.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be inserted into Model Space where ERoofPlanes exist. |
| Paper Space | No | Not supported for Paper Space layout. |
| Shop Drawing | No | This is not a manufacturing/Shop Drawing script. |

## Prerequisites
- **Required Entities:** `ERoofPlane` entities must exist in the drawing.
- **Minimum Beam Count:** 0 (This script relies on roof planes, not beams).
- **Required Settings:**
  - Catalog entries for `hsbRoofData-EaveArea`
  - Catalog entries for `hsbRoofData-InnerArea`
  - Catalog entries for `hsbRoofData-RoofArea`
  - Catalog entries for `hsbRoofData-Schedule`

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or use the hsbCAD Insert Script tool) → Select `hsbRoofData.mcr`

### Step 2: Insert Script Instance
```
Command Line: Click to place script instance:
Action: Click anywhere in the Model Space to insert the script. The script will automatically detect and process all Roof Planes in the model.
```
*(Note: There are no manual selection prompts or insertion points for specific geometry; the script scans the model automatically.)*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Eave Area | dropdown | Disabled | Selects the catalog entry to define the Eave Area (overhang). If "Disabled", this area is not calculated or displayed. |
| Inner Area | dropdown | Disabled | Selects the catalog entry for the Inner Area (main roof surface). Enables calculation and display of the structural footprint area. |
| Roof Area | dropdown | Disabled | Selects the catalog entry for the Total Roof Area (complete geometric surface). Calculates the sum of all roof surfaces. |
| Schedule Table | dropdown | Disabled | Selects the catalog entry for the Schedule Table configuration. Generates a table listing all calculated roof areas. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add Point | Adds a grip point to the annotation geometry, allowing you to drag or reshape the label placement. |
| Remove Point | Removes a specific grip point from the annotation geometry. |
| Select polyline | Allows you to select a drawing polyline to define or modify the boundary for the area calculation. |
| Show edge description on/off | Toggles the visibility of textual descriptions along the edges of the calculated areas. |

## Settings Files
- **Catalog Entries**: `hsbRoofData-EaveArea`, `hsbRoofData-InnerArea`, `hsbRoofData-RoofArea`, `hsbRoofData-Schedule`
- **Location**: hsbCAD Catalog (Company or Installation path)
- **Purpose**: These XML entries define the visual style (hatching patterns, text size, layer) and calculation logic for the different roof areas.

## Tips
- Ensure your ERoofPlanes are correctly defined in 3D before inserting the script, as it relies on their geometry.
- If areas are not appearing, check the Properties Palette to ensure the relevant parameters are not set to "Disabled".
- Use the "Select polyline" context menu option if you need to calculate areas for non-standard or complex roof shapes not fully defined by the automatic roof plane detection.

## FAQ
- **Q: Why do I see labels but no hatching?**
  A: The hatching pattern is defined in the Catalog Entries. Check the specific catalog entry selected (e.g., for Inner Area) to ensure a hatch pattern is assigned.
- **Q: Can I update the areas if I modify the roof design?**
  A: Yes. The script listens to geometry changes. If you modify the ERoofPlanes, the calculations will automatically update.
- **Q: Where does the Schedule Table appear?**
  A: The schedule table is generated in the Model Space. Its insertion point and format are determined by the catalog entry selected in the "Schedule Table" property.
# hsbRP_EaveArea.mcr

## Overview
This script calculates and annotates the surface area of a specific boundary defined on a roof plane. It is used for material estimation (e.g., tiles, insulation, fascia) and supports displaying Gross/Net areas or Material names with optional hatching.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Requires selection of an existing Roof Plane entity. |
| Paper Space | No | Not designed for Shop Drawings or layout views. |
| Shop Drawing | No | Does not generate manufacturing details. |

## Prerequisites
- **Required Entities**: An existing `ERoofPlane` (Roof Plane) must exist in the model.
- **Minimum Beam Count**: 0
- **Required Settings**: None (uses standard CAD DimStyles and Hatch patterns).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbRP_EaveArea.mcr`

### Step 2: Configure Properties (Optional)
A "Properties" dialog may appear automatically, or you can configure settings later in the Properties Palette (Ctrl+1). Set values like **DimStyle**, **Unit**, and **Type of area** as needed.

### Step 3: Select Roof Plane
Action: Click on the existing Roof Plane entity in the drawing where you want to calculate the area.

### Step 4: Define Boundary
```
Command Line: select points
Action: Click points in the drawing to define the closed polyline boundary for the area calculation.
```
*Tip: Press Enter to finish the point selection.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimstyle | dropdown | *Current* | Sets the text style and height for the area labels. |
| Material | text | | Name of the material (e.g., "Zinc"). Only displayed if "Type of area" is set to "Eave area". |
| Unit | dropdown | mm | Unit of measurement for the displayed area (mm, cm, m, inch, feet). |
| Group (seperate Level by '\') | text | | Assigns the script to a specific group/layer hierarchy for organization. |
| Roof Name | text | | Identifier for the roof plane, used for data export/reports. |
| Hatch pattern | dropdown | None | Visual pattern to fill the calculated area (e.g., ANSI31, SOLID). |
| Type of area | dropdown | \|Roof area\| | **Roof area**: Shows Gross/Net area (subtracts openings). **Eave area**: Shows Material name and area. |
| Hatch scale | number | 30.0 | Scale factor for the hatch pattern density. |
| Color | number | 93 | Color index for the boundary lines and text labels. |
| Decimals | number | 0 | Number of decimal places for the displayed area and length values. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add Point | Adds new points to the current polyline boundary. |
| Remove Point | Removes specific points from the polyline boundary. |
| Select polyline | Replaces the current boundary by selecting an existing closed polyline in the drawing. |
| Show edge description on/off | Toggles the visibility of the edge length labels. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Quick Boundary**: If you have already drawn a polyline representing the area (e.g., a fascia line), insert the script, then use the **Select polyline** right-click option to snap the calculation to that existing shape instead of picking points manually.
- **Material Labels**: To see the Material name in the label, ensure **Type of area** is set to `|Eave area|` and fill in the **Material** property.
- **Net Area Calculation**: If the roof has openings (skylights, chimneys), use the `|Roof area|` mode. The script will automatically calculate the Net area (Gross minus openings).

## FAQ
- **Q: Why is my area text showing "0.00"?**
  A: Check the **Unit** property. If you are working in millimeters but displaying in meters, the number might look very small unless you adjust your decimals or unit settings.
- **Q: How do I move the text label?**
  A: The text is automatically placed at the centroid of the boundary. To move it, you must modify the boundary points so the centroid shifts, or explode the entity (not recommended if you want to keep it editable).
- **Q: Can I use this on a flat floor?**
  A: This script is designed specifically for `ERoofPlane` entities. For floors, use a floor-specific calculation script.
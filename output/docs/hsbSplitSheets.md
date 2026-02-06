# hsbSplitSheets.mcr

## Overview
This script automatically tiles an element zone (wall, floor, or roof) with rectangular panels (sheets or beams). It allows you to fill a construction layer with standard-sized material starting from a user-defined origin, automatically cutting panels around openings and element boundaries.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D construction entities (Elements and Sheets). |
| Paper Space | No | Not applicable for paper space layouts. |
| Shop Drawing | No | This is a model generation tool, not a detailing tool. |

## Prerequisites
- **Required Entities**: An existing hsbCAD Element (Wall, Floor, or Roof) containing at least one Sheet.
- **Minimum Beam Count**: 0.
- **Required Settings**: None specific, though a Material Catalog is recommended for assigning properties.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbSplitSheets.mcr`

### Step 2: Select Reference Sheet
```
Command Line: |Select a sheet of desired zone|
Action: Click on an existing sheet within the element/layer you wish to tile.
```
*This determines the target Element and the specific construction Zone (e.g., outer sheathing).*

### Step 3: Define Origin Point
```
Command Line: |Select first distribution point|
Action: Click in the model to set where the tiling grid starts (usually a bottom corner).
```

### Step 4: Define Split Points (Optional)
```
Command Line: |Select additional distribution point (optional)|
Action: Click points to create "stop lines" for the tiling pattern, or press Enter to finish.
```

### Step 5: Configure Properties
```
Action: The Properties Palette (OPM) will open. Adjust panel size, gap, and material as needed.
```
*Note: Default values are automatically pulled from the Element's Zone properties if available.*

### Step 6: Generate
```
Action: Double-click the script instance OR Right-click and select "Create Sheets" (or "Create Beams").
```

## Properties Panel Parameters

### Compose Rule
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Source | dropdown | Zone contour | **Zone contour**: Fills the entire element outline.<br>**Generated sheets**: Only fills areas where sheets currently exist (updates layout). |
| Merge Gap | number | 10 mm | Tolerance to merge adjacent profiles when updating existing sheets (closes small gaps). |

### Geometry
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Width | number | 1250 mm | The target width of the panels along the element's X-axis. |
| Length | number | 3000 mm | The target length of the panels along the element's Y-axis. |
| Thickness | number | 10 mm | The material thickness of the panels. |
| Gap | number | 10 mm | The spacing (expansion gap) left between adjacent panels. |

### Properties
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Material | text | *empty* | The material name/grade assigned to the panels (from catalog). |
| Label | text | *empty* | The main label identifier for the panels. |
| Sub-label | text | *empty* | The sub-label identifier for the panels. |
| Grade | text | *empty* | The structural grade or quality class. |

### Output
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Convert Type | dropdown | Beams | **Sheets**: Creates 2D contour objects with thickness.<br>**Beams**: Creates 3D volumetric bodies. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Create Sheets / Create Beams | Finalizes the process, erases old sheets in the zone, and generates the new panels. |
| Add Split Points | Allows you to select additional points to modify the grid layout after insertion. |
| Erase | Removes the script instance without generating geometry. |

## Settings Files
- **Filename**: None specific (uses hsbCAD Catalogs).
- **Location**: N/A
- **Purpose**: Material properties are pulled from the standard hsbCAD Material Catalog.

## Tips
- **Updating Layouts**: If you have an existing sheet layout and want to modify it (e.g., change width), select **Source: "Generated sheets"**. The script will calculate the new layout based on where sheets currently exist rather than the whole wall contour.
- **Gap Calculation**: If the Element Zone variables define a specific gap, the script will automatically calculate the `Width` property as `(Zone Width - Gap)` to ensure a perfect fit.
- **Visual Feedback**: After insertion, you can drag the **Origin Point** and **Split Points** (grips) in the model to visually adjust the tiling pattern before creating it.
- **Origin Point**: The first point you pick acts as the "start" corner. Ensure it is placed logically relative to how you want the sheets to run (e.g., bottom-left of a wall).

## FAQ
- **Q: What is the difference between creating Sheets vs Beams?**
  - A: **Sheets** are typically used for 2D representations with thickness (like OSB or Plywood in plans). **Beams** are volumetric 3D objects (like CLT panels or Timber frames) that have true volume and may interact differently with other 3D operations.
- **Q: Why did my script disappear after I clicked Create?**
  - A: This is normal behavior. The script acts as a temporary "calculator." Once you click "Create," it produces the final geometry and removes itself from the model to prevent duplication.
- **Q: Can I use this to floor a whole house?**
  - A: Yes. Select the floor sheet, pick the origin, and ensure **Source** is set to "Zone contour" to fill the entire floor outline.
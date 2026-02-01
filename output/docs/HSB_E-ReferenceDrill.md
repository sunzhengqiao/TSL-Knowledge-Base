# HSB_E-ReferenceDrill.mcr

## Overview
Automatically creates reference drilling grids on multiple beams within an element. Drills are placed at specified intervals along vertical and horizontal axes relative to the element origin, useful for alignment marks or assembly reference points.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment. |
| Paper Space | No | Not designed for layout views. |
| Shop Drawing | No | Not designed for 2D drawings. |

## Prerequisites
- **Required Entities**: Elements containing GenBeams.
- **Minimum Beam Count**: 0 (Script handles empty elements gracefully).
- **Required Settings Files**: None (Catalog entries optional for ExecuteKeys).

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT`
**Action:** Browse and select `HSB_E-ReferenceDrill.mcr`.

### Step 2: Configure Properties
**Dialog Box:** A dynamic dialog will appear upon insertion.
**Action:**
1. **Selection**: Choose whether to "Include" or "Exclude" specific beam codes. Enter the beam codes (e.g., `STU`, `RIE`) if filtering is required.
2. **Position**: Enter distances for "Horizontal positions" and "Vertical positions" (e.g., `500; 1000`).
3. **Drill**: Set the desired Diameter for the reference holes.
4. Click **OK** to confirm.

### Step 3: Select Elements
**Command Line:** `Select a set of elements`
**Action:** Click on the Element(s) in the model where you want to add reference drills. Press Enter to finish selection.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| \|Selection\| | Header | - | Section header for filtering settings. |
| \|Filter type\| | Dropdown | Include | Determines if the beam code list acts as a whitelist (Include) or blacklist (Exclude). |
| \|Filter beams with beamcode\| | Text | - | List of beam codes to filter. Supports wildcards (e.g., `*STU*`). |
| \|Position\| | Header | - | Section header for grid position settings. |
| \|Horizontal positions\| | Text | - | Distances (mm) along the element Y-axis where vertical drill planes are created. |
| \|Vertical positions\| | Text | 500 | Distances (mm) along the element X-axis where vertical drill planes are created. |
| \|Drill\| | Header | - | Section header for machining settings. |
| \|Diameter\| | Number | 18 | Diameter of the reference drill hole. |
| \|Visualisation\| | Header | - | Section header for display settings. |
| \|Color\| | Number | 4 | CAD color index for the grid lines and markers. |
| \|Symbol size\| | Number | 40 | Size of the graphical marker displayed in the model. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| MasterToSatellite (Catalog Mapping) | Updates property values from a specific catalog entry if a mapping flag exists (Advanced use). |

## Settings Files
- **Filename**: Catalog entries (internal)
- **Location**: Company or Install hsbCAD Catalog path
- **Purpose**: Stores property presets for ExecuteKeys and MasterToSatellite mapping, allowing for quick loading of standard drilling configurations.

## Tips
- **Interactive Adjustment**: After insertion, select the element and look for the grip points on the visualized grid lines. Drag these points to visually adjust the drilling positions; the property values will update automatically.
- **Beam Filtering**: Use the "Filter beams with beamcode" field with wildcards (e.g., `*Wall*`) to apply drills only to specific types of beams within a complex element.
- **Coordinate Origin**: The script calculates the reference origin based on the bounding box of the beams. Ensure your beams are correctly positioned before inserting the script.

## FAQ
- **Q: How do I move the drill lines after I have placed them?**
  A: Select the script instance in the model. You will see grip points along the horizontal and vertical grid lines. Click and drag these grip points to the desired location. The drill positions will update immediately.
- **Q: Why are some of my beams not getting drilled?**
  A: Check the Properties Palette. Ensure the "Filter type" is set correctly (Include vs. Exclude) and that the "Filter beams with beamcode" matches the codes of the beams you wish to process.
- **Q: Can I use multiple distances for the grid?**
  A: Yes. In the "Horizontal positions" or "Vertical positions" fields, enter multiple values separated by semicolons (e.g., `500; 1000; 1500`).
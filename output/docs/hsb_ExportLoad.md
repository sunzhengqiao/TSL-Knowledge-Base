# hsb_ExportLoad.mcr

## Overview
Graphically defines structural engineering loads (Point, Line, or Area) within the 3D model and packages the data for export to structural analysis software.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment. |
| Paper Space | No | Not supported in layout views. |
| Shop Drawing | No | Not applicable for 2D drawings. |

## Prerequisites
- **Required entities:** None.
- **Minimum beam count:** 0.
- **Required settings files:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_ExportLoad.mcr`

### Step 2: Configure Load
**Action:** Upon running the script, a dialog will appear.
- **Load Type:** Select **Point**, **Line**, or **Area**.
- **Load Magnitude:** Enter the force value.
- **Load Units:** Select the unit of measurement (e.g., kg/sq m).
- **Color:** Select a display color (default is Red).
- Click **OK** to proceed.

### Step 3: Define Geometry
The command line prompts will vary based on the Load Type selected in Step 2:

**If Type = Point:**
```
Command Line: Select a point
Action: Click in the model to place the point load.
```

**If Type = Line:**
```
Command Line: Select start point
Action: Click the start location of the load.
Command Line: Select end point
Action: Click the end location of the load.
```

**If Type = Area:**
```
Command Line: Select start point
Action: Click the first corner of the area.
Command Line: Select next point
Action: Click subsequent corners to define the perimeter.
Action: Press Enter or Esc to close the shape and finish.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Load Type | dropdown | Point | Determines the shape of the load (Point, Line, or Area). **Note:** Becomes read-only after insertion. |
| Load Magnitude | number | 1 | The numerical value of the force or pressure. |
| Load Units | dropdown | kg/sq m | The unit of measurement for the magnitude (e.g., kg/sq mm, Ibs/sq ft). |
| Color | number | 1 | The AutoCAD color index (ACI) used to draw the load marker in the model. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are available for this script. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Visual Distinction:** Use the **Color** property to differentiate between different load cases (e.g., Red for Dead Load, Blue for Live Load) directly in the model view.
- **Type Locking:** Once the load is inserted, the **Load Type** cannot be changed (e.g., you cannot change a Point load to a Line load). You must delete the instance and re-insert it to change the type.
- **Area Closure:** For **Area** loads, ensure your pick points form a logical loop. The script will automatically close the polyline connecting the last point to the first.

## FAQ
- **Q: Why can't I change the Load Type in the properties palette after inserting?**
  - A: The script locks the Load Type property upon insertion to maintain data integrity for the export map. To change the type, erase the current instance and insert a new one.
- **Q: Does this script alter the physical timber geometry?**
  - A: No. This script creates visual markers (lines/polylines) and data maps for structural analysis calculations; it does not cut or modify beams.
- **Q: How do I export the data?**
  - A: This script prepares the data map. You must use the relevant hsbCAD export function or a subsequent script that reads the "Load" map to transfer data to your analysis software.
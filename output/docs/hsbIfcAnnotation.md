# hsbIfcAnnotation.mcr

## Overview
This script visualizes IFC (Industry Foundation Classes) annotation data, such as dimensions, text labels, and reference points, directly in the 3D model. It acts as a display container for non-geometric BIM data, ensuring architectural or structural annotations are visible within the timber detailing environment.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script runs exclusively in Model Space to visualize 3D annotations. |
| Paper Space | No | Not supported for layout generation. |
| Shop Drawing | No | Not intended for use in 2D shop drawings. |

## Prerequisites
- **Required Entities:** An Element or Entity with `ifcAnnotation` map data attached to it.
- **Minimum Beam Count:** 0 (The script functions independently of beams).
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `hsbIfcAnnotation.mcr` from the file selection dialog and click **Open**.

### Step 2: Place Instance
Action: Click in the Model Space to set the insertion point (`_Pt0`) for the annotation group.
- **Note:** The script does not prompt for further input during insertion. Upon placement, it will immediately attempt to read the attached IFC map data to generate the visualization.

### Step 3: Verify Visualization
- If valid IFC data is found in the map, the script will draw the specific geometry (Lines, Points as crosshairs, or Text).
- If no data is found, the script will display its own name (`hsbIfcAnnotation`) at the insertion point as a diagnostic placeholder.

## Properties Panel Parameters
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| *None* | N/A | N/A | This script does not expose user-editable parameters in the Properties palette. The visualization is driven entirely by the attached `ifcAnnotation` map data. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| *None* | No custom context menu items are added by this script. Standard options (Move, Rotate, Erase, Recalculate) apply. |

## Settings Files
- **Filename:** None required.
- **Location:** N/A
- **Purpose:** N/A

## Tips
- **Diagnostic Mode:** If you see the script name written at the insertion point instead of IFC geometry, it indicates the required `ifcAnnotation` map data is missing or empty on that instance.
- **Moving Annotations:** You can move or rotate the entire group of annotations using standard AutoCAD grips or commands on the script instance. The geometry is drawn relative to the script's local coordinate system.
- **Point Representation:** IFC Points are visualized as crosshairs ("X") with a fixed size to ensure they are visible in the 3D model.

## FAQ
- **Q: Why do I only see the text "hsbIfcAnnotation" in my model?**
  **A:** This is the fallback behavior. It means the script cannot find the `ifcAnnotation` map data on the instance. This usually happens if the script is inserted manually without the accompanying BIM data generation process, or if the data map was deleted.

- **Q: Can I change the size of the text or the crosshairs?**
  **A:** No, these values are hardcoded internal defaults designed to ensure visibility. The script renders the data exactly as provided in the map (with text size overrides if specified in the IFC data).

- **Q: How do I update the annotation if the BIM data changes?**
  **A:** Use the **Recalculate** command (or right-click and select Recalculate) on the script instance. This forces the script to re-read the map data and redraw the geometry.
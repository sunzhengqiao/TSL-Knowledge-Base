# HSB_E-MarkSheetEdges.mcr

## Overview
Automatically marks the edges of sheathing or sheeting materials on underlying structural beams. This tool is used to visualize and generate nailing or fixing lines (e.g., for plywood or OSB sheets) directly on the beams in the 3D model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script attaches to Elements and modifies beams in the 3D model. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | This is a model processing script, not a 2D detail generator. |

## Prerequisites
- **Required Entities:** Elements containing Sheets and GenBeams.
- **Required Settings:** The script `HSB_G-FilterGenBeams.mcr` must be loaded in the drawing to use filter definitions.
- **Minimum Beams:** 0 (The script will run, but marks require beams to be present).

## Usage Steps

### Step 1: Launch Script
Command: Type `TSLINSERT` in the command line and select `HSB_E-MarkSheetEdges.mcr`.

### Step 2: Configure Properties
If an Execute Key (saved preset) is not selected, a properties dialog will appear.
- **Assign to element zone:** Select the construction layer index (e.g., 0-10) that contains the sheeting material you wish to process.
- **Filter definition female beams:** (Optional) Select a preset filter to determine which beams receive the marks (e.g., only Rafters).
- **Click OK** to confirm settings.

### Step 3: Select Elements
```
Command Line: Select elements
Action: Click on the Element(s) (walls, roofs, or floors) containing the sheets and beams you wish to process. Press Enter to finish selection.
```

### Step 4: Review Results
The script will attach to the element. Visual markers will appear on the beams at the intersections with the sheet edges. You can inspect these marks in the 3D model or use them for machining/data export.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Assign to element zone | Dropdown | 6 | Selects the specific construction layer (Index 0-10) within the Element that contains the sheeting geometry to be analyzed. |
| Filter definition female beams | Dropdown | (Empty) | Selects a saved filter preset from `HSB_G-FilterGenBeams` to identify which supporting beams should receive the marks. If left blank, manual beam codes are used. |
| Female beam codes to filter | Text | (Empty) | Manually enter Beam Codes (e.g., "Rafter", "Joist") to mark specific beams. **Note:** This is only active if "Filter definition female beams" is left blank. |
| Only use horizontal edges | Dropdown | No | If set to "Yes", the script ignores vertical or non-horizontal sheet edges (like gable ends) and only marks horizontal lines. |
| Use Outline for marking | Dropdown | Yes | If set to "Yes", outer perimeter edges are marked. If "No", only internal sheet-to-sheet joints are marked. |
| Color | Number | 4 | Specifies the AutoCAD color index for the visualization symbol. |
| Symbol size | Number | 40.0 (mm) | Specifies the size of the visualization symbol displayed in the model. |
| Identifier | Text | (Empty) | Ensures only one instance of this script per identifier is attached to an element. Useful for managing multiple configurations. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None specific) | This script uses standard hsbCAD update behavior. Changes in the Properties Palette trigger automatic recalculation. |

## Settings Files
- **Dependency**: `HSB_G-FilterGenBeams.mcr`
- **Purpose**: This script is required to provide the list of available filter definitions and to process beam filtering logic.

## Tips
- **Check Your Zone:** If no marks appear, verify that the "Assign to element zone" corresponds to the layer where your sheets (e.g., OSB) are actually defined in the Element construction.
- **Filtering:** Use `HSB_G-FilterGenBeams` to create complex filters (e.g., "All beams except purlins") rather than manually typing codes for better control.
- **Visual Confirmation:** Adjust the "Color" and "Symbol size" properties if the marks are hard to see against your timber material colors.
- **Internal vs External:** Set "Use Outline for marking" to **No** if you only want to see where sheets butt against each other, rather than the outer edge of the roof/floor.

## FAQ
- **Q: Why are no marks appearing on my beams?**
  - **A:** Check three things: 1) Ensure the correct "Zone" is selected where sheets exist. 2) Ensure your "Filter definition" actually includes the beams you expect to mark. 3) Ensure the `HSB_G-FilterGenBeams` script is loaded.
- **Q: Can I mark only the joints between sheets and ignore the outer edge?**
  - **A:** Yes. Set the property "Use Outline for marking" to **No**.
- **Q: What happens if I change the Element geometry?**
  - **A:** The script is set to update automatically. Changing the roof shape or sheet layout will trigger the script to recalculate the mark positions immediately.
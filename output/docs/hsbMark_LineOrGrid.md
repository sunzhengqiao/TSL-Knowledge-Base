# hsbMark_LineOrGrid.mcr

## Overview
Projects reference lines, polylines, or grid lines onto structural timber elements (beams, sheets, panels) to create manufacturing marks or layout text.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for selecting 3D structural elements and reference geometry. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**:
  - Source Geometry: Lines, Polylines, or Grids.
  - Target Elements: GenBeams, Sheets, or Panels.
- **Minimum Beam Count**: 1 (Must select at least one valid structural element).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbMark_LineOrGrid.mcr`

### Step 2: Configure Parameters (Optional)
Before selecting geometry, you can adjust settings in the Properties Palette (e.g., define text, select mark type, or set filters).

### Step 3: Select Marking Objects
```
Command Line: Select marking objects (Line, Polyline, Grid):
Action: Click on the reference lines, polylines, or grid objects you wish to project.
```
- **Note for Grids**: If a Grid is selected, a "Jig" mode activates. Hover over grid lines to toggle them Green (Selected) or Red (Not Selected). Press Enter or click to confirm the selection.

### Step 4: Select Target Elements
```
Command Line: Select target elements:
Action: Click on the beams, sheets, or panels that need to receive the marks.
```
- If a "Filter" is defined in properties, only matching elements will be processed.

### Step 5: Completion
The script automatically processes the geometry, calculates intersections, and attaches the marks to the elements. If `sRemoveInstance` is set to "Yes", the script instance will delete itself, leaving only the marks on the beams.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sFilterGbs | String | <No definition> | Filters target elements based on a specific Painter Definition (e.g., only walls). |
| sMarkType | Enum | Mark | Determines the output type: "Mark" (Text/Number) or "Markerline" (Physical line). |
| sFullLength | Enum | No | **No**: Projects the line across the entire face of the element. **Yes**: Projects only the length of the selected source object. |
| sMarkSide | Enum | Closest side | Determines which face receives the mark: "Closest side", "Opposite side", "Left side", or "Right side". |
| sRemoveMarkingObject | Enum | No | **Yes**: Deletes the source Line/Polyline/Grid after processing. **No**: Keeps the source geometry. |
| sRemoveInstance | Enum | No | **Yes**: Deletes script instance (Static Tool). **No**: Keeps instance for dynamic updates. |
| nColor | Number | 2 | Sets the AutoCAD color index for visual display of the mark. |
| sTxt | String | "" | Defines the text content for the mark (supports format variables). |
| dTxtHeight | Number | 30 | Sets the physical height of the text on the timber (in mm). |
| sTxtPosition | Enum | Middle | Aligns text relative to the mark line: Right, Middle, or Left. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the marks if the script instance is still present and geometry has moved. |
| Properties | Opens the Properties Palette to adjust parameters. |

## Settings Files
- None required.

## Tips
- **Clean Up**: Use `sRemoveMarkingObject` set to "Yes" to automatically delete the temporary construction lines used as references.
- **Performance**: For large models, use `sFilterGbs` to prevent the script from attempting to mark irrelevant elements (like floor joists when marking wall grids).
- **Static vs. Dynamic**: If you do not plan to move the grid lines or beams later, set `sRemoveInstance` to "Yes" to reduce the size of your model tree.
- **Grid Selection**: When using Grids, pay attention to the color highlights (Green/Red) during the jig phase to ensure you are marking exactly the lines you intend.

## FAQ
- **Q: Why did some beams not receive a mark?**
  **A:** The script will skip a beam if the projection line misses the body completely or if the mark lands exactly on an edge/corner where it cannot be applied.
- **Q: Can I use this on curved timber?**
  **A:** Yes. However, if the mark side is set to "Closest" or "Opposite", the script will automatically override this and use "Left" or "Right" side logic, as curved geometry cannot calculate a standard "closest" face projection.
- **Q: What is the difference between "Mark" and "Markerline"?**
  **A:** "Mark" typically adds information to production lists or labels. "Markerline" creates actual geometric data used for CNC machining or scribing on the timber surface.
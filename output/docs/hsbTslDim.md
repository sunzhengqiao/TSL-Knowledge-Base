# hsbTslDim.mcr

## Overview
This script creates associative dimension lines for timber elements (beams, sheets, planes) and their sub-components (like drill holes or TSL connectors) directly in the 3D model. It provides accurate measurement annotations that automatically update if the design geometry changes.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary environment for interactive placement and viewing. |
| Paper Space | No | This script does not generate dimensions in layout views. |
| Shop Drawing | No | Not intended for automatic shop drawing generation. |

## Prerequisites
- **Required Entities**: None strictly required (points can be selected manually), but typically used with `GenBeam`, `Sheet`, `ERoofPlane`, or `TslInst`.
- **Minimum Beam Count**: 0.
- **Required Settings**: `_DimStyles` (Standard CAD dimension styles must be available in the drawing).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbTslDim.mcr`

### Step 2: Configure Properties
```
Dialog Box: [Properties Dialog]
Action: Verify settings (DimStyle, Color, etc.) and click OK.
```

### Step 3: Set Insertion Point
```
Command Line: Select insertion point
Action: Click in the model where you want the dimension line to start.
```

### Step 4: Define Direction
```
Command Line: Next point (Defines Direction)
Action: Click a second point to set the direction and angle of the dimension line.
```

### Step 5: Add Manual Points (Optional)
```
Command Line: Select dim point
Action: Click specific points you want to dimension. Press **Enter** or **Esc** to finish adding points and proceed.
```

### Step 6: Select Entities (Optional)
```
Command Line: Select entities (optional)
Action: Select beams, sheets, or other elements to automatically generate dimension points based on their geometry. Press **Enter** to finish selection.
```

### Step 7: Define Entity Side (If Entities Selected)
```
Command Line: Dimpoints of entities on ... (Default = 2)
Action: Enter a number to define which side of the entity to dimension (e.g., 1 for Left, 2 for Right, 3 for Center).
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimstyle | dropdown | _DimStyles | Selects the visual style (text size, arrows) for the dimension. |
| Color | number | 9 | Sets the CAD color index for the dimension line and text. |
| Display mode Delta | dropdown | Parallel | Controls how individual (delta) dimension text aligns relative to the line. Options: Parallel, Perpendicular, None. |
| Display mode Chain | dropdown | Parallel | Controls how cumulative chain dimension segments align. Options: Parallel, Perpendicular, None. |
| Mirror read direction | dropdown | No | If Yes, flips the text orientation so it is readable from the opposite side. |
| Delta on Top | dropdown | No | If Yes, moves the dimension text above the line instead of breaking the line. |
| Description Alias | text | | Adds a custom text label (e.g., "Ridge") at the start of the dimension. |
| Linear Scale Factor | number | 1 | Multiplies the displayed dimension value (e.g., use 0.001 to convert mm to m). |
| TSL Name | text | | Filters which specific TSL connectors are dimensioned. Separate multiple names with a semicolon (;). |
| additional dimpoints | dropdown | None | Automatically includes points for Drills or TSLs connected to the selected entities. |
| Show in Modelspace | dropdown | No | Toggles the visibility of the dimension in the 3D model. |
| Mode | dropdown | Default | Switches logic to "Opening embraced by GenBeams" to dimension clear openings within a wall frame. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Edit points of entities | Breaks the link to the timber entities. Converts all currently calculated dimension points into manual grip points, allowing you to move them independently without affecting the original beams. |

## Settings Files
- **Filename**: Catalog Entries (defined in `_kExecuteKey`)
- **Location**: hsbCAD Catalog
- **Purpose**: Allows you to save predefined property sets (presets) so you don't have to manually configure the dialog every time.

## Tips
- **Dimensioning Openings**: To find the width of a window or door opening in a frame, set the **Mode** property to "Opening embraced by GenBeams" and select the surrounding beams.
- **Filtering Hardware**: If you only want to dimension specific connectors (like screws), type the name of that TSL script into the **TSL Name** property and set **additional dimpoints** to "TSL's".
- **Static Dimensions**: If you want to keep a dimension even if you delete or move the beam later, use the "Edit points of entities" right-click option to freeze the points.

## FAQ
- **Q: How do I display dimensions in meters instead of millimeters?**
  **A:** Change the **Linear Scale Factor** property to `0.001`.
- **Q: My dimension text is upside down. How do I fix it?**
  **A:** Set the **Mirror read direction** property to "Yes".
- **Q: Can I mix manual points and automatic entity dimensions?**
  **A:** Yes. You can pick manual points in Step 5 and then select entities in Step 6. The script will combine them into one dimension line.
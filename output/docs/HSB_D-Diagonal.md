# HSB_D-Diagonal.mcr

## Overview
This script automatically creates diagonal dimension lines and arrows in Paper Space viewports to display the diagonal length of selected timber elements (e.g., walls or floor panels), effectively ignoring minor manufacturing details at the corners.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | Reads geometry from Model Space via the Viewport. |
| Paper Space | Yes | Draws dimensions and text on the Layout. |
| Shop Drawing | No | Used for production layouts, not generating CAM data. |

## Prerequisites
- **Required Entities**: A Layout (Paper Space) with an active Viewport containing a valid hsbCAD Element.
- **Minimum Beam Count**: 0 (The element must have geometry to measure, but specific beam count requirements vary by design).
- **Required Settings**: Access to the `HSB_G-FilterGenBeams` catalog/map for filtering elements.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `HSB_D-Diagonal.mcr` from the file dialog.

### Step 2: Select Viewport
```
Command Line: Select viewport
Action: Click on the viewport in Paper Space that displays the timber element you wish to dimension.
```

### Step 3: Select Position
```
Command Line: Select position
Action: Click a point in Paper Space. This serves as the insertion point for the script instance (used primarily for positioning error messages if they occur).
```

### Step 4: Configure Properties
Action: After insertion, the script properties appear in the AutoCAD Properties Palette (Ctrl+1). Adjust filters, style, and margins as needed. The dimension will update automatically.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Filter Definition** | String | (Empty) | Select a predefined filter set from the HSB_G-FilterGenBeams catalog to determine which beams to include. |
| **Filter Beam Code** | String | (Empty) | Specify beam codes (e.g., "STU;PLT") to include only specific beam types. |
| **Filter Label** | String | (Empty) | Filter elements by their material label (e.g., "C24"). |
| **Filter Zone** | String | 1;7 | Filter elements by their construction Zone IDs. |
| **Dimension Method** | Enum | As arrow | Choose between a graphical arrow/leader or a standard dimension line. |
| **Corner Margin** | Double | 25.0 | Tolerance distance (mm) to treat points as a single corner. Set to **-1** to calculate based on vertical midpoint (Gable Mode). |
| **Position** | Enum | Automatic | Selects which diagonal to draw: "Automatic", "From bottom-left", or "From bottom-right". |
| **Dimension Style** | String | _DimStyles | Select the CAD Dimension Style to use for text and arrows. |
| **Precision** | Int | 0 | Number of decimal places for the length text (e.g., 0 for 5000, 1 for 5000.0). |
| **Arrow Length** | Double | 300.0 | Visual length of the arrow tail or dimension line extension. |
| **Offset Text X** | Double | 50.0 | Horizontal offset of the dimension text relative to the line. |
| **Offset Text Y** | Double | 15.0 | Vertical offset of the dimension text relative to the line. |
| **Dim Color** | Int | -1 | Color index for the dimension line (-1 = ByBlock). |
| **Arrow Color** | Int | 3 | Color index for the arrow head. |
| **Show Script Name** | Enum | No | If "Yes", displays the script name "HSB_D-Diagonal" on the drawing. |
| **Assign to Layer** | String | (Empty) | Specifies the CAD layer on which to draw the dimensions and text. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Filter this element** | Hides the diagonal dimension for the specific element selected in this instance. |
| **Remove filter for this element** | Restores the diagonal dimension for this specific element. |
| **Clear filter for all elements** | Clears all global filters, making dimensions visible for all filtered elements again. |

## Settings Files
- **Filename**: `HSB_G-FilterGenBeams.mcr`
- **Location**: Company or hsbCAD Install path (Catalog/Scripts)
- **Purpose**: Provides pre-defined logical groups of beams (e.g., "External Walls") to automate the selection of geometry to dimension.

## Tips
- **Gable Walls**: If dimensioning a gable wall where the top corners are not the same height, set the **Corner Margin** property to `-1`. This activates "Automatic Mode" which calculates the vertical midpoint to correctly identify top and bottom points.
- **Missing Dimensions**: If the text "Corner offset to small" appears, the **Corner Margin** value is too tight to detect the corners clearly. Increase the value slightly (e.g., from 5 to 20).
- **Filtering**: Use the **Filter Zone** or **Filter Label** properties if the script is picking up beams you don't want to include in the measurement (like dummy beams or sheathing).

## FAQ
- **Q: Why do I see "Unexpected error" when I insert the script?**
  A: This usually means the script could not find any valid points in the selected element after applying filters. Check if the Viewport contains a valid Element and that your Beam Code/Label filters aren't excluding everything.
  
- **Q: Can I move the text after inserting?**
  A: The text position is calculated automatically based on the geometry. You can adjust the **Offset Text X/Y** properties in the Properties Palette to shift it relative to the line. Moving the script insertion point (Grip Edit) moves the error message location.

- **Q: How do I dimension the other diagonal?**
  A: Change the **Position** property from "Automatic" to "From bottom-left" or "From bottom-right" to force a specific direction.
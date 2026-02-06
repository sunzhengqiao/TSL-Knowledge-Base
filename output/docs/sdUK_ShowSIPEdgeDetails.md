# sdUK_ShowSIPEdgeDetails.mcr

## Overview
This script automatically generates detailed 2D cross-sections for Structural Insulated Panel (SIP) edges. It displays the layered construction, dimensions, bevel angles, and recess depths directly in your drawing layout to assist with manufacturing and assembly.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Details are generated at the 3D location of the panel. |
| Paper Space | Yes | Used in conjunction with the "shopdraw multipage" mode to place details in a grid on the layout. |
| Shop Drawing | Yes | Specifically designed to work with Shopdraw Viewports. |

## Prerequisites
- **Required entities**: Structural Insulated Panels (SIP).
- **Minimum beam count**: 1 SIP panel.
- **Required settings**: Valid AutoCAD Dimension Styles must exist in the drawing.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `sdUK_ShowSIPEdgeDetails.mcr`

### Step 2: Configure Settings
- A dialog box appears automatically upon insertion.
- Set your preferred Drawing Space, Dimensions, and Colors.
- Click OK to proceed.

### Step 3: Set Insertion Point
```
Command Line: Pick a point for edge details
Action: Click in the drawing area to set the origin for the detail block.
```

### Step 4: Select Elements
The next prompt depends on the **Drawing Space** setting selected in Step 2.

*   **Option A: If set to 'Model'**
    ```
    Command Line: Please select Elements
    Action: Select one or more SIP panels from the model.
    ```

*   **Option B: If set to 'shopdraw multipage'**
    ```
    Command Line: Select the view entity from which the module is taken
    Action: Click on the Shopdraw Viewport border or the view entity representing the panel.
    ```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Drawing space | dropdown | Model | Choose where to generate details: **Model** (3D) or **shopdraw multipage** (2D Layout). |
| Dimstyle | dropdown | _DimStyles | Select the dimension style to control text size and arrow style. |
| Detail Color | number | 1 | AutoCAD Color Index for the edge profile lines (Red). |
| Text Color | number | 0 | AutoCAD Color Index for dimension and label text (White/ByBlock). |
| Maximum Number of Rows | number | 5 | In Shopdraw mode, sets how many edge details stack vertically before starting a new column. |
| Dimensions offset | number | 50.0 | Distance (mm) between the edge geometry and the dimension lines. |
| Extra offset between details | number | 200.0 | Buffer distance (mm) used to crop the main panel body, isolating the specific edge detail. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None Specific) | This script relies on the standard AutoCAD Properties Palette for configuration. Select the script instance and press `Ctrl+1` to edit parameters. |

## Settings Files
- **Filename**: None (Script uses standard AutoCAD DimStyles).
- **Location**: N/A
- **Purpose**: The script references standard Dimension Styles available in the current drawing for formatting text and arrows.

## Tips
- **Layout Control**: When using **shopdraw multipage** mode, adjust the **Maximum Number of Rows** property. If your layout is Portrait, increase this number to use vertical space efficiently. If Landscape, decrease it to force columns to the right.
- **Clipping**: If the edge details are overlapping too much with the main panel view, increase the **Extra offset between details** to create a larger "blank" buffer around the cross-section.
- **Update Speed**: Changing the **Detail Color** or **Text Color** in the properties palette updates the drawing immediately without needing to delete and re-insert the script.

## FAQ
- **Q: Why are my dimensions showing as very small or huge?**
  A: Check the **Dimstyle** property. Ensure the selected Dimension Style has the appropriate text height and scale set for your current drawing units.
- **Q: Can I use this on standard timber beams?**
  A: No, this script is specifically designed to read the layered composition of Structural Insulated Panels (SIPs).
- **Q: The details appear in the wrong location in my shop drawing.**
  A: Ensure you selected the correct **Shopdraw Viewport** during insertion. Moving the original insertion point (Step 3) will also shift the grid of details.
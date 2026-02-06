# hsbFloorPlanDimension.mcr

## Overview
This script automates the creation of floor plan dimensions for timber construction. It supports intelligent detection of wall types (including log walls), allows grouping of dimension lines into reusable configurations, and offers various strategies for dimensioning frames, openings, and wall connections.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Dimensions are generated in the 3D model environment. |
| Paper Space | No | Not designed for use in Layouts/Viewports. |
| Shop Drawing | No | Not for use with hsbCAD Shop Drawing entities. |

## Prerequisites
- **Required Entities**: Wall Elements (`Element`) or Beams (`GenBeam`) must be present in the drawing.
- **Required Settings**:
  - `hsbFloorPlanDimension.xml` (Loaded automatically from Company or Install path).
  - PainterDefinition collection named `PlanDimension` (Auto-generated if missing).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `hsbFloorPlanDimension.mcr` from the file dialog and click **Open**.

### Step 2: Insert and Position
Action: Click in the drawing area to place the dimension lines, or select a Wall Element if prompted. The script will automatically detect surrounding walls and generate dimensions based on the default settings.

### Step 3: Adjust Configuration (Optional)
Action: Select the newly inserted dimension instance. Open the **Properties Palette** (Ctrl+1).
- Change the **Configuration** to select a predefined setup (e.g., "Exterior Walls").
- Change the **Association** to filter for Interior, Exterior, or Both.

### Step 4: Create a Custom Configuration Group
1.  Right-click on the script instance in the drawing.
2.  Select **Setup Dimension Group** from the context menu.
3.  **Command Line**: `Select additional floorplan dimensions`
    Action: Click on existing dimension lines in the drawing to add them to the group. Press **Enter** to finish selection.
4.  **Dialog**: Enter a name for the new **Configuration** (e.g., "Ground Floor Ext").
5.  **Dialog**: Select an **Association** type (Interior, Exterior, or Both).
6.  **Command Line**: If the configuration name already exists, `Overwrite existing rule? [No]/[Yes]`. Type `Y` and press **Enter** to overwrite, or `N` to cancel.

## Properties Panel Parameters

| Parameter | Type | Options | Description |
|-----------|------|---------|-------------|
| Configuration | Dropdown | *Loaded from XML* | Selects a predefined dimension setup (e.g., specific wall offsets). |
| Association | Dropdown | Interior Walls / Exterior Walls / Exterior and Interior Walls | Filters which walls are included in the dimension calculation. |
| Strategy | Dropdown | *List of strategies (e.g., Frame, Openings, Wall Connections)* | Defines the logic used to generate dimensions (e.g., measure the frame vs measure the openings). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Setup Dimension Group** | Allows you to select existing dimension lines and save their current settings as a named Configuration in the XML file for future reuse. |
| **Set Strategy of Painter** | Opens a dialog to change the dimensioning algorithm strategy for the current painter definition. |

## Settings Files
- **Filename**: `hsbFloorPlanDimension.xml`
- **Location**: `hsbCompany` or `hsbInstall` directory.
- **Purpose**: Stores user-defined Configurations, Associations, and offset rules. It also manages the PainterDefinitions used to filter walls.

## Tips
- **Log Wall Support**: The script automatically detects log walls (Version 1.6+) and adjusts filters accordingly.
- **Grouping**: Use the **Setup Dimension Group** feature if you have multiple dimension lines at specific offsets (e.g., inner, outer, and opening dimensions) that you use repeatedly on different floors.
- **Visual Feedback**: During insertion (`_bOnJig`), the dimensions will update dynamically as you move your cursor, allowing you to preview placement.

## FAQ
- **Q: The dimensions are not appearing on my walls.**
  **A:** Check the **Association** property in the palette. Ensure it is set to "Exterior and Interior Walls" or matches the specific wall type you are trying to dimension. Also, verify the **Strategy** is not set to "None".
- **Q: How do I change how far the dimension lines are from the wall?**
  **A:** You must use the **Setup Dimension Group** feature. Select a dimension line at the desired distance, group it, and save it as a new Configuration.
- **Q: Can I use this on log walls?**
  **A:** Yes, the script includes support for log walls automatically (updated in v1.6). Ensure your `PlanDimension` painter filters are up to date.
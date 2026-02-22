# Dimline.mcr

## Overview

This script automatically generates linear dimensions for timber construction entities—such as beams, panels, sheets, and metal parts—as well as their tooling details (drills and cuts). It functions in both Model Space and Paper Space viewports, making it suitable for generating annotations for general layouts or detailed shop drawings.

A versatile, smart dimensioning tool used to create automated dimension lines in both Model Space (3D model) and Paper Space (Shop Drawings/Viewports). It automates the dimensioning of structural elements based on Painter definitions and allows for precise control over measurement points, styles, and formatting.

This script automates the creation, management, and placement of dimension lines in PaperSpace views. It is designed to generate production drawings by dimensioning elements, drillings, openings, and custom grids with precise control over styles and sequencing.

This script automates the creation and management of dimension lines in both Model Space and Paper Space. It provides advanced tools for controlling visual styles (colors, layers, line types) via "Painter Management" and allows users to save or load dimension configurations using XML files.



## Usage Environment

|Space|Supported|Notes|
|-|-|-|
|Model Space|Yes|Select entities directly in the model.|
|Paper Space|Yes|Supports dimensioning inside viewports on layout sheets.|
|Shop Drawing|Yes|Suitable for detailing element views.|

| Model Space | Yes | Supports dimensioning of GenBeams, Elements, Sheets, and Openings using 3D geometry. |
| Paper Space | Yes | Works with hsbCAD Viewports, MultiPages, and ShopDraw Views. |
| Shop Drawing | Yes | Detects view scales and filters elements within the specific shop drawing view. |

| Model Space | Partial | Specific modes like Offset or Global triggers can run here, but full functionality requires PaperSpace. |
| Paper Space | Yes | Primary environment. Used for dimensioning views on Layouts. |
| Shop Drawing | Yes | Supports MultiPage controllers for automated drawing generation. |

| Model Space | Yes | Fully supported with enhanced opening and element dimensioning. |
| Paper Space | Yes | Supports custom grids and viewports (ignores dimpoints outside the viewport). |
| Shop Drawing | No | This is a general CAD utility script. |



## Prerequisites

* **Required Entities**: GenBeam, Element, Sheet, Panel, PLine, MetalPartCollectionEnt, TrussEntity, CollectionEntity, Opening.
* **Minimum Beam Count**: 0 (Script works with various entities, not just beams).
* **Required Settings**: `TslUtilities.dll` must be installed and loaded.
* **Required Entities**: GenBeam, Element, Sheet, Panel, MultiPage, ShopDrawView, Viewport, or Opening.
* **Minimum Beam Count**: 0 (Can dimension geometry without beams).
* **Required Settings**: `Dimension.xml` (Must be located in Company or Install path).
* **Required Entities**: Elements, GenBeams, Openings, CollectionEntities, or TslInsts must be present in the drawing to be dimensioned.
* **Minimum Beam Count**: 0 (Can work with points or other entities).
* **Required Settings**:

  * `CustomSettings/PaperSpace` mappings (internal).
  * Optional XML file for importing/exporting tool configurations.

* **Required Entities**: None (Script generates geometry based on user-selected points).
* **Minimum Beam Count**: 0.
* **Required Settings**: A map object configuration is used internally to store settings.



## Usage Steps

### Step 1: Launch Script

Command: `TSLINSERT` → Select `Dimline.mcr`

### Step 2: Insert Instance

```
Action: Click in the drawing area (Model Space or Paper Space viewport) to place the script instance.
Note: The script uses the current view direction and entities present in the selection/area to determine dimensions.
```

### Step 3: Configure Dimensions

```
Action: Select the inserted script instance and open the Properties Palette (Ctrl+1).
Action: Adjust the View Strategy settings (sVS\*) to filter which entities are dimensioned based on their orientation.
Result: Dimensions will update automatically based on these properties.
```

### Step 2: Select Context

```
Command Line: Select entity / \[Enter] to open dialog:
Action:
- In Model Space: Select the beams, elements, or walls you wish to dimension.
- In Paper Space: Select the Viewport or MultiPage frame containing the elements to dimension.
```

### Step 3: Configure Insertion Options

```
Command Line: \[Options] <Segment> / <Diagonal> / <Match Visuals>:
Action:
- Click a point to start the dimension.
- Type 'S' (Segment) to snap the dimension direction to a specific segment of the highlighted geometry.
- Type 'D' (Diagonal) to align the dimension along the diagonal of the profile.
- Type 'M' (Match Visuals) to copy the DimStyle and settings from an existing dimension line in the drawing.
```

### Step 4: Place Dimension

```
Command Line: Specify location:
Action: Move the cursor to position the dimension line. The script will automatically generate tick marks based on the intersection of the dimension line and the visible geometry.
Action: Click to finalize placement.
```

### Step 2: Place Dimension Line

```
Command Line: Pick location
Action: Click in the PaperSpace layout where you want the dimension line to appear.
```

### Step 3: Select Entities (If prompted)

```
Command Line: Select entities
Action: Select the elements (beams, walls, etc.) you wish to dimension. Press Enter to confirm.
```

*Note: Often the script automatically detects entities near the dimline location based on the 'Painter' filter.*

### Step 4: Configure via Right-Click Menu

```
Action: Right-click on the inserted Dimline instance to access context menu options such as "Set Alignment," "Add Points," or "Define Tool Sets" to refine the dimension.
```

Command: `TSLINSERT`
Action: Select `Dimline.mcr` from the file list.

### Step 2: Insert the Dimension Line

```
Command Line: \[Insertion prompts]
Action: Follow the command line prompts to select points or elements to define the dimension geometry.
```

*Tip: You can use Ortho mode (F8) during insertion to help align points (Version 9.9+).*

### Step 3: Configure Visual Styles (Optional)

After insertion, you can define how the dimension line looks (colors, layers).

1. Select the inserted Dimension Line element in the drawing.
2. Right-click to open the Context Menu.
3. Select **Painter Management**.
4. Choose one of the following options:

   * **Default/Folder specific**: Uses standard visual definitions based on the folder structure.
   * **All painters for this dimline (Instance)**: Allows any visual style, saving the choice specifically to this instance.
   * **All painters for any dimline (Global)**: Allows any visual style and applies the setting globally.

### Step 4: Save Configuration (Optional)

1. Right-click on the Dimension Line.
2. Select **Export Settings**.
3. If the file already exists, confirm "Yes" to overwrite.
4. The script saves the current configuration to an XML file in your company or install folder.

### Step 5: Load Configuration (Optional)

2. Select **Import Settings**.
3. The script loads settings from the XML file found in the standard directory, updating the dimension line appearance immediately.



## Properties Panel Parameters

|Parameter|Type|Default|Description|
|-|-|-|-|
|sVSBeam|Dropdown|\|Any view\||Defines which beams are dimensioned. Options: \|Any view\|, \|Perpendicular to View Direction\|, \|Parallel to View Direction\|.|
|sVSSheet|Dropdown|\|Any view\||Defines which sheets are dimensioned. Options: \|Any view\|, \|Perpendicular to View Direction\|, \|Parallel to View Direction\|.|
|sVSPanel|Dropdown|\|Any view\||Defines which panels are dimensioned. Options: \|Any view\|, \|Perpendicular to View Direction\|, \|Parallel to View Direction\|.|
|sVSMetalPart|Dropdown|\|Any view\||Defines which metal parts are dimensioned. Options: \|Any view\|, \|Perpendicular to View Direction\|, \|Parallel to View Direction\|.|
|sGroupAssignment|Dropdown|<\|Default\|>|Defines the layer to assign the dimension instance. <\|Default\|> inherits the layer from the entity ("byEntity").|

| **DimPointMode** | Dropdown | Default | Determines where dimension ticks are generated (e.g., Extreme Points, Mid Points, or Offset Dimension). |
| **DisplayMode** | Dropdown | parallel / parallel | Controls the orientation of text (parallel or perpendicular) and line chaining behavior. |
| **RefPointMode** | Dropdown | Default | Sets the anchor point for the measurement (First Point, Last Point, Closest Point). |
| **ShapeMode** | Dropdown | Envelope Shape | **Envelope** (Fast, uses bounding box), **Basic** (Bounding contour with cuts), or **Real** (Exact 3D body, slower but accurate). |
| **Stereotype** | String | | Filters dimension points based on specific TSL script names (e.g., connectors). Use `\*` for wildcard. |
| **ToolSet** | String | | Filters dimension points based on a specific Tool Set configuration. |
| **Painter** | String | Dimension | Selects the Painter Definition used to filter which entities are dimensioned. |
| **RefPainter** | String | Dimension | Selects the Painter Definition for reference entities (used for offset dimensions). |
| **DimStyle** | String | Standard | Selects the AutoCAD/hsbCAD Dimension Style (arrows, text, color). |
| **TextHeight** | Double | 0 | Sets explicit text height. `0` uses the DimStyle default. |
| **ScaleFactor** | Double | 1 | Applies a global scale multiplier to dimension components (arrows, gaps). |
| **Format** | String | | Allows custom text formatting (e.g., `@(Area)m²` to add area calculations). |

| sPainter | String | "Default" | Filters entities to dimension based on material classification (e.g., Studs, Plates). |
| sRefPainter | String | "Default" | Specifies the reference element class for calculating the baseline offset. |
| dTextHeight | Double | 2.5 | Sets the height of the dimension text in PaperSpace (mm). |
| dScaleFactor | Double | 1.0 | Scaling multiplier for dimension values and geometry representation. |
| nDeltaMode | Int | 0 | Controls dimension style: 0 (Running Chain), 1 (Stacked Delta), 2 (Single/Linear). |
| bDeltaOnTop | Boolean | false | Toggles the orientation of delta dimensions relative to the baseline. |
| sFormat | String | "%(...)" | Defines the formatting string for dimension text (rounding, units, prefixes). |
| nRefLocMode | Int | 0 | Determines positioning: 0 (Fixed), 1 (Near object), 2 (Extremes). |
| sShapeMode | Enum | tBasicShape | Selects geometry definition: Basic contour, Envelope, Real Shape, or Extreme Point. |
| nVSBeam | Int | 0 | View Strategy index for Beam drillings (Top/Side/Front view selection). |
| nSequence | Int | -1 | Controls processing order to prevent text overlap (-1 = Auto). |
| sStereotype | String | "\*" | Wildcard filter for selecting tools/components contributing dimension requests. |

| Painter Management Mode | Context Menu Option | 0 (Default) | Determines if visual styles are restricted to the folder, specific to the instance, or globally available. |



## Right-Click Menu Options

|Menu Item|Description|
|-|-|
|*None detected in this chunk*|No custom context menu options are defined in this version of the script.|

| **Realign Dimlines** | Recalculates the dimension vector and alignment based on the current geometry or user input. Useful if the model changes. |
| **Set View** | (MultiPage only) Re-associates the dimension to a different view within the MultiPage layout. |
| **Update** | Forces a recalculation of the dimension points based on current properties and geometry. |

| Add Dimension | Adds a new offset dimension at a user-picked location. |
| Swap Delta/Chain | Toggles between Delta (stacked) and Chain (running) dimension styles. |
| Add Points | Adds custom dimension points interactively via the cursor. |
| Remove Points | Removes specific custom dimension points interactively. |
| Add Entities | Adds selected entities to the current dimensioning set. |
| Remove Entities | Removes selected entities from the current dimensioning set. |
| Set Alignment | Sets the dimension alignment by picking two points on screen. |
| Select Segment | Selects a specific segment to define the dimension direction. |
| Set Diagonal | Configures the dimension for diagonal measurement. |
| Rotate 90° | Rotates the dimension direction by 90 degrees instantly. |
| Copy Dimline | Creates a copy of the dimline at a new location (allows rotation during placement). |
| Define Tool Sets | Opens a dialog to filter which tools (drillings, etc.) contribute dimensions. |
| Define Parent Tool Filter | Opens a dialog to select specific parent tools for dimensioning. |
| Set Viewport Reference Mode | Opens a dialog to set how the dimline locates relative to viewports. |
| Regenerate Shopdrawing | Forces a regeneration of the associated shopdrawing page. |
| Align Dimlines | Automatically spaces multiple dimlines on the page to prevent overlap. |
| Align Dimlines2 | Aligns dimlines using the MultipageController TSL. |
| Purge Dimlines | Removes duplicate dimlines from the current page. |
| Drill Dimension Visibility Settings | Configures view strategies for drill dimensions (Top/Side/Front). |
| Add RUB-Grid | Links a RUB-Grid instance for custom grid dimensioning. |
| Remove RUB-Grid | Unlinks the current RUB-Grid instance. |
| Import Settings | Loads configuration settings from an XML file. |
| Export Settings | Saves current configuration settings to an XML file. |

| Painter Management | Opens a dialog to specify automatic painter creation and usage modes (Default, Instance, or Global). |
| Import Settings | Imports configuration settings from an XML file located in the company or install folder. Only visible if a valid XML file is found. |
| Export Settings | Exports current configuration settings to an XML file. Prompts for overwrite confirmation if the file exists. Only visible if settings data is present. |



## Settings Files

* **Filename**: None specified in this chunk.
* **Location**: N/A
* **Purpose**: N/A (Script relies on `TslUtilities.dll` for utility functions).
* **Filename**: `Dimension.xml`
* **Location**: Company or Install path (TSL folder).
* **Purpose**: Stores default configurations, lists of available Painters, and default visual styles for the dimensioning tool.
* **Filename**: `CustomSettings.xml` (Implied path)
* **Location**: Company/Project path or hsbCAD Install path
* **Purpose**: Stores tool definitions, view strategies for drillings, and custom filter configurations used by the script.
* **Filename**: `Implied XML file` (Defined by script variable)
* **Location**: Searches in `hsbCompany\\hsbDimline` or `hsbInstall\\hsbDimline`.
* **Purpose**: Stores and retrieves dimension line configurations (Painter Management modes, visual styles) to ensure consistency across projects or users.



## Tips

* **Reducing Clutter**: In detailed elevation views, change the `sVSBeam` or `sVSPanel` settings to **"|Perpendicular to View Direction|"** or **"|Parallel to View Direction|"**. This filters out dimensions for elements that would otherwise make the drawing too busy.
* **Layer Control**: Use the `sGroupAssignment` property to ensure your dimensions are placed on the correct CAD layer for easy plotting and visibility management.
* **Paper Space Workflow**: This script can dimension entities through viewports. Ensure your viewport is active and locked correctly to ensure the view direction aligns with your desired dimensioning logic.
* **Performance vs. Accuracy**: Use **Envelope Shape** mode for large models to improve regeneration speed. Switch to **Real Shape** only when dimensioning complex 3D contours where precise machining details are required.
* **Offset Dimensions**: The "Offset Dimension" mode is specifically designed for hsbCAD Viewports and allows you to measure distances from a reference line (defined by the RefPainter) to the dimensioned elements.
* **Matching Standards**: Use the `Match Visuals` keyword during insertion to quickly copy the look of existing dimensions in your drawing, ensuring consistency.
* **Grip Editing**: After insertion, you can drag the main grip to move the dimension line or drag individual tick points to adjust their location manually.
* **Fixing Overlaps**: If dimension text overlaps with other lines, use the **Align Dimlines** context command to automatically redistribute them.
* **Viewport Handling**: The script automatically ignores dimension points that fall outside the Viewport boundary. If points are missing, check if your Viewport clip is cutting them off.
* **Quick Style Change**: Use **Swap Delta/Chain** to instantly switch between a running total dimension and individual stacked dimensions without changing properties.
* **Drill Views**: To control which drill holes are dimensioned (e.g., side view vs. top view), use the **Drill Dimension Visibility Settings** menu or adjust the `nVSBeam` property.
* **Ortho Mode**: Use Ortho mode (F8) during point selection to ensure perfectly straight dimension lines.
* **Viewport Handling**: When working in Paper Space, dimension points located outside the current viewport are automatically ignored.
* **Visibility of Menu Items**: The "Import" and "Export" options only appear in the right-click menu if the necessary file exists or valid data is present to save.
* **Multi-Page Support**: This script supports MultipageController, allowing it to function correctly in environments with multiple page layouts.



## FAQ

* **Q: Why are some beams not being dimensioned?**
  **A:** Check the **View Strategy** properties (e.g., `sVSBeam`). If set to "Perpendicular to View Direction", beams running parallel to your view might be filtered out. Change it to "|Any view|" to dimension all beams.
* **Q: Can I use this to dimension metal plates and connectors?**
  **A:** Yes, use the `sVSMetalPart` property to enable dimensioning for metal parts based on the current view.
* **Q: Does this script work in Layout Tabs (Paper Space)?**
  **A:** Yes, it supports dimensioning within viewports in Paper Space. The script calculates the transformation from the viewport to model space automatically.
* **Q: Why are my dimension ticks missing some cuts or holes?**
  **A**: Your `ShapeMode` might be set to "Envelope Shape" or "Basic Shape". Change it to "Real Shape" in the properties to capture exact 3D geometry.
* **Q: Can I dimension diagonally across a gable wall?**
  **A**: Yes. During insertion, use the keyword "Diagonal" or select the diagonal vertices of the highlighted profile to align the dimension line.
* **Q: The dimension text is too small in my viewport.**
  **A**: Check the `ScaleFactor` property. If using Paper Space, ensure the factor matches your viewport scale, or set `TextHeight` explicitly.
* **Q: I am getting an error about 'Offset Dimension only supported for hsbcad viewports'.**
  **A**: You likely have `DimPointMode` set to "Offset Dimension" while working in Model Space. Change `DimPointMode` to "Extreme Point" or "Default" for Model Space dimensioning.
* **Q: Why are my drill holes not showing dimensions?**
  **A:** Check the "Drill Dimension Visibility Settings" in the right-click menu. You may need to select a different View Strategy (e.g., Side View) depending on your current drawing orientation.
* **Q: How can I change the order of stacked dimension lines?**
  **A:** Modify the `nSequence` property in the Properties Palette. A lower number places the dimline closer to the object.
* **Q: Can I dimension a custom grid that isn't a standard beam?**
  **A:** Yes. Use the **Add RUB-Grid** option in the right-click menu to link a specific RUB-Grid TSL instance as the dimension source.
* Q: Why don't I see the "Import Settings" option in the menu?
* A: The script hides this option if no valid XML file is found in the `hsbDimline` folder. Ensure you have a configuration file saved in the correct directory.
* Q: Why don't I see the "Export Settings" option?
* A: This option only appears if the current dimension line instance has configuration data to save. Try modifying the "Painter Management" setting first; the export option should then become available.
* Q: What does "All painters for this dimline" mean?
* A: It means the visual style (colors/lines) chosen for this specific dimension line is saved *only* to this instance. It won't affect other dimlines or the global project settings.

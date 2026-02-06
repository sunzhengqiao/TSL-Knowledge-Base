# hsbViewLegend.mcr

## Overview
This script generates a dynamic legend table that displays hatch patterns and symbols used in a specific view. It is designed to help document materials and annotations within construction drawings, supporting custom definitions and operating in Model Space, Paper Space, or Shop Drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Requires selection of `Section2d` entities. The legend will attach to these sections. |
| Paper Space | Yes | Requires selection of a Viewport. The legend is placed on the layout sheet. |
| Shop Drawing | Yes | Requires selection of a Shop Drawing View. The legend is placed within the view. |

## Prerequisites
- **Required Entities**:
  - **Model Space**: `Section2d` entities.
  - **Paper Space**: A viewport (`Viewport`).
  - **Shop Drawing**: A Shop Drawing View (`ShopDrawView`).
- **Minimum beam count**: None (0).
- **Required settings files**: None.

## Usage Steps

### Step 1: Launch Script
Run the command `TSLINSERT` (or use the hsbCAD insert menu) and select `hsbViewLegend.mcr`.

### Step 2: Select Context (Dependent on active space)
The script behavior changes based on your current location in AutoCAD:

**Option A: In Model Space**
```
Command Line: Select Section2d
Action: Click on the Section2d entities (section cuts) you wish to associate with the legend.
Note: The script will automatically attach a legend to each selected section and close the initial insertion command.
```

**Option B: In Shop Drawing Space**
```
Command Line: Select ShopDrawView
Action: Click inside the Shop Drawing View where you want the legend to appear.
```

**Option C: In Paper Space (Layout Tab)**
```
Command Line: Select a viewport
Action: Click on the viewport border that represents the view you want to document.
```

### Step 3: Place Legend
*(For Shop Drawing and Paper Space flows)*
```
Command Line: Pick insertion point
Action: Click on the drawing sheet to position the top-left corner of the legend table.
```

### Step 4: Configure Appearance
Select the newly created legend and open the **Properties Palette** (Ctrl+1) to adjust text height, column count, or add custom items.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Text Height** | Number | 0 | Sets the height of the text labels in the legend. |
| **Columns** | Dropdown (1, 2, 3) | 1 | Defines how many vertical columns the legend uses to display items. |
| **Column Sizes** | String | Empty | Defines the width of columns in millimeters, separated by semicolons (e.g., `50;20`). |
| **Material** | String | Empty | The name label for a hatch or symbol (e.g., "C24", "Insulation"). |
| **Color** | Dropdown | 1 | The AutoCAD color index for the hatch or symbol. |
| **Transparency** | Dropdown | 0 | The transparency level (0-90) for solid hatches. |
| **Pattern** | Dropdown | _HatchPatterns | The hatch pattern style (e.g., SOLID, ANSI31). |
| **Scale** | Number | 0 | The scale factor for the hatch pattern density. |
| **Angle** | Number | 0 | The rotation angle of the hatch pattern (in degrees). |
| **Symbol Name** | String | TXT | The label text for a custom symbol entry. |
| **Symbol Color** | Dropdown | 0 | The display color for a custom symbol. |

## Right-Click Menu Options

Select the legend and right-click to access the following context menu options:

| Menu Item | Description |
|-----------|-------------|
| **Add Hatch** | Opens the Properties Palette to define a new custom hatch pattern (Material, Pattern, Color, etc.) and adds it to the legend. |
| **Remove Hatch** | Opens the Properties Palette listing all current custom hatches. Select one to remove it from the legend. |
| **Erase All Custom Hatches** | Immediately deletes all custom hatch definitions from the legend. |
| **Add Symbol** | Prompts you to select geometry/entities in the drawing, then adds them as a symbol entry in the legend. |
| **Remove Symbol** | Opens the Properties Palette listing custom symbols. Select one to remove it. |
| **Remove All Symbols** | Immediately deletes all custom symbol definitions from the legend. |

## Settings Files
- **Filename**: N/A
- **Location**: N/A
- **Purpose**: This script does not rely on external XML settings files.

## Tips
- **Column Alignment**: Use the `Column Sizes` property to manually define widths if the default automatic sizing doesn't align well with your title block or other notes.
- **Model Space Workflow**: When used in Model Space, this script acts as a "batch" tool. Selecting 5 sections will automatically create 5 separate legend instances, one attached to each section.
- **Text Height**: If `Text Height` is set to 0, the script may use a default internal value; it is recommended to explicitly set this to your drawing standard (e.g., 2.5mm or 3.0mm) for consistency.

## FAQ
- **Q: Can I add my own custom hatch patterns that aren't in the default list?**
  - A: You can select any pattern name loaded in AutoCAD by typing it into the `Pattern` property, or select from the dropdown which lists available patterns.
- **Q: How do I move the legend after inserting it?**
  - A: Simply select the legend and use the standard AutoCAD Move command or drag the grip points.
- **Q: What happens if I select the wrong Viewport?**
  - A: You can delete the legend instance and run the script again, or if the script allows, check the Properties to see if it can be reassigned (usually re-running is safer).
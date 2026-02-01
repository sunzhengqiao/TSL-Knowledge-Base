# GE_PLOT_ELEMENT_BOM.mcr

## Overview
This script generates a Bill of Materials (BOM) table and places position numbers for hsbCAD Elements. It supports both Paper Space (via Viewports) and Shop Drawings (via ShopDrawViews), automatically categorizing beams and sheets based on the element type (Wall, Floor, Roof, or SIP).

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed for detailing output. |
| Paper Space | Yes | Select a Viewport linked to an hsb Element. |
| Shop Drawing | Yes | Select a ShopDrawView entity. |

## Prerequisites
- **Required Entities**: An existing Layout with a Viewport linked to an hsb Element OR a Shopdrawing containing a ShopDrawView linked to an Element.
- **Minimum Beam Count**: 0 (Processes any valid element).
- **Required Settings**: None specific.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_PLOT_ELEMENT_BOM.mcr`

### Step 2: Configure Options
A dialog will appear upon insertion. Set the **Drawing space** property to either:
- **paper space**: If you are working on a 2D layout with a viewport.
- **shopdraw multipage**: If you are working within the hsbCAM/Shopdrawing environment.

### Step 3: Pick Insertion Point
```
Command Line: Pick a point to show the table
Action: Click in the drawing where you want the top-left corner of the BOM table to be placed.
```

### Step 4: Select Source View
Depending on your selection in Step 2:
- **If Paper Space**:
  ```
  Command Line: Select the viewport from which the element is taken
  Action: Click on the border of the viewport displaying the element.
  ```
- **If Shopdraw Multipage**:
  ```
  Command Line: Select the view entity from which the module is taken
  Action: Click on the ShopDrawView frame of the element.
  ```

### Step 5: Automatic Generation
The script will automatically generate the table and position numbers based on the default properties.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Drawing space | Dropdown | paper space | Choose between 'paper space' or 'shopdraw multipage'. |
| Using Defaults Editor | Dropdown | No | If Yes, material and grade are parsed from tokens in the grade property on the beam. |
| Dim Style | Dropdown | *Current* | Select the dimension style to use for the table text. |
| Color | Number | 3 | Sets the AutoCAD color index (e.g., 3 = Green) for the table entities. |
| Materials to exclude from the BOM | Text | (Empty) | List materials to hide in the BOM. Use a semicolon (;) as a separator (e.g., "M12;Nail"). |
| Switch to Complementary Angle | Dropdown | No | Toggles the display of angles to their complementary value. |
| Show Sheets in the BOM | Dropdown | Yes | Toggles the visibility of sheet/panel materials in the table. |
| Show Beams in the BOM | Dropdown | Yes | Toggles the visibility of timber beams in the table. |
| Show SIPs in the BOM | Dropdown | Yes | Toggles the visibility of Structural Insulated Panels in the table. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Properties | Opens the Properties Palette to configure BOM filters and visual styles. |
| Recalculate | Manually refreshes the BOM if automatic updates are disabled. |
| Erase | Removes the script instance and all generated geometry from the drawing. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script uses internal logic and standard Element properties; no external XML settings file is required.

## Tips
- **Filtering Materials**: To exclude fasteners or small hardware from the BOM, type their material names into the "Materials to exclude" property separated by semicolons (e.g., `Steel;Connector`).
- **Moving the Table**: Select the script insertion point (usually the top-left of the table) and use the AutoCAD `MOVE` command. The table and position numbers will move together.
- **Updating the BOM**: Simply change a property in the Properties Palette (e.g., toggle "Show Beams") to force an immediate redraw of the table without re-inserting the script.
- **Classification**: The script automatically detects if the element is a Wall, Floor, or Roof and adjusts the content columns (e.g., showing "Studs" for walls or "Rafters" for roofs) accordingly.

## FAQ
- **Q: Why did the BOM table disappear?**
  **A:** The script is linked to a specific Viewport or ShopDrawView. If you delete that source entity, the script detects this and erases itself to prevent errors.
- **Q: Can I use this script in Model Space?**
  **A:** No, this script is specifically designed for detailing in Paper Space or Shop Drawings to ensure correct 2D representation.
- **Q: How do I change the table text size?**
  **A:** The text size is controlled by the selected "Dim Style". Change the `Dim Style` property to a style with your preferred text height.
# GE_PLOT_ELEMENT_BOM.mcr

## Overview
This script generates a Bill of Materials (BOM) table and places position numbers for hsbCAD Elements. It supports both Paper Space (via Viewports) and Shop Drawings (via ShopDrawViews), automatically categorizing beams and sheets based on the element type (Wall, Floor, Roof, or SIP).

**Script Purpose**: Create detailed fabrication documentation that lists all timber members, panels, and hardware components with their dimensions, quantities, and position assignments.

## Version History
- **v1.0** (11.mar.2013): Initial version, copied from hsb_ElementBOM
- **v1.19** (11.mar.2013): Version control sync with hsb_ElementBOM
- **v1.20** (14.mar.2013): Added "Show Angle Column" property; fixed real size display for US market
- **v1.21** (07.apr.2013): Added "Using Defaults Editor" for material/grade parsing from beam grade tokens
- **v1.22** (20.may.2013): All strings made translatable
- **v1.23** (13.ene.2014): Added classification groups - Sill, Very Top Plate, Jacks, Header (renamed from lintel)

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
| Show Metalparts in the BOM | Dropdown | Yes | Toggles the visibility of metal hardware/connectors in the table. |
| Show Trusses in the BOM | Dropdown | Yes | Toggles the visibility of truss components in the table. |
| Show Label Column | Dropdown | Yes | Displays an additional column with custom labels. |
| Show Angle Column | Dropdown | Yes | Displays the angle of each member in the table. |
| Show Material Column | Dropdown | Yes | Displays the material type for each item. |
| Show Grade Column | Dropdown | Yes | Displays the grade/specification for each item. |
| Show table in two columns | Dropdown | No | Displays the BOM in a two-column layout instead of single column. |
| Show Beam Reference | Dropdown | None | Shows selected reference (Posnum, Length) on each beam. |
| Joist Reference Catalogue | Text | (Empty) | Catalogue name for joist references in Exporter. |
| Show Posnum Zone | Number | 0 (none) | Displays position numbers in specified zone. |

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

## BOM Table Structure

The BOM table includes the following columns based on element type and user settings:

### For Walls (ElementWallSF)
- **Quantity**: Number of pieces
- **Position**: Position number/identifier
- **Type**: Member type (Stud, Top Plate, Bottom Plate, Header, Jack, etc.)
- **Size**: Dimensions (Width × Height or Diameter)
- **Length**: Member length
- **Material**: Material type (if enabled)
- **Grade**: Material grade (if enabled)
- **Angle**: Angle from horizontal (if enabled)
- **Label**: Custom label (if enabled)

### For Floors/Roofs
- **Quantity**: Number of pieces
- **Position**: Position number/identifier
- **Type**: Member type (Rafter, Joist, Purlin, etc.)
- **Size**: Dimensions
- **Length**: Member length
- **Material**: Material type (if enabled)
- **Grade**: Material grade (if enabled)
- **Angle**: Angle from horizontal (if enabled)
- **Label**: Custom label (if enabled)

### For SIPs (Structural Insulated Panels)
- **Quantity**: Number of panels
- **Position**: Position number/identifier
- **Type**: Panel description
- **Size**: Panel dimensions (Width × Length)
- **Thickness**: Panel thickness
- **Material**: Material type (if enabled)

## Position Numbering System

The script implements intelligent position numbering:
- **Collision Avoidance**: Position numbers are automatically offset to avoid overlapping
- **Zone Support**: Can display position numbers in specific zones (useful for multi-story buildings)
- **Beam References**: Option to show position numbers directly on beams in the drawing
- **Joist Integration**: Special support for joist reference catalogs when exporting

## Tips
- **Filtering Materials**: To exclude fasteners or small hardware from the BOM, type their material names into the "Materials to exclude" property separated by semicolons (e.g., `Steel;Connector;Nail`).
- **Moving the Table**: Select the script insertion point (usually the top-left of the table) and use the AutoCAD `MOVE` command. The table and position numbers will move together.
- **Updating the BOM**: Simply change a property in the Properties Palette (e.g., toggle "Show Beams") to force an immediate redraw of the table without re-inserting the script.
- **Classification**: The script automatically detects if the element is a Wall, Floor, or Roof and adjusts the content columns (e.g., showing "Studs" for walls or "Rafters" for roofs) accordingly.
- **Space Planning**: For complex elements, use the "Show table in two columns" option to save vertical space on the drawing.
- **Angle Display**: Use "Switch to Complementary Angle" to display angles as 90° minus the actual angle (useful for some framing conventions).

## Error Handling

The script includes robust error handling:
- **Missing Viewport**: If the selected viewport doesn't contain valid hsb data, the script erases itself.
- **Invalid ShopDrawView**: If the selected view entity is invalid, the script exits gracefully.
- **Element Not Found**: If no valid element is found in the view data, the script removes itself.
- **Material Filter**: Materials listed for exclusion are processed case-insensitively.

## Performance Notes
- The script processes all entities in the linked element to generate the BOM
- Coordinate system transformations ensure accurate placement in Paper Space
- Position number collision detection may take longer for complex assemblies
- Use material filtering to reduce table size for large projects

## FAQ
- **Q: Why did the BOM table disappear?**
  **A:** The script is linked to a specific Viewport or ShopDrawView. If you delete that source entity, the script detects this and erases itself to prevent errors.

- **Q: Can I use this script in Model Space?**
  **A:** No, this script is specifically designed for detailing in Paper Space or Shop Drawings to ensure correct 2D representation.

- **Q: How do I change the table text size?**
  **A:** The text size is controlled by the selected "Dim Style". Change the `Dim Style` property to a style with your preferred text height.

- **Q: Why are some materials showing up even though I excluded them?**
  **A:** Check that you're using the exact material name and proper case. The comparison is case-insensitive but must match exactly.

- **Q: Can I customize the BOM table format?**
  **A:** The table format is determined by the element type. You can toggle columns on/off via properties but cannot modify the basic structure.

- **Q: What happens if I resize the viewport after placing the BOM?**
  **A:** The BOM remains at its original position. You'll need to re-insert the script to match a resized viewport.
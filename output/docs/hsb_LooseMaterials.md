# hsb_LooseMaterials.mcr

## Overview
Generates a dynamic Bill of Materials (BOM) table for miscellaneous (loose) construction items, allowing users to list, sort, and display material properties such as screws, nails, insulation, and plates directly in the drawing layout.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Can be placed in model space for 3D context. |
| Paper Space | Yes | Typically used here for production drawings and layout plans. |
| Shop Drawing | No | This is not a shop drawing script. |

## Prerequisites
- **External DLL**: The file `hsbLooseMaterialsUI.dll` must exist in the hsbCAD Install Utilities folder.
- **Catalog Entry**: A valid catalog entry is recommended to load default properties, though not strictly required to run the script.
- **No Entities Required**: You do not need to pre-select beams or elements; this script manages its own data.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or your company shortcut for inserting tsl scripts)
1. Run the command.
2. Browse and select `hsb_LooseMaterials.mcr`.

### Step 2: Set Table Origin
```
Command Line: Select upper left corner of bill of material.
Action: Click in the drawing (Model or Paper Space) where you want the top-left corner of the table to appear.
```

### Step 3: Configure Materials
1. Immediately after selecting the point, the **Loose Materials** dialog window appears.
2. Use the dialog to add items (e.g., "Screw 5x120"), define quantities, and set attributes (Material, Width, Height, etc.).
3. Click **OK** to generate the table.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Dimension style** | String | (Empty) | Sets the text style and dimension format for the table based on existing CAD styles. |
| **Line color** | Number | -1 | Sets the color index for the grid lines and table border (-1 = ByBlock). |
| **Text color: Header** | Number | -1 | Sets the text color for the column title row. |
| **Text color: Groups** | Number | -1 | Sets the text color for group/category separator rows. |
| **Text color: Content** | Number | -1 | Sets the text color for the standard item rows. |
| **Show article HSB** | Dropdown | No | Toggles visibility of the internal hsbCAD inventory number column. |
| **Show article number** | Dropdown | No | Toggles visibility of the supplier/manufacturer article number. |
| **Show description** | Dropdown | No | Toggles visibility of the item description column. |
| **Show material** | Dropdown | No | Toggles visibility of the material specification column. |
| **Show height** | Dropdown | No | Toggles visibility of the item height. |
| **Show width** | Dropdown | No | Toggles visibility of the item width. |
| **Show length/thickness** | Dropdown | No | Toggles visibility of the item length or thickness. |
| **Show label** | Dropdown | No | Toggles visibility of a user-defined label column. |
| **Show function** | Dropdown | No | Toggles visibility of the usage function description. |
| **Show units** | Dropdown | No | Toggles visibility of the unit of measure (e.g., pcs, m). |
| **Show quantity** | Dropdown | No | Toggles visibility of the quantity/count column. |
| **Sort column** | Dropdown | (First) | Determines which property is used to sort the list (e.g., by Material, Description, Quantity). |
| **Sort mode** | Dropdown | Ascending | Sets the sort order to Ascending or Descending. |
| **Align header** | Dropdown | Center | Sets the horizontal alignment for the header text (Left, Center, Right). |
| **Align content** | Dropdown | Center | Sets the horizontal alignment for the data rows. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Update Loose Materials** | Reopens the .NET dialog, allowing you to add, remove, or edit items in the list. The table will automatically update to reflect changes upon confirmation. |

## Settings Files
- **Filename**: `hsbLooseMaterialsUI.dll`
- **Location**: `hsbCAD Install Utilities` folder.
- **Purpose**: Provides the user interface form for data entry.

## Tips
- **Modify Columns Quickly**: You can show or hide specific columns (like "Width" or "Function") directly from the Properties Palette without reopening the dialog.
- **Moving the Table**: Select the table and use the standard AutoCAD grip points to move it. The script will regenerate the geometry at the new location.
- **Sorting**: To group all similar materials together (e.g., all nails), change the **Sort column** property to "Description" or "Material".
- **Units**: If your drawing is set to Imperial, the script automatically converts metric dimensions (mm) to inches for the display.

## FAQ
- **Q: Why did my table disappear?**
  - A: If the script detects no data in the internal map (e.g., if the external dialog was cancelled during creation), it erases itself. Try running the command again and ensure you confirm the dialog.
  
- **Q: Can I change the font size of the table?**
  - A: Yes. Select the table, open the Properties Palette, and change the **Dimension style** to a style that uses your desired text height.

- **Q: How do I fix incorrect quantities?**
  - A: Right-click the table and select **Update Loose Materials**. Edit the quantities in the list and click OK.
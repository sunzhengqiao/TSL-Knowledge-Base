# Hsb-LooseMaterials

## Overview
Generates a customizable 2D Bill of Materials (BOM) table for non-modeled "loose" materials (such as nails, screws, and metal plates) associated with a specific floor group, using data imported from an external XML file.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script creates 2D geometry (lines and text) in the model space. |
| Paper Space | No | Not designed for layout tabs. |
| Shop Drawing | No | This is a model space documentation tool. |

## Prerequisites
- **Required Entities**: None.
- **Minimum Beam Count**: 0.
- **Required Settings**:
  - **Floor Group**: You must have a Floor Group (e.g., `House\Ground Floor`) selected as the current group in the hsbCAD organizer.
  - **External Tool**: The script relies on `hsbCadLooseMaterial.exe` (found in your hsbCAD installation folder) to edit material data.
  - **Group Naming**: The Floor Group name must **not** contain an underscore `_`.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `Hsb-LooseMaterials.mcr`.

### Step 2: Set Current Group
Action: Before inserting the script, right-click your desired Floor Group (e.g., `House\Ground Floor`) in the hsbCAD Organizer tree and select **Set Current**.
*Note: The script will fail if you are at the House level or if the group name contains an underscore `_`.*

### Step 3: Pick Insertion Point
```
Command Line: Pick insertion point:
Action: Click in the Model Space where you want the top-left corner of the table to appear.
```

### Step 4: Edit Materials (Automatic)
Action: Upon the first insertion, the `hsbCadLooseMaterial` application will automatically launch.
- Use this external tool to add loose materials (e.g., "Nail 3.1x90"), set quantities, dimensions, and units.
- Save and close the application.
- The TSL will recalculate and draw the table in your drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **sDimStyle** | String | Standard | The text style used for the table content. |
| **_Pt0** | Point | (0,0,0) | The insertion point (top-left corner) of the table. Use the grip to move this in the drawing. |
| **dTextHeight** | Double | 2.5 | The height of the text within the table rows. |
| **dRowHeight** | Double | 6.0 | The height of each table row. |
| **dColWidth0** to **dColWidth7** | Double | Various | Width of specific columns in the table. Adjust these to fit your text content. |
| **colorLine** | Integer | Various | Color index for the table grid lines. |
| **colorText** | Integer | Various | Color index for the text inside the table. |
| **colorHeader** | Integer | Various | Color index for the header row background/text. |
| **bShowLabel**, **bShowFunction**, etc. | Boolean | 1 (True) | Toggles the visibility of specific columns (Label, Function, Units, etc.). |
| **nSortColumn** | Integer | 0 | Determines which column number to sort the table by (0 = first column). |
| **nSortMode** | Integer | 1 | Sorting order (e.g., Ascending/Descending). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Change or Update materials** | Opens the external `hsbCadLooseMaterial` editor. You can modify the material list, quantities, or descriptions here. Upon saving and closing, the table in the drawing will automatically update to reflect the changes. |

## Settings Files
- **Filename**: `[HouseName]_[FloorName].xml`
- **Location**: The script looks for an XML file matching the name of your current Floor Group in the project directory.
- **Purpose**: Stores the list of loose materials, their quantities, units, and descriptions. This file acts as the database for the table.

## Tips
- **Avoid Underscores**: Ensure your Floor Group names in the hsbCAD Organizer do not use underscores (e.g., use `Ground Floor` instead of `Ground_Floor`), or the script will abort.
- **Moving the Table**: You can drag the table using the grip point at the top-left corner (_Pt0) without triggering a recalculation of the material data.
- **Column Widths**: If text looks cut off, increase the `dColWidth...` properties in the Properties Palette to make specific columns wider.
- **One Table Per Floor**: You can only have one instance of this script attached to a specific Floor Group. If you need to replace it, delete the old instance first.

## FAQ
- **Q: I get an error "Set group current at floor level."**
  A: You have selected the "House" group or a different entity. Right-click the specific floor (e.g., "1st Floor") in the Organizer and choose "Set Current" before inserting the script.

- **Q: I get an error "Groupname cannot contain a _".**
  A: Rename your Floor Group in the hsbCAD Organizer to remove any underscore characters.

- **Q: How do I add a new item like "Spackle" to the list?**
  A: Right-click the table in the drawing, select "Change or Update materials," add the item in the window that pops up, and save/close.

- **Q: The table is empty after insertion.**
  A: This usually means the associated XML file was created but contains no data. Use the "Change or Update materials" right-click option to populate it.
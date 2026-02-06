# hsb_Inv-AssignSheetItemToArea.mcr

## Overview
This script assigns a specific sheet material (e.g., plywood or OSB) from your inventory database to an area defined by polylines. It automatically calculates the gross and net area (accounting for openings) for material estimation and places a label in the drawing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script is designed to run in the 3D model or 2D layout. |
| Paper Space | No | Not supported for layout viewports. |
| Shop Drawing | No | Not intended for generation of shop drawings. |

## Prerequisites
- **Required Entities**: At least one closed Polyline representing the main boundary. Optional Polylines representing openings (holes).
- **Required Settings**: `hsbLooseMaterialsUI.dll` must be installed. The Inventory database must contain items classified as "Sheet" (MinorGroupName='Sheet').

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_Inv-AssignSheetItemToArea.mcr`

### Step 2: Select Boundary
```
Command Line: Select main poliline
Action: Click the closed polyline that defines the outer edge of the sheet area (e.g., the wall face).
```

### Step 3: Select Openings
```
Command Line: Select opening polilines or ENTER to ignore
Action: Select polylines that represent holes or windows within the boundary. 
Note: Press ENTER if there are no openings.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Choose Sheet for this area | dropdown | (Dynamic) | Select the material stock code (e.g., "OSB 18mm") from your Inventory database. |
| Dimension style | dropdown | (Current) | Select the dimension style to control the font and size of the label text. |
| Text Color | number | -1 | Set the color of the label text. (-1 = ByLayer). |
| Area: | text (Read-only) | 0 | Displays the total gross surface area of the boundary. |
| Net Area: | text (Read-only) | 0 | Displays the usable area (Gross Area minus openings). |
| Perimeter: | text (Read-only) | 0 | Displays the total length of the outer boundary. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the area and label position if the source polylines have been modified. |

## Settings Files
- **Filename**: `hsbLooseMaterialsUI.dll`
- **Location**: `%hsbInstall%\Utilities\hsbLooseMaterials\`
- **Purpose**: Required to connect to the Inventory database and retrieve the list of available Sheet items.

## Tips
- **Automatic Updates**: If you stretch or move the main boundary polyline using AutoCAD grips, the script will automatically recalculate the Area, Perimeter, and move the label to the new centroid.
- **Visual Consistency**: Set the "Text Color" to -1 so the label adopts the color of the layer it is placed on, making layer management easier.
- **Inventory Setup**: If the script fails to load, check your hsbLooseMaterials settings to ensure you have items defined with the Group "Sheet".

## FAQ
- **Q: Why does the script say "No Sheet items available"?**
  **A:** The script cannot find any items in your Inventory database categorized as "Sheet". You need to add materials to your Inventory database and assign them to the "Sheet" group.
- **Q: Can I change the assigned material after inserting?**
  **A:** Yes. Select the script instance in the drawing, open the Properties palette (Ctrl+1), and choose a different item from the "Choose Sheet for this area" dropdown.
- **Q: What is the difference between Area and Net Area?**
  **A:** "Area" is the total size of the boundary you selected. "Net Area" is the Area minus the size of any opening polylines you selected in Step 3. Use Net Area for estimating actual material usage.
# hsbCAD_SIP_BOM.mcr

## Overview
Generates a 2D Bill of Materials (BOM) table in Paper Space that lists all timber beams and sheets from a specific hsbCAD Element selected via a viewport.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed to be inserted and viewed in Paper Space. |
| Paper Space | Yes | The script draws the BOM table on the current layout. |
| Shop Drawing | No | This is a drafting utility, not an hsbCAD Shop Drawing generation script. |

## Prerequisites
- **Required Entities**: A Viewport on the current Paper Space layout that references a valid hsbCAD Element (e.g., a Wall or Floor).
- **Minimum Beam Count**: 0.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCAD_SIP_BOM.mcr` from the file dialog.

### Step 2: Select Insertion Point
```
Command Line: Select upper left point of rectangle
Action: Click in Paper Space to define where the top-left corner of the BOM table will be placed.
```

### Step 3: Select Viewport
```
Command Line: Select the viewport from which the element is taken
Action: Click on the border of the viewport that displays the hsbCAD Element you wish to list in the BOM.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Header color | Number | 0 | Controls the color of the Element Title (e.g., Elevation Number) and the column header text (e.g., Width, Material) within the table. Uses AutoCAD Color Index (0-255). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script has no custom right-click menu options. Use the Properties Palette to adjust settings. |

## Settings Files
- **Filename**: None used.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Updating the Table**: If you modify the timber or sheets in the model (e.g., add a beam, change a material), update the script to automatically recalculate quantities and regenerate the table.
- **Moving the Table**: Select the script entity and use the grip point at the top-left corner to move the entire BOM table to a new location.
- **Organization**: The BOM aggregates identical items. It sorts the list by Position Number to keep components organized logically.

## FAQ
- **Q: Why did my table appear blank or empty?**
  A: The selected viewport might not contain a valid hsbCAD Element, or the element might contain no beams or sheets. Ensure the viewport is looking at a generated hsbCAD wall or floor.
- **Q: Can I change the color of just the data rows?**
  A: No, currently the script only allows you to change the "Header color" via the Properties Panel. The data rows use the current layer or default color settings.
- **Q: What is the difference between Beams and Sheets in this list?**
  A: The script processes them differently: Beams list Width, Height, and Length, while Sheets list Width, Height, and Material (Length column is empty for sheets).
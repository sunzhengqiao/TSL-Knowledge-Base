# GE_WALL_SPLICING.mcr

## Overview
This tool calculates and visualizes split points for long walls to meet manufacturing or transport length constraints. It allows you to preview where walls will be cut, manually adjust split locations, and then execute the breaks to create separate wall elements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D Single Frame Wall elements. |
| Paper Space | No | Not designed for layout views. |
| Shop Drawing | No | Does not generate 2D drawing views. |

## Prerequisites
- **Required Entities**: `ElementWallSF` (Single Frame Wall).
- **Minimum Count**: 1 wall element (walls shorter than the max length will be ignored automatically).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_WALL_SPLICING.mcr`

### Step 2: Select Walls
```
Command Line: Select a set of elements
Action: Click on the wall(s) you wish to check for splicing and press Enter.
```
*Note: The script will automatically ignore walls that are already shorter than the defined 'Max Wall Length'.*

### Step 3: Review Visualization
The script will attach to the wall and draw red overlay lines and markers indicating where the wall will be split.

### Step 4: Adjust Configuration (Optional)
Select the wall (the script instance is attached to it) and open the **Properties Palette** (Ctrl+1). Adjust parameters like *Max Wall Length* or *Starting Side* to see the split points update automatically.

### Step 5: Modify Split Points (Optional)
Right-click on the wall to access context menu options:
- Select **Set Distibution Point** if you want to define a custom start location in the model.
- Select **Add Spliting Point** to manually insert a split where the automatic logic did not place one.
- Select **Reset Splitable Points** to clear all manual changes and revert to the automatic calculation.

### Step 6: Execute Splits
```
Action: Right-click the wall → Select "Do The Splits"
```
The wall will be physically broken into separate elements at the calculated points, and the script instance will remove itself.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| BREAK PROPERTIES | Header | - | Visual separator only. |
| Max Wall Length | Number | 144.0 | The maximum allowed length for a single wall segment (in inches). Walls longer than this will be split. |
| Starting Side | Dropdown | Left | Determines the anchor and direction of splitting. Options include Left, Right, Left on Zone, Right on Zone, Pick Point, or Left - Right (splits from both ends towards center). |
| Zone Index | Dropdown | 5 | Specifies which wall layer (zone) to use as the geometric reference when "Starting Side" is set to a Zone option. |
| Wall Sides | Dropdown | Yes | Toggles the visibility of the wall's outer boundary lines in the visualization. |
| Wall Centerlines | Dropdown | Yes | Toggles the visibility of the wall's centerline in the visualization. |
| Openings | Dropdown | Sides | Strategy for handling windows/doors. "Sides" adds splits at opening edges; "In From Last Kings" offsets from trimmers; "None" ignores openings. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Do The Splits | Executes the physical split operation at the calculated points. The script instance is deleted after this action. |
| Reset Splitable Points | Removes any manually added split points and recalculates the layout based on current properties. |
| Add Spliting Point | Prompts you to click a location on the wall to manually add a specific split point. |
| Set Distibution Point | Changes the "Starting Side" mode to "Pick Point" and prompts you to select a new 3D reference point for the split calculation. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies entirely on Properties Palette inputs; no external settings files are required.

## Tips
- **Visualization Clutter**: If the model view becomes too cluttered, set the *Wall Sides* and *Wall Centerlines* properties to "No" to show only the split markers.
- **Long Walls**: For very long walls, use the "Left - Right" mode under *Starting Side*. This calculates splits from both ends of the wall towards the center, which is often structurally preferable.
- **Double Stud Walls**: If working with double walls, use the *Zone Index* property to ensure splits align with a specific leaf (e.g., the inner or outer layer) rather than the centerline.
- **Undo**: You can use the standard AutoCAD `UNDO` command immediately after executing "Do The Splits" if the result is not as expected.

## FAQ
- **Q: Why did the script disappear immediately after I selected the wall?**
  **A**: This happens if the selected wall's length is less than or equal to the *Max Wall Length*. The script determines no split is needed and removes itself to save resources. Try decreasing the *Max Wall Length* property before running the script.
  
- **Q: Can I undo the split operation?**
  **A**: Yes. Immediately after running "Do The Splits", you can use the standard `UNDO` command in AutoCAD to revert the wall to its original single piece.

- **Q: How do I make sure the split doesn't cut through a window?**
  **A**: Set the *Openings* property to "Sides". This forces the script to calculate split points at the sides of openings (windows/doors) rather than allowing a split line to intersect them.
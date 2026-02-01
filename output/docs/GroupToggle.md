# GroupToggle

## Overview
A utility script to quickly toggle the visibility of specific construction groups (such as walls or roofs) on or off to simplify the current drawing view.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script interacts with Group objects here. |
| Paper Space | No | Script is not designed for Paper Space. |
| Shop Drawing | No | Script is for the model layout, not detailing. |

## Prerequisites
- **Required Entities:** Elements (Walls/Roofs) or Entities within Groups.
- **Required Settings:** Valid Painter Definitions located in the catalog path `TSL\GroupToggle\`. (Note: The script attempts to auto-create default definitions for Exterior/Interior Walls and Roofs if they do not exist).
- **Minimum Beam Count:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GroupToggle.mcr`

### Step 2: Select Filter (Painter)
```
Properties Palette: |Painter| Dropdown
Action: Select the specific category to toggle (e.g., "Exterior Walls", "Interior Walls", "Roof Elements").
```
*Note: If you have created a catalog/toolbar button with a specific Execute Key (matching a Painter Name), the script will bypass this dialog and execute immediately.*

### Step 3: Apply Toggle
```
Action: Close the Properties Palette or press Enter.
Result: The script checks the current visibility state:
- If ANY matching group is currently visible, it turns ALL matching groups OFF.
- If ALL matching groups are currently invisible, it turns ALL matching groups ON.
```
The script instance will automatically erase itself from the drawing after execution.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| |Painter| | Dropdown | Dynamic List | Selects the specific filter rule (Painter Definition) used to identify which groups to toggle (e.g., Exterior Walls, Interior Walls, Roof Elements). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script executes immediately upon insertion and does not have persistent right-click menu options. |

## Settings Files
- **Location**: Catalog folder `TSL\GroupToggle\`
- **Purpose**: Stores the Painter Definition files that define the logic for what constitutes an "Exterior Wall", "Interior Wall", etc. The script can generate default definitions automatically if ElementWalls or ElementRoofs are present in the drawing.

## Tips
- **Toolbar Integration:** For frequent use, add this script to your toolbar. You can create separate buttons for different views (e.g., one button for "Exterior Walls" and one for "Roof Elements") by setting the Execute Key in the catalog properties to match the Painter Name.
- **Context Sensitivity:** If you run this script while inside a specific Group in the tree structure, it will only toggle sub-groups within that parent. If run in the root, it searches the entire model.
- **View Refresh:** The script automatically triggers a full regeneration (`_RegenAll`) if groups are turned ON to ensure the display updates correctly.

## FAQ
- **Q: I get an error saying "This drawing does not contain any valid definition."**
- **A:** The script requires Painter Definitions to function. Ensure the folder `TSL\GroupToggle` exists in your catalog, or create Elements (Walls/Roofs) in the drawing so the script can auto-generate the necessary definitions.

- **Q: Why did the script disappear immediately after I used it?**
- **A:** This is normal behavior. It is a "fire-and-forget" utility designed to perform the visibility toggle and then remove itself to keep your drawing clean.
# hsb_CreateMultielements.mcr

## Overview
Automates the creation and management of "Multielements" (transportable building blocks) by grouping and stacking single Elements (walls/floors) in 3D space. It visualizes assembly packages and manages their logical grouping based on attached metadata.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model to organize and stack elements. |
| Paper Space | No | Not designed for layout or detailing views. |
| Shop Drawing | No | Does not generate 2D drawings directly. |

## Prerequisites
- **Required Entities:** Single Elements (Walls/Floors) containing the `hsb_Multiwall` submap data (usually applied by a separate preprocessing script).
- **Minimum Beam Count:** 0 (Works with Element entities).
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT` → Select `hsb_CreateMultielements.mcr`

### Step 2: Set Base Point
```
Command Line: |Pick a point|
Action: Click in the Model Space to define the origin (0,0,0) for the first multielement stack.
```
*Note: Only one instance of this script manager is allowed per drawing.*

### Step 3: Configure Properties
After insertion, select the script instance and open the **Properties Palette**.
1. Set the **Single elements group** to match the layer containing your source elements.
2. Set the **Vertical offset** to the desired stacking height (e.g., 4000mm).
3. (Optional) Set a **Grouping format** if you want to sort stacks into columns based on naming conventions.

### Step 4: Generate Multielements
**Action:** Double-click the script instance or Right-click → `Refresh all Multielements`.
*The script will scan the model, collect valid elements, and draw the stacked multielements.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Vertical offset between multielements | Number | 4000.0 | The vertical distance (Z-axis) between the base of one multielement and the next. |
| Horizontal offset between multielements | Number | 0.0 | The horizontal spacing (X-axis) applied when a new group of multielements starts. |
| Assign to group | Dropdown | *Dynamic List* | The structural group to which the generated Multielement entities are assigned. |
| Single elements group | Dropdown | *Dynamic List* | The structural group from which the script reads source elements to create multielements. |
| Grouping format | Text | | A naming mask (e.g., "Project-Phase") used to sort multielements. If the key changes between elements, a new column is started using the horizontal offset. |
| Groups to check | Dropdown | \|All\| | Sets the scope of the search: \|All\| scans the whole model; \|This\| restricts scanning to the groups defined above. |
| Show MultiElement Names | Dropdown | \|Yes\| | Toggles the visibility of 3D text labels displaying the name of each multielement in the model. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Refresh all Multielements** (Double Click) | Rebuilds all multielements in the drawing. It erases existing multielements and recreates them based on current source elements and property settings. |
| **Refresh selected Multielement** | Prompts you to select a specific multielement to rebuild. Useful if you only want to update one stack without regenerating the whole model. |
| **Delete Multielement Metadata** | Removes the logical link (metadata) from source single elements. This disassociates them from the multielement logic without deleting the physical geometry. |

## Settings Files
- **Filename:** None
- **Location:** N/A
- **Purpose:** This script relies on standard hsbCAD element properties and map data, not external settings files.

## Tips
- **Singleton Manager:** If you try to insert a second instance of this script, it will automatically delete itself. Use the existing instance to change settings.
- **Grouping Logic:** Use the `Grouping format` property to organize your stacks. For example, if elements are named "House1-Floor1" and "House2-Floor1", setting the format to separate "House" will stack the floors for House1 in one column and House2 in the next column over.
- **Visualization:** If the model gets too cluttered with text, set `Show MultiElement Names` to `No` in the properties.

## FAQ
- **Q: Why didn't the script generate any multielements?**
  **A:** Ensure your single elements have the `hsb_Multiwall` map data attached (usually done via a preprocessing script) and that the `Single elements group` property matches the group where those elements reside.
- **Q: I changed the offsets, but nothing moved.**
  **A:** Changes to properties do not update the geometry automatically. You must **Double Click** the script instance or run `Refresh all Multielements` to apply the new spacing.
- **Q: How do I remove the multielements but keep my walls?**
  **A:** Use the `Delete Multielement Metadata` context menu option to remove the logical links. You can then manually delete the generated multielement blocks if needed.
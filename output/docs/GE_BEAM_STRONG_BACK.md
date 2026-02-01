# GE_BEAM_STRONG_BACK.mcr

## Overview
This script generates a structural strongback assembly (T-section or L-section) running parallel to selected joists or rafters. It is used to provide lateral stiffness and reduce deflection in floor or roof systems.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script creates 3D beam entities in the model. |
| Paper Space | No | Not designed for layout or detailing views. |
| Shop Drawing | No | Does not generate shop drawings directly. |

## Prerequisites
- **Required entities**: Existing Beam entities (joists or rafters) to which the strongback will be applied.
- **Minimum beam count**: 1 (though typically used on multiple parallel beams).
- **Required settings files**: `hsbFramingDefaults.Inventory.dll` (Must be present in the hsbCAD installation path).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_BEAM_STRONG_BACK.mcr`

### Step 2: Configure Properties (Dialog)
A dialog will appear automatically upon insertion.
**Action**: Select the desired lumber sizes for the Horizontal and Vertical beams from the inventory list. You may also select `|None|` if you only wish to create one part of the assembly (e.g., only horizontal).

### Step 3: Select Beams
```
Command Line: |Select beam|(s)
Action: Click to select the joists or rafters you want to reinforce. Press Enter to confirm selection.
```

### Step 4: Define Position
```
Command Line: |Insertion reference point|
Action: Click a point in the model space to define where the strongback attaches relative to the selected beams (e.g., on the side or at a specific depth).
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Horizontal beam** | Dropdown | First inventory item | Select the lumber size for the horizontal member (flange) from the inventory. Select `|None|` to omit this member. |
| **Vertical beam** | Dropdown | First inventory item | Select the lumber size for the vertical member (web) from the inventory. Select `|None|` to omit this member. |
| **Flip side** | Dropdown | \|No\| | Toggle between `\|No\|` and `\|Yes\|` to flip the strongback to the opposite side of the insertion point. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script acts as a generator and erases itself after creating the beams. There are no persistent right-click menu options for the script instance. |

## Settings Files
- **Filename**: `hsbFramingDefaults.Inventory.dll`
- **Location**: `[hsbCAD Install Path]\Utilities\hsbFramingDefaultsEditor`
- **Purpose**: This DLL provides the list of available lumber inventory items (Width, Height, Material, Grade) used to populate the dropdown menus for the horizontal and vertical beams.

## Tips
- **Insertion Point**: If you receive an error stating "There is no room for these beams at this point," try picking a reference point deeper within the joist depth, or select smaller lumber sizes.
- **Beam Orientation**: Ensure the beams you select are parallel to each other. The script calculates the strongback length based on the outermost perpendicular beams.
- **Post-Processing**: The script erases itself after running. The resulting beams are standard GenBeams and can be edited individually using standard hsbCAD tools.

## FAQ
- **Q: Why did the script disappear after I picked the point?**
  **A:** This is a "generator" script. Its purpose is to create the beam geometry and then remove itself from the drawing. The resulting strongback beams remain as independent objects.
- **Q: I get an error "Data incomplete, check values on inventory".**
  **A:** The lumber item you selected in the properties might be missing Width or Height data in your `hsbFramingDefaults`. Check your inventory configuration.
- **Q: Can I create only a horizontal beam without the vertical part?**
  **A:** Yes. Set the "Vertical beam" property to `|None|` in the properties or dialog before inserting.
# HSB_E-AssignEntitiesToGroup.mcr

## Overview
This script automates the organization of your model by assigning selected entities (or the contents of an entire element) to specific drawing groups. It uses configurable naming formats and filter criteria to sort items into groups for exporting, scheduling, or BIM coordination.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in Model Space. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not intended for use within shop drawings. |

## Prerequisites
- **Required Entities:** Existing Elements (Walls/Roofs) or specific Entities (Beams/Plates) in the model.
- **Minimum Beams:** 0.
- **Required Settings/Dependencies:** The following TSL scripts must be loaded in your drawing:
  - `HSB_G-FilterEntities` (Used to define which entities to select).
  - `HSB_G-ContentFormat` (Used to format the group names).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-AssignEntitiesToGroup.mcr`

### Step 2: Configure Properties
Once inserted, the **Properties Palette** will open. You must configure the following before proceeding:
1. **Entity filter catalog:** Select a catalog from the dropdown. This determines *which* entities inside the element will be assigned (e.g., only studs, or only top plates).
2. **Group format:** Enter a string defining the group name structure (e.g., `@(GroupLevel1)\@(GroupLevel2)`). Use `\` to create sub-groups.

### Step 3: Select Input Method
The command line will prompt:
```
Select a set of elements | or <ENTER> to select entities
```
- **Option A (Element Mode):** Click on an Element (like a wall). The script will attach to that element and process all entities inside it that match your filter.
- **Option B (Entity Mode):** Press `<ENTER>` on your keyboard. The command line changes to:
  ```
  Select entities
  ```
  Click specifically on the beams or bodies you want to organize.

### Step 4: Execution
The script will automatically filter the selected items, calculate the group names based on your format, and move the entities into the specified groups. If a group does not exist, it will be created.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Entity filter catalog | Dropdown | *Empty* | Select the predefined rule set (from `HSB_G-FilterEntities`) that determines which entities are processed. |
| Group format | Text | @(GroupLevel1)\@(GroupLevel2) | Defines the name of the group the entities will be added to. Use tokens like `@(Name)` and separate levels with a backslash `\`. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add custom items to the right-click menu. Modify settings via the Properties Palette. |

## Settings Files
- **Filename:** None specified.
- **Location:** N/A
- **Purpose:** This script relies on the logic within the dependency TSLs (`HSB_G-FilterEntities` and `HSB_G-ContentFormat`) rather than external XML settings files.

## Tips
- **Creating Sub-groups:** Always use the backslash symbol `\` in your **Group format** string (e.g., `Floor1\Walls`) to create a nested group structure in the tree.
- **Troubleshooting:** If the script reports that it "could not filter entities," ensure that the `HSB_G-FilterEntities` TSL is loaded into your drawing via the TSL Script Load Manager.
- **Manual Selection:** If you only want to organize specific parts of a wall (e.g., just the opening trim), use the **Entity Mode** (Press `<ENTER>` at the first prompt) and pick the items manually.

## FAQ
- **Q: I ran the script but nothing happened. Why?**
  A: Check the command line for error messages. The most common cause is missing dependencies. Ensure `HSB_G-FilterEntities` and `HSB_G-ContentFormat` are loaded. Also, verify that your filter catalog actually returns results (e.g., if the filter looks for "Steel" but your element is "Wood", nothing will be selected).
- **Q: Can I use this to group entities from different elements into one group?**
  A: Yes. Use the Entity Mode (press `<ENTER>` at the prompt) and select entities from multiple different elements. They will all be assigned to the group name defined in your properties.
- **Q: What happens if the group already exists?**
  A: The script will find the existing group and simply add the new entities to it. It will not overwrite or delete the existing group.
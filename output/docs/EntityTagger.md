# EntityTagger

## Overview
This tool allows for the batch numbering, tagging, and property assignment of structural timber elements (GenBeams) and TSL instances. It uses logic defined in hsbCAD Painter Definitions to automatically calculate and update fields such as Labels, Position Numbers (PosNums), Materials, and Grades.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on GenBeam and TslInst entities in the model. |
| Paper Space | No | Not designed for layout views. |
| Shop Drawing | No | Not a shop drawing script. |

## Prerequisites
- **Required Entities**: GenBeams or TslInsts to be modified.
- **Minimum Beam Count**: 0 (User selects the target group).
- **Required Settings**: A collection of Painter Definitions named **`EntityTagger`** is recommended to organize and filter the available logic options.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or `TSLCONTENT`) → Select `EntityTagger.mcr`

### Step 2: Configure Properties
```
Action: The Properties Palette (OPM) or a dialog window will appear.
User Task: Select the desired Painter Definitions for Name, Label, Material, etc.
          Configure sequential tagging options if needed.
          Set the Position Number start value.
Note:     If run from a catalog, these settings may load automatically.
```

### Step 3: Select Entities
```
Command Line: Select genbeams
Action: Click on GenBeams or TslInsts in the drawing. Press Enter to confirm selection.
```

### Step 4: Execution
```
Action: The script calculates values based on the selected painters and updates the entities.
Result: The script instance automatically erases itself from the drawing.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Sublabel** | dropdown | \|_Default\| | Selects the Painter Definition used to group elements for sequential numbering in the SubLabel field (e.g., 1, 2, 3...). |
| **Sort Direction** (Seq) | dropdown | \|Ascending\| | Defines the order (Ascending/Descending) in which sequential tags are assigned to the grouped elements. |
| **Prefix Target** | dropdown | \<\|Disabled\|\> | Specifies which property receives the 'prefix' value if the Sequence Painter includes an alias definition. Options: Disabled, Label, Sublabel 2, Information. |
| **Name** | dropdown | \|_Default\| | Selects a Painter Definition to calculate and overwrite the 'Name' property of the elements. |
| **Label** | dropdown | \|_Default\| | Selects a Painter Definition to calculate and overwrite the 'Label' property. (Skipped if Prefix Target is Label). |
| **Material** | dropdown | \|_Default\| | Selects a Painter Definition to calculate and assign the 'Material' property. |
| **Grade** | dropdown | \|_Default\| | Selects a Painter Definition to calculate and assign the 'Grade' (Strength Class). |
| **Information** | dropdown | \|_Default\| | Selects a Painter Definition to write user notes into the 'Information' field. (Skipped if Prefix Target is Information). |
| **PosNum Painter** | dropdown | \<\|Disabled\|\> | Selects the Painter Definition used to group elements for Position Number assignment. Elements with the same result get the same PosNum. |
| **Sort Direction** (PosNum) | dropdown | \|Ascending\| | Defines the order in which unique PosNum groups are numbered. |
| **Start Number** | integer | -1 | Sets the starting number for PosNums. **Negative values clear existing PosNums** and start fresh at the absolute value. **0 clears/releases PosNums**. Positive numbers start incrementing from that value. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | The script instance erases itself immediately after execution, leaving no active instance for right-click interactions. |

## Settings Files
- **Entity**: Painter Definitions (Internal hsbCAD Database)
- **Location**: hsbCAD Painter Palette
- **Purpose**: This script does not load external XML files. It relies on Painter Definitions defined within the hsbCAD environment.
  - It specifically looks for a collection named `EntityTagger`.
  - If this collection is missing, it lists all painters containing `@(` in their format string.

## Tips
- **Organization**: Create a Painter Collection named `EntityTagger` and add your relevant painters to it. This keeps the dropdown lists in the script clean and relevant.
- **Prefix Conflicts**: If you set **Prefix Target** to "Label", the script will automatically disable the standard **Label** painter mapping to prevent the sequence logic from being overwritten immediately.
- **Renumbering**: To completely reset Position Numbers for a selection, set **Start Number** to `0`. To reset and start numbering at 1, set it to `-1`.
- **Debug Mode**: If the script fails to erase itself (rare), ensure you are not in a debug mode that halts execution.

## FAQ
- **Q: Why don't I see my specific Painter in the dropdown list?**
  - A: Ensure your Painter is either inside a collection named `EntityTagger` or contains the characters `@(` in its format string.
- **Q: Why did my Position Numbers disappear?**
  - A: Check the **Start Number** parameter. If it is set to `0` or a negative number, it clears existing numbers.
- **Q: Can I undo the changes?**
  - A: Yes, use the standard AutoCAD `UNDO` command immediately after running the script.
- **Q: Where did the script object go after I ran it?**
  - A: The script is designed to "fire and forget." It erases itself automatically after updating the entities to keep your drawing clean.
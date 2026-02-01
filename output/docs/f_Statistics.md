# f_Statistics.mcr

## Overview
This script calculates and reports the accumulated weight and volume of selected construction elements directly to the command line. It is designed to help verify shipping weights or material totals for groups of timber components, beams, and panels.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates on 3D physical entities. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | This is a model-level estimation tool. |

## Prerequisites
- **Required Entities**: At least one of the following entity types must be present in the selection: GenBeam, Element, MassElement, MassGroup, ChildPanel, or Sip.
- **Required Settings**: The drawing dictionary `hsbTSL` must contain an entry `f_Stacking` with a `Truck` map. This map defines where the script looks for weight properties (e.g., `Properties.Weight`).
- **Fallback**: If specific weight properties are missing, the script attempts to use the `hsbCenterOfGravity` MapIO to estimate weight based on volume and density.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `f_Statistics.mcr`

### Step 2: Select Items
```
Command Line: |Select item(s)|
Action: Click on individual beams, panels, or elements in the model. You can also use a window selection to pick multiple items at once. Press Enter to confirm the selection.
```

### Step 3: View Results
```
Action: Look at the AutoCAD Command Line (F2 to view full history).
Output: The script will display a summary including:
- Total number of items
- Total number of child items (if Elements were selected)
- Total Weight (in kg)
- Total Volume
Note: The script instance will automatically erase itself from the drawing after reporting.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not expose any user-editable properties in the Properties Palette. All configuration is handled via the drawing dictionary. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | No specific context menu actions are defined for this script. |

## Settings Files
- **Dictionary Entry**: `hsbTSL` (Key: `f_Stacking`)
- **Location**: Drawing Dictionary (AutoCAD internal database)
- **Purpose**: Stores configuration maps, specifically the `Truck` map. This map tells the script which property path (e.g., `Properties.Weight`) to read for mass calculations. Special support is included for "KLH" projects to look at `MassElement` property sets.

## Tips
- **Mixed Selections**: You can select a mix of beams, panels, and entire Elements (walls/floors) in one go. The script will automatically break down Elements to count their internal beams.
- **Window Selection**: For large packages, using a crossing window selection is faster than picking items one by one.
- **Accuracy**: For the most accurate results, ensure your entities have the correct "Weight" property assigned. If this is missing, the script estimates weight based on volume, which might differ from actual shipping weights due to hardware or finishing.

## FAQ
- **Q: Where does the weight number come from?**
  A: The script primarily looks for a specific property defined in your project settings (usually under `Properties.Weight`). If that property is empty or zero, it calculates an estimated weight using the `hsbCenterOfGravity` tool based on the material density.
- **Q: Why does the script disappear after I run it?**
  A: This is a utility script designed to perform a one-time calculation and report. It automatically cleans up (erases itself) after printing the results to keep your drawing clean.
- **Q: Can I use this to check the weight of a single wall?**
  A: Yes, simply select the `Element` (wall/floor) entity. The script will aggregate the weight of all beams and panels within that element.
# hsb_MultiWallManager.mcr

## Overview
This script configures, names, and updates Multiwall (prefab wall) assemblies for manufacturing export. It manages element metadata, assigns export groups, and controls the regeneration of associated drawings for selected wall elements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in Model Space. |
| Paper Space | No | Not supported in Layouts. |
| Shop Drawing | No | This is a model configuration tool. |

## Prerequisites
- **Required entities**: Element (Timber walls).
- **Minimum beam count**: 0 (Operates on Element level).
- **Required settings**: 
  - `hsbMultiwallExporter.dll`
  - `MultiElementTools.dll`
  - Valid Export Groups configured in the ModelMap.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_MultiWallManager.mcr` from the list.

### Step 2: Select Wall Elements
```
Command Line: Select one or More Elements
Action: Click on the wall elements (Element entities) you wish to include in the Multiwall assembly, then press Enter.
```

### Step 3: Configure Properties
```
Action: With the script instance selected, open the Properties Palette (Ctrl+1) to configure the Multiwall settings.
```

### Step 4: Apply Updates
```
Action: Modify the parameters in the Properties Panel. The script will automatically process the changes based on the flags set (e.g., recalc drawings, update metadata).
Note: The script instance may erase itself after execution depending on the specific workflow context.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Export Group | dropdown | First available 'MW' group | Select the manufacturing interface configuration. If "Default export group" is selected, a new group is created automatically. |
| Name Format | text | `@(Code)_@(SW)` | Defines the naming convention for the Multiwall elements (e.g., `MW_@(Seq)`). |
| Update existing multi elements | dropdown | Yes | If "Yes", forces a full refresh of existing multi elements (this may overwrite manual changes). |
| Clear multi element meta data | dropdown | No | **Warning:** If "Yes", deletes all existing multiwall data from *all* elements in the model, effectively resetting the configuration. |
| Recalc existing multi element tsls | dropdown | Yes | If "Yes", forces the associated drawing scripts to regenerate to reflect geometry and name changes. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not add specific items to the right-click context menu. All interactions are handled via the Properties Palette. |

## Settings Files
- **Dependencies**: `hsbMultiwallExporter.dll`, `MultiElementTools.dll`
- **Location**: hsbCAD Application Directory.
- **Purpose**: These DLLs handle the logic for composing Multiwall maps and interacting with the manufacturing export configuration. No specific XML settings file is required for the script itself beyond standard ModelMap configurations.

## Tips
- **Resetting Data**: Use the "Clear multi element meta data" property with caution. It scans the *entire* model, not just your selection, to remove multiwall links.
- **Naming Tokens**: Ensure your "Name Format" uses valid hsbCAD tokens like `@(Code)`, `@(SW)`, or `@(Seq)` to guarantee correct numbering.
- **Drawing Updates**: If you change the Name Format but your drawing labels do not update, ensure "Recalc existing multi element tsls" is set to "Yes".
- **Export Groups**: The list of Export Groups is automatically filtered to show only those containing "MW" or specific export starters.

## FAQ
- **Q: What happens if I choose "Default export group"?**
- **A**: The script will automatically create a new Export Group in your ModelMap named `hsb_MW_Export_Group_for_Multiwalls` and assign it to the elements.

- **Q: My Multiwall names changed in the model, but the drawings are still showing the old names.**
- **A**: Check the "Recalc existing multi element tsls" property. If it is set to "No", the drawing scripts will not automatically update to reflect the new name format or geometry.

- **Q: I received a license warning during insertion.**
- **A**: Ensure your license dongle includes the `hsbMultiwallComposer` module. The script will stop functioning if this specific license is not found.
# hsb_CNCGroupExport

## Overview
Automates the export of CNC and production data for timber components based on specific machine configurations or project delivery phases. It generates manufacturing files (e.g., BTL, Posex) for the entire project, specific deliveries, or user-selected objects.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in Model Space to access Elements and Entities. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities**: Elements or Entities (beams/walls) present in the drawing.
- **Minimum Beam Count**: 0 (Can export an empty list if nothing is found).
- **Required Settings**: Exporter Groups and Exporter Shortcuts must be configured in the ModelMap (Company or Install path).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_CNCGroupExport.mcr`

### Step 2: Configure Export Settings
The Properties Palette will appear automatically upon insertion. Configure the following:
1. **Elements to export**: Choose how to filter the model (e.g., "Select all entities in drawing", "Select current delivery", or manual selection modes).
2. **Exporter group**: Select a predefined group of exports from the dropdown (e.g., a group containing both a CNC machine export and a Label export).
3. **Single export**: If the "Exporter group" is left empty, select a specific single export shortcut (e.g., "Weinmann CNC").
4. Click outside the Properties Palette or close it to execute.

### Step 3: Select Objects (Conditional)
*This step only appears if you selected "Select entities in drawing" or "Select elements in drawing" in Step 2.*

**Option A: Select entities**
```
Command Line: |Select a set of entities|
Action: Click on specific beams or parts in the model. Press Enter to confirm.
```

**Option B: Select elements**
```
Command Line: |Select a set of elements|
Action: Click on whole Elements (e.g., a wall assembly) in the model. Press Enter to confirm.
```

### Step 4: Execution
The script processes the selected objects, generates the CNC/Production files, and then automatically removes itself from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Elements to export | dropdown | Select all entities in drawing | Determines the scope of the export. Options include all entities, all elements, manual selection, or filtering by the current project delivery. |
| Exporter group | dropdown | (Empty) | Select a named collection of export configurations from the ModelMap. If selected, this overrides the "Single export" setting. |
| Single export | dropdown | (Empty) | Select a specific single export configuration (shortcut) from the ModelMap. Used only if "Exporter group" is empty. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Execute Key | Sets the script properties based on a predefined Catalog Entry (Key). This allows for silent execution without opening the Properties Palette if a matching Key is found. |

## Settings Files
- **Filename**: ModelMap Configuration (`.map` or related XML configuration)
- **Location**: `_kPathHsbCompany` or `_kPathHsbInstall`
- **Purpose**: Defines the available "Exporter Groups" and "Exporter Shortcuts" used in the dropdown menus. Without these, the export targets cannot be resolved.

## Tips
- **Script Behavior**: This script is "run-once." It will automatically delete itself from the drawing after the export is complete to prevent duplicate data.
- **Delivery Management**: Use the "Select current delivery" option to quickly export only the parts assigned to the active delivery phase in your project map.
- **Group vs. Single**: If you need to generate files for multiple machines at once (e.g., a saw and a CNC), define an "Exporter Group" in the ModelMap and select it here. Otherwise, use "Single export."

## FAQ
- **Q: Why did the script disappear immediately after I closed the properties?**
  - A: This is normal behavior. The script executes the export command and then runs `eraseInstance()` to clean itself up automatically.
- **Q: The export failed. What went wrong?**
  - A: Verify that the name you entered in "Exporter group" or "Single export" matches exactly with the names defined in your ModelMap configuration. Also, ensure you have write permissions to the destination folder.
- **Q: Can I edit the settings after I run it?**
  - A: No. Since the script erases itself after running, you must insert a new instance to change settings or run the export again.
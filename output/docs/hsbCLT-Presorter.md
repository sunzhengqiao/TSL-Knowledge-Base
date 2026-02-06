# hsbCLT-Presorter.mcr

## Overview
This script organizes CLT child panels into logical groups for production, applies sorting rules, and displays group information labels. It prepares panel data for nesting optimization by allowing manual rotation, flipping, and property visualization.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D model manipulation of CLT panels. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | Not applicable. |

## Prerequisites
- **Required Entities**: CLT Elements and ChildPanels must exist in the model.
- **Required Settings**: `hsbCLT-MasterPanelManager` (defines sorting rules).
- **External Libraries**: `TslUtilities.dll` (for dialog utilities).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-Presorter.mcr`

### Step 2: Select Panels
```
Command Line: Select child panels to trace
Action: Click on the specific CLT child panels you want to include in the sorting group. Press Enter to select all visible child panels.
```

### Step 3: Configure Properties
After insertion, select the script instance in the model and open the **Properties Palette** (Ctrl+1) to set sorting rules and label preferences.

### Step 4: Run Sorting
Once properties are set, the script will automatically group the panels and update the display labels in the 3D model.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| bDebug | number | 1 | Enables debug mode to show calculation details and geometry overlays. Set to 0 to hide. |
| sFaceAlignment | dropdown | (Empty) | Sets the alignment of the group header text relative to the panels (e.g., Left or Right). |
| sChildProperties | dropdown | \|All\| | Determines which properties are displayed in the group header label (e.g., Material, Grade, Dimensions). |
| sRule | text | (Empty) | Specifies the sorting rule name defined in the hsbCLT-MasterPanelManager (e.g., 'SortByWidth'). |
| sSortingDir | dropdown | (Empty) | Sets the sorting direction order (Ascending or Descending). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Show Dependencies | Toggles the display of trace lines connecting child panels to their parent elements. |
| Hide Dependencies | Hides the trace lines connecting child panels to their parent elements. |
| Rotate All 90° | Rotates all associated child panels 90 degrees around the script's Z-axis instantly. |
| Rotate 90° | Prompts you to select specific child panels and rotates them 90 degrees. |
| Rotate 180° | Prompts you to select specific child panels and rotates them 180 degrees. |
| Flip + Rotate Child | Prompts you to select specific child panels, flips them, and applies rotation. |

## Settings Files
- **Filename**: `hsbCLT-MasterPanelManager`
- **Location**: Company standard or hsbCAD install path.
- **Purpose**: Contains the definitions for sorting rules referenced by the `sRule` parameter (e.g., grouping logic, default widths).

## Tips
- Use the **Rotate All 90°** context menu option to quickly adjust all panels in a group to fit a specific production layout.
- Double-clicking the script instance triggers the "Show Dependencies" command, allowing you to quickly verify which parent elements are associated with the sorted panels.
- Ensure your `sRule` parameter exactly matches the name defined in your MasterPanelManager settings to avoid grouping errors.

## FAQ
- Q: How do I change what information is shown on the group label?
- A: Select the script instance, open Properties (Ctrl+1), and change the **sChildProperties** dropdown from "All" to a specific subset like "Material" or "Length".
- Q: Why aren't my panels sorting correctly?
- A: Verify that the **sRule** property matches a rule name defined in your `hsbCLT-MasterPanelManager` settings file.
- Q: Can I rotate just one panel instead of the whole group?
- A: Yes, right-click the script instance and select **Rotate 90°** or **Rotate 180°**, then click only the specific panel you wish to modify.
# hsbCLT-SubNesting

## Overview
This script manages and visualizes sub-elements (subnestings) within a Master CLT panel. It allows users to display specific properties on the subnesting (like grade or material) and to clone specific machining tools (drills, cuts, slots) from the main panel to the subnesting for production data processing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This is the primary environment for this script. |
| Paper Space | Yes | Supported for display purposes. |
| Shop Drawing | No | This is a Model script, but it outputs geometry that shop drawing scripts can read. |

## Prerequisites
- **Required Entities**: A single Master CLT Panel (Element).
- **Minimum Beam Count**: 1.
- **Required Settings**:
    - Map entry for `Tool[]` (used for populating tool name dropdowns).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-SubNesting.mcr`

### Step 2: Select Element
Action: Click on the Master CLT Panel (Element) in the drawing to attach the script.

### Step 3: Configure Display (Optional)
Action: Double-click the script instance or use the Right-Click menu "Add/Remove Format" to select which properties (e.g., Name, Grade, Material) to display on the label.

### Step 4: Clone Machining (Optional)
Action: Right-click the script instance and select a cloning option (e.g., "Clone Drills"). Adjust the specific filters (Diameter, Face, etc.) in the Properties palette to define which tools to clone.

## Properties Panel Parameters

*Note: Many properties only appear or become relevant after triggering a specific Context Menu command (e.g., Clone Drills).*

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Diameter** | Text | `""` | Filters drill holes. Supports single values, ranges (e.g., `0-20`), or lists (e.g., `20;40`). Empty = all diameters. |
| **Alignment** | Dropdown | `All` | Filters drills or beam cuts based on angle. Options: `All`, `Perpendicular`, `Beveled`. |
| **Face** | Dropdown | `All` | Filters operations by the panel face. Options: `All`, `bottom`, `top`, `complete through`, `Edge`. |
| **Tool** | Dropdown | `Any` | Filters Free Profiles, Cuts, Slots, or X-Fix by the specific tool name defined in the Tool Map. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Add/Remove Format** | Opens a list to select which properties (Name, Label, Grade, etc.) are displayed in the text label. |
| **Select subnesting** | Selects the subnesting instance in the model. |
| **Show Settings** | Displays the script's internal settings map. |
| **Clone Drills** | Enables drill cloning mode. Exposes Diameter, Alignment, and Face filters in the Properties palette to select which drills to copy. |
| **Remove Drills** | Removes previously cloned drills based on the current filter settings. |
| **Clone BeamCuts** | Enables beam cut cloning mode. Exposes Alignment and Face filters. |
| **Clone FreeProfiles** | Enables free profile (contour) cloning mode. Exposes Tool and Face filters. |
| **Clone Cuts** | Enables cut cloning mode. Exposes Tool and Alignment filters. |
| **Clone Slots** | Enables slot cloning mode. Exposes Tool filter. |
| **Clone X-Fix** | Clones X-Fix hardware profiles defined by free profiles. |

## Settings Files
- **Map Entries**: `Tool[]`
- **Location**: `_kPathHsbCompany` or `_kPathHsbInstall`
- **Purpose**: Provides the list of available Tool names used in the dropdown filters for machining operations.

## Tips
- **Diameter Syntax**: When filtering drills, you can use `0-20` to catch all holes up to 20mm, or `12;16` to catch only exactly 12mm and 16mm holes.
- **Dynamic Labels**: Use the "Add/Remove Format" menu to quickly toggle the display of Grain Direction or Material info without editing complex strings manually.
- **Cloning Workflow**: When using "Clone" commands, set your filters in the Properties palette first, then re-calculate the script (or move it) to apply the cloning logic.

## FAQ
- **Q: I don't see any filter options (Diameter, Tool) in the Properties palette.**
  - **A**: You must first trigger the specific clone command from the Right-Click menu (e.g., "Clone Drills"). This activates the specific properties needed for that operation.
- **Q: The text label is not showing the correct information.**
  - **A**: Double-click the script instance or select "Add/Remove Format" from the menu. Check if the desired fields (like Name or Grade) are selected in the list.
- **Q: My cloned drills are not appearing.**
  - **A**: Check the "Diameter" property. If it contains a value that excludes your drill size (e.g., set to `100` but your drill is `10`), nothing will be cloned. Clear the Diameter field to accept all sizes.
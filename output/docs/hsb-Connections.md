# hsb-Connections.mcr

## Overview
This script automates the batch detection and generation of structural steel connections between timber beams within a selected Element. It analyzes geometric intersections to apply specific steel tools (like plates or angles) based on connection types (Corner, T, X, etc.).

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Calculates geometry based on 3D beam intersections. |
| Paper Space | No | Not designed for 2D layouts. |
| Shop Drawing | No | This is a model generation script, not a detailing tool. |

## Prerequisites
- **Required Entities**: Element and GenBeams (Timber beams).
- **Minimum Beam Count**: 0 (Though intersecting beams are required to create connections).
- **Required Settings**: 
  - The script `hsb-SteelTool` (or variants like SFT-SteelTool/FFB-SteelTool) must be installed.
  - Valid catalog entries within hsb-SteelTool for various connection types (Corner, X, T, Angled).

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT`
**Action:** Select `hsb-Connections.mcr` from the file browser.

### Step 2: Configuration (Optional)
**Action:** If running the script for the first time or if triggered, a configuration dialog may appear. Select the desired catalogs for different connection types. You can also modify these later in the Properties Palette.

### Step 3: Select Element
```
Command Line: Select a set of elements
Action: Click on the Element (e.g., a wall or roof plane) containing the beams you want to process. Press Enter to confirm selection.
```

### Step 4: Preview or Generate
**Action:** 
- By default, the script runs in **Preview Mode**. It will draw text labels (e.g., "Tm", "X", "G") at connection points to show you where connections will be made.
- To generate the actual steel connections, select the script instance in the model, open the **Properties Palette**, and change `sPreviewMode` to "Disabled", or use the Right-Click menu option described below.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sPreviewMode | Dropdown | Enabled | **Enabled**: Shows only text labels for connections. **Disabled**: Generates actual steel connection tools. |
| sMakeSquared | Dropdown | Do not make square | Controls if angled beam ends are forced to be square cuts (90°). Options: Do not make square, Only male, Only female, Make both square. |
| catalogNameCornerConnections | String | <hsb-SteelTool Default> | The catalog preset used for standard 90-degree corner connections. |
| catalogNameXConnections | String | <hsb-SteelTool Default> | The catalog preset used for cross connections where one beam passes through another. |
| catalogNameTConnectionsWithVerticalMale | String | <hsb-SteelTool Default> | The catalog preset for T-connections where a vertical beam (column) meets a horizontal beam. |
| catalogNameTConnectionsWithHorizontalMale | String | <hsb-SteelTool Default> | The catalog preset for T-connections between horizontal beams (e.g., joist to beam). |
| catalogNameBackConnections | String | <hsb-SteelTool Default> | The catalog preset for connections entering from the web/side of a beam. |
| catalogNameAngledCornerConnections | String | <hsb-SteelTool Default> | The catalog preset for corners where beams meet at an angle other than 90 degrees. |
| catalogNameAngledTConnections | String | <hsb-SteelTool Default> | The catalog preset for generic angled T-connections. |
| catalogNameAngledTConnectionsWithVerticalMale | String | <hsb-SteelTool Default> | The catalog preset for T-connections with a vertical column meeting an angled beam. |
| catalogNameAngledTConnectionsWithHorizontalMale | String | <hsb-SteelTool Default> | The catalog preset for T-connections with a horizontal beam meeting an angled beam. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| End preview mode | Switches the script from Preview Mode to Production Mode. This generates the actual `hsb-SteelTool` instances and removes the temporary preview labels. |

## Settings Files
- **Catalog Entries**: Defined within the `hsb-SteelTool` (or SFT/FFB variant) configuration.
- **Location**: Usually stored in the company folder or hsbCAD installation directory.
- **Purpose**: These files contain the geometric and material data (plate sizes, bolt patterns) used by the generated connection tools.

## Tips
- **Verify Connections First**: Always run the script in `Preview Mode` (Enabled) first. Check the text labels to ensure the script has correctly identified the connection types (Corner vs. T vs. X) before generating the heavy 3D steel geometry.
- **Beam Filtering**: The script automatically filters out beams with specific profiles or connection codes (like "PS") that are designated as invalid.
- **Grouping**: This script processes entire Elements at once. It is efficient for applying connections to whole walls or roof panels rather than single beams.

## FAQ
- **Q: I ran the script, but I don't see any steel plates.**
- A: Check the `sPreviewMode` property. If it is set to "Enabled", the script only draws text labels. Change it to "Disabled" or use the "End preview mode" right-click option.
- **Q: Some connections are missing.**
- A: Ensure your beams are actually intersecting within the Element. The script also ignores beams marked as "Rectangular" profiles or with specific excluded connection codes.
- **Q: How do I change the size of the steel plates?**
- A: You do not change this directly in `hsb-Connections`. Instead, modify the specific Catalog Name properties (e.g., `catalogNameCornerConnections`) to point to a different catalog preset defined in `hsb-SteelTool`.
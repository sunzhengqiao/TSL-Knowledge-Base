# SimpsonHanger.mcr

## Overview
Automates the selection, placement, and detailing of Simpson Strong-Tie joist hangers at T-connections between joists and carrying beams. It supports automatic model selection based on joist profiles and includes options for web stiffeners and backer blocks.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script calculates 3D intersections and places models. |
| Paper Space | No | Script is not designed for 2D layout or detailing views. |
| Shop Drawing | No | Generates 3D models and data exports, not shop drawings directly. |

## Prerequisites
- **Required Entities**: At least one set of Joists and one set of Carrying Beams (Headers).
- **Minimum Beams**: 2 (1 Joist and 1 Header forming a T-connection).
- **Required Settings**: The script attempts to auto-generate a library map named `Hangers/Simpson`. If the map is missing, ensure `HangerList.mcr` is present in your script folder.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `SimpsonHanger.mcr`

### Step 2: Select Joists
```
Command Line: Select Joists, all must be parallel
Action: Click on the joists that need hangers. You can select multiple joists at once, but they must run in the same direction.
```

### Step 3: Select Carrying Beams
```
Command Line: Select Carrying Beams
Action: Click on the carrying beams (headers or rim beams) that the joists connect into.
```

### Step 4: Generation
The script will automatically identify T-connections, calculate the geometry, and insert a hanger instance at each valid intersection.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Execution Mode | dropdown | Standard | **Standard**: Selects hanger based on joist profile type (I-Joist vs Sawn). <br> **Manual**: Selects hanger based purely on geometry (used for mixed or non-standard joists). |
| Posnum | number | -1 | The Position Number (Item Mark) for this specific hanger instance used in lists and BOMs. |
| General notes | text | | User-defined text for specific installation notes or fabrication instructions. |
| Web Stiffener | dropdown | No | **Yes**: Creates solid wood blocks inside the joist to reinforce the web. <br> **No**: Removes any stiffeners. |
| Backer Block | dropdown | None | Specifies the configuration of backer blocks on the carrying beam (None, Single, or Double). |
| Hanger Color | number | 6 | Sets the display color of the 3D hanger model (AutoCAD Color Index). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Update Hanger List | Re-runs the `HangerList.mcr` script to refresh the internal library of available Simpson hangers. Use this if the script reports missing data. |

## Settings Files
- **Dependency**: `HangerList.mcr`
- **Location**: TSL Scripts folder
- **Purpose**: This script is called automatically by `SimpsonHanger.mcr` to populate the internal "Hangers/Simpson" map used to look up correct model numbers based on dimensions.

## Tips
- **Mixed Joist Sizes**: If you select joists with different profiles, the script automatically switches to "Manual" mode to ensure the correct geometry is calculated.
- **I-Joist Reinforcement**: For I-Joists, it is highly recommended to set **Web Stiffener** to "Yes" to prevent the web from crushing under the hanger's top flange.
- **Visual Feedback**: If a hanger model cannot be found in the library, the script will draw a circle at the connection point to indicate the location.

## FAQ
- **Q: The script disappeared after I ran it. Why?**
  - A: This usually happens if the script did not detect valid beams (e.g., no T-connection found) or if the hanger library data is completely empty. Check your command line for error messages.
- **Q: How do I force a specific hanger model if the auto-selection is wrong?**
  - A: Change the **Execution Mode** property to "Manual". You can then modify the hanger data properties manually if exposed, or ensure your library map matches your joist profile names.
- **Q: What does "Safety broke sorting loop" mean?**
  - A: This indicates a geometric anomaly (likely collinear beams or extremely close spacing). The script attempts to recover, but you may need to check the beam alignment manually.
# hsb_HangerDisplay.mcr

## Overview
Displays a parametric metal hanger plate at a T-connection between beams. This script manages the 3D visualization, text labeling, and exports hardware data (BOM) for production.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used to place and visualize hangers in the 3D model. |
| Paper Space | No | Not intended for 2D layouts. |
| Shop Drawing | No | Not used for generating shop drawings directly. |

## Prerequisites
- **Required Entities:** At least 2 Beams or TrussEntities (typically intersecting).
- **Minimum Beams:** 2 (One "female" support beam and one or more "male" intersecting beams).
- **Required Settings:** The script usually requires a "HANGER" map structure injected by a parent script (e.g., `hsb_Hanger.mcr`) or valid IFC import data to function correctly.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_HangerDisplay.mcr`
*(Note: This script is typically launched automatically by a parent script, but can be run manually if data is pre-configured).*

### Step 2: Select Male Beams
```
Command Line: Select male beams
Action: Click on the beams that are resting on or intersecting the main support beam. Press Enter when finished.
```

### Step 3: Select Female Beam
```
Command Line: Select female beam
Action: Click on the main beam that supports the hanger.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Model | dropdown | (From Map) | Selects the specific hanger part number or configuration (geometry and BOM data). |
| Dim Style | dropdown | Current Style | Sets the dimension style used for the hanger's visual labels. |
| Display Model | dropdown | Short Model | Controls the text label next to the hanger: "No", "Yes" (Full Name), or "Short Model" (Type only). |
| Draw alt solid | dropdown | No | If "Yes", draws a simplified solid geometry. Useful if the detailed geometry fails to generate. |
| Text Height | number | -1 | Overrides the text height for the label. Set to -1 to use the default style height. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Invert Hanger | Flips the orientation of the hanger 180 degrees. Use this if the plate is facing the wrong direction relative to the beam. |

## Settings Files
- **Dependency**: `hsb_Hanger.mcr` (Parent Script)
- **Location**: TSL Catalog
- **Purpose**: This display script typically relies on the parent script `hsb_Hanger.mcr` to calculate the connection details and inject the "HANGER" map (containing geometry and product data) into this script. It does not usually use a standalone XML configuration file.

## Tips
- **Manual Insertion:** If inserting manually, ensure the "HANGER" map data exists or the script may erase itself immediately.
- **Geometry Issues:** If the hanger looks incorrect or missing, try setting **Draw alt solid** to "Yes" in the properties to force a simplified representation.
- **Text Visibility:** Set **Display Model** to "Short Model" to keep the drawing clean while still identifying the part type.

## FAQ
- **Q: Why does the script disappear immediately after I select the beams?**
  **A:** The script requires specific configuration data (a "HANGER" map) to generate the geometry. If run manually without this data (usually provided by a parent script), it will automatically erase itself.
- **Q: How do I change the hanger size or type?**
  **A:** Select the hanger in the model, open the Properties palette (Ctrl+1), and change the **Model** dropdown to a different part number.
- **Q: The text label is too large/small. How do I fix it?**
  **A:** Change the **Text Height** property to a specific value (in mm) or ensure it is set to -1 to respect your current CAD text style settings.
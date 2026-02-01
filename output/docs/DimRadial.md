# DimRadial.mcr

## Overview
This script automates the creation of radial, diametric, and arc length dimensions for curved timber contours, drill holes, and mortises within hsbCAD shop drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed for detailing views. |
| Paper Space | Yes | Intended for use in Shop Drawing layouts. |
| Shop Drawing | Yes | Requires an active ShopDrawView or MultiPageView. |

## Prerequisites
- **Required Entities**: Curved GenBeams, Elements with round drill holes, or Mortises.
- **Minimum Beam Count**: 0 (Can annotate a single element or void).
- **Required Settings Files**: 
  - `TslUtilities.dll` (for dialogs).
  - hsbCAD DimStyle definitions (must exist in the project).

## Usage Steps

### Step 1: Launch Script
```
Command: TSLINSERT
Action: Browse and select DimRadial.mcr
```

### Step 2: Select Location or Entity
```
Command Line: Select Entity or [Position]:
Action: Click on the curved beam, drill hole, or mortise you wish to dimension in the drawing view.
```
*Note: The script will automatically detect arcs or circles based on the active filter settings.*

### Step 3: Adjust Settings (Optional)
```
Action: Select the inserted script instance. Open the Properties palette (Ctrl+1) to change the dimension mode (Radius/Diameter) or filter type if the wrong curve was detected.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| nDimMode | Index | 0 | Selects the dimension type: 0=Radial, 1=Diametric, 2=Automatic, 3=Arc Length. |
| sToolTypeFilter | String | _kContour | Filters what to measure (e.g., Beam Contour, Openings, Drills, Mortises). |
| sDimStyle | String | System Default | Selects the visual style (color, text size, arrows) from the hsbCAD DimStyle catalog. |
| bConvex | Boolean | True | Toggles between measuring the Outer (Convex) or Inner (Concave) radius of a curve. |
| dLeaderLength | Double | 0 | Sets the length of the leader line pulling text away from the curve (0 = disabled). |
| nPainterManagementMode | Index | 0 | Controls how automatic painter/visibility filters are handled. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Painter Management | Opens a dialog to configure how the script applies "Painter" filters (visibility settings) to automatic dimensions. |
| Import Settings | Loads configuration settings from a `DimRadial.xml` file. Useful for applying company standards quickly. |
| Export Settings | Saves the current configuration settings to a `DimRadial.xml` file to share with other users or projects. |

## Settings Files
- **Filename**: `DimRadial.xml`
- **Location**: `..\Tsl\DimRadial\` (Company or Project path)
- **Purpose**: Stores script properties (DimMode, Filters, etc.) so they can be reused or imported into other drawings.

## Tips
- **Drill Holes**: If the script dimensions the beam edge instead of a drill hole, change the **sToolTypeFilter** property to the specific Drill type (e.g., `_kADPerpendicular`).
- **Switching Types**: You can instantly switch a Radius dimension to a Diameter by changing the **nDimMode** property in the Properties palette; no need to delete and re-insert.
- **Cluttered Views**: Use the **Painter Management** option to ensure dimensions only appear in specific drawing views or scales.

## FAQ
- **Q: Why does the dimension not appear after insertion?**
  - **A:** Ensure you are in a Shop Drawing view (Paper Space) and that the selected entity actually contains a circular or radial arc. Check the **sToolTypeFilter** to ensure it matches the geometry you clicked.
- **Q: How do I dimension the inside of a curved beam?**
  - **A:** Select the dimension and toggle the **bConvex** property to `False`.
- **Q: Can I use this for arc lengths?**
  - **A:** Yes. Set **nDimMode** to `3` (Arc Length) to display the measured length along the curve.
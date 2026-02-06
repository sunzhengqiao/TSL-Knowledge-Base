# TrussVWebPlate

## Overview

TrussVWebPlate visualizes metal web members for ITW SpaceJoist open-web truss systems. It renders V-shaped or diagonal web profiles as 3D solid bodies based on polyline paths passed through the Map system. This script supports both standard V-web configurations and GangNail alternate web patterns. Like TrussNailPlate, it is automatically inserted by parent truss manufacturing scripts.

## Usage Environment

| Environment | Supported |
|------------|-----------|
| **Model Space** | Yes (3D visualization of web members) |
| **Paper Space** | No |
| **Script Type** | Object (Type O) - Passive visualization entity |
| **Automatic Insertion** | Yes (created by truss analysis scripts) |

## Prerequisites

- Parent truss script must pass web geometry through Map system
- Required Map parameters:
  - `POINTS3D` - Polyline defining web profile path (Point3dPLine)
  - `Label` - Web type identifier
  - Y-axis vectors (`YV_X`, `YV_Y`, `YV_Z`) or CoordSys object
  - Optional: `vecZOffset` - Offset distance for double webs
  - Optional: `AlternateWeb` - Flag for single-sided web rendering

## Usage Steps

This script is **not manually inserted** by users. Automatic workflow:

1. **Truss Analysis**: Parent script analyzes truss geometry and determines web member locations
2. **Path Generation**: Parent creates polyline path defining web centerline
3. **Parameter Passing**: Map receives path geometry, orientation vectors, and web specifications
4. **Extrusion**: TrussVWebPlate extrudes the polyline path into 3D web body
5. **Display**: Web member appears in color 8 (gray) with 2mm default thickness

### Web Configurations

- **Standard Double Web**: Two webs offset symmetrically (default, when `AlternateWeb = 0`)
- **Alternate Web** (GangNail): Single web on one side only (when `AlternateWeb = 1`)
- **Centered Web**: Single web at insertion point (when `vecZOffset = 0`)

## Properties Panel Parameters

| Property | Type | Description | Read-Only |
|----------|------|-------------|-----------|
| **Web Type** | String | Web member identification label (e.g., "V-Web 200", "Diagonal") | Yes |

All other geometric parameters are defined internally through the Map system and are not exposed as user properties.

## Right-Click Menu

No custom right-click menu commands available.

## Settings Files

No external XML settings files. All configuration is passed dynamically from parent truss scripts.

## Tips

- **Debug Output**: The script writes console messages showing `AlternateWeb` value, Z-vector, and point count. Check the AutoCAD command line during truss generation for diagnostics
- **Thickness**: Web thickness is fixed at 2mm. This represents the thickness of the metal web profile after extrusion
- **Visualization Color**: Webs use `.vis(3)` display mode (color 3) during rendering
- **Path Complexity**: The polyline path (`POINTS3D`) can have any number of vertices to represent complex web geometries
- **Coordinate System Detection**: Script automatically detects legacy vector format vs. new CoordSys-based Map structure

## FAQ

### Why is my web member not displaying?

Check the following:
- Verify the polyline path (`POINTS3D`) exists in the Map and contains valid points
- Ensure Y-axis vectors or CoordSys are properly defined
- Check console messages for the number of points - if 0, the path was not passed correctly

### What does "AlternateWeb" mean?

AlternateWeb is used in GangNail truss systems where some web members are placed on alternating sides of the truss rather than symmetrically. When `AlternateWeb = 1`, only one web is drawn instead of a mirrored pair.

### Can I modify the web path after insertion?

No. The web geometry is defined by the parent truss script. To modify web paths, adjust the truss geometry or web layout in the parent script.

### What is the difference between this and TrussNailPlate?

- **TrussVWebPlate**: Renders diagonal/V-shaped web members (the internal structural members of open-web trusses)
- **TrussNailPlate**: Renders rectangular connector plates at joints

Both work together to visualize complete truss assemblies.

### How is the web thickness determined?

Web thickness is fixed at 2mm in the current version. This is adequate for visualization. For structural analysis, refer to the parent truss script's engineering specifications.

### Why do I see console messages during truss generation?

The script includes a `reportMessage()` call (line 68) that outputs diagnostic information:
```
AlternateWeb [value] VecZ [vector] NumPoints [count]
```
This helps developers verify correct parameter passing. It can be safely ignored during normal use.

### Can I use this for non-SpaceJoist web members?

While designed for ITW SpaceJoist systems, the script can technically render any web geometry if the correct Map parameters are provided. However, it's specifically optimized for V-web truss patterns.

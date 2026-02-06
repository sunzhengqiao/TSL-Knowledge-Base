# hsbCLT-Electra

## Overview
This script creates 3D machining for electrical installations (such as sockets, switches, and junction boxes) and vertical wire chases on CLT panels. It automatically links hardware components for BOM lists and generates 2D annotations for production drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in Model Space on 3D panels. |
| Paper Space | No | Not applicable for layout views directly. |
| Shop Drawing | No | Not a shop drawing generation script. |

## Prerequisites
- **Required Entities**: A single `GenBeam` or `Element` (CLT Wall/Floor) must exist in the model.
- **Minimum Beam Count**: 1
- **Required Settings**:
    - Catalog entries containing predefined electrical installation types (e.g., "Socket 1x", "Wirechase").
    - Submap `Hsb_Tag` must exist for tagging functionality.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-Electra.mcr` from the list.

### Step 2: Select Panel
```
Command Line: Select element/beam:
Action: Click on the CLT panel (GenBeam or Element) where you want to add the installation.
```

### Step 3: Select Type
```
Command Line: [Dialog Box Appears]
Action: Select a Catalog Entry (e.g., "Socket Round", "Socket Rect", "Wirechase") from the list and click OK.
```

### Step 4: Specify Insertion Point
```
Command Line: Specify insertion point:
Action: Click on the face of the panel in Top View or 3D View to place the center of the socket.
```

### Step 5: Specify Elevation
```
Command Line: Elevation <1050>:
Action: Type the vertical height (e.g., 1050) from the bottom of the panel and press Enter, or click a point in a Front/Elevation view.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sShape | Dropdown | Circle | Shape of the cutout: Circle, Rectangle, or Square. |
| nQty | Number | 1 | Quantity of sockets (1-10). Set to **0 or negative** to enable **Wirechase** mode. |
| dDiameter | Number | 68.0 | Diameter of round sockets OR Width of rectangular sockets. |
| dDepth | Number | 40.0 | Depth of the cutout into the panel material. |
| dOffsetInstallation | Number | 100.0 | Center-to-center distance between multiple grouped sockets (used when nQty > 1). |
| dElevation | Number | 1050.0 | Vertical height of the installation center from the floor level. |
| sFormat | String | <EL> | Format for the 2D label tag (e.g., `<EL>`, `<Type>`, `<Qty>`). |
| dXOffset | Number | 0.0 | Horizontal shift of the installation along the panel width. |
| dXBc / dYBc / dZBc | Number | 100 / 50 / 60 | Dimensions for Wirechase mode (Width, Height, Depth). Only active when nQty <= 0. |
| dRotZ | Number | 0.0 | Rotation angle of the installation on the panel surface. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Catalog Entries | Opens a dialog to switch the installation to a different preset configuration (e.g., changing from a single socket to a double socket). |
| Edit in place | Enables special "Edit in place" grips for advanced stretching/modification of the geometry. |
| Disable edit in place | Disables the advanced editing grips. |

## Settings Files
- **Filename**: Catalog (specific name depends on company configuration, usually associated with Hsb catalogs).
- **Location**: Company Standard or hsbCAD Install directory.
- **Purpose**: Provides predefined dimensions and names for standard electrical boxes and wire chases.

## Tips
- **Wirechase Mode**: To create a vertical wire chase instead of a socket, change the `nQty` property to `0`. The script will then use the `dXBc`, `dYBc`, and `dZBc` parameters for dimensions.
- **Multi-Gang Sockets**: Set `nQty` greater than 1 to create a combined cutout for multiple sockets (e.g., 2 or 3-gang switches). Adjust `dOffsetInstallation` to control the spacing.
- **Editing**: You can drag the central grip (Blue square) to move the installation across the panel surface or change its elevation.
- **Rectangular Sockets**: Ensure `sShape` is set to "Rectangle" if your catalog entry implies a junction box rather than a round flush-mount socket.

## FAQ
- **Q: How do I create a wire chase?
- **A:** Select the "Wirechase" entry from the catalog during insertion, or manually set the `nQty` property to `0` in the Properties Palette.
- **Q: The cutout is in the wrong spot on the panel.
- **A:** Select the script instance in the model. Drag the central grip (Square handle) to move it, or adjust `dElevation` and `dXOffset` in the properties.
- **Q: Can I rotate the socket?
- **A:** Yes, use the `dRotZ` property in the Properties Palette to rotate the cutout.
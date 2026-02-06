# Dimline.mcr

## Overview
Automated dimensioning tool for timber construction that creates linear dimensions for beams, panels, sheets, openings, and machining tools in both ModelSpace and PaperSpace viewports.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Dimensions 3D model entities directly. |
| Paper Space | Yes | Supports dimensioning inside viewports; points outside the viewport are ignored. |
| Shop Drawing | Yes | Suitable for detailing production drawings. |

## Prerequisites
- **Required Entities**: GenBeam, Element, Opening, Polyline, MetalPartCollectionEnt, CollectionEntity, TrussEntity, BlockRef, Sheet, Panel.
- **Minimum Beam Count**: 0 (Can dimension sheets, panels, and other entities without beams).
- **Required Settings Files**: `TslUtilities.dll` located in `_kPathHsbInstall + \Utilities\DialogService\`.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Dimline.mcr`

### Step 2: Select Viewport (If in Paper Space)
```
Command Line: Select viewport
Action: Click inside the viewport where you want to place the dimension.
```
*Note: This step is skipped if you are currently in Model Space.*

### Step 3: Select Entities
```
Command Line: Select entities
Action: Click on the beams, panels, sheets, or other elements you wish to dimension. Press Enter to confirm selection.
```

### Step 4: Define Alignment and Position
```
Command Line: Set position
Action: Move your cursor to position the dimension line. The script will automatically calculate dimension points based on the selected geometry. Click to place the dimension.
```
*Tip: You can often move the cursor orthogonally to switch between horizontal and vertical dimensioning.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Beam | dropdown | Any view | Determines which beams are dimensioned based on their orientation relative to the current view (e.g., only beams seen from the side). |
| Sheet | dropdown | Any view | Determines which sheeting materials (e.g., CLT) are dimensioned based on orientation. |
| Panel | dropdown | Any view | Determines which structural panels (walls/floors) are dimensioned based on orientation. |
| MetalPart | dropdown | Any view | Determines which metal plates and hardware are dimensioned based on orientation. |
| Group Assignment | dropdown | <Default> | Controls the layer management of the dimension instance. <Default> groups it with the dimensioned entities; "No group assignment" keeps it independent. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Realign Dimension | Re-positions the dimension line relative to the geometry using a Jig interaction. |
| Copy Dimension | Creates a copy of the current dimension instance at a new location. |
| Add Points | Allows manual selection of specific points to include in the dimension. |
| Remove Points | Removes specific points from the existing dimension. |
| Global Settings | Opens a dialog to configure drill visibility and default group assignments. |

## Settings Files
- **Filename**: `TslUtilities.dll`
- **Location**: `hsbCAD Install Folder\Utilities\DialogService\`
- **Purpose**: Provides the user interface dialogs for selecting configuration options (like drill visibility and group settings).

## Tips
- **Filtering by View Direction**: Use the "Perpendicular to View Direction" setting in the Properties Panel to avoid dimensioning the ends of beams (cross-sections) and only dimension the lengths.
- **Drill Visibility**: Access "Global Settings" from the right-click menu to configure specific visibility for machining tools (drills/cuts) if they are not appearing automatically.
- **Paper Space Clipping**: When working in Paper Space, ensure your dimension points fall clearly within the viewport boundaries; points outside are automatically ignored.

## FAQ
- **Q: Why are some of my beams not being dimensioned?**
  **A:** Check the "Beam", "Sheet", or "Panel" properties in the palette. If set to "Perpendicular to View Direction", beams that are end-on to your view will be excluded.
- **Q: Can I dimension specific machining tools like drills?**
  **A:** Yes. Use the "Global Settings" option in the right-click menu to adjust drill visibility filters.
- **Q: Can I add a point to an existing dimension?**
  **A:** Yes. Select the dimension, right-click, and choose "Add Points". You can then select geometry or snap to points to append them to the dimension.
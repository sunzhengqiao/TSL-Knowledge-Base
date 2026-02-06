# hsbSlottedPlate.mcr

## Overview
This script generates a custom-shaped steel slotted connecting plate that joins a main beam to one or more secondary beams. The plate dimensions and shape are automatically calculated based on drill pattern configurations and user-defined parameters.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Operates strictly in 3D Model Space to create geometry. |
| Paper Space | No | Not designed for 2D layout or detailing views. |
| Shop Drawing | No | Generates physical 3D bodies and tools, not drawing annotations. |

## Prerequisites
- **Required Entities**: At least one Main Beam and one Secondary Beam.
- **Minimum Beam Count**: 2 beams total.
- **Required Settings**: The `hsbDrillPattern.mcr` script must be loaded and available in the current drawing.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or hsbCAD specific insert command) → Select `hsbSlottedPlate.mcr` from the list.

### Step 2: Select Main Beam
```
Command Line: Select main beam:
Action: Click on the primary timber beam that will host the main connection point.
```

### Step 3: Select Secondary Beams
```
Command Line: Select secondary beams:
Action: Click on the connecting timber beams. Press Enter to finish selection.
Note: You must select at least one secondary beam.
```

### Step 4: Configure Drill Pattern
```
Action: A dialog box will appear to configure the drill pattern (via the hsbDrillPattern script).
Action: Set the bolt layout, spacing, and dimensions as required.
Action: Confirm the dialog settings.
```

### Step 5: Insertion Complete
```
Action: The script calculates the geometry, generates the steel plate body, applies slots to the beams, and inserts the connection into the model.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| dThickness | Number | 6 mm | The physical thickness of the steel plate. |
| dExtraDiam | Number | 2 mm | The additional clearance added to fastener diameters for the plate holes. |
| dYSlot | Number | 8 mm | The width of the slot cut into the secondary beams. |
| dZOffset | Number | 0 mm | The vertical shift of the plate relative to the beam axis. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add Drill Pattern | Prompts you to select existing drill pattern instances in the drawing to add them to the current plate configuration. |
| Add Contour | Prompts you to select Polylines to add their shape to the plate volume (Union). If a selected polyline was previously subtracting volume, it will be moved to the additive list. |
| Subtract Contour | Prompts you to select Polylines to cut their shape out of the plate volume (Subtraction). |

## Settings Files
- **Dependency**: `hsbDrillPattern.mcr`
- **Location**: hsbCAD TSL directory (Standard Install or Company Folder).
- **Purpose**: Provides the logic for creating and managing the bolt/drill patterns that drive the plate geometry.

## Tips
- **Check Dependencies**: If the script deletes itself immediately upon insertion, check that `hsbDrillPattern.mcr` is loaded in the drawing.
- **Complex Shapes**: Use the "Add Contour" or "Subtract Contour" right-click options to modify the plate shape with polylines for custom geometries not covered by standard drill patterns.
- **Beam Order**: Ensure you select the main beam first during the insertion phase, as the script relies on array positioning to determine which beam controls the primary reference plane.

## FAQ
- **Q: Why did the script disappear after I selected the beams?**
  A: This usually happens if fewer than 2 beams were selected or if the required `hsbDrillPattern.mcr` script could not be found. Ensure you have at least one main and one secondary beam selected and the dependency script is loaded.
- **Q: How can I make the holes in the plate larger?**
  A: Select the generated plate in the model and open the Properties Palette. Increase the `dExtraDiam` value to add more clearance around the bolts.
- **Q: Can I change the plate shape after insertion?**
  A: Yes. You can modify the drill pattern properties or use the Right-Click "Add Contour" / "Subtract Contour" options to modify the plate profile using polylines.
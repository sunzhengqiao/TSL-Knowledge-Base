# hsbSchlitzblech.mcr

## Overview
Generates a custom steel connection plate (slotted gusset plate) that sits between a main joist and connecting beams. It automates the creation of the 3D plate body, drill holes, and slots in the timber based on selected drill patterns and user-defined contours.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script generates 3D bodies and machining in the model. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This is a model generation script. |

## Prerequisites
- **Required Entities**: 
  - At least two GenBeams (one main joist and one or more secondary beams).
  - The child script `hsbDrillPattern` must be loaded in the drawing.
- **Minimum Beam Count**: 2 (1 Main + 1 Secondary).
- **Required Settings**: 
  - A catalog entry named `|_LastInserted|` must exist in your hsbCAD environment.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbSchlitzblech.mcr`

### Step 2: Select Main Joist
```
Command Line: Select main joist
Action: Click on the primary timber beam that will hold the steel plate.
```

### Step 3: Select Secondary Beams
```
Command Line: Select secondary Beam(s)
Action: Click on all connecting beams that intersect the main joist. Press Enter to finish selection.
```

### Step 4: Configure Drill Pattern
```
Action: The script automatically launches the 'hsbDrillPattern' dialog.
Action: Adjust the hole settings (diameter, spacing, etc.) for the connection and click OK.
```
*Note: The steel plate is now generated based on these patterns.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Thickness Steelplate** (t) | Number | 6 mm | Specifies the material thickness of the steel plate. |
| **Additional Diameter Drills** (E) | Number | 2 mm | The clearance added to the drill holes (Drill Diameter = Fastener Diameter + E). |
| **Slot Width** (T) | Number | 8 mm | Defines the width of the slot cut into the timber beams. |
| **Z-Offset from Axis** (dZ) | Number | 0 mm | Moves the plate vertically (up or down) relative to the beam axis. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Add Drill Pattern** | Allows you to select existing drill pattern instances in the model to be included in this plate. |
| **Add Contour** | Adds custom shape to the plate. You can select existing polylines or manually draw points to define a new contour for the steel plate. |

## Settings Files
- **Catalog Entry**: `|_LastInserted|`
- **Purpose**: Stores the default settings used when creating temporary drill pattern instances during insertion.

## Tips
- **Adjusting Vertical Position**: Use the **Z-Offset** property in the Properties Palette to move the plate up or down after insertion without deleting it.
- **Custom Shapes**: If the default rectangular plate isn't sufficient, use the **Add Contour** right-click option. You can pick existing polylines or draw points to create complex plate shapes (e.g., notched plates).
- **Hole Sizes**: To change hole sizes without re-inserting, modify the **Additional Diameter Drills** property. This adds clearance to the existing hole patterns.
- **Troubleshooting**: If the script disappears immediately after insertion, ensure the `hsbDrillPattern` script is loaded in the drawing.

## FAQ
- **Q: Why did the script delete itself after I selected the beams?**
  - A: This usually happens if the required child script `hsbDrillPattern` is missing or if the catalog entry `|_LastInserted|` cannot be found. Ensure these are available in your project.
- **Q: Can I add more holes after the plate is created?**
  - A: Yes. Use the **Add Drill Pattern** option in the right-click context menu to select additional existing patterns.
- **Q: How do I make the plate wider or taller?**
  - A: The plate size is driven by the drill patterns and contours. You can add a contour via the right-click menu to extend the plate boundaries, or adjust the drill pattern settings.
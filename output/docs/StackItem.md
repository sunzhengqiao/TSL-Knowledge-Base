# StackItem.mcr

## Overview
Creates a virtual container (pack) to group construction elements like beams, panels, and walls for logistics, truck loading, and site delivery organization. It allows you to visualize and manage how items are stacked and transported without modifying the structural model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used for 3D logistics planning and placement. |
| Paper Space | No | Not intended for 2D annotation. |
| Shop Drawing | No | While it can be hidden in shop drawings, the script operates in the 3D model. |

## Prerequisites
- **Required Entities**: GenBeam, Beam, Sheet, Panel, Element, Wall, RoofFloor, or MetalPart.
- **Minimum Beam Count**: 0 (Can represent a single item or a group).
- **Required Settings**: `TslUtilities.dll` (must be present in hsbCAD installation path).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `StackItem.mcr` from the catalog.

### Step 2: Set Origin and Orientation
```
Command Line: |Select origin point [Vertical/Horizontal]|
Action: Click in the model to set the base point, or type a keyword:
- Type "Vertical" to align the item upright.
- Type "Horizontal" to lay the item flat.
```

### Step 3: Select Content
```
Command Line: (Dialog appears)
Action: A selection dialog opens.
1. Check the boxes for the entity types you wish to include (e.g., "Beam", "Panel").
2. Select the specific objects in the drawing that belong in this stack.
3. Confirm the selection.
```

### Step 4: Place Item
```
Command Line: |Pick point to place item|
Action: Click the final location in the model where the stack item should be positioned.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Name | Text | "" | User-defined name for the stack (e.g., "Pack A", "Floor 1 Walls"). |
| Visible | Dropdown | Yes | Controls visibility of the stack in the 3D model (Yes/No). |
| Item Mode | Dropdown | Edit | Controls behavior in drawings. Select "Hide in Shopdrawing" to keep logistics data out of production layouts. |
| Show 3D Bodies | Dropdown | No | If "No", shows a simplified representation for performance. If "Yes", renders the full geometry of the contents. |
| Filter | Text | "" | Excludes items from the stack based on this name/text filter. |
| Spacer Height | Number | 0 | Physical thickness of spacers (sticks) between layers in mm. Used for calculating total stack height. |
| Projection Display | Dropdown | None | Displays bounding box outlines (Top, Bottom, Front, etc.) to visualize the footprint and volume. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Face | Rotates the item 180 degrees around the X-axis (top becomes bottom). |
| Rotate 90° | Rotates the item 90 degrees around the Z-axis. |
| Rotate 180° | Rotates the item 180 degrees around the Z-axis. |
| Flip + Rotate | Combines a Flip Face and 180° rotation. |
| Rotate Item | Opens an advanced rotation jig with the following sub-options:<br>- **Angle**: Enter a specific degree value.<br>- **Basepoint**: Pick a new pivot point for rotation.<br>- **ReferenceLine**: Align the item to a selected line in the model. |

## Settings Files
- **Filename**: `TslUtilities.dll`
- **Location**: `_kPathHsbInstall` (hsbCAD installation directory)
- **Purpose**: Provides the selection dialog interface and interaction services.

## Tips
- **Truck Loading**: Use the *Spacer Height* property to account for wooden dunnage between layers. This ensures your calculated stack height matches real-world truck dimensions.
- **Clean Drawings**: Set *Item Mode* to "Hide in Shopdrawing". This keeps your logistics organization visible in the 3D model but prevents it from cluttering your 2D production plans.
- **Visualization**: Toggle *Projection Display* to "All" to see exactly how much volume the pack occupies. This is useful for checking if items will fit through doors or in specific transport bays.
- **Grip Editing**: You can drag the StackItem using its grip point. If you drop it onto a `StackPack`, it may automatically snap into the parent container.

## FAQ
- **Q: How do I prevent specific small parts (like metal plates) from appearing in my stack?**
  A: Use the **Filter** property in the Properties Palette. Enter the name or property of the items you want to exclude, and they will be filtered out of the stack representation.
  
- **Q: Can I align the stack exactly with a wall or other line?**
  A: Yes. Right-click the stack, select **Rotate Item**, and choose the **ReferenceLine** option. Then select two points on the line you want to align with.

- **Q: Why is my stack visible in the model but not in the layouts?**
  A: Check the **Item Mode** property. It is likely set to "Hide in Shopdrawing". Change it to "Edit" if you need it to appear in the layout.
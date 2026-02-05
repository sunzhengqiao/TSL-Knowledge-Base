# MasterPanelStorage

## Overview
This script creates a logical storage or freight container in the 3D model to group, stack, and visualize master panels for transport planning. It automates the vertical arrangement of panels, calculates package dimensions/weights, and displays labeling information.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script inserts at a 3D point and manipulates entities in the model. |
| Paper Space | No | Not designed for 2D layout or detailing. |
| Shop Drawing | No | This script organizes data in the model; other scripts use this data for drawings. |

## Prerequisites
- **Required entities**: None to insert the script, but you typically need existing Master Panel entities to add to the storage.
- **Minimum beam count**: 0
- **Required settings files**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `MasterPanelStorage.mcr` from the list.

### Step 2: Configure Initial Properties (Optional)
A "Properties" dialog may appear automatically upon insertion. You can accept the defaults or set the **Storage ID** and **Batten Height** now. You can also change these later via the Properties Palette.

### Step 3: Place Storage Unit
```
Command Line: Specify insertion point:
Action: Click in the Model Space to define the bottom-center origin (0,0,0) of your storage stack.
```

### Step 4: Add Panels
```
Action: Double-click the Storage Unit or Right-click and select "Add Item".
Command Line: Select entities:
Action: Select the master panels you want to include in this stack.
Result: The selected panels will move to align with the storage unit's origin and stack vertically.
```

### Step 5: Stack Panels (Optional)
```
Action: Right-click the Storage Unit and select "Stack Items".
Result: The script will automatically sort panels by height and move them up to resolve overlaps, adding the specified Batten Height between layers.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sStorageID | text | 001 | A unique identifier label for the storage stack (e.g., "PAL-001"). |
| sFormat | text | @(Number) | Defines how properties are displayed in the text label (e.g., "Storage: @(StorageID)"). |
| nSolidColor | number | 7 | The color of the 3D visualization bodies (AutoCAD Color Index 0-255). |
| dBattenHeight | number | 0 | The thickness of spacer battens placed between layers of stacked panels (in mm). |
| sStackMode | dropdown | Disabled | Controls stacking behavior: **Disabled** (manual placement), **Only Once** (stacks immediately then stops), **Always** (maintains stacking on every update). |
| nColor | number | 7 | The color of the annotation text (AutoCAD Color Index 0-255). |
| dTextHeight | number | 300 | The height of the text label (in mm). Set to 0 to use the DimStyle default. |
| sDimStyle | dropdown | <current> | The dimension style used to determine font and text height properties. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add Item | Prompts you to select entities. It moves them to the storage origin and stacks them on top of the current content. (Can also be triggered by Double-Click). |
| Remove Item | Prompts you to select entities and a new location point. It removes the entities from the storage stack and moves them to the chosen location. |
| Stack Items | Forces the script to perform a vertical stacking calculation immediately (setting mode to "Only Once" for this operation). |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external settings files; all configuration is handled via the Properties Palette.

## Tips
- **Quick Access**: Simply double-click the storage origin point to open the "Add Item" selection prompt.
- **Dynamic Stacking**: If you are editing the package frequently, set **Stack Mode** to "Always". This ensures panels automatically rearrange vertically if you move them horizontally.
- **Visualization**: Use the **nSolidColor** property to make the freight stack stand out from other model elements (e.g., set to a specific color for shipping visualization).

## FAQ
- **Q: Why did my panels disappear?**
  - A: Check if they were moved to a high Z-coordinate. If the **Stack Mode** is active, the script may have stacked them very high based on overlapping geometry. Try "Remove Item" to extract them, or reset the Stack Mode to "Disabled".
  
- **Q: How do I account for packaging wood between panels?**
  - A: Set the **Batten Height** property to the thickness of your packing strips (e.g., 50mm) before running the "Stack Items" command.

- **Q: Can I change the ID label later?**
  - A: Yes. Select the storage script, open the Properties Palette (Ctrl+1), and edit the **Storage ID** field. The text label in the model will update automatically.
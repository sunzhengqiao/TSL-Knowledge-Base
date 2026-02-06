# hsbMetalPlate.mcr

## Overview
This script creates and inserts standardized metal connection plates (splines) at the intersections of 2 or 3 timber beams. It automatically generates the 3D geometry of the plate and adds the hardware data to the Bill of Materials (BOM).

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model to create physical connections. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | The geometry is created in the model, not directly on drawings. |

## Prerequisites
- **Required Entities**: GenBeams (Timber beams).
- **Minimum Beam Count**: 2 (or 3, depending on the Type setting).
- **Required Settings**: `MetalPlateCatalog.xml` must exist in the company or install settings folder.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbMetalPlate.mcr`

### Step 2: Select Beams
```
Command Line: Select Genbeams
Action: Select the timber beams you wish to connect (e.g., select 2 beams for a corner joint or 3 for a T-junction). Press Enter to confirm selection.
```

### Step 3: Place Plate
```
Action: Move your cursor over the intersection of the selected beams.
- The script will highlight valid intersection points dynamically.
- Click once to select the specific intersection point where you want the plate placed.
```

### Step 4: Adjust Properties
```
Action: With the plate selected, open the Properties Palette (Ctrl+1).
- Select the **Manufacturer** (e.g., Simpson, Meko).
- Select the **Family** and **Product** (this sets the physical size of the plate).
- Adjust alignment (Face, Side) or offsets if needed.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Manufacturer | dropdown | --- | Selects the plate manufacturer. Updates the available families. |
| Family | dropdown/text | | Selects the product series (updates available products). |
| Product | dropdown/text | | Selects the specific plate model. Determines geometry size and thickness. |
| Mode | dropdown | Single | Choose between inserting at one intersection (`Single`) or all found valid intersections (`Multiple`). |
| Face | dropdown | View Direction | Sets the orientation relative to your current view (View Direction, Normal to View, All). |
| Side | dropdown | One | Sets whether to insert one plate (`One`) or two plates sandwiching the joint (`Both`). |
| Type | dropdown | 2 Genbeams | Defines the joint topology: connection of 2 beams or 3 beams. |
| Offset Length | number | 0 | Shifts the plate along its length axis relative to the joint center. |
| Offset Width | number | 0 | Shifts the plate along its width axis relative to the joint center. |
| Rotate | number | 0 | Rotates the plate on the plane (degrees). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Swap Side | Flips the metal plate to the opposite side of the joint. |

## Settings Files
- **Filename**: `MetalPlateCatalog.xml`
- **Location**: `_kPathHsbCompany\TSL\Settings` or `_kPathHsbInstall\Content\General\TSL\Settings`
- **Purpose**: Defines the library of available metal plates, including dimensions, thicknesses, and manufacturer details.

## Tips
- **Dynamic Updates**: After insertion, you can change the Product in the properties palette to resize the plate without deleting and re-running the script.
- **Fine-tuning**: Use the Offset Length and Offset Width properties to slide the plate into the exact position without moving the script itself.
- **Visual Confirmation**: If the plate appears on the "back" side of the beam, use the **Swap Side** right-click option to flip it to the front.
- **Catalog Management**: If the Manufacturer dropdown is empty, check your `MetalPlateCatalog.xml` file location.

## FAQ
- **Q: Why did the script delete itself immediately after I selected the beams?**
  A: This usually happens if the `MetalPlateCatalog.xml` file is missing or cannot be found. Ensure the settings file is in the correct directory.
- **Q: Can I use this for non-standard intersection angles?**
  A: Yes, the script calculates the intersection plane based on the actual geometry of the selected beams, but you may need to use the Rotate property to align specific plate shapes.
- **Q: How do I insert a plate on both sides of the beams automatically?**
  A: Set the **Side** property to `Both` in the Properties Palette before or after insertion.
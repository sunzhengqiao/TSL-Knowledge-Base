# TaperedInsulation.mcr

## Overview
This script generates 3D solid geometry representing tapered or flat insulation layers on roofs or floors. It allows for the creation of drainage slopes (falls), height restrictions, and material labeling for thermal modeling and detailing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script creates 3D Body objects and interacts with 3D entities like Slabs. |
| Paper Space | No | This script does not generate 2D drawings directly in Paper Space. |
| Shop Drawing | No | Not intended for shop drawing generation. |

## Prerequisites
- **Required Entities**: A Slab or TslInst (e.g., RUB-Raum) is required if using the "Align To Entity" feature.
- **Minimum Beam Count**: 0 (This script does not require beams).
- **Required Settings Files**: `TaperedInsulation.xml` (Located in `_kPathHsbCompany\TSL\Settings` or `_kPathHsbInstall\Content\General\TSL\Settings`).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse the script list and select `TaperedInsulation.mcr`.

### Step 2: Insert and Position
```
Command Line: [Insertion point]
Action: Click in the Model Space to place the insulation instance.
```
*Note: Upon insertion, a default rectangular insulation block is created. You can adjust its position and shape immediately using grip points.*

### Step 3: Define Geometry
Action: Use the **Properties Palette** (Ctrl+1) to adjust the insulation type, thickness, and slope. Use **Grips** on the corners to stretch or reshape the insulation outline to match your roof or floor area.

### Step 4: Align to Structure (Optional)
Action: Right-click the insulation instance and select **Align To Entity**.
```
Command Line: Select Entity
Action: Click on the structural Slab or TSL instance you want the insulation to sit on.
```
*Result: The insulation moves and rotates to match the top surface of the selected element.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Type** | Dropdown | Free definition | Defines the generation logic. Options: *Free definition* (constant thickness), *Roof shape*, or *Gradient insulation* (sloped). |
| **Elevation** | Number | 0 | The vertical elevation (Z-height) of the bottom surface of the insulation. |
| **Thickness** | Number | 30 mm | The nominal height/thickness of the insulation at its lowest or starting point. |
| **Slope** | Number | 0 % | The incline of the top surface for drainage, expressed as a percentage. |
| **Slope Grad** | Number | 0 deg | The incline of the top surface expressed in degrees (alternative to %). |
| **Max Height** | Number | 0 mm | A constraint that caps the maximum thickness. If the slope calculation exceeds this height, the volume is cut off horizontally (useful for parapets). |
| **Display Style** | Dropdown | From XML | Determines the visual appearance (color, layer, hatching) based on company standards. |
| **Legend** | Dropdown | No | Toggles the visibility of the text label (Name, Number, Material) in the model. |
| **Number** | Text | - | Unique identifier or index for the insulation piece. |
| **Name** | Text | - | Descriptive name of the material (e.g., 'PIR Board 100mm'). |
| **Material 1** | Text | - | Defines the material composition of the first layer. |
| **Material 2** | Text | - | Defines the material composition of the second layer (if applicable). |
| **Show Hatch** | Boolean | Yes | Toggles the hatching pattern representation of the insulation in views. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Align To Entity** | Prompts you to select a Slab or compatible TSL. The insulation will automatically move and rotate to sit on top of the selected element. |
| **Align Faces** | (Only visible if edges overlap) Modifies the vertical sides of the insulation volume to match the underlying structure's walls or edges. |

## Settings Files
- **Filename**: `TaperedInsulation.xml`
- **Location**: `_kPathHsbCompany\TSL\Settings` (Company overrides) or `_kPathHsbInstall\Content\General\TSL\Settings` (Default).
- **Purpose**: Defines the visual styles (colors, layers, hatch patterns) available in the "Display Style" property dropdown.

## Tips
- **Editing Shape**: Use the grip points on the inserted insulation block to stretch or reshape the outline to fit complex roof perimeters.
- **Creating Falls**: Set **Type** to "Roof shape" or "Gradient insulation" and enter a value in **Slope (%)**. The script will automatically calculate the tapered top surface.
- **Restricting Thickness**: If your slope makes the insulation too thick at the high end, use the **Max Height** property to cut it off flat at the desired level.
- **Data Extraction**: Fill in the **Number**, **Name**, and **Material** fields to create data-rich labels that can be exported to BIM schedules or visible in 3D views if **Legend** is set to "Yes".

## FAQ
- **Q: Why is the "Align Faces" option missing from the right-click menu?**
  A: This option only appears when the insulation outline edges overlap exactly (within a small tolerance) with the edges of the entity beneath it. Ensure your insulation outline is aligned to the underlying slab edges.
- **Q: How do I switch between a flat insulation board and a tapered one?**
  A: Change the **Type** property in the Properties Palette. Select "Free definition" for a flat board, or "Roof shape" for a tapered drainage slope.
- **Q: What happens if I see a version mismatch notice?**
  A: This indicates that the `TaperedInsulation.xml` file in your Company folder differs from the installation default. You generally do not need to fix this, but consult your CAD Manager if default styles are missing.
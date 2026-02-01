# f_Layer

## Overview
This script creates and visualizes a stacking "Layer" of timber panels or elements in the 3D model. It is primarily used for logistics planning, allowing you to simulate how items fit onto a transport truck or pallet, including automatic nesting (arrangement) and collision detection.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model to visualize the stack. |
| Paper Space | No | Does not generate 2D shop drawing views directly. |
| Shop Drawing | No | This is a logistical tool, not a detailing script. |

## Prerequisites
- **Required Entities**: Stackable Items (ChildPanels or other TslInstances).
- **Minimum Beam Count**: 0 (This script handles panels and assemblies, not just beams).
- **Required Settings**: `_kPathHsbCompany\TSL\Settings\f_Stacking.xml` (Required for default truck dimensions and nesting logic).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `f_Layer.mcr` from the list.

### Step 2: Define Location
```
Command Line: Select insert point:
Action: Click in the Model Space to place the layer origin.
```
*(Note: Depending on your hsbCAD configuration, you may be prompted to select the elements to stack immediately after insertion, or you may need to assign them as child entities manually).*

### Step 3: Configure Properties
Select the inserted `f_Layer` entity and open the **Properties Palette** (Ctrl+1).
1.  Under **Nester**, select the **Nester Type** (e.g., "Rectangular Nester") to arrange items.
2.  Under **Bedding**, set the **Height** to simulate the thickness of support battens.
3.  Use the **Nesting** right-click menu option to access spacing and cutout settings.

### Step 4: Align to Truck (Optional)
If you have a truck entity in the model:
1.  Select the Layer entity.
2.  Use the **Grip** (usually the second grip) to snap or align the layer vertically to the truck bed height.

## Properties Panel Parameters

| Parameter | Category | Type | Default | Description |
|-----------|----------|------|---------|-------------|
| **Spacing** | Nesting | Number | 0 | Defines the clearance distance between stacked items in millimeters. (Only visible when Nesting Mode is active). |
| **NestInOpening** | Nesting | Dropdown | No | If "Yes", allows smaller items to be placed inside the cutouts (openings) of larger items. (Only visible when Nesting Mode is active). |
| **Height** | Bedding | Number | 80 | The vertical height (mm) of the bedding material (e.g., battens) placed between layers or the truck floor. |
| **Nester Type** | Nester | Dropdown | Rectangular Nester | Selects the arrangement algorithm: Disabled, Autonester, or Rectangular Nester. |
| **Rotation** | Nester | Dropdown | any angle | Restricts how items can be rotated during nesting (forbidden, 90°, 180°, any angle). |
| **Text** | Information | Text | - | Custom text annotation that appears next to the layer in the model. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Nesting** | Switches the Properties Palette to "Nesting Mode", revealing the **Spacing** and **NestInOpening** parameters. |

## Settings Files
- **Filename**: `f_Stacking.xml`
- **Location**: `_kPathHsbCompany\TSL\Settings\`
- **Purpose**: Stores project-specific defaults such as truck dimensions, maximum loading heights, and specific nesting rules (e.g., contour thickness for different manufacturers like KLH).

## Tips
- **Interference Checking**: The script generates a red hatch pattern where stacked items overlap or collide. Use this to ensure your load is physically stable.
- **Visualizing Gaps**: If items are touching but you need space for straps, right-click the layer and select **Nesting**. Set **Spacing** to 10mm or 20mm, and the stack will update automatically.
- **Truck Alignment**: Link the layer to a truck entity to use the truck's vertical position as a reference. This is done by selecting the layer and using the specific alignment grip or setting the relationship in the project structure.
- **Efficiency**: Use the "Rectangular Nester" for organized, block-style packing, or "Autonester" to try and squeeze more items into the available space.

## FAQ
- **Q: I cannot see the "Spacing" or "NestInOpening" properties in the palette.**
- **A: These are hidden by default. Right-click the `f_Layer` entity in the model and select **Nesting** from the context menu. They will then appear in the Properties Palette.

- **Q: Why is there a red hatched area on my stack?**
- **A: The red hatch indicates a collision or interference between two items in the stack. You need to adjust the position of the items or increase the spacing to resolve the conflict.

- **Q: How do I change the vertical offset of the whole stack?**
- **A: Modify the **Height** property under the **Bedding** category in the Properties Palette. This raises or lowers the stack relative to its insertion point.
# f_Item.mcr

## Overview
This script creates a logistics representation (stackable item) from a structural entity, allowing it to be visualized, labeled, and positioned in a stacking or transport plan. It is typically used to generate truck load plans or package lists by converting structural timber elements into manageable stack items with calculated dimensions and weight.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script operates in the 3D model to generate stacking layouts. |
| Paper Space | No | Not intended for 2D drawing annotations. |
| Shop Drawing | Yes/No | Not a shop drawing generation script (no `sd_` prefix), but uses model data. |

## Prerequisites
- **Required Entities**: At least one structural entity (GenBeam, Element, MassElement, RoofElement, or TslInst) existing in the model.
- **Minimum Beam Count**: 1.
- **Required Settings**: A configuration file named `Stacking Settings` must exist in the Company or Install path.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `f_Item.mcr` from the list.

### Step 2: Select Source Entity
```
Command Line: Select entity, select properties or catalog entry and press OK
Action: Click on a timber element (e.g., a wall panel, floor beam, or roof element) in the model that you want to add to a stack.
```

### Step 3: Position and Orient
Once selected, the script calculates the item's bounding box and generates a visualization.
- The item is aligned to the World XY coordinates.
- Use the **Right-Click Menu** to rotate the item if necessary for the stacking layout.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Source Entity | Entity Reference | *Selected Entity* | The physical timber element linked to this stack item. Changes to this entity trigger automatic updates. |
| Note: Specific rotation parameters are modified via the Context Menu rather than the Properties Palette. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| RecalcKey | Forces the script to recalculate. Use this if the source entity has been modified (e.g., trimmed or stretched) and the stack item needs to update its dimensions. |
| Rotate 90° X-Axis | Rotates the item visualization 90 degrees around the X-axis. Use this to change the item's orientation to fit within truck bed constraints or stacking rules. |

## Settings Files
- **Filename**: `Stacking Settings` (usually `.xml` or `.ini`)
- **Location**: Searches in `kPathHsbCompany` (Company folder) or `kPathHsbInstall` (hsbCAD Installation folder).
- **Purpose**: Provides configuration rules for selection sets, maximum stacking heights, surface quality mappings (colors), and text formatting strings for labels.

## Tips
- **Dense Packing**: Use the "Rotate 90° X-Axis" context menu option frequently to toggle orientations and achieve optimal packing density in your truck load plan.
- **Source Updates**: If you modify a wall or beam in the model, simply use "RecalcKey" on the stack item to update its volume and weight without recreating it.
- **Visibility**: If an item is not visible in a specific layout view, check that the view direction matches the item's orientation relative to the stacking plane.

## FAQ
- **Q: Why does the script fail to create an item for my wall?**
  **A:** This usually happens if the wall is part of an "Element Relation" hierarchy. You cannot stack individual parts of an assembly if the parent or child is already stacked. Try selecting the root element of the assembly instead.
- **Q: Why is my item showing up as a specific color?**
  **A:** The color is determined by the "Surface Quality" mapping in your `Stacking Settings` file. Check the configuration file to see which quality code is assigned to your entity.
- **Q: The text label on my item is mirrored or unreadable.**
  **A:** This can occur depending on the device mode and view vectors. The script includes logic to prevent mirrored text, but if it persists, try using the "RecalcKey" command after changing the view angle.
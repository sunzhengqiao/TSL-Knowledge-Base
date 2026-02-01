# hsb_DrawBlock.mcr

## Overview
This script inserts a predefined AutoCAD block definition as a graphical symbol at a user-selected location in Model Space.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Intended for placement in 3D or 2D model views. |
| Paper Space | No | Not supported for layout sheets. |
| Shop Drawing | No | Not intended for manufacturing views. |

## Prerequisites
- **Required entities**: None
- **Minimum beam count**: 0
- **Required settings files**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_DrawBlock.mcr`

### Step 2: Pick Insertion Point
```
Command Line: Pick a Point
Action: Click anywhere in the Model Space to define where the block should be placed.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Block Name | text | (Empty) | The unique name of the AutoCAD Block definition to draw. Note: This property is Read-Only. |

## Right-Click Menu Options
None available.

## Settings Files
None used.

## Tips
- **Invisible Object**: If you insert the script but do not see any geometry, check that the Block Name specified in the script properties matches a block definition that actually exists in your current drawing.
- **Read-Only Property**: You cannot change the block name via the Properties Palette after insertion. The specific block to be drawn is determined by the script configuration or catalog assignment.
- **Moving the Symbol**: You can move the placed block using standard AutoCAD commands (e.g., `MOVE`) or by dragging the entity's insertion grip.

## FAQ
- **Q: Why is the Block Name property greyed out?**
  A: The property is set to Read-Only to prevent accidental changes. To use a different block, you typically need to use a different script instance or edit the script source code.
- **Q: The object vanished after I inserted it. How do I fix it?**
  A: This usually means the script is trying to insert a block that hasn't been defined in the drawing yet. Ensure the required block definition is imported or created in the DWG file.
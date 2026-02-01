# CE_CuttingBlock.mcr

## Overview
This script inserts a parametric 3D Cutting Block tool into the model. It allows users to define a specific volume for timber processing operations by graphically setting the insertion point, direction, and dimensions, with interactive grips for resizing and rotating.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Primary usage environment. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required Entities:** None (Standalone tool).
- **Minimum Beams:** 0.
- **Required Settings:** None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `CE_CuttingBlock.mcr`

### Step 2: Set Insertion Point
```
Command Line: Insertion point:
Action: Click in the Model Space to set the base origin (ptCutBase) of the cutting block.
```

### Step 3: Define Cut Direction
```
Command Line: Tool insert direction:
Action: Click a second point to define the primary axis (Depth) and length of the tool.
Note: Ensure the distance between the two points is sufficient; picking the same point will cancel the operation.
```

### Step 4: Define Width Direction
```
Command Line: Width direction:
Action: Click a third point to define the width orientation.
Note: A dynamic preview (Jig) will show the block orientation as you move the cursor.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Cut Depth @ Center | Double | Calculated | The length of the tool along the primary insertion direction. |
| Cut Width | Double | User Defined | The width of the cutting block. |
| Cut Length | Double | User Defined | The length of the cutting block (perpendicular to Width). |
| Target Beams | String | - | Specifies the target beams for this tool operation. |
| Corner Rounding | Double | - | Sets the fillet radius for the block corners. |
| Tool Type | String | - | Classification of the tool type for downstream processing. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the script geometry and internal maps based on current properties or grip edits. |

## Settings Files
- **Filename:** None detected in script header.

## Tips
- **Visualizing Orientation:** Watch the preview block during Step 4 (Width Direction) to ensure the block is rotating correctly around the cut axis before clicking.
- **Precise Rotation:** Use the rotation grips (Grips 5, 6, and 7) to rotate the block around specific axes relative to the base point if the initial placement was slightly off.
- **Centering:** The block geometry automatically re-centers itself along the Width or Length axes when you resize it using the properties panel, ensuring the base point remains centered relative to those dimensions.

## FAQ
- **Q: I received an error "Bad pick, could not determine direction". Why?**
  **A:** This happens if the points you clicked for the Insertion Direction are too close together (distance < 0.001 inch). The script will delete itself; simply run the command again and pick distinct points.
- **Q: How do I change the size after inserting?**
  **A:** You can either drag the dimension grips (Grips 0-4) in the model or type new values into the "Cut Depth", "Cut Width", or "Cut Length" fields in the Properties palette.
- **Q: What do the different colored grips do?**
  **A:** Grips 0-4 control the dimensions (Depth, Width, Length). Grips 5, 6, and 7 are rotation handles that allow you to rotate the tool around the Width, Cut Direction, and Length axes respectively.
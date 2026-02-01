# HSB_E-SetDirection

## Overview
This script sets the primary Y-axis direction (system axis) of selected roof elements. It allows you to manually define this direction by picking two points in 3D space, which updates the element's internal processing axis.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script runs in the 3D model environment. |
| Paper Space | No | Not applicable for layout views. |
| Shop Drawing | No | Not applicable for 2D drawings. |

## Prerequisites
- **Required entities**: Element or ElementRoof entities must exist in the model.
- **Minimum beam count**: 0
- **Required settings files**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-SetDirection.mcr` from the file dialog.

### Step 2: Select Elements
```
Command Line: Select one or more elements
Action: Click on the roof element(s) you wish to modify. Press Enter to confirm selection.
```

### Step 3: Define Start Point
```
Command Line: Select start point direction
Action: Pick a 3D point in the model representing the start of your desired direction vector.
```

### Step 4: Define End Point
```
Command Line: Select end point direction
Action: Pick a second 3D point. The line formed between the start point and this point determines the new Y-axis direction for the selected elements.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script does not expose editable parameters in the Properties Palette (OPM). All inputs are collected via the command line during insertion. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script does not add specific options to the entity right-click menu. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Batch Processing**: You can select multiple roof elements in Step 2 to apply the same direction vector to all of them simultaneously.
- **Vector Definition**: Ensure the direction you pick accurately represents the intended rafter or processing direction, as this affects subsequent machining and layout calculations.
- **Visualization**: Use object snaps (OSNAP) to ensure your start and end points align precisely with existing geometry if you need the direction to be parallel to a specific edge.

## FAQ
- **Q: What exactly does this script change?**
  - A: It updates the internal Y-vector (system axis) of the ElementRoof. It does not draw new lines or beams but modifies how the element interprets its own orientation.

- **Q: Can I use this on single beams?**
  - A: No, this script is designed specifically for Element or ElementRoof entities.

- **Q: How is the direction calculated?**
  - A: The script creates a vector from the Start Point to the End Point you select, normalizes it, and assigns that as the element's new Y-axis.
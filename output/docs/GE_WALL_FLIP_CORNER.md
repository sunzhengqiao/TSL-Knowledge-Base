# GE_WALL_FLIP_CORNER

## Overview
This script automatically modifies the intersection geometry of two connected timber walls to create specific corner joint types (e.g., miter, butt-and-pass) and updates the underlying AutoCAD wall length to match the new timber geometry.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D modification of timber elements. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | This script modifies 3D model elements, not 2D layouts. |

## Prerequisites
- **Required Entities**: Two `ElementWall` entities connected at a corner.
- **Minimum Beam Count**: 2 walls.
- **Required Settings**: None specific to external files; however, the underlying ACA (AutoCAD Architecture) wall must exist if you intend to use the "Stretch ACA" feature.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_WALL_FLIP_CORNER.mcr`

### Step 2: Select Walls
```
Command Line: Select wall entities:
Action: Click on the two timber walls that meet at the corner you wish to modify. Press Enter to confirm selection.
```

### Step 3: Specify Joint Type (if prompted)
```
Command Line: Angle Type [1 Butt and pass/2 Miter/3 Open angle/4 Miter-square bottom/5 Miter-square top/6 Square-miter bottom/7 Square-miter top] <2>:
Action: Type the number corresponding to the desired joint configuration and press Enter.
```
*(Note: This prompt only appears if the `nAngleConfig` property is set to "Prompt user" and the corner is not automatically detected as a standard right angle).*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| iStretchACA | Integer | 1 | **Stretch ACA Wall**: Determines if the script automatically adjusts the length of the host AutoCAD Architecture (ACA) wall object. <br>0 = No (Only timber geometry changes).<br>1 = Yes (CAD wall line updates to match timber). |
| nAngleConfig | Integer | 7 | **Corner Joint Configuration**: Specifies the type of corner joint to apply.<br>0 = Butt and pass<br>1 = Miter<br>2 = Open angle<br>3 = Miter-square bottom<br>4 = Miter-square top<br>5 = Square-miter bottom<br>6 = Square-miter top<br>7 = Prompt user (asks via command line). |
| dTol | Integer | 4 | **90° Tolerance (degrees)**: The tolerance used to identify if the intersection is a standard 90-degree corner. If the angle is within this range (±4° by default), the script may apply optimized right-angle logic. |
| strPrompt | String | (See Desc.) | **Prompt Text**: The text instruction displayed to the user when in manual prompt mode. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Re-runs the script logic using the current property values to update the wall geometry. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script operates on standard hsbCAD entities and does not require external XML configuration files.

## Tips
- **Synchronization**: Keep `iStretchACA` set to `1` (Yes) to ensure your 2D CAD wall lines always stay aligned with the 3D timber elements after modifications.
- **Right Angles**: If your walls are exactly 90 degrees, the script may default to a specific joint type (often Butt and Pass) regardless of the `nAngleConfig` setting, due to internal optimization logic. Adjust the `dTol` value if you need to force a specific calculation on near-right angles.
- **Hybrid Joints**: Options 3–6 (e.g., "Miter-square bottom") are useful for specific framing conditions where a complex profile is required at the top or bottom of the wall intersection.

## FAQ
- **Q: Why didn't the script ask me for the joint type?**
  **A:** The `nAngleConfig` property might be set to a specific number (0–6) instead of 7, or the walls were detected as a perfect 90-degree corner, which triggers an automatic configuration.
- **Q: Does this script work if I delete the underlying AutoCAD wall?**
  **A:** The script can still modify the timber element geometry (`ElementWall`), but the "Stretch ACA" feature (`iStretchACA`) will fail or have no effect if the host CAD wall object is missing.
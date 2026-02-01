# FLR_LADDER.mcr

## Overview
This script generates various types of blocking (joist, squash, and ladder blocking) between floor joists or trusses. It supports automatic or manual selection of bay boundaries and allows for distribution by specific count or maximum spacing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Creates physical 3D Beams assigned to Element Groups. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: A Floor Element (`ElementRoof`) containing structural members (Beams or TrussEntities).
- **Minimum Requirements**: The floor must have joists/trusses to define the bay.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `FLR_LADDER.mcr`

### Step 2: Select Floor Element
```
Command Line: Select element:
Action: Click on the floor element (ElementRoof) where you want to add blocking.
```

### Step 3: Define Distribution Limits
*The prompt here depends on the "Distribution method" property.*

*   **If Full bay length (Default):**
    ```
    Command Line: Give insertion point:
    Action: Click a point within the bay to define the start and end based on the nearest perpendicular joists.
    ```
*   **If Manual distribution limits:**
    ```
    Command Line: Give start point:
    Action: Click the start point for the blocking array.
    Command Line: Give end point:
    Action: Click the end point for the blocking array.
    ```

### Step 4: Define Bay Boundaries
*The prompt here depends on the "Limit beams detection" property.*

*   **If Automatic bay boundaries detection (Default):** The script automatically finds the nearest perpendicular beams/trusses to act as limits. No user input required.
*   **If Manualy select limit beams:**
    ```
    Command Line: Select first limit beam/truss:
    Action: Click the first joist or truss forming the edge of the bay.
    Command Line: Select second limit beam/truss:
    Action: Click the opposite joist or truss forming the other edge of the bay.
    ```

### Step 5: Select Source (If applicable)
*Only appears if the "Blocking type" property is set to "Selection".*
```
Command Line: Select beam to copy attributes:
Action: Click on an existing beam in the model. The script will copy the material and size of this beam for the new blocking.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Blocking type** | Enum | Joist Blocking | Selects the configuration: Joist Blocking, Upper & Lower Flat, Upper Flat, Lower Flat, Squash, Squash (double sided), Lower Block with Squash, Upper Blocking, or Selection (to copy from an existing beam). |
| **Number of blocks** | Integer | 1 | Sets the exact quantity of blocking pieces. Set to **0** to use unlimited mode (spacing is then determined by "Distribution"). |
| **Distribution** | Double | 16 | Maximum center-to-center spacing (in inches) when "Number of blocks" is 0. |
| **Size** | Enum | TwoByFour | Selects the lumber size (e.g., 2x4, 2x6). |
| **Squash H** | Double | 0 | Additional height adjustment (in inches) for Squash blocks to ensure proper load transfer or fit. |
| **Distribution method** | Enum | Full bay length | **Full bay length**: Uses the distance between limit beams. **Manual distribution limits**: Allows picking specific start/end points. |
| **Limit beams detection** | Enum | Automatic bay boundaries detection | **Automatic**: Script finds nearest perpendicular beams. **Manual**: User explicitly selects two limit beams. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Update | Recalculates and regenerates the blocking based on current property changes or model changes. |

## Settings Files
- None detected.

## Tips
- **Switching modes**: If the automatic boundary detection selects the wrong joists (common in complex floors), change **Limit beams detection** to "Manualy select limit beams" to explicitly pick the correct edges.
- **Spacing vs. Count**: To ensure blocks never exceed a certain distance (e.g., 12" O.C.), set **Number of blocks** to `0` and adjust **Distribution** to `12`.
- **Squash Blocks**: Use the **Squash H** parameter to account for sheathing thickness or camber when creating load-transfer blocks between floors.

## FAQ
- **Q: The script reports "Manual limits smaller then distribution value".**
  - A: The distance between your selected start and end points (in Manual mode) is shorter than the spacing defined in the **Distribution** property. Increase the distance or decrease the **Distribution** value.
- **Q: Why did no blocking generate?**
  - A: Ensure the selected floor element contains Beams or TrussEntities. If using "Automatic" detection, ensure there are perpendicular beams to define the bay; otherwise, switch to Manual detection.
- **Q: How do I use a specific material or size not listed in "Size"?**
  - A: Set **Blocking type** to "Selection". The script will pause to let you click an existing beam in the model that has the desired properties and dimensions.
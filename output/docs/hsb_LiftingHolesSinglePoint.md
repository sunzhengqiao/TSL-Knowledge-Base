# hsb_LiftingHolesSinglePoint.mcr

## Overview
This script calculates the Center of Gravity (CoG) of a wall panel and generates visual markers on the front face to indicate optimal lifting point positions, ensuring a safe offset from the wall edges to prevent splitting.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in the model context on wall elements. |
| Paper Space | No | Not supported in layout views. |
| Shop Drawing | No | This is a detailing/modeling script, not a drawing generation script. |

## Prerequisites
- **Required Entities**: `ElementWallSF` (Standard Wall).
- **Minimum Beams**: 1 (Must include Top Plates: `_kSFTopPlate`, `_kTopPlate`, `_kSFAngledTPLeft`, or `_kSFAngledTPRight`).
- **Required Settings Files**:
  - `Materials.xml` located in `_kPathHsbCompany\Abbund\`.
  - Script `hsbCenterOfGravity` must be accessible.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `hsb_LiftingHolesSinglePoint.mcr`.

### Step 2: Configure Properties (Optional)
```
Command Line: [Dialog appears]
Action: Set the initial "Min Distance from edge" and "Color" if prompted. Click OK to proceed.
```
*Note: This step may be skipped depending on your system configuration.*

### Step 3: Select Wall Elements
```
Command Line: Select a set of elements
Action: Click on the Wall Element(s) you wish to calculate lifting points for. Press Enter to finish selection.
```

### Step 4: View Results
The script will attach to the elements and draw "V" shaped markers on the front face indicating the calculated lifting positions.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Min Distance from edge of the wall | Number | 600 | The minimum safety distance (mm) from the left or right edge of the wall to the center of the lifting hole. |
| Color | Number | 4 | The AutoCAD color index used to draw the lifting markers. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are defined for this script. |

## Settings Files
- **Filename**: `Materials.xml`
- **Location**: `_kPathHsbCompany\Abbund\`
- **Purpose**: Provides material density data required to calculate the accurate weight and Center of Gravity (CoG) of the wall panel.

## Tips
- **Dynamic Updates**: If you modify the wall geometry (e.g., add windows or change studs), the script will automatically recalculate the lifting points to match the new Center of Gravity.
- **Visualizing Safety**: If the calculated CoG is very close to one edge, increasing the `Min Distance from edge of the wall` parameter will push the lifting points inward to ensure structural safety, though this may reduce the spread between points.
- **Troubleshooting**: If markers do not appear, ensure the `_kPathHsbCompany` variable is set correctly so the script can find the `Abbund\Materials.xml` file.

## FAQ
- **Q: Why didn't the script generate any markers?**
  A: Ensure the selected element is a valid Wall (`ElementWallSF`) and that it contains recognized Top Plates. Also, verify that `Materials.xml` exists in the specified Company folder.

- **Q: What happens if my wall is too narrow for the calculated spread?**
  A: The script logic automatically detects if the distance between the lifting points is too small relative to the edge offset. It will "clamp" the positions to ensure the minimum edge distance is maintained.

- **Q: Can I change the marker color after insertion?**
  A: Yes. Select the script instance (or the wall), open the Properties palette (Ctrl+1), and change the "Color" integer value (e.g., 1 for Red, 2 for Yellow, etc.).
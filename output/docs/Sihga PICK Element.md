# Sihga PICK Element

## Overview
Generates SIHGA PICK lifting anchors and CNC machining data for timber roof or floor elements. It automatically calculates lifting point positions based on the Center of Gravity to ensure safe handling during transport and installation.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in 3D model context. |
| Paper Space | No | Not supported for 2D layouts. |
| Shop Drawing | No | Generates model data, not 2D drawings directly. |

## Prerequisites
- **Required Entities**: `ElementRoof`, `Beam`, `Sheet`.
- **Minimum Requirements**: At least one structural beam (min 80x120mm) within the element.
- **Required Settings**: The script `hsbCenterOfGravity.tsl` must be available in the DWG or search path.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `Sihga PICK Element.mcr`
*Alternatively, drag and drop the script into the AutoCAD model space.*

### Step 2: Configure Settings (Manual Launch Only)
If run manually (not from a catalog), a dialog appears.
```
Dialog: Select Options
Action:
1. Set (A) Quantity to 3 or 4 points.
2. Set (B) Lifting Belt Length (default 2000mm).
3. Set (C) Distance Lifting points (default 1000mm).
4. Toggle (D) Apply Weinmann Tools to Yes/No.
5. Click OK.
```

### Step 3: Select Element
```
Command Line: Select element(s)
Action: Click on the target ElementRoof in the model.
```

### Step 4: Review Results
The script will automatically attach to the element.
- **Success**: 3D bodies (anchors and belts) are visualized; drills are added to beams.
- **Failure**: The script instance will delete itself if beams are too small, sheeting is too thick (>22mm), or the Center of Gravity cannot be calculated.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| (A) - Quantity | dropdown | 1 | Select 3 or 4 lifting points distribution. |
| (B) - Lifting Belt Length | number | 2000 | Length of the lifting slings used (in mm). Determines the max distance between points. |
| (C) - Distance Lifting points | number | 1000 | Spacing between lifting points. Note: If this value exceeds the safe limit for the belt length, it auto-corrects. |
| (D) - Apply Weinmann Tools | dropdown | No | If Yes, adds CNC `ElemNoNail` zones and `ElemDrill` operations for Weinmann machinery. |
| Element weight | text | 0 | Calculated weight of the element. If this exceeds the safe load limit, a visual warning appears. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are defined. Modify properties via the Properties Palette (Ctrl+1). |

## Settings Files
- **Filename**: None used.
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Safety Auto-Correction**: If you set the "Distance Lifting points" too wide for the specified "Lifting Belt Length", the script will automatically reduce the distance to maintain a minimum 45° lifting angle.
- **Visual Warnings**: Watch for Red text or "Attention" graphics in the model. This indicates the element weight exceeds the load capacity of the lifting configuration or the angle is too shallow.
- **Beam Size**: Ensure your structural beams are at least 120mm in height and 80mm in width. The script will fail on smaller beams.
- **Sheeting Limit**: If using Weinmann tools, the top sheeting layer must not exceed 22mm thickness.

## FAQ
- **Q: Why did the script disappear after I selected the element?**
  **A:** The script likely failed validation. Check that your beams are at least 80x120mm, the top sheeting is under 22mm thick, and that the `hsbCenterOfGravity` script is loaded.
- **Q: Why did my "Distance Lifting points" value change after I ran the script?**
  **A:** The input value violated the safety requirements for the specified belt length (lifting angle < 45°). The script automatically corrected it to the maximum safe distance.
- **Q: What do the "No-Nail" zones do?**
  **A:** If "Apply Weinmann Tools" is set to Yes, these zones prevent the CNC machine from applying nails or screws in the critical areas where the lifting anchors are installed.
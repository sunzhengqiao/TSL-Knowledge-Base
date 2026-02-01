# FLR_SQUASH_BLOCKING.mcr

## Overview
Generates lumber blocking (squash blocks) for floor or roof elements to stiffen the structure and provide nailing surfaces. It supports manual insertion of single blocks or automatic detection of joist bays for multiple blocks, including specialized rim blocking options.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run on an existing 3D Floor or Roof element. |
| Paper Space | No | Not applicable for layout generation. |
| Shop Drawing | No | This script generates model geometry, not 2D drawing views. |

## Prerequisites
- **Required Entities**: A Floor or Roof Element (Element). For automatic insertion, the element must contain Joists or Rafters (Beams or TrussEntities).
- **Minimum Beam Count**: 0 (Manual mode), or 2 (for automatic Joist bay detection).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `FLR_SQUASH_BLOCKING.mcr`

### Step 2: Select Floor Element
```
Command Line: Select Floor Element
Action: Click on the desired Floor or Roof element in the model to which the blocking will be applied.
```

### Step 3: Set Reference Point
```
Command Line: Select reference point
Action: Click in the model to set the starting location for the blocking (e.g., at a load-bearing wall or specific joist bay).
```

### Step 4: Define Direction
```
Command Line: Select direction
Action: Click a second point to define the direction and length of the blocking line. In "Multiple blocks" mode, this line defines the path along which the script searches for joists.
```

### Step 5: Configure and Preview
Once the points are placed, the script generates a preview.
- **Action**: Open the **Properties Palette** (Ctrl+1) to adjust parameters like Size, Orientation, or Blocking Type. The preview updates automatically as you change values.
- **Action**: Drag the Reference or Direction point grips in the model to adjust the location or angle.

### Step 6: Commit to Drawing
```
Action: Right-click on the script instance and select "Commit Beams to Dwg".
Result: The preview blocks are converted into actual Beam entities and added to the Element group. The script instance is removed.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Size | Dropdown | \|2x4 Blocks\| | Select the nominal lumber size for the blocking (e.g., 2x4, 2x6, up to 2x12). |
| Blocking orientation | Dropdown | \|X-axis\| | Sets the plan orientation of the blocking relative to the element's local coordinate system. Choose X-axis or Y-axis. |
| Number of Blocks | Number | 1 | Defines how many blocks to create in a stack at the insertion location. |
| Insertion method | Dropdown | \|One block\| | **One block**: Places blocks only at the reference point. **Multiple blocks**: Places blocks at every intersection between the defined direction line and the floor joists. |
| Blocking type | Dropdown | (Blank) | **Standard**: Uses settings above. **Upper/Lower/Upper & Lower**: Specialized mode for rim blocking that fills joist bays entirely at the top or bottom chord. Overrides Orientation and Number of Blocks settings. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Commit Beams to Dwg | Converts the temporary preview bodies into permanent Beam entities and assigns them to the Element group. The script instance is then deleted. |

## Settings Files
None required.

## Tips
- **Automatic Bay Detection**: For fastest results, set **Insertion method** to "Multiple blocks" and draw your direction line across several joists. The script will calculate intersection points automatically.
- **Rim Blocking**: Use the **Blocking type** parameter to generate solid blocking between joists (e.g., for rim boards). Note that this option forces the script to use "Multiple blocks" mode and aligns orientation to the X-axis.
- **Visual Feedback**: If the blocking appears rotated incorrectly, toggle the **Blocking orientation** parameter between X-axis and Y-axis.
- **Grip Editing**: You can adjust the reference and direction points after insertion to fine-tune the blocking line before committing.

## FAQ
- **Q: Why did my settings change when I selected "Upper blocking"?**
  A: When using specialized Blocking types (Upper, Lower, etc.), the script automatically overrides Orientation and Number of Blocks to ensure the geometry is calculated correctly for rim joist applications.
- **Q: I see an error "Less then 2 joist between selected boundaries".**
  A: This occurs in "Multiple blocks" or "Blocking type" modes if your defined direction line does not cross at least two joists. Extend your line or move it to intersect the structural members.
- **Q: Can I edit the blocks after I commit them?**
  A: Once "Commit Beams to Dwg" is selected, the script is removed. The blocks become standard Beam entities and can be edited individually using normal hsbCAD beam editing tools.
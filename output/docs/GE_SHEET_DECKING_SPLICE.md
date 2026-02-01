# GE_SHEET_DECKING_SPLICE

## Overview
Splits selected large-format sheeting (such as OSB or Plywood) into smaller, staggered panels. This tool simulates a structural decking or sheathing layout with running bond joints for floor, roof, or wall areas.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required for 3D sheeting entities. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required entities**: Existing "Sheet" entities (e.g., large uncut panels) already drawn in the model.
- **Minimum beam count**: 0
- **Required settings files**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `GE_SHEET_DECKING_SPLICE.mcr`.

### Step 2: Adjust Properties (Optional)
Action: Before proceeding, you can adjust the **Sheeting length** and **Sheeting height** in the Properties Palette if the default dimensions do not match your desired panel size.

### Step 3: Select Sheeting
```
Command Line: Select sheeting
Action: Click on the large sheet entities you wish to split. Press Enter to confirm selection.
```

### Step 4: Define Starting Point
```
Command Line: Select starting point
Action: Click a point in the drawing area.
```
*Note: This point acts as the origin for the cutting grid. It determines where the first row of cuts begins and aligns the staggered pattern.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Sheeting length | number | 2438.4 mm / 96 in | The target length of the individual panels along the primary axis. This determines the spacing of vertical cuts. Odd rows are offset by half this value to create the stagger. |
| Sheeting height | number | 1219.2 mm / 48 in | The target height (or width) of the individual panels perpendicular to the primary axis. This determines the spacing of horizontal cuts (rows). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | The script instance is removed from the model immediately after execution. There are no post-insertion context menu options. |

## Settings Files
None

## Tips
- **Alignment**: Use the "Select starting point" click carefully. Clicking near a structural element (like a joist or rafter) ensures panel edges align where you need them.
- **Optimization**: The script calculates cuts starting from the bottom of the sheeting upwards. This helps minimize the number of small, unusable cut-off pieces at the top.
- **Undo**: Since the script replaces the original sheets and deletes itself, use the AutoCAD `UNDO` command if you need to revert the changes or adjust the sizes.
- **Staggering**: The script automatically offsets every other row by 50% of the *Sheeting length* to ensure joints do not line up vertically.

## FAQ
- **Q: Why did my original sheet disappear?**
  - A: The script deletes the original sheet entity and replaces it with the new, smaller individual panels. This is the intended behavior.
- **Q: How do I change the panel size after I have run the script?**
  - A: You cannot simply modify the properties and update. You must use the `UNDO` command to revert to the original large sheet, change the *Sheeting length* or *Sheeting height* properties, and run the script again.
- **Q: What happens if I select sheets of different sizes or orientations?**
  - A: The script processes each selected sheet individually based on its own geometry and the global starting point provided. Ensure the starting point is relevant to all selected sheets if they are in the same plane.
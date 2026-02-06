# hsbCLT-Slot.mcr

## Overview
This script creates a parametric slot (rectangular cutout) on the face of a CLT or timber panel. It is designed to create precise pockets for seating beams, steel plates, or other connecting elements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates in 3D model space to cut panel geometry. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Does not generate 2D drawing views directly. |

## Prerequisites
- **Required Entities**: A Solid Inner Part or Panel (Sip entity).
- **Minimum Panels**: 1
- **Required Settings**: None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCLT-Slot.mcr`

### Step 2: Configure Properties
```
Command Line: [Dialog or Catalog Opens]
Action: A properties dialog appears. You can either load a preset from the catalog or manually set the initial dimensions (Width, Depth, Alignment). Click OK to proceed.
```

### Step 3: Select Panel
```
Command Line: Select panels:
Action: Click on the CLT or timber panel where you want the slot to be cut.
```

### Step 4: Select Start Point
```
Command Line: Start Point:
Action: Click a point on the face of the panel to define the start of the slot.
```

### Step 5: Define End Point and Orientation
```
Command Line: Select end point [Start/Mid/End/Left/Center/Right/FlipSide]:
Action: Move your cursor to preview the slot. Click to set the end point. 
Note: You can type keywords at the command line before clicking to adjust alignment:
- Start/Mid/End: Adjusts longitudinal anchor.
- Left/Center/Right: Adjusts lateral alignment.
- FlipSide: Switches the cut to the opposite face.
```

### Step 6: Finish
The slot is calculated and subtracted from the panel geometry.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Length | Number | 0 | Defines the length of the slot. Set to 0 to define length dynamically by clicking start/end points. |
| Width | Number | 8 | Defines the width of the slot (perpendicular to the length). |
| Depth | Number | 100 | Defines how deep the slot cuts into the panel. Set >= Panel Thickness for a through-cut. |
| Alignment | Dropdown | Center | Sets the lateral position of the slot relative to the axis line (Left, Center, Right). |
| Face | Dropdown | Reference Side | Determines which side of the panel the cut starts from (Reference Side or Opposite Side). |
| Angle | Number | 0 | Rotates the slot relative to the normal of the face (-90 to 90 degrees). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Flip Side | Switches the slot to the opposite face of the panel (Toggles the "Face" property). |
| Add Panels | Allows you to select additional panels to apply the same slot cut to. |
| Remove Panels | Removes selected panels from the slot operation. |

## Settings Files
- **Filename**: None specific
- **Location**: N/A
- **Purpose**: Standard script properties are used; no external settings file is required.

## Tips
- **Dynamic Length**: Leave the `Length` property as 0 during insertion to let the distance between your clicked points determine the size automatically.
- **Quick Flip**: Double-click the script instance in the model to quickly flip the slot to the opposite side.
- **Grip Points**: After insertion, use the blue grip points to drag the start or end of the slot. The `Length` property will update automatically.
- **Through Cuts**: To ensure the slot goes all the way through, check your panel thickness in the Properties palette and set the `Depth` slightly higher than that value.

## FAQ
- Q: Why did the tool disappear after I selected a panel?
  A: The script requires a valid Panel (Sip entity). If you selected a line or a different element type, or if the dimensions were set too small (epsilon), the script will delete itself automatically.
- Q: Can I cut a slot at an angle?
  A: Yes. Use the `Angle` property in the palette to rotate the slot, or use the visual rotation options during the insertion jig.
- Q: How do I cut the same slot in multiple stacked panels?
  A: Insert the slot on the first panel. Then, right-click the script instance and select "Add Panels" to select the other panels in the stack.
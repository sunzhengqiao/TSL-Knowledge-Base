# hsbCAD_Multi Point Load

## Overview
This script inserts structural point load reinforcements (typically vertical studs or blocking) into timber elements like walls or floors. It automatically detects top and bottom plates, validates for conflicts with wall openings, and generates the required beams based on your alignment and quantity settings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Used for 3D model generation. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required entities**: Element (e.g., a Wall or Floor panel) containing valid Top and Bottom plates.
- **Minimum beam count**: 0 (The script analyzes beams contained within the selected Element).
- **Required settings**: The child script `hsbCAD_Point Load` must exist in your TSL search path.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCAD_Multi Point Load.mcr`

### Step 2: Select Elements
```
Command Line: Select a set of elements
Action: Click on the wall(s) or panel(s) where you want to apply the point load. Press Enter when finished.
```

### Step 3: Select Insertion Point
```
Command Line: Select an insertion point
Action: Click on the face of the element to define the location of the point load.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Align | dropdown | Left | Aligns the group of beams relative to the insertion point. Options: Left, Center, Right. |
| Nr. of beams in pointload | dropdown | 1 | The number of vertical reinforcement beams to generate (Range: 1-12). |
| Extrusion profile name | dropdown | *Empty* | Optional. Specifies a custom profile name. If empty, the beam width defaults to the Element's height. |
| Text style | dropdown | *Empty* | Specifies the text style used for the "PL" (Point Load) label display. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (Standard hsbCAD Context) | Standard options (Erase, Move, Properties) apply. No specific custom menu items are added by this script. |

## Settings Files
- **Filename**: None used by this script.

## Tips
- **Opening Conflicts**: If the script displays a red "PL" text and a graphical "X" with a warning message, the point load location is interfering with an opening (lintel or jack stud). Move the insertion point away from the opening or adjust the opening size.
- **Valid Elements**: Ensure your selected Element contains recognized Top and Bottom plates. If the script only draws a wireframe box "PL X", it could not find the necessary structural plates within the element.
- **Adjusting Position**: You can grip-edit the insertion point after placement to move the load along the wall. The script will automatically re-check for valid plate intersections and opening conflicts.

## FAQ
- **Q: Why does my point load show as a red "X"?**
  A: This indicates the location is blocked by an opening beam (like a lintel) or the script cannot safely fit the beams. Move the point load to a clear section of the wall.
- **Q: Can I apply this to multiple walls at once?**
  A: Yes, during the "Select a set of elements" prompt, you can select multiple walls. The point load will be applied to all of them at the relative insertion location.
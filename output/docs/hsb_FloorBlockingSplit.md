# hsb_FloorBlockingSplit.mcr

## Overview
This script automatically detects and splits floor blocking or batten beams within selected construction elements. It cuts these members to fit around intersecting structural beams and dynamically stretches them to maintain contact with those intersections.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D construction elements and beams. |
| Paper Space | No | Not designed for layout views or 2D drawings. |
| Shop Drawing | No | Not intended for manufacturing detailing views. |

## Prerequisites
- **Required Entities**: Construction Elements containing Beams.
- **Minimum Beam Count**: At least one beam must exist within the element. The script requires perpendicular beams within the element to define the floor orientation.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_FloorBlockingSplit.mcr`

### Step 2: Configure Beam Codes
```
Action: Before selecting elements, check the AutoCAD Properties Palette (Ctrl+1).
```
Locate the property **Enter beam codes**. By default, it looks for "BLOCKING;BATTEN". 
- Edit this list to include the specific names (codes) of the blocking or battens you wish to split.
- Separate multiple codes with a semicolon (`;`).

### Step 3: Select Elements
```
Command Line: Please select Elements
Action: Click on the construction Elements (floors/roofs) containing the blocking to be processed. Press Enter to confirm selection.
```

### Step 4: Automatic Processing
The script will automatically calculate intersections, split the matching beams, and apply cuts. 
**Note:** The script instance will disappear from the drawing immediately after processing. This is normal behavior.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Enter beam codes | Text | BLOCKING;BATTEN | Defines which beams to split. Enter the exact catalog names separated by semicolons (e.g., `STUD;BLOCKING`). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | The script deletes itself automatically after execution, leaving no context menu options. |

## Settings Files
- None used.

## Tips
- **Exact Spelling**: Ensure the Beam Codes match your catalog entries exactly. If the code is "Blk" and you type "Blocking", the script will ignore that beam.
- **Dynamic Connections**: The resulting split beams maintain a dynamic link to the intersecting beams. If you move the main structural beams later, the blocking will automatically stretch to stay connected.
- **Undo**: If the result is not as expected, simply use the standard AutoCAD `UNDO` command to revert the changes.

## FAQ
- **Q: Why did the script disappear after I selected the elements?**
  A: This is a "run-once" script. It modifies the geometry and then removes its own instance from the drawing to keep the file clean.
  
- **Q: The script ran, but some beams weren't split. Why?**
  A: Check the **Enter beam codes** property. The beam you wanted to split must have its code listed there exactly as it appears in the beam properties.

- **Q: Can I use this on walls?**
  A: The script is designed for floor structures and looks for beams perpendicular to the Element's X-axis. It may not function correctly on vertical wall elements.
# CNC_DrillElement.mcr

## Overview
Automates the insertion of vertical drilling, slot milling, or annotation symbols into timber beams and elements. It supports creating physical CNC tooling (drills and slots), graphical symbols for drawings, or both simultaneously.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script operates on 3D beams and elements. |
| Paper Space | No | Not designed for 2D layout or detailing space. |
| Shop Drawing | No | Generates 3D tooling and symbols, but does not create shop drawing views directly. |

## Prerequisites
- **Required Entities**: An existing `Element` (Wall/Floor) containing `GenBeams`.
- **Minimum Beam Count**: 1 (Must select a set of beams during insertion).
- **Required Settings**: None required for basic use, though Catalog entries can preset parameters.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `CNC_DrillElement.mcr` from the list.

### Step 2: Select Beams
```
Command Line: Select set of beams
Action: Click to select the beam(s) you wish to drill or mill, then press Enter.
```

### Step 3: Select Insertion Point
```
Command Line: Select insertion point
Action: Click on the face or surface of the beam/element where the drill center should start.
```

### Step 4: Select End Point (Optional)
```
Command Line: Select end point (optional)
Action: Click to define the end point of the drill/slot.
Note: If skipped, the script projects the drill through the element automatically.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Visualization Type** | dropdown | Drill | Determines the operation mode: **Drill** (Physical hole), **Mill** (Slot), **Symbol** (2D drawing only), **Both** (Physical hole + 2D), or **Elementdrill** (Wall-level tooling). |
| **Diameter** | number | 8mm | The diameter of the drill hole. |
| **Offset inside frame** | number | 0mm | Stops the drill short of the opposite face (blind hole) or offsets it from the start. |
| **Subtype** | text | | Prefix for dimension subtypes; used to filter drills in other scripts. |
| **Width mill** | number | 10mm | Width of the slot (only active when Visualization is *Mill*). |
| **Depth mill** | number | 10mm | Depth of the slot cut into the beam face (only active when Visualization is *Mill*). |
| **Cut angle** | angle | 0° | Angle of the saw cut at the ends of the slot (0-90 degrees, only active for *Mill*). |
| **Cut offset** | number | 0mm | Distance the angled end cuts are shifted inward (only active for *Mill*). |
| **Dimension style** | dropdown | Standard | Drafting style used for dimensions and text. |
| **Diameter symbol** | number | 40mm | Visual size of the drill circle in 2D drawings. |
| **Text size** | number | 30mm | Height of the annotation text. |
| **Color circle** | number | 4 | CAD Color index for the drill circle symbol. |
| **Color line** | number | 4 | CAD Color index for the centerline. |
| **Color text** | number | 7 | CAD Color index for annotation text. |
| **Zone index** | number | 4 | Logical zone/grouping within the element (used for Elementdrill). |
| **Tool index** | number | 1 | Identifier for the CNC tool to be used (used for Elementdrill). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None specific* | This script relies on the Properties Palette (OPM) for configuration and standard AutoCAD grips for movement. |

## Settings Files
- **Filename**: None specified.
- **Purpose**: This script uses standard TSL properties and does not depend on external XML settings files for basic functionality.

## Tips
- **Switching Modes**: Use the **Visualization Type** property to toggle between creating a real CNC hole (Drill) and just drawing a symbol (Symbol) for planning purposes.
- **Angled Slots**: Select **Mill** as the Visualization Type to create slots. Use the **Cut angle** parameter to create angled ends (e.g., for housing tenons).
- **Moving Holes**: You can select the script instance in the model and use the **Grip Edit** (Move) command to slide the drill along the beam to a new position.
- **Element Drills**: If you need a drill that goes through multiple layers of a wall (e.g., MEP vertical shafts), set **Visualization Type** to **Elementdrill**.

## FAQ
- **Q: Why did the script instance disappear after I moved it?**
  **A:** The script automatically erases itself if it no longer intersects with the beam geometry. Ensure you move the grip point back onto the beam surface.
- **Q: Can I use this for horizontal drilling?**
  **A:** This script is designed for drilling perpendicular to the beam face or through the element Z-axis (vertical). It is not intended for long-axis horizontal drilling.
- **Q: What happens if I don't select an end point?**
  **A:** The script will calculate the end point by projecting the insertion point through the element frame, effectively creating a through-hole.
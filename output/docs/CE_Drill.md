# CE_Drill.mcr

## Overview
Creates parametric cylindrical drill holes through beams or panels for mechanical connections like dowels, rods, or bolts. The script includes visual markers to indicate the drilling direction and allows for precise alignment across multiple elements.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Operates in 3D Assembly environment. |
| Paper Space | No | Not designed for 2D layout or detailing views. |
| Shop Drawing | No | Does not generate 2D drawings directly. |

## Prerequisites
- **Required Entities**: At least one GenBeam (Beam or Panel) must be selected during insertion.
- **Minimum Beam Count**: 1 (during insertion).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `CE_Drill.mcr` from the list.

### Step 2: Select Target Beam
```
Command Line: Select a beam or panel to tool in Assembly
Action: Click on the beam or panel you want to drill through.
```

### Step 3: Define Insertion Point
```
Command Line: Select Insertion Point
Action: Click in the model to set the start point of the drill hole.
```

### Step 4: Define Direction
```
Command Line: Select Drill Direction
Action: Move your mouse to orient the drill path. A visual preview (jig) will appear. Click to set the direction and length.
```
*Note: The length is automatically determined by the distance between Step 3 and Step 4.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Internal Drill Diameter | Number | 12 mm | The actual diameter of the hole bored into the wood (e.g., for the bolt/rod). |
| Applied Drill Diameter | Number | 15 mm | The diameter of the visual drill bit shank. Often represents a counterbore or clearance size. |
| Overall Drill Length | Number | Auto | The distance between the start and end grips. Editing this moves the end grip. |
| Target Beams | Dropdown | Parent | Selects which beams are machined: "Parent" (selected beam), "Children", or "All". |
| Operation Mode | Dropdown | Anchor End 1 | Defines the connection logic for anchors. Controls visual arrows (Start, End, or Both). |
| \|Text Height\| | Number | 0.3 in | Height of the text labels ('1' and '2') displayed at the drill ends. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add beams to be tooled | Allows you to select additional beams or panels to include in the current drilling operation. |
| Remove beams to be tooled | Allows you to select specific beams or panels to remove from the current drilling operation. |

## Settings Files
- None.

## Tips
- **Grip Editing:** After insertion, you can drag the square grips (Start and End points) in the model to dynamically resize or reorient the drill hole.
- **Quick Length Change:** Instead of dragging grips, you can type a specific value in the "Overall Drill Length" property to extend or shorten the hole along its current axis.
- **Visual Confirmation:** Use the "Operation Mode" to toggle visual arrows if you need to communicate the insertion direction (e.g., "Anchor End 1" shows an arrow at the exit point).
- **Multiple Beams:** Use the "Add beams to be tooled" context menu to drill through a stack of aligned beams simultaneously without creating a new script instance.

## FAQ
- **Q: What is the difference between Internal and Applied Diameter?**
  **A:** The *Internal Drill Diameter* defines the physical hole size in the wood (NC Data). The *Applied Drill Diameter* is primarily for the 3D visual representation, allowing you to show a larger shank or counterbore visually while keeping the physical hole size smaller.
- **Q: How do I change the drill angle after inserting?**
  **A:** Use the "AddRecalc" menu (usually right-click the script instance) or simply drag the grips to the new positions. The script will recalculate the vector automatically.
- **Q: Why did my drill disappear?**
  **A:** This script is designed to cut into beams. If you remove the linked beam (set "Target Beams" to empty or delete the beam), the visual drill may remain but will have no effect until a valid beam is assigned via the "Add beams to be tooled" menu.
# GE_PLOT_A4_LAYOUT.mcr

## Overview
This script generates a detailed 2D shop drawing layout for timber wall elements within an A4 Paper Space environment. It automates the creation of dimension lines, material lists, sheathing outlines, and weight calculations based on the selected wall geometry.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | The script is designed to output to Layouts. |
| Paper Space | Yes | Primary environment for generating the A4 layout. |
| Shop Drawing | Yes | Supports "Shopdraw multipage" mode. |

## Prerequisites
- **Required Entities**: A Timber Wall Element (or collection of GenBeams).
- **Minimum Beam Count**: 1 (though typically used on full wall assemblies).
- **Required Settings**: None (uses standard hsbCAD entity data).

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the AutoCAD command line.
2.  Navigate to the location of `GE_PLOT_A4_LAYOUT.mcr` and select it.

### Step 2: Select Wall Element
```
Command Line: Select element:
Action: Click on the timber wall element in Model Space you wish to layout.
```
*Note: If an element is already selected before running the script, this step may be skipped.*

### Step 3: Configure Layout
Once inserted, the script generates an initial layout. To customize it:
1.  Select the layout drawing entity (or the script anchor if visible).
2.  Open the **Properties Palette** (Ctrl+1).
3.  Adjust parameters (e.g., dimension offsets, visibility of sheathing, beam filters) as described below.
4.  The drawing will update automatically to reflect changes.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Drawing space | Dropdown | Paper Space | Choose between "Paper Space" or "Shopdraw multipage". |
| Timber density | Number | 450 kg/m³ | Density of material used to calculate total weight displayed on the drawing. |
| Dimension headers | Dropdown | No | If Yes, includes horizontal blocking (headbinders) in the bottom running dimensions. |
| Show Element Dimension | Dropdown | Yes | Toggles the overall width dimension of the entire wall element. |
| Dimension Mode | Dropdown | Line and Text | Sets the visual style for running dimensions: "Line and Text" or "Dimension Line". |
| Include Beam With BeamCode | String | (Empty) | Filters which beams are dimensioned based on their BeamCode (e.g., type 'STUD' to only dimension studs). |
| Show Diagonal Dimension | Dropdown | Yes | Displays the diagonal length (hypotenuse) of the wall. Options: Yes, No, or "As Text on Top". |
| Show Sheathing Outlines | Dropdown | No | Toggles the visibility of the sheathing/sheet material polylines (OSB/Plywood). |
| Offset from Element | Number | 150 mm | Sets the distance between the wall geometry and the first row of dimensions. |
| Opening Dim Location | Dropdown | Right Side | Specifies where vertical dimensions for windows/doors are placed (Left, Right, Center, or None). |
| Show Cumulative Opening Dims | Dropdown | No | If Yes, adds running dimensions for openings (e.g., distance from wall start to window). |
| Show Blocking Dims | Dropdown | Yes | Toggles the dimensioning of blocking/bridging members within the wall. |
| Blocking Dim Point | Dropdown | Top | Defines the reference point for blocking dimensions: Top, Center, or Bottom of the blocking member. |
| Show Delta Opening Dimension | Dropdown | Yes | Toggles the specific dimension indicating the width of the individual opening. |
| Offset for cumulative... | Number | 0 mm | Distance separating the cumulative opening dimension from the delta dimension. |

## Settings Files
- No external settings files are required. The script relies on entity properties and script-embedded logic.

## Tips
- **Filtering Content**: Use the *Include Beam With BeamCode* property to dimension only studs or plates, hiding other members like cripples or trimmers from the dimension string.
- **Clarity**: For complex walls, turn *Show Sheathing Outlines* to "No" to reduce visual clutter in the layout.
- **Spacing**: If dimensions overlap with the wall geometry, increase the *Offset from Element* value.
- ** angled Walls**: The script automatically detects angled plates and dimensions them correctly relative to their slope.

## FAQ
- **Q: How is the wall weight calculated?**
  - A: The weight is calculated using the volume of timber in the element multiplied by the *Timber density* (dFactor) property.
- **Q: Can I place dimensions on both sides of the wall?**
  - A: This script specifically handles bottom running dimensions and vertical opening dimensions. Side placement is determined by the *Opening Dim Location* property.
- **Q: Why are some beams not dimensioned?**
  - A: Check the *Include Beam With BeamCode* property. If it is not empty, only beams matching that code will be dimensioned.
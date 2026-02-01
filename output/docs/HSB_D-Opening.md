# HSB_D-Opening.mcr

## Overview
Automates the dimensioning and annotation of openings (windows, doors, shafts) within timber wall or roof elements directly on 2D layout views. It calculates dimensions based on rough openings or timber trimmer sizes and draws the results in Paper Space.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | Script is intended for 2D documentation. |
| Paper Space | Yes | Primary environment; requires a Viewport selection. |
| Shop Drawing | Yes | Used to annotate production drawings. |

## Prerequisites
- **Required Entities**: A Viewport in an AutoCAD Layout displaying an hsbCAD Element (Wall/Roof).
- **Minimum Beam Count**: 0 (Script detects openings in the element profile).
- **Required Settings**: `HSB_G-FilterGenBeams.mcr` (Optional, used if custom beam filters are required).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_D-Opening.mcr` from the list.

### Step 2: Select a Viewport
```
Command Line: Select a viewport
Action: Click on the viewport border that displays the element you wish to dimension.
```

### Step 3: Select Insertion Point
```
Command Line: Select insertion point
Action: Click anywhere in the Paper Space layout to place the script instance. This point acts as the anchor for the script but does not necessarily dictate the dimension line location (which is controlled by properties).
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Selection** | | | |
| Section tsl name | String | Empty | Links this dimension script to a specific section script to ensure they analyze the same element. |
| Filter definition for GenBeams | Dropdown | Empty | Select a filter to define which structural beams are considered when calculating "closest beam" dimensions (e.g., ignoring sheathing). |
| Filter beams with beamcode | String | Empty | Enter a beamcode to only include beams matching this code in the dimension calculation. |
| Filter beams and sheets with label | String | Empty | Enter a label to only include entities with this label. |
| Filter zones | String | Empty | Enter a zone number to restrict dimensioning to specific zones. |
| Filter openings with description | String | Empty | Enter text to only dimension openings whose description matches this text. |
| **Geometry & Mode** | | | |
| Mode | Enum | Outline | **Outline**: Measures the rough opening size.<br>**Closest beams**: Measures to the face of the nearest timber beam (trimmer/jack).<br>**Shadow profile**: Measures the projection on complex surfaces. |
| Sheet in opening | Enum | No | If "Yes", treats sheeting materials inside the opening as boundary beams for dimensioning. |
| **Layout & Style** | | | |
| Position | Enum | Horizontal bottom | Sets where the dimension line is placed (e.g., below the view, beside the view, or vertical for each opening). |
| Offset in paperspace units | Enum | No | **Yes**: Offset is fixed on paper (ignores viewport scale).<br>**No**: Offset scales with the model (ModelSpace units). |
| Dim line offset | Double | 300 | Distance between the element and the dimension line. |
| Dim layout | Enum | Delta perpendicular | **Delta**: Shows individual segment sizes.<br>**Cumulative**: Shows total running distances.<br>**Both**: Combines styles. |
| Dimension side | Enum | Left | Determines which side of the opening the dimension markers snap to (Left, Right, Both, or Center). |
| **Reference & Origin** | | | |
| Reference type | Enum | No reference point | **No reference point**: Starts dimensioning from the element start.<br>**Zone**: Uses the first beam of a specific zone as the zero point (0.00). |
| Reference zone index | Int | 0 | Specifies the zone number to use as the reference origin (only if Reference Type is 'Zone'). |
| **Annotation** | | | |
| Description | String | Empty | The text label to display next to the dimension (e.g., "Window 01"). |
| Side description | Enum | Left | Places the description text on the Left or Right side of the dimension line. |
| **Vertical Dimensions** | | | |
| Dim header | Enum | Yes | Includes the header height in the vertical dimension stack. |
| Dim top plate | Enum | Yes | Includes the top plate height in the vertical dimension stack. |
| Dim bottom plate | Enum | Yes | Includes the bottom plate height in the vertical dimension stack. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the dimensions based on changes to the model or properties. |
| Properties | Opens the Properties Palette to adjust the parameters listed above. |
| Erase | Removes the script and all generated dimensions from the drawing. |

## Settings Files
- **Filename**: `HSB_G-FilterGenBeams.mcr`
- **Location**: TSL Catalog path
- **Purpose**: Defines the filter lists available in the "Filter definition for GenBeams" dropdown.

## Tips
- **Consistent Layouts**: Enable "Offset in paperspace units" if you have multiple viewports at different scales. This ensures the gap between the wall and the dimension line looks the same on paper for all views.
- **Trimmer Dimensions**: To dimension the size of the timber trimmers (studs/jacks) around a window rather than the rough opening, set **Mode** to "Closest beams".
- **Clutter Reduction**: Use "Filter openings with description" to dimension only specific types (e.g., only "Door" openings) while ignoring windows.
- **Missing Dimensions**: If dimensions do not appear, check that your filters are not too restrictive (e.g., an incorrect Zone or Beamcode filter). The script will exit silently if it finds no valid geometry.

## FAQ
- **Q: Why are my dimensions way too far away from the model?**
- **A: Check the "Offset in paperspace units" property. If it is set to "No", the offset is in ModelSpace (mm). If it is "Yes", it is in PaperSpace (mm on paper). Switching between these can cause drastic changes in distance.
  
- **Q: How do I dimension from a specific grid line or zone instead of the wall start?**
- **A: Set **Reference type** to "Zone" and enter the specific zone index in "Reference zone index". The dimensions will start from the first beam found in that zone.

- **Q: The script measures the rough opening, but I need the clear opening for the window.**
- **A: Change the **Mode** property from "Outline" to "Closest beams". Ensure your beam filters allow the script to "see" the trimmer studs.
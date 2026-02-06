# hsbLayoutDimCustomObjects.mcr

## Overview
This script automatically creates dimension lines in PaperSpace (Layouts) based on the content of a selected Model Space viewport. It detects TSL objects (like windows or doors), openings, and structural zones to generate precise elevation dimensions for your drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | Dimensions are created in PaperSpace. |
| Paper Space | Yes | This is the primary environment for this script. |
| Shop Drawing | Yes | Used for detailing views on production drawings. |

## Prerequisites
- **Required Entities**: An existing Layout (PaperSpace) with a Viewport that is linked to an hsbCAD Element.
- **Minimum Beams**: None (Works with Elements and TSLs).
- **Required Settings**: The Element linked to the viewport must contain TSL objects (e.g., `hsbWindow`, `hsbDoor`) or structural zones to generate dimensions.

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT`
1.  Type `TSLINSERT` in the command line.
2.  Browse and select `hsbLayoutDimCustomObjects.mcr`.
3.  The Properties Palette may appear immediately to configure initial settings.

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the viewport in the Layout that displays the Element you want to dimension.
```

### Step 3: Set Insertion Point
```
Command Line: insertion point
Action: Click in the PaperSpace to define where the dimension lines (and description alias) will be placed.
```

## Properties Panel Parameters

### General Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimstyle | dropdown | (empty) | Select the visual style (arrows, text font) from your CAD's pre-defined dimension styles. |
| Description Alias | text | (empty) | Enter a label to identify the view (e.g., "Wall Elevation"). This text appears at the insertion point. |
| Color | number | 171 | Sets the AutoCAD color index for the dimension lines and text. |
| Scale Factor | number | 1.0 | Multiplies the size of the dimension features (text height, arrow size) relative to the viewport scale. |

### Object Filtering
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Include entities of Zone | text | (empty) | Filters which structural zones to dimension. Separate multiple zone names with `;` (e.g., "EndZone;MiddleZone"). |
| TSL byName | text | (empty) | Filters dimensions by specific TSL script names. Separate names with `;` (e.g., "hsbWindow;hsbDoor"). |
| TSL byColor | text | (empty) | Filters dimensions by the color index of the TSL objects. Separate indices with `;`. |
| Filter Reference Zone | text | (empty) | Filters which structural zones act as the bounding box for reference points. |

### Horizontal Dimensions
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| RefModeHor | dropdown | Element | Determines reference points: `Element` (overall width), `Reference Zone`, `Opening`, `Opening+Walls`, or `Walls`. |
| DisplayModeHorDelta | dropdown | Parallel | Controls orientation of individual measurements: `Parallel`, `Perpendicular`, or `None`. |
| DisplayModeHorChain | dropdown | Parallel | Controls orientation of continuous measurements: `Parallel`, `Perpendicular`, or `None`. |

### Vertical Dimensions
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| RefModeVer | dropdown | Element | Determines vertical reference points (e.g., `Element`, `Reference Zone`, `Opening`). |
| DisplayModeVerDelta | dropdown | Perpendicular | Controls orientation of individual vertical measurements. |
| DisplayModeVerChain | dropdown | Perpendicular | Controls orientation of continuous vertical measurements. |
| TSL by Instance | dropdown | No | **Yes**: Creates individual vertical dimensions for each filtered TSL. **No**: Creates one global vertical dimension for the whole element. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add Point | Allows you to click a location in the viewport to add a custom user-defined dimension reference point. |
| Delete Point | Allows you to click near a custom point to remove it from the dimension calculation. |
| Delete all Points | Removes all custom points associated with the current Element/Script instance. |
| Delete all Points of all Elements | Clears all custom points stored by this script for every element in the project. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: This script relies entirely on the Properties Palette parameters and the geometry of the selected Element.

## Tips
- **Filtering**: If no dimensions appear, check your **TSL byName** or **Include entities of Zone** filters. If the filter does not match any objects in the model, the script will produce no output.
- **Separators**: When entering multiple items in text fields (like Colors or Zones), ensure you separate them with a semicolon and a space (`; `).
- **TSL by Instance**: Set **TSL by Instance** to "Yes" if you want each window or door to have its own separate height dimension line next to it, rather than one long vertical dimension chain for the whole wall.
- **Map-Based Points**: Use the **Add Point** right-click option to manually add dimension points for unique geometry that the automatic filters might miss.

## FAQ
- **Q: Why did my dimensions disappear after I changed the Display Modes?**
  **A:** If you set all Display Modes (Delta and Chain for both Horizontal and Vertical) to "None", the script detects this as an invalid state and resets the Delta modes to their defaults ("Parallel" and "Perpendicular") to ensure something is drawn.
- **Q: Can I dimension walls that are not rectangular?**
  **A:** This script works best with orthogonal elevations. It calculates references based on bounding boxes of the selected elements or openings.
- **Q: How do I change the arrow style?**
  **A:** Use the **Dimstyle** property to select a pre-defined AutoCAD dimension style that matches your company standards.
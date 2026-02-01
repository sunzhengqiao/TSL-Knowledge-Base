# HSB_D-Outline.mcr

## Overview
This script automatically generates dimension lines and 2D outlines for timber frame walls or floors in Paper Space shop drawings. It calculates the dimensions based on the 3D geometry visible in a selected viewport.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script must be inserted in Paper Space. |
| Paper Space | Yes | The script operates within the layout to dimension views of Model Space elements. |
| Shop Drawing | Yes | This is specifically designed for creating production drawings. |

## Prerequisites
- **Required Entities**: A Viewport in Paper Space that is currently viewing a valid hsbCAD Element (Wall or Floor).
- **Minimum Beam Count**: 0 (Dimensions are based on the Element's bounding box or specific filtered beams).
- **Required Settings**: The catalog `HSB_G-FilterGenBeams` must be present in the project to use advanced filtering options.

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT`
**Action:** Browse and select `HSB_D-Outline.mcr`.

### Step 2: Select a Viewport
```
Command Line: Select a viewport
Action: Click on the border or inside the viewport that displays the element you want to dimension.
```

### Step 3: Select Position
```
Command Line: Select a position
Action: Click in the Paper Space layout to place the script instance label (this marks where the script is located but does not determine the dimension location).
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Filter** | | | |
| Filter definition for GenBeams | dropdown | | Select a predefined filter from the `HSB_G-FilterGenBeams` catalog to determine which beams are included. |
| Filter beams with beamcode | text | | Enter beam codes (e.g., "WAL;PLT") to filter elements by their structural role. |
| Filter beams and sheets with label | text | | Enter labels to include only elements matching specific label names. |
| Filter beams and sheets with material | text | | Enter material names to filter elements by specific material grades. |
| Filter beams and sheets with hsbID | text | | Enter specific hsbCAD IDs to target unique elements. |
| **Dimension object** | | | |
| Zone | dropdown | 0 | Sets the construction layer (0-10) to calculate dimensions from. Useful for multi-layer walls. |
| Draw outline | dropdown | Yes | Toggles the visibility of the 2D outline polyline. Choose "No" to show dimensions only. |
| **Positioning** | | | |
| Position | dropdown | Angled aligned | Sets dimension orientation: "Angled aligned" follows wall slope, "Angled Perpendicular" projects perpendicularly, "Straight" creates horizontal/vertical dimensions. |
| Offset in paperspace units | dropdown | Yes | If "Yes", the offset distance is scaled by the viewport zoom (consistent print size). If "No", it uses real-world Model Space units. |
| Offset dimension line | number | 100.0 | The distance between the element outline and the dimension line. |
| **Style** | | | |
| Color dimension | number | -1 | Sets the color index for the dimension lines (-1 = ByBlock). |
| Dimension style | dropdown | System Default | Selects the CAD dimension style (text size, arrows) to apply. |
| Color outline | number | -1 | Sets the color index for the outline polyline (-1 = ByBlock). |
| Linetype outline | dropdown | System Default | Selects the line type (e.g., Continuous, Hidden) for the outline. |
| Prefix | text | | Text added before the dimension value (e.g., "L: "). |
| Suffix | text | | Text added after the dimension value (e.g., " mm"). |
| **Reference** | | | |
| Reference side frame | dropdown | Inside | Determines if the outline reference is the Inside or Outside face of the element. |
| **Name and description** | | | |
| Default name color | number | -1 | Color of the script label text in the drawing. |
| Filter other element color | number | 30 | Color used to indicate that a filter is active for other elements in the drawing. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Filter this element** | Adds the current element to a global exclusion list. The script will stop generating geometry for this specific element. |
| **Remove filter for this element** | Removes the current element from the exclusion list, allowing the script to generate geometry again. |
| **Remove filter for all elements** | Clears the entire exclusion list for this script type. |
| **Disable the tsl** | Turns off the script instance entirely. It will remain in the drawing but will not calculate or draw anything until re-enabled. |

## Settings Files
- **Filename**: `HSB_G-FilterGenBeams`
- **Location**: Project Catalog or hsbCAD Company/Install path
- **Purpose**: Defines the logic for the "Filter definition for GenBeams" dropdown, allowing complex pre-configured selection of beams (e.g., "Only Top Plates").

## Tips
- **Consistent Drawings**: Enable "Offset in paperspace units" to ensure dimension lines look the same distance away from the wall on all drawings, regardless of the viewport scale.
- **Complex Walls**: If dimensioning a wall with different inner/outer layers, adjust the **Zone** parameter. For example, setting Zone to 1 might target the inner leaf, while 0 targets the overall bounding box.
- **Clean Dimensions**: If you only want overall dimensions and not every stud, use the **Filter definition** or **Filter beams with beamcode** to exclude internal members.

## FAQ
- **Q: Why do my dimensions disappear when I zoom in/out?**
  - **A:** Check the **Offset in paperspace units** property. If set to "No", the offset is in Model Space units and may appear to move drastically relative to the viewport frame. Usually, this should be "Yes" for shop drawings.
- **Q: The outline is not where I expect it to be.**
  - **A:** Check the **Reference side frame** property. It defaults to "Inside". If you are looking at the exterior of the building, switch this to "Outside".
- **Q: Can I dimension only the longest walls?**
  - **A:** Not directly by length in this script, but you can use the **Filter beams with label** property to only dimension elements tagged with a specific label (e.g., "Ext-Wall").
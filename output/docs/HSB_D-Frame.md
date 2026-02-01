# HSB_D-Frame.mcr

## Overview
Automates the dimensioning of the outer frame or angled segments of structural elements (walls/floors) directly in Paper Space layouts. It creates clean, scale-independent production drawings by filtering specific structural members and calculating precise boundary dimensions.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | The script reads geometry from Model Space but operates in Paper Space. |
| Paper Space | Yes | You must select a Viewport that displays an hsbCAD Element. |
| Shop Drawing | Yes | Intended for creating detailed production drawings. |

## Prerequisites
- **Required Entities:** A Layout (Paper Space) containing a Viewport.
- **Element Data:** The selected Viewport must reference a valid hsbCAD Element (e.g., a Wall or Floor) with generated beams.
- **Required Settings:** The script relies on `HSB_G-FilterGenBeams.mcr` to provide filter definitions.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_D-Frame.mcr`

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the viewport in Paper Space that contains the element you wish to dimension.
```

### Step 3: Select Position
```
Command Line: Select a position
Action: Click in Paper Space to set the origin point for the dimension line and label.
```

## Properties Panel Parameters

### Filter Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Filter definition for GenBeams** | dropdown | *Empty* | Select a predefined filter set (from the catalog) to determine which beams are included. |
| **Filter beams with beamcode** | text | *Empty* | Enter a Beam Code (e.g., "STUD", "PLATE") to include only those beams. |
| **Filter beams and sheets with label** | text | *Empty* | Enter a label to filter elements by their assigned label. |
| **Filter beams and sheets with material** | text | *Empty* | Enter a material name to include only beams of that material. |
| **Filter beams and sheets with hsbID** | text | *Empty* | Enter a specific hsbID to dimension only that unique element. |

### Frame Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Dimension object** | dropdown | Frame | Choose what to dimension: `Frame` (overall size), `Angled segments` (sloped edges), or `Angles` (degree values). |
| **Frame side** | dropdown | Inside | Measure to the `Inside` face or `Outside` face of the beams. |
| **Use minimum frame** | dropdown | No | If **Yes**, calculates dimensions based only on vertical studs and connected beams, ignoring overhangs. |
| **Draw outline** | dropdown | Yes | Toggles the visibility of the polyline representing the frame boundary. |

### Position & Style
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Range** | number | 0 | Limits the length of the dimension chain from the insertion point (0 = unlimited). |
| **Ang size** | number | 15 | The size/radius of the arc drawn for angle dimensions. |
| **Position** | dropdown | *Varies* | Sets the dimension location relative to the frame (e.g., Vertical left, Horizontal bottom). |
| **Offset dimension line** | number | 100 | Distance between the frame outline and the dimension line. |
| **Use PS units for offset** | dropdown | Yes | If **Yes**, the offset is fixed in Paper Space. If **No**, it scales with the Viewport. |
| **Nr of dim points required** | number | 2 | Minimum number of points needed to generate a dimension segment. |
| **Reference** | dropdown | No reference | Adds extension lines pointing to a reference coordinate system (e.g., Grid). |
| **Disable the tsl** | dropdown | No | Temporarily turns off the script without deleting the instance. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Filter this element** | Stops dimensioning for this specific element and highlights it to indicate it is filtered out. |
| **Remove filter for this element** | Re-enables dimensioning for this specific element if it was previously filtered. |
| **Remove filter for all elements** | Clears all stored filters, restoring dimensioning for all instances using this script. |

## Settings Files
- **Filename**: `HSB_G-FilterGenBeams.mcr`
- **Purpose**: Provides the catalog of predefined filter definitions available in the "Filter definition for GenBeams" dropdown. This allows you to save and reuse complex beam selection criteria.

## Tips
- **Consistent Offsets:** Keep "Use PS units for offset" set to **Yes** to ensure dimension lines stay at a fixed distance from the drawing, regardless of the viewport scale.
- **Partial Dimensions:** Use the "Range" property if you only want to dimension a specific section of a long wall without creating a new script instance.
- **Gable Walls:** Set "Dimension object" to `Angled segments` when dimensioning gable walls to get the individual lengths of the sloped top plates instead of the overall bounding box.
- **Moving the Label:** You can click and drag the text label (created at the insertion point) to move the dimension origin and label location.

## FAQ
- **Q: Why are my dimensions not appearing?**
- **A:** Check if "Disable the tsl" is set to **No**. Ensure your Viewport contains valid hsbCAD data and that your Filter settings are not too restrictive (try clearing the filter strings to test).

- **Q: How do I dimension only the structural studs and ignore the cladding/sheeting?**
- **A:** Use the "Filter beams with beamcode" field to enter the code for your studs (e.g., "STUD"), or use a Filter Definition that excludes sheeting materials.

- **Q: The dimension line moves when I change the viewport scale.**
- **A:** Change the "Use PS units for offset" property to **Yes**. This locks the offset distance to Paper Space units rather than Model Space units.
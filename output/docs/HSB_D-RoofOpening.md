# HSB_D-RoofOpening.mcr

## Overview
This script automates the detailing and dimensioning of roof openings (such as skylights, dormers, and service penetrations) in 2D shop drawings. It generates precise dimensions, outlines, and labels for openings across Front, Side, and Top views within Paper Space layouts.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed for drawings/annotations, not 3D modeling. |
| Paper Space | Yes | Script must be run within a Shop Drawing viewport. |
| Shop Drawing | Yes | Required to calculate the correct transformation between Model and Paper Space. |

## Prerequisites
- **Required Entities:** Elements (walls/roofs) containing openings or custom TSL instances (e.g., skylights).
- **Context:** An active hsbCAD Shop Drawing layout with at least one viewport.
- **Minimum Requirements:** At least one Element with an opening in the active drawing region.

## Usage Steps

### Step 1: Launch Script
1. Open your hsbCAD Shop Drawing layout.
2. Type `TSLINSERT` in the command line and press Enter.
3. Select `HSB_D-RoofOpening.mcr` from the list and click Open.

### Step 2: Insert Instance
1. Click inside the viewport where you want the opening details to appear.
2. The script will process the visible elements and draw the opening details based on default settings.

### Step 3: Configure Properties
1. Select the newly inserted script instance.
2. Open the **Properties Palette** (press `Ctrl + 1`).
3. Adjust the parameters (listed below) to filter which openings to show and how to dimension them.
4. The drawing will update automatically when properties are changed.

## Properties Panel Parameters

### Filter Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Section tsl name | dropdown | (Empty) | Selects the specific Section View script to apply these settings to. |
| Filter beams with beamcode | text | (Empty) | Filters structural elements by their Beam Code (supports wildcards like `*`). |
| Filter beams and sheets with label | text | (Empty) | Filters elements by their assigned label. |
| Filter beams and sheets with material | text | (Empty) | Filters elements by material name. |
| Filter beams and sheets with hsbID | text | (Empty) | Filters elements by their unique hsbID. |
| Filter zones | text | (Empty) | Filters elements by zone name. |
| Filter type | dropdown | Exclude | Sets the logic for the description filter: *Include* (show matches) or *Exclude* (hide matches). |
| Filter openings with description | text | (Empty) | Filters openings based on text in their description (e.g., "SKY" for skylights). |

### Dimension Object Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension type | dropdown | Opening size | **Opening size:** Draws linear dimensions. **Cross:** Draws an 'X' marker instead of dimensions. |
| Show description | dropdown | Yes | Toggles the visibility of the opening description text label. |
| Show frame | dropdown | Yes | Toggles the drawing of the physical perimeter (outline) of the opening. |
| New line character | text | ; | Character used to split long text descriptions into multiple lines (e.g., "Floor;Sky" splits into two lines). |

### Positioning Settings
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Orientation dimension line | dropdown | Horizontal | Aligns dimension lines horizontally or vertically relative to the view. |
| Side dimension line | dropdown | Left | Places dimensions to the Left, Right, or Center of the opening. |
| Dimension line per opening | dropdown | No | **Yes:** Individual dimension lines per opening. **No:** Chain dimensions for all openings. |
| Position reference | dropdown | Opening | **Opening:** Offset from the opening edge. **Element:** Offset from the element edge (consistent spacing). |
| Offset in paperspace units | dropdown | Yes | **Yes:** Offsets are fixed paper distances (mm). **No:** Offsets scale with the view. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Filter this element | Automatically updates the "Filter beams..." properties in the OPM to match the element currently selected in the drawing. |
| Remove filter | Clears all text from the filter properties in the OPM, displaying all openings. |

## Tips
- **Multi-line Labels:** If your opening descriptions are long, use the `New line character` property (e.g., set to `/` or `;`) to make the text stack neatly in the drawing.
- **Filtering Views:** Use the `Section tsl name` property to apply different dimensioning styles to different viewports (e.g., dimensions in Front view, crosses in Top view).
- **Clean Drawings:** If dimensions become cluttered, set `Dimension line per opening` to "No" to create a clean chain dimension line.
- **Skylights:** Use the `Filter openings with description` to isolate specific items (e.g., type "SKY" to hide standard vents and show only skylights).

## FAQ
- **Q: Why did the script not draw anything?**
  - **A:** Ensure you are inside a Paper Space viewport (Shop Drawing) and that the viewport is active. The script requires the Model-to-Paper Space transformation to function.
- **Q: My dimensions are too small or huge.**
  - **A:** Check the `Offset in paperspace units` property. If set to "No", your offsets are scaling with the drawing zoom. Set it to "Yes" to keep text and lines at a constant readable size on paper.
- **Q: Can I show dimensions for skylights but only outlines for vents?**
  - **A:** You would need to insert the script twice. Configure one instance to filter "SKY" with Dimension type "Opening size" and the other to filter "VENT" with Dimension type "Cross".
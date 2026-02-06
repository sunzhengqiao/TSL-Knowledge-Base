# hsbX-Marking.mcr

## Overview
This script automatically generates position marks (text) and visual indicator lines on timber beams. It detects intersections between selected elements (such as roof planes or purlins) and target beams, applying annotations to indicate assembly locations.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates exclusively in the 3D model. |
| Paper Space | No | Not applicable for 2D drawings. |
| Shop Drawing | No | Marks are applied to the 3D model for production or detailing. |

## Prerequisites
- **Required Entities**: You must have at least two sets of elements in the model:
    - **Marking Entities**: Roof planes, beams, or trusses that define *where* the mark should be placed.
    - **Target Beams**: The beams you want to mark (e.g., rafters or studs).
- **Minimum Beam Count**: At least one marking entity and one target beam that physically intersect.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbX-Marking.mcr`
*Alternatively, drag and drop the script from your catalog browser into the model.*

### Step 2: Configure Properties (Optional)
Upon insertion, a properties dialog may appear (depending on your configuration).
- Adjust settings such as **Prefix**, **Text Position**, or **Color** if needed.
- Click OK to confirm.

### Step 3: Select Marking Entities
```
Command Line: Select marking entities (roofplane and/or beams and/or trusses)
Action: Click on the elements that define the intersection line (e.g., a purlin crossing several rafters). Press Enter to confirm selection.
```

### Step 4: Select Target Beams
```
Command Line: Select beams to be marked
Action: Click on the beams that require the marking (e.g., the rafters intersected by the purlin selected in Step 3). Press Enter to confirm.
```

### Step 5: Generation
The script calculates intersections and automatically places the marks and lines on the selected beams.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Face of marking | dropdown | Front | Selects which side of the beam receives the mark (Front, Top, Back, Bottom). |
| Side of marking | dropdown | Both | Determines the placement along the intersection: Both edges, Left edge, Center, Right edge, or None. |
| Prefix | text | | Adds custom text before the automatic position number (e.g., "W-" for Wall). |
| Autotext | dropdown | PosNum | Sets the text content: Position Number, Position Number + Text comment, or None. |
| Text Position | dropdown | Bottom | Vertical alignment of the text relative to the marking line (Bottom, Center, Top). |
| Text Alignment | dropdown | Right | Horizontal justification of the text (Right, Center, Left). |
| Text Direction | dropdown | normal | Controls the reading orientation (e.g., normal, upside down, vertical). |
| Direction of marking | dropdown | Along marking beam | **Key Setting**: <br>• *Along marking beam*: Follows the angle of the intersecting element.<br>• *Recangular on marked beam*: Projects the mark vertically/horizontally relative to the beam. |
| Color | number | 92 | Sets the CAD color index for the marking lines and text. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Mark top edge | Switches the marking location to the top intersection edge. (Only available when "Direction of marking" is set to "Recangular on marked beam"). |
| Mark bottom edge | Switches the marking location to the bottom intersection edge. (Only available when "Direction of marking" is set to "Recangular on marked beam"). |

## Settings Files
- None required. This script relies on the geometric properties of the selected entities and standard OPM (Object Property Model) inputs.

## Tips
- **Distributor Behavior**: This script acts as a "distributor." Once it runs, it creates individual marks on the beams and the main script instance is removed. To edit marks later, select the specific mark on the beam and adjust its properties in the Properties Palette.
- **Rectangular Mode**: If you need to toggle the mark between the top and bottom edge of a connection (e.g., on a plate), set **Direction of marking** to "Recangular on marked beam" and use the Right-Click menu on the specific mark.
- **Intersections Required**: Ensure elements physically touch or overlap within the default tolerance (approx. 5mm). If beams are parallel or too far apart, no mark will be generated.

## FAQ
- **Q: Why did no marks appear on my beam?**
  **A:** The script skips beams that are parallel to the marking element or do not physically intersect within the tolerance range. Check your geometry to ensure the elements actually cross each other.

- **Q: How can I change the text after inserting?**
  **A:** Select the specific marking (line or text) on the beam. Open the Properties Palette (Ctrl+1) and modify the **Prefix**, **Text Position**, or **Autotext** fields.

- **Q: Can I mark multiple beams at once?**
  **A:** Yes. In Step 4, you can window select multiple beams. The script will loop through all selected beams and place marks where they intersect with the entities selected in Step 3.
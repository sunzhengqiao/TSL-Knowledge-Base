# HSB_E-DistributeSheeting.mcr

## Overview
This script automates the distribution of sheeting materials (e.g., OSB, plywood) within a defined area. It allows users to generate a grid of sheets based on specified dimensions, gaps, and rotation, handling complex boundary shapes through addition and subtraction.

## Usage Environment

| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Recommended to be used in an Elevation View. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: A closed Polyline (`EntPLine`) or an existing `Sheet` entity to define the boundary.
- **Minimum Beam Count**: 0.
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
**Command:** `TSLINSERT` → Select `HSB_E-DistributeSheeting.mcr`

### Step 2: Define Area
```
Command Line: Select closed polyline or sheet [Sheet/EntPLine]:
Action: Click on a closed polyline or an existing sheet in the drawing to define the sheathing boundary.
```

### Step 3: Set Start Point
```
Command Line: Start point of distribution:
Action: Click in the drawing to specify where the sheet distribution should begin (_Pt0).
```

### Step 4: Configure Properties
**Action:** The script will insert. Open the **Properties Palette** (Ctrl+1) to adjust sheet dimensions, material, gaps, and rotation.

### Step 5: Modify Geometry (Optional)
**Action:** Use the grip point `_Pt0` in the model to drag the start of the distribution grid. The sheets will regenerate automatically.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Length | Double | - | The length of the individual sheets to be generated. |
| Width | Double | - | The width of the individual sheets to be generated. |
| Gap X | Double | 0 | The gap between sheets along the X-axis. |
| Gap Y | Double | 0 | The gap between sheets along the Y-axis. |
| Sheet Angle | Double | 0.0 | The rotation angle applied to the sheets. |
| Direction | Integer | 0 | Specifies the primary direction of the distribution grid. |
| Material | String | - | The material assigned to the generated sheets. |
| Material Hatch | String | - | The hatch pattern used for the area visualization. |
| Draw area hatch | Boolean | - | If true, draws a hatch representing the total distribution area. |
| Color | Integer | - | The color index for the generated sheets. |
| Assign to element | Boolean | No | If checked, assigns the new sheets to the Element of the original selected entity. |
| Assign to floorgroup | Entity | - | The Floor Group to which sheets are assigned (if "Assign to element" is No). |
| Zone Index | Integer | - | The zone index for the generated sheets. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add area | Prompts the user to select an additional polyline or sheet to merge with the current sheathing area. |
| Subtract area | Prompts the user to select a polyline or sheet to create an opening (hole) within the current sheathing area. |

## Settings Files
- None required.

## Tips
- **Modifying Existing Layouts**: If you select an existing `Sheet` entity during insertion, the script will use its envelope as the boundary and replace the original sheet with the new distribution.
- **Complex Shapes**: For areas with openings like windows or doors, insert the script on the outer boundary first, then use the **"Subtract area"** right-click option to cut out the openings.
- **Grip Editing**: You can dynamically adjust the layout by dragging the `_Pt0` grip point in the drawing rather than typing coordinates.
- **Performance**: The script limits generation to a maximum of 500 rows and 500 columns to prevent system overload.

## FAQ
- **Q: What happens if I select an invalid group?**
  A: The script will report "Invalid group selected" in the command line and stop generation. Ensure a valid Floor Group is selected in the properties if "Assign to element" is disabled.
- **Q: Can I change the sheet angle after insertion?**
  A: Yes, you can change the "Sheet Angle" and "Distribution Direction" in the Properties Palette at any time, and the sheets will update.
- **Q: How do I reset the start point?**
  A: Simply click and drag the `_Pt0` grip point visible in the drawing to the desired location.
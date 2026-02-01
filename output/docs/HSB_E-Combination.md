# HSB_E-Combination.mcr

## Overview
This script combines selected roof elements into a single production or transport unit. It calculates optimal dimensions (including gaps and rounding) and visualizes the combined assembly to verify fit and logistics.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be inserted in 3D Model Space. |
| Paper Space | No | Not applicable for drawing generation. |
| Shop Drawing | No | This is a planning/modeling tool. |

## Prerequisites
- **Required Entities**: 1 or 2 `ElementRoof` objects.
- **Minimum Count**: 1 Element (Optimized for 2).
- **Requirements**: Selected elements must belong to the same **FloorGroup**.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Select `HSB_E-Combination.mcr` from the file dialog.

### Step 2: Select Elements
```
Command Line: Select one or two elements
Action: Click on the first roof element, then optionally click on a second roof element. Press Enter to confirm selection.
```
*Note: The script will verify that the selected elements are on the same floor.*

### Step 3: Position Visualization
```
Command Line: Select a position to visualize the combination
Action: Click anywhere in the empty Model Space to place the visualization marker.
```

## Properties Panel Parameters
Double-click the script instance in the model to open the Properties Palette and modify parameters.

### Combination
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Combination type | Dropdown | Length combination | Choose to join elements end-to-end (Length) or side-by-side (Width). |
| Gap between elements | Number | 40 mm | Physical space allowed between elements for connections or lifting. |
| Optimized width | Number | 1020 mm | Target width for the combined unit (0 = use actual calculated width). |
| Extra width | Number | 2 mm | Additional margin added to the total width. |

### Dimension
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Maximum length | Number | 8000 mm | Maximum allowable length for the combination (transport limit). |
| Round length to | Number | 250 mm | Rounds the total length to the nearest increment (e.g., modular planning). |
| Dimension style | Dropdown | *Project Default* | Selects the drafting style for dimension labels. |
| Offset dimension lines | Number | 200 mm | Distance between the geometry and the dimension lines. |

### Visualization
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Show outline | Dropdown | Yes | **Yes**: Shows a 2D outline. **No**: Shows the full 3D solid bodies. |
| Linetype back | Dropdown | *Project Default* | Line style used for hidden/back edges of the outline. |

## Right-Click Menu Options
The script uses standard TSL context options:

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the geometry based on changes to the source elements or properties. |
| Erase | Removes the script instance from the model. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script does not rely on external XML settings files. It uses standard AutoCAD Dimension Styles and Line Types.

## Tips
- **Validation**: If you see an error "Elements are not part of the same floorgroup", check your Project Manager to ensure both elements are assigned to the same floor/group.
- **Existing Combinations**: You cannot combine an element that is already part of another combination. You must remove the existing script instance first.
- **3D Verification**: Change `Show outline` to **No** if you want to see exactly how the 3D bodies (beams/plates) fit together in the combined layout.
- **Updating**: If you modify the original roof elements, select the combination script instance and right-click **Recalculate** to update the dimensions.

## FAQ
- **Q: Can I combine more than two elements?**
  A: No, this script is designed to combine a maximum of two elements at a time.
- **Q: What does the "Optimized width" do?**
  A: If set to a value greater than 0, it forces the combined unit to be a perfect rectangle of that width, ignoring the actual width of the source elements. This is useful for standardizing production sizes.
- **Q: Why did the script disappear after insertion?**
  A: This usually happens if you selected more than 2 elements, or if the selected elements were invalid (e.g., had no geometry outline). Check the command line history for specific error messages.
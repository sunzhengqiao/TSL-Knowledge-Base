# Merk Stutzenfuss K1

## Overview
Inserts a "Merk" brand post shoe (column base) hardware component into vertical timber posts. It generates the 3D hardware visualization and automatically applies the necessary trimming and drilling machining to the beam.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model to modify beam geometry and add bodies. |
| Paper Space | No | Not designed for 2D drawings or layouts. |
| Shop Drawing | No | Not a shop drawing generation script. |

## Prerequisites
- **Required Entities**: `GenBeam` (The timber post/column).
- **Minimum beam count**: 1
- **Required settings**: None. (Can use standard Catalogs for preset values).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or run `Merk Stutzenfuss K1.mcr` from the script menu).
*   **Action**: If executed via `TSLINSERT`, select the script file from the file browser.

### Step 2: Configure Dimensions (Optional)
*   **Condition**: This step occurs if you do not use a specific Catalog Key during insertion.
*   **Action**: A dialog will appear displaying parameters like Height, Diameter, and Baseplate dimensions. Adjust these values as needed for your connection.

### Step 3: Select Post
```
Command Line: Select post(s)
Action: Click on the timber beam(s) (posts) where you want to install the base. Press Enter to confirm selection.
```

### Step 4: Define Insertion Point
```
Command Line: Select insertion point
Action: Click on the beam or in 3D space to define the location of the post base. This point typically defines where the rod enters the timber.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Height | Number | 200 mm | The depth the metal rod inserts into the timber post. This defines the reference point for the cut. |
| Total Height | Number | 300 mm | The total length of the vertical metal rod. Must be greater than the Height value. |
| Diameter | Number | 40 mm | The thickness of the central metal rod. This controls the main drill hole size. |
| Extra Drilling Depth | Number | 0 mm | Additional depth drilled below the metal rod length (e.g., for drainage). |
| Depth Housing | Number | 20 mm | The depth of the counterbore (recess) required to sink the pressure plate into the timber. |
| Diameter Pressure Plate | Number | 75 mm | The diameter of the pressure plate (flange). This controls the width of the counterbore sink drill. |
| Width Base | Number | 100 mm | The width (X-axis) of the rectangular bottom baseplate. |
| Length Base | Number | 180 mm | The length (Y-axis) of the rectangular bottom baseplate. |
| Color | Number | 253 | The ACI color index used to display the hardware bodies in the model. |
| Group, Layername or Zone Character | Text | Z | Determines layer management. Can match a Group name, a single character code (T, I, J, Z, C), or a custom layer name. |

## Right-Click Menu Options
*Note: This script uses standard TSL behavior and does not define custom context menu items.*

| Menu Item | Description |
|-----------|-------------|
| Properties | Opens the Properties Palette to edit dimension parameters. |
| Erase | Removes the script instance and repairs the beam machining (if dynamic update is active). |

## Settings Files
- **Filename**: N/A (Internal Defaults)
- **Purpose**: The script uses internal default values, but can be linked to standard hsbCAD Catalogs (`.catalog` files) to load predefined configurations via the `_kExecuteKey` parameter.

## Tips
- **Vertical Orientation**: The script validates that the beam is vertical (like a post). If the script disappears immediately after insertion, check that your beam is oriented correctly (Local X axis aligned with World Z).
- **Grip Editing**: You can select the inserted hardware and drag the blue grip to move the insertion point up or down the post. The drilling and cuts will update automatically.
- **Relationship Check**: Ensure `Total Height` is always larger than `Height`. If not, the script will delete itself to prevent invalid geometry.
- **Layer Management**: Using the character "Z" in the Group property usually assigns the element to the Zone layer of the beam.

## FAQ
- **Q: Why did the script delete itself immediately after I selected the beam?**
  - A: The beam orientation check failed. This tool is designed for vertical columns only. Ensure the beam's local X-axis is pointing vertically (World Z).
- **Q: Why did the script delete itself after changing properties?**
  - A: You likely set the `Total Height` to be smaller than the `Height`, or set a Diameter to 0. Correct these values in the Properties Panel.
- **Q: Can I use this on inclined beams?**
  - A: No, the script explicitly checks for vertical posts ("The Tool may only be inserted at the bottom of a beam which is like a post").
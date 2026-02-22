# GE_BEAM_POST_TO_WALL

**Version:** 1.5
**Author:** David Rueda (dr@hsb-cad.com)
**Date:** 03.nov.2013
**Category:** Generic Angle Brackets (GA)

## Overview

Places horizontal lumber pieces (beams) between a post and a wall. This script creates multiple horizontal beams that span from a vertical post to connect with a wall element, automatically cutting the beams to fit the wall surface. This is ideal for creating ledger supports, blocking, or nailers between posts and walls.

## Features

- Creates multiple horizontal beams between a post and wall
- Supports different distribution patterns (left-to-right, centered, right-to-left)
- Integrates with lumber inventory system for automatic material and grade selection
- Allows manual override of beam properties
- Automatically cuts beams to fit wall surface
- Supports custom beam properties (color, name, material, grade, labels)

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates in the 3D model environment. |
| Paper Space | No | Not designed for 2D layouts or shop drawings. |
| Shop Drawing | No | Does not generate detailing views. |

## Prerequisites
- **Required Entities**: A valid vertical GenBeam (Post) and a valid Element (Wall).
- **Minimum Beam Count**: 1 Post must exist in the model.
- **Required Settings**: Access to the company's Lumber Inventory (via `hsbFramingDefaults.Inventory.dll`).

## How to Use

1. **Select the Post**: Click on the vertical post where you want to attach the horizontal beams
2. **Select the Wall**: Click on the wall element where the beams will connect
3. **Configure Properties** (in the OPM - Object Properties Manager):
   - Number of beams to place
   - Distribution pattern
   - Lumber item (from inventory or manual selection)
   - Beam properties (size, color, type, material, grade, etc.)
4. **Place the Script**: The beams will be created automatically

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_BEAM_POST_TO_WALL.mcr`

### Step 2: Select Post
```
Command Line: Select Post (GenBeam)
Action: Click on the vertical post in the model where you want to attach the beams.
```

### Step 3: Select Wall
```
Command Line: Select Wall (Element)
Action: Click on the wall element that will define the trim line for the ends of the beams.
```

### Step 4: Configure Properties
After selection, the Properties Palette (OPM) will display.
```
Action: Adjust parameters such as beam count, distribution, lumber size, and material.
        The script will automatically calculate and generate the beams based on these settings.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Number of beams | Integer | 1 | The quantity of blocking beams to generate along the post. |
| Distribution | Dropdown | Centered | Alignment logic relative to the post centerline (Left to right, Centered, Right to left). |
| Lumber Item | String (Inventory) | *First Available* | The lumber profile from the inventory defining dimensions, material, and grade. |
| Size | Dropdown | From inventory | Manual override for nominal dimensions (e.g., 2x4, 2x6). If set, ignores inventory width. |
| Color | Integer | 32 | The AutoCAD Color Index (ACI) for the new beams. |
| Type | Dropdown | 12 (User defined) | The functional classification of the beam (e.g., Stud, Joist, Beam). |
| Material | String | Empty | Manual override for the wood species (e.g., SPF, GLULAM). |
| Grade | String | Empty | Manual override for the structural grade (e.g., SS, #2). |
| Name | String | Empty | Custom entity name. |
| Information | String | Empty | Additional descriptive text for manufacturing notes. |
| Label | String | Empty | Primary identifier for labeling/export. |
| SubLabel | String | Empty | Secondary identifier for labeling/export. |
| SubLabel2 | String | Empty | Tertiary identifier for labeling/export. |
| BeamCode | String | Empty | General classification code for data management. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script deletes itself immediately after generating the beams. Standard right-click options do not apply post-generation. |

## Settings Files
- **Filename**: `hsbFramingDefaults.Inventory.dll`
- **Location**: Defined in hsbCAD configuration (Utilities path).
- **Purpose**: Provides the default dimensions (Width/Height), Material, and Grade properties based on the selected Lumber Item.

## Tips
- Ensure the post is perfectly vertical; otherwise, the script will erase itself and report an error.
- If you receive an error that "beams are not suitable on post," reduce the **Number of beams** or select a smaller lumber size to fit within the post's width.
- The generated beams are created as standard GenBeams. Once created, they are independent of the script and can be edited manually using grips or the properties palette.

## FAQ
- **Q: Why did the script disappear after I ran it?**
  - A: This is a "generator" script. It creates the geometry and then deletes itself to avoid cluttering the drawing management. The resulting beams remain in the model.
- **Q: Can I change the number of beams after inserting?**
  - A: No, because the script instance is removed. To change the configuration, delete the generated beams and run the script again.
- **Q: What does "Selected number of beams are not suitable on post" mean?**
  - A: The total width of the specified beams (e.g., 3 beams x 50mm width = 150mm) exceeds the width of the post you selected. Use fewer beams or narrower lumber.

## Technical Details

### Validation Checks
1. **Post Orientation**: The post must be vertical (parallel to Z-axis)
2. **Space Availability**: The script checks if there's enough space on the post for the selected number of beams
3. **Data Completeness**: Validates that all required beam properties are properly filled

### Beam Creation Process
1. Calculates proper spacing based on distribution pattern
2. Creates new beams at the correct position and orientation
3. Applies all specified properties (color, name, material, grade, etc.)
4. Automatically cuts beams to fit the wall surface using a cut operation

### Distribution Patterns
- **Left to right**: Beams start from the far left and move right
- **Centered**: Beams are centered on the post, alternating outward
- **Right to left**: Beams start from the far right and move left

### Error Handling

If issues are encountered, the script will:
- Display error messages in the command line
- Automatically erase the instance if critical requirements aren't met
- Validate color values (must be between -1 and 255)
- Check for valid beam dimensions before creation

## Version History

- **v1.5** (03.nov.2013): Added stick frame path to mapIn when calling DLL
- **v1.4** (15.may.2012): Added thumbnail and description
- **v1.3** (25.jan.2012): Updated grade and material info from inventory, added beam props to manual definition
- **v1.2** (20.jul.2011): Added beam info set by user
- **v1.1** (17.jul.2011): Debugged
- **v1.0** (15.jul.2011): Initial release

## Usage Tips

1. Use the lumber inventory for quick standard beam selections
2. Manual overrides allow for custom beam specifications not in inventory
3. The centered distribution works well for odd numbers of beams
4. Ensure proper wall and post selection for best results
5. Check the command line for any error messages if beams aren't created
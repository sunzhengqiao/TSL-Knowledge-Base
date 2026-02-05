# HSB_W-KneeWallCreator.mcr

## Overview
Converts loose construction beams (studs, top/bottom plates) located within a selected roof or floor element into a formalized Knee Wall element. It automatically detects the wall geometry based on the top plate, applies cuts to the components, and assigns them to a new wall group for manufacturing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates exclusively in 3D Model Space to generate construction elements. |
| Paper Space | No | Not designed for 2D layout or annotation. |
| Shop Drawing | No | Not a drawing generation script. |

## Prerequisites
- **Required Entities**:
  - A source Element (e.g., Roof or Floor) containing loose GenBeams representing the knee wall framing.
  - A "Dummy" Group containing `ElementWallSF` templates to serve as the wall definition catalog.
- **Dependencies**:
  - `HSB_G-FilterGenBeams.tsl` must be available in the TSL search path.
- **Project Structure**:
  - Floor groups must be organized correctly (identified by name parts) for the script to detect valid target groups.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_W-KneeWallCreator.mcr`

### Step 2: Configure Properties
Before selecting elements, open the **Properties Palette (Ctrl+1)** to configure the script parameters.
1. Set the **Beam codes** to match the naming convention used in your project (e.g., "TP" for Top Plates, "STUD" for Studs).
2. Select the **Group name dummy knee walls** to load available wall templates.
3. Select the specific **Knee wall type** (template) you wish to generate.

### Step 3: Select Source Elements
```
Command Line: |Select elements|
Action: Click on the main Element (e.g., Roof or Floor) that contains the loose knee wall beams you wish to convert.
```
*Note: The script will process the beams inside this element based on the codes defined in Step 2.*

### Step 4: Automatic Processing
The script will automatically:
1. Filter beams by the specified codes.
2. Calculate the wall geometry based on the Top Plate locations.
3. Create the new Wall element and assign the filtered beams to it.
4. Apply orthogonal cuts to the start and end of the wall.
5. Place the new wall in the specified target group.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Beam codes top plates | Text | "" | Enter the beam code (e.g., "TP") used to identify the top plates. These beams define the wall's length and position. |
| Beam codes bottom plates | Text | "" | Enter the beam code (e.g., "BP") used to identify bottom plates to be included in the wall. |
| Beam codes studs | Text | "" | Enter the beam code (e.g., "STUD") used to identify vertical studs to be included in the wall. |
| Beam codes zone 6 | Text | "" | Enter the beam code for specific GenBeams (Zone 6) to be associated with the knee wall. |
| Group name dummy knee walls | Dropdown | "" | Select the source group (library) containing your `ElementWallSF` wall templates. |
| Knee wall type | Dropdown | "0" | Select the specific wall template (e.g., "Internal-90", "External-140") to generate. Options populate based on the Dummy Group selected. |
| Group name knee walls | Dropdown | "" | Select the target group where the new knee wall element should be placed (e.g., "1st Floor"). |

## Right-Click Menu Options
None defined. The script runs immediately upon insertion and entity selection.

## Settings Files
- **Dependency**: `HSB_G-FilterGenBeams.tsl`
- **Location**: TSL Search Path (Company or Install folder)
- **Purpose**: Filters the selected element's beams based on the specified beam codes.

## Tips
- **Beam Codes**: Ensure the codes entered in the properties match the actual codes of the loose beams in your element exactly. If the script creates nothing, check the spelling of these codes.
- **Top Plate Continuity**: The script calculates the wall start and end points based on the vertices of the beams identified as "Top Plates." Ensure these beams are placed accurately to define the correct wall length.
- **Template Setup**: Before running the script, ensure your "Dummy" group contains valid `ElementWallSF` entities with the desired construction layers.

## FAQ
- **Q: The script erases itself immediately without creating a wall. Why?**
  **A**: This usually happens if the script cannot find beams matching the specified "Beam codes" in the selected element. Check the Properties Palette to ensure the codes (e.g., for Top Plates) match the data in your model.
- **Q: How do I change the height or layer makeup of the wall?**
  **A**: The wall properties are derived from the "Knee wall type" template. You must modify the `ElementWallSF` template in the "Dummy" group or select a different template from the dropdown.
- **Q: Can I process multiple elements at once?**
  **A**: Yes, the script supports selecting multiple elements during the "Select elements" prompt. It will generate a knee wall for each valid selection.
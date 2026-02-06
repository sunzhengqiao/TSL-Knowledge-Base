# TruckDefinition.mcr

## Overview
Inserts a truck definition marker into the model to visualize loading areas, calculate load volumes, and manage logistics planning for timber transport. It allows users to define specific truck dimensions, visualize load profiles, and assign 3D representations to the truck.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script creates visual entities (polylines, bodies) in the model. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required entities**: None.
- **Minimum beam count**: 0.
- **Required settings**: None required.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `TruckDefinition.mcr` from the list.

### Step 2: Configure Truck Properties
```
Command Line: [Properties Dialog appears or Properties Palette opens]
Action: Select a "Truck Definition" from the dropdown list to load predefined dimensions.
        Optionally, modify Length, Width, Height, Tara (empty weight), or Max Gross Weight.
```

### Step 3: Select Location
```
Command Line: Select location
Action: Click in the Model Space to place the truck marker. The script will draw a visual representation at the selected point.
```

### Step 4: Edit Definition (Optional)
To define where timber packages will be placed on the truck:
1. Select the inserted TruckDefinition script in the model.
2. Right-click and choose **Edit Definition**.
3. Select **Add Load Profile** from the context menu.
4. **Input Method A (Draw)**: 
   - Pick an origin point.
   - Pick a second point to define the length axis.
   - Pick a third point to define the width (a dynamic rectangle will follow your cursor).
5. **Input Method B (Select)**:
   - Type `S` or select the option to pick existing Polylines in the drawing to define the load area.

### Step 5: Set Truck Display (Optional)
To add a visual 3D truck body (chassis/wheels) instead of a simple box:
1. Ensure you are in **Edit Definition** mode.
2. Right-click and select **Set truck display**.
3. Select the 3D Body entities in the drawing that represent the truck.
4. The script will save these entities as the visual display for this truck type.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Truck Definition (sDefinition) | dropdown | (List) | Selects the specific truck type from the library. Updates Length, Width, and Height automatically. |
| Length (dLength) | Number | 13600 | The total length of the truck's loading bed (mm). |
| Width (dWidth) | Number | 2480 | The total width of the truck's loading bed (mm). |
| Height (dHeight) | Number | 2700 | The maximum vertical stacking height for load volume calculation (mm). |
| Tara (dTara) | Number | 0 | The unladen (empty) weight of the truck (kg). |
| Max Gross (dMaxGross) | Number | 0 | The maximum legally permitted gross weight of the vehicle (kg). |
| Description (sDescription) | String | Empty | A user-defined label for this specific truck instance. |
| Dim Style (sDimStyle) | dropdown | _DimStyles... | Selects the CAD dimension style for annotations. |
| Text Height (dTextHeight) | Number | 0 | Overrides the dimension style text height. Enter 0 to use the style default. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Edit Definition | Toggles "Edit Mode". In this mode, you can add load profiles or change the truck display. Load profiles are highlighted in yellow. |
| Add Load Profile | (Only available in Edit Mode) Opens options to draw a new loading rectangle or select existing polylines to represent a cargo area. |
| Set truck display | (Only available in Edit Mode) Allows you to select 3D bodies to serve as the visual representation of the truck. |

## Tips
- **Edit Mode Geometry**: When in Edit Mode, load profiles are editable polylines. You can use standard AutoCAD Grips to stretch or move them to fit your packages precisely.
- **Volume Visualization**: The script extrudes the load profiles vertically up to the `Height` (dHeight) parameter to visualize the utilized volume.
- **Dynamic Updates**: Changing the `Length` or `Width` in the properties palette immediately updates the boundary box, but you must manually adjust load profiles if the truck size changes drastically.
- **Move/Rotate**: You can use standard AutoCAD `Move` or `Rotate` commands on the script instance to position the truck correctly within the site plan.

## FAQ
- **Q: How do I change the truck size after inserting it?**
  A: Select the truck, open the Properties palette (Ctrl+1), and change the `Length`, `Width`, or `Height` values.
- **Q: Why are my load profiles yellow?**
  A: Yellow profiles indicate that "Edit Definition" mode is active. Right-click and select "Edit Definition" again to toggle it off and return to the standard grey view.
- **Q: Can I use a specific 3D model for the truck?**
  A: Yes. Enable "Edit Definition", right-click, choose "Set truck display", and select the 3D bodies you wish to use.
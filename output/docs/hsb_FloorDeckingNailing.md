# hsb_FloorDeckingNailing

## Overview
Automates the generation of nailing patterns (NailLines) for floor or roof decking elements within hsbCAD. It calculates precise nail locations, spacing, and tool assignments based on specific zones and material filters to create manufacturing data for CNC machines or graphical representations for shop drawings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D construction elements. |
| Paper Space | No | Not designed for 2D layouts. |
| Shop Drawing | No | Generates data in the model environment only. |

## Prerequisites
- **Required Entities**: `ElementRoof` (Floor or Roof elements).
- **Minimum Beam Count**: 0 (The script operates on the sheets and beams contained within the selected Element).
- **Required Settings**: None.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the AutoCAD command line.
2.  Browse to and select `hsb_FloorDeckingNailing.mcr`.

### Step 2: Configure Parameters
```
Action: The Properties Palette (OPM) will appear automatically.
Instructions: Adjust the nailing settings (Zone, Spacing, Materials, etc.) before selecting elements.
Note: Changes made here apply to the elements you are about to select.
```

### Step 3: Select Elements
```
Command Line: Select one or More Elements
Action: Click on the desired Floor or Roof elements in the model view. Press Enter to confirm selection.
```

### Step 4: Execution
```
Action: The script calculates nailing lines for the selected elements and adds them to the model.
Result: The script instance removes itself from the drawing upon completion.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone to be Nail | dropdown | 1 | Selects the construction layer to nail. <br>• **1-5**: Layers on the primary side (e.g., top deck).<br>• **6-10**: Layers on the opposite side (e.g., bottom ceiling). |
| Nailing Tool index | number | 1 | Identifier for the nail gun or machine configuration. This also determines the color of the nail lines in the model. |
| Maximum nailing spacing | number | 200 mm | The maximum distance allowed between nails along the line. |
| Distance from beam edge | number | 9 mm | Setback distance from the end of the beam or sheet edge. Ensures nails are not placed too close to the timber ends to prevent splitting. |
| Zone Material to be Nailed | text | "" | Optional filter. If a material name is entered (e.g., "OSB"), nailing will only be applied to sheets matching that name. |
| Material beams to avoid | text | "CLS;" | List of beam materials to exclude from nailing. Default excludes "CLS" (timber trimmers). Separate multiple materials with a semicolon (;). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script is a "fire and forget" utility. Once executed, the script instance deletes itself. To modify nailing, run the script again on the elements. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: All configuration is handled via the Properties Panel during insertion.

## Tips
- **Updating Existing Nailing**: If you run the script on an element that already has nail lines generated with the same **Nailing Tool index**, the old lines will be deleted and replaced with the new calculations.
- **Visual Verification**: Nail lines are displayed in the color corresponding to the **Nailing Tool index**. If you do not see lines, check your layer visibility or display settings for that tool index.
- **Beam Filtering**: Use the **Material beams to avoid** field to prevent the script from calculating nails on trimmers or stiffeners that do not require nailing (e.g., small blocking members).
- **Side Selection**: Remember that Zones 6-10 correspond to the "negative" or bottom side of the element. If you expect nails on the bottom and see none, ensure you have selected a zone between 6 and 10.

## FAQ
- **Q: How do I nail the bottom layer of my floor element?**
  A: Change the **Zone to be Nail** parameter to a value between 6 and 10 (e.g., 6).
- **Q: Why are some beams being skipped?**
  A: Check the **Material beams to avoid** property. Also, beams without a defined nailing code in the database or beams narrower than 20mm are automatically excluded.
- **Q: Can I nail specific sheet materials (like just OSB and ignore Plywood)?**
  A: Yes. Enter "OSB" into the **Zone Material to be Nailed** property. The script will only process sheets with that exact material name.
# hsbRedistributeSheets.mcr

## Overview
This script allows you to manually split and redistribute structural sheeting (panels) on a wall element. It is useful when automatic sheet generation places joints in undesirable locations, or when you need to define specific panel lengths manually.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script modifies 3D geometry and sheet assignments. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: An Element (Wall or Floor) that already contains generated Sheets.
- **Minimum Beam Count**: 0
- **Required Settings**: None. The Element must be calculated enough to have sheet geometry available.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbRedistributeSheets.mcr`

### Step 2: Select Element
Click on the Wall or Floor element where you want to modify the sheeting distribution.

### Step 3: Configure Properties (Optional)
Before or during insertion, open the **Properties Palette** (Ctrl+1) to adjust settings:
- Set **Zone** to the layer you wish to modify (e.g., external sheathing).
- Set **Distribution Range** to `0` for interactive mode.

### Step 4: Select Insertion Point
```
Command Line: Select insertion point
Action: Click in the drawing to place the symbol indicating the modification area.
```

### Step 5: Select Distribution Point (Interactive Mode)
If **Distribution Range** is set to 0:
```
Command Line: Select distribution point
Action: Click on the sheets where you want the new joint/cut to be located.
Note: A dynamic preview (Jig) will show the proposed cut line as you move your cursor.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Zone | dropdown | 5 | Selects the construction layer (Zone index) within the element to be modified. Ensure the selected zone exists in the element. |
| Distribution Range | number | 0 | Defines the area to modify. **0** enables interactive mode (prompts for a click point). Values > 1 target a specific distribution area index. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu items are defined by this script. Use standard AutoCAD grip edits to modify the position. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A

## Tips
- **Interactive Adjustment**: Set **Distribution Range** to `0`. After insertion, you can select the script instance and drag its grip point to slide the sheet cut line along the wall dynamically.
- **Validation**: If the script disappears immediately after insertion, check the command line. It usually means the selected **Zone** does not exist in the element or no sheets were found.
- **Visualizing Changes**: During insertion, look for the dynamic preview highlight to ensure the cut line intersects the sheets correctly.

## FAQ
- **Q: Why did the script delete itself immediately?**
  **A**: This usually happens if the selected **Zone** number does not exist in the target wall element, or if the element has not generated sheets for that zone yet. Try changing the Zone property in the properties palette before insertion.

- **Q: Can I move the cut line after I have placed it?**
  **A**: Yes. If **Distribution Range** is set to `0`, simply select the TSL instance in the model and drag the blue grip point to relocate the distribution point. The sheets will update automatically.

- **Q: What does "Zone" mean?**
  **A**: It refers to the specific layer of the wall construction (e.g., inner lining, structure, outer sheathing). Common values range from -5 to 5, depending on how the wall was constructed.
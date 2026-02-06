# hsbBracing.mcr

## Overview
Generates structural wall bracing (diagonal cross straps) or sheathing sheets within a selected timber wall element, automating placement based on manufacturer-specific constraints defined in external settings.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script generates 3D model elements (Sheets, GenBeams, MetalParts). |
| Paper Space | No | Not intended for 2D drawing generation. |
| Shop Drawing | No | This is a generative modeling script, not a detailing script. |

## Prerequisites
- **Required Entities**: An Element (Wall) must be selected or active.
- **Minimum Beams**: The Element must contain at least two beams (typically top/bottom plates and studs) to define the geometry.
- **Required Settings**: The `hsbBracing.xml` file must be present in the specified Company or Install paths to populate manufacturer options.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbBracing.mcr` from the list.

### Step 2: Select Wall Element
```
Command Line: Select Element:
Action: Click on the wall Element (or individual beams belonging to a wall) where you want to apply the bracing or sheeting.
```

### Step 3: Configure Properties
Before placing the bracing, open the **Properties Palette** (Ctrl+1).
1.  **Type**: Choose between `|Cross Brace|` (diagonal straps) or `|Sheet|` (panels).
2.  **Zone**: Select `1` or `-1` to define which side of the wall the bracing applies to.
3.  **Manufacturer**: Select a brand from the dropdown (populated from XML).
4.  **Family**: Select the product family (filtered by Manufacturer).
5.  **Model**: Select the specific model code (filtered by Family).
6.  **Stud Tie**: Set to `|Yes|` if you want automatic connections/ties at stud intersections.

### Step 4: Define Placement (Jig Mode)
```
Command Line: Specify start point:
Action: Click in the model to define the start corner of the bracing area.

Command Line: Specify end point:
Action: Click to define the opposite corner.
Note: A visual preview will appear. For Cross Braces, ensure the preview is Green (valid). Red indicates the angle or length exceeds the Model's limits.
```

### Step 5: Generation
The script will automatically generate the Sheets or Cross Braces, assign them to the correct Element group on the specified side, and then erase its own instance.

## Properties Panel Parameters

| Parameter | Type | Options | Description |
|-----------|------|---------|-------------|
| |Type| |Dropdown| \|Cross Brace\|, \|Sheet\| |Defines the type of bracing to generate: diagonal straps or solid sheathing panels. |
| |Zone| |Dropdown| 1, -1 |Defines which side of the wall the bracing is applied to (e.g., interior vs exterior face). |
| |Stud Tie| |Dropdown| \|No\|, \|Yes\| |If "Yes", generates connections or machining where the bracing intersects wall studs. |
| |Manufacturer| |Dropdown| *(From XML)* |Selects the product brand (e.g., Simpson, MiTek). |
| |Family| |Dropdown| *(From XML)* |Selects the product category (e.g., strap type). List updates based on Manufacturer. |
| |Model| |Dropdown| *(From XML)* |Selects the specific product size/constraints. List updates based on Family. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| strJigAction1 | Triggers the visual Jig mode again, allowing you to re-click points to adjust the bracing area or angle dynamically. |

## Settings Files
- **Filename**: `hsbBracing.xml`
- **Location**: 
  - `_kPathHsbCompany\TSL\Settings\`
  - `_kPathHsbInstall\Content\General\TSL\Settings\`
- **Purpose**: Contains the catalog of Manufacturers, Families, and Models, along with their geometric constraints (min/max angle, width, height, thickness).

## Tips
- **Missing Data**: If the Manufacturer, Family, or Model dropdowns are empty, check that `hsbBracing.xml` is located in one of the Settings folders listed above.
- **Visual Validation**: When inserting `|Cross Brace|`, watch the preview color. Green means the angle fits the manufacturer's specs; Red means it is too steep or too shallow for the selected model.
- **Grid Alignment**: For `|Sheet|` types, the script automatically calculates a grid based on the Model's dimensions and aligns it to the wall geometry and stud layout.

## FAQ
- **Q: Why does the script not create any bracing?**
  A: Ensure you have selected a valid `sModel` in the properties. If the wall dimensions are smaller than the minimum size defined in the XML, the script may generate nothing.
  
- **Q: How do I switch the bracing to the other side of the wall?**
  A: Change the `sZone` property in the Properties Palette from `1` to `-1` (or vice versa) and run the Jig action or re-insert the script.

- **Q: Can I use this for gable walls?**
  A: Yes, the script supports gable walls (implemented in v1.3). Ensure your selection includes the gable geometry.
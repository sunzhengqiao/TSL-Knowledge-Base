# hsbItemClone.mcr

## Overview
Generates a 2D flattened layout of timber elements (beams, sheets, panels) directly in Model Space. This tool is used to create a visual overview or "bill of materials" layout for production planning, allowing you to verify dimensions, counts, and grain direction.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The layout is generated here. |
| Paper Space | No | Not designed for Paper Space layout. |
| Shop Drawing | No | This is a Model Space production tool. |

## Prerequisites
- **Required Entities**: At least one structural element (GenBeam, Sheet, Beam, Sip, or TslInst) must exist in the model.
- **Minimum Beam Count**: 1
- **Required Settings Files**: `hsbItemClone.xml` (Must be located in `%hsbCompany%\TSL\Settings`).

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the command line.
2. Select `hsbItemClone.mcr` from the list.
3. Click in the Model Space to insert the script instance.

### Step 2: Configure Layout
1. With the script instance selected, open the **Properties Palette** (Ctrl+1).
2. Locate the **Item** category.
3. Set the **Rule** (`sRule`) parameter to the desired filter (e.g., "Floor 1 Walls", "Roof Beams").
4. Adjust layout parameters like **MaxRowLength** or **Distance to Next** as needed.
   - *Note: The script will automatically execute the layout generation once parameters are changed.*

### Step 3: Review Result
1. The script will generate the cloned layout in the model.
2. The original script instance will automatically delete itself (`eraseInstance`) upon completion.
3. Navigate to the generated layout to verify the elements.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Rule | dropdown | \<Disabled\> | Selects a filter configuration (defined in XML) to determine which elements are included in the layout. |
| dMaxRowLength | number | 25000 mm | Sets the maximum width of a row. Items will wrap to the next line if the row exceeds this length. |
| dDistToNext | number | 500 mm | Defines the spacing (gap) between cloned items in the layout. |
| nDisplayMode | integer | 0 | **0**: Shows simple outline (Envelope). **1**: Shows detailed geometry with cuts and holes (Real Body). |
| bIsBaufritz | boolean | false | Enables special grain direction logic and coloring for Baufritz construction standards. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| (None detected) | This script executes automatically based on property changes and does not use custom context menu triggers. |

## Settings Files
- **Filename**: `hsbItemClone.xml`
- **Location**: `%hsbCompany%\TSL\Settings`
- **Purpose**: Stores the configuration for filter rules, sorting logic, display parameters (dimensions, colors, linetypes), and layout settings.

## Tips
- **Visual Verification**: Set `nDisplayMode` to **1** if you need to check for specific machining details or holes on the flattened parts.
- **Optimizing Layout**: If your layout is too spread out vertically, decrease `dMaxRowLength`. If items are overlapping, increase `dDistToNext`.
- **Grain Direction**: Ensure `bIsBaufritz` is checked correctly for your project standards to ensure the grain arrows on sheets/SIPs are accurate.

## FAQ
- **Q: Where did the script go after I changed the properties?**
  **A:** This script is designed to run once ("fire and forget"). It generates the layout and then deletes the original script instance automatically to keep your drawing clean.
- **Q: The "Rule" dropdown is empty or shows `<Disabled>` only.**
  **A:** Check that `hsbItemClone.xml` exists in your company TSL folder and contains valid rule definitions.
- **Q: How do I update the layout if I change the model?**
  **A:** Insert the script again and re-run the process with the desired settings.
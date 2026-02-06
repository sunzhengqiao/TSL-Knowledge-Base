# hsb_OpeningPackers

## Overview
This script automatically generates timber sheeting (packers/reveal liners or covering boards) around wall openings based on defined wall layers and zones. It is typically used to create structural backing for drywall (Packers) or aesthetic external timber returns (Covering boards).

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script must be run in the model where the wall elements and openings exist. |
| Paper Space | No | Not intended for layout views. |
| Shop Drawing | No | Generates physical sheet entities (3D model), not drawing annotations. |

## Prerequisites
- **Required Entities**: An existing Wall Element containing at least one Opening.
- **Minimum Beam Count**: The wall construction must have beams surrounding the opening if using "Construction" reference.
- **Required Settings**: None specific, though a catalog entry is recommended for saving presets.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` (or catalog selection)
Action: Select `hsb_OpeningPackers.mcr` from the file dialog or click the catalog button.

### Step 2: Select Opening(s)
```
Command Line: Select opening(s)
Action: Click on the opening(s) in the drawing where you want to generate packers or covering boards. Press Enter to confirm selection.
```

### Step 3: Configuration (Optional)
Action: If no specific execute key was used, a properties dialog may appear automatically. Alternatively, select the inserted TSL instance and open the **Properties Palette (OPM)** to adjust settings before the script executes/finishes.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Sheet Definition** | | | |
| Insert as | Dropdown | Packer | Defines the position of the boards. "Packer" places them inside the reveal; "Covering board" covers the opening from the outside. |
| Width | Text | 100 | Defines the width of the board (mm). Use one value for all sides, or a sequence (e.g., `top;bottom;right;left`) for independent widths. |
| Thickness | Text | 20 | Defines the thickness of the board (mm). Use one value for all sides, or a sequence (e.g., `top;bottom;right;left`) for independent thicknesses. |
| Gap at the ends | Text | Empty | Clearance margin at the ends of the sheet (mm). Use one value or a sequence (top;bottom;right;left). |
| Gap to opening | Text | Empty | Clearance margin relative to the opening frame (mm). Use one value or a sequence. |
| Sheet properties | Text | Empty | Sets entity properties. Format: `ColourIndex; Name; Material; Grade; Information; Label; SubLabel; Beamcode`. |
| Assign to zone | Dropdown | 0 | Logical zone to assign the generated sheets to (-5 to 5). |
| **Sheet Position** | | | |
| Zone to align sheet to | Dropdown | 0 | Physical zone to align the sheet geometry to. Negative = Outside, Positive = Inside. |
| Offset to zone | Number | 0 | Fine-tunes the position away from the aligned zone (mm). |
| Create a vertical sheet(s) | Dropdown | None | Select to generate Left, Right, or Both vertical sides. |
| Create a horizontal sheet(s) | Dropdown | None | Select to generate Bottom, Top, or Both horizontal sides. |
| Reference | Dropdown | Construction | "Construction" uses surrounding beams to calculate length; "Opening" uses the raw opening size. |
| Ignore parallel beams | Dropdown | No | If "Reference" is Construction, ignores beams running parallel to the packer (e.g., cripple studs). |
| **Behavior of Tsl instance** | | | |
| Delete TSL after insertion | Dropdown | Yes | If "Yes", the script instance is removed after creating geometry. If "No", it remains for editing. |

## Right-Click Menu Options
This script does not add specific custom items to the right-click context menu.

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: N/A (Configuration is handled via OPM properties).

## Tips
- **Individual Sizing**: You can specify different dimensions for each side of the opening using semicolons. For example, in the **Width** field, enter `100;100;50;50` to set Top/Bottom to 100mm and Left/Right to 50mm.
- **Zone Alignment**: Use negative numbers for the **Zone to align sheet to** to position packers on the exterior side of the wall, and positive numbers for the interior side.
- **Reference Mode**: If your packers are coming out too short or too long, switch **Reference** from "Construction" to "Opening" (or vice versa) to change whether the script calculates length based on the studs or the window frame itself.
- **Static vs. Parametric**: If you plan to modify the wall or window frequently, set **Delete TSL after insertion** to "No". This allows you to select the TSL later and update the packers without re-inserting the script.

## FAQ
- **Q: Why did the script not generate boards on one side?**
  - A: Check the **Create a vertical sheet(s)** and **Create a horizontal sheet(s)** properties. You may have "None" or "Left/Right" selected when you need "Top/Bottom".
- **Q: What does the error "Opening is too small or gap is too big" mean?**
  - A: The calculated length of the board is effectively zero or negative. Reduce the values in **Gap at the ends** or **Gap to opening**.
- **Q: How do I assign the packers to a specific material layer?**
  - A: Use the **Assign to zone** property to match a layer defined in your wall construction, or manually set the material in the **Sheet properties** string.
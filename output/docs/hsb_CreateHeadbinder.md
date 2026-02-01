# hsb_CreateHeadbinder

## Overview
Automates the generation of headbinders (rim beams) along the top of selected timber walls. It calculates material lengths, creates optimized beam segments based on maximum transport lengths, and optionally generates a Bill of Materials (BOM) table.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script must be run in Model Space where Element Walls exist. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Generates 3D model geometry, not 2D drawing views. |

## Prerequisites
- **Required Entities**: `ElementWall` entities with Top Plates already generated.
- **Minimum Beams**: 0 (Requires Walls, but works on the wall geometry itself).
- **Required Settings**: `hsb_SolePlate Material Table` script (if "Show BOM" is enabled).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_CreateHeadbinder.mcr`

### Step 2: Configure Properties
1.  Select the script instance in the drawing.
2.  Open the **Properties Palette** (Ctrl+1).
3.  Adjust settings such as Material, Dimensions, and Group Names as required.
4.  Set **Show BOM** to "Yes" if you need a material list.

### Step 3: Execute Creation
1.  Right-click the script instance and select **Execute**.
2.  **If Show BOM is "Yes"**: The command line will prompt: `Select the Location for the Material Table`. Click in the model to place the table.
3.  **Prompt**: `Select a set of elements`.
4.  **Action**: Click on the timber walls (ElementWalls) you wish to process and press Enter.

### Step 4: Processing
The script will generate the headbinders. If "Loose Material" is selected, they will be placed in the specified construction group. If "Fix to the Element" is selected, they will be added directly to the wall's element group. The script instance will erase itself automatically upon completion.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Identification** | | | |
| Name | String | Headbinder | Name assigned to the generated beam entities. |
| Material | String | | Material code for the timber. |
| Grade | String | | Timber grade. |
| Information | String | | Additional text info. |
| Label | String | | Primary label. |
| Sublabel | String | | Secondary label. |
| Sublabel 2 | String | | Third level label. |
| **Grouping** | | | |
| House Level group name | String | 00_GF-Headbinder | Top-level group name (e.g., Project level). |
| Floor Level group name | String | GF-Headbinder | Second-level group name (e.g., Floor level). |
| **Configuration** | | | |
| Code External Walls | String | A;B; | Wall codes that define "External" walls (separated by `;`). Used for labeling. |
| Code Party Walls | String | F;G; | Wall codes that define "Party" walls (separated by `;`). Used for labeling. |
| Headbinder Type | Dropdown | Loose Material | **Loose Material**: Creates separate beams in a new group.<br>**Fix to the Element**: Adds beams to the existing Wall element group. |
| Show BOM | Dropdown | No | If **Yes**, prompts for a location to insert a Material Table. |
| Dimstyle | Dropdown | | Dimension style to use. |
| Show the Metal Parts in Disp Rep | String | | Display representation setting. |
| **Dimensions & Nails** | | | |
| H1 SolePlate | Number | 38 | Height/Depth of the headbinder timber (mm). |
| Max Length | Number | 4800 | Maximum length for a single piece (mm). Beams longer than this will be split. |
| Min Length | Number | 600 | Minimum acceptable cut length (mm). Prevents tiny offcuts. |
| Nails Centers | Number | 600 | Spacing between nails (mm). Used for BOM calculations. |
| Insert Nails | Dropdown | No | If **Yes**, calculates nail quantities in the BOM. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Execute | Runs the script to generate geometry based on current properties. |
| Erase | Removes the script instance from the drawing without generating geometry. |
| Properties | Opens the Properties palette to edit parameters. |

## Settings Files
- **Script**: `hsb_SolePlate Material Table`
- **Purpose**: This script is called internally if "Show BOM" is set to "Yes". It reads the generated data and formats it into a table on the drawing.

## Tips
- **Wall Codes**: Ensure your Wall Codes (e.g., "A" for external, "F" for party) match the values in the **Code External Walls** and **Code Party Walls** properties to ensure labels are applied correctly.
- **Length Optimization**: The script automatically splits long walls into segments based on the **Max Length**. If the last segment is too short (below **Min Length**), the script adjusts the previous cut to ensure all pieces are usable.
- **Re-running**: Since the script erases itself after running, you must insert `hsb_CreateHeadbinder.mcr` again if you need to regenerate the headbinders with new settings.
- **Group Organization**: Use "House Level group name" to keep your "Loose" headbinders organized separately from the main wall structure, making it easier to generate cut lists or exports.

## FAQ
- **Q: Why did the script disappear after I selected the walls?**
  - A: This is normal behavior. The script is designed to run once ("Fire and Forget"), create the geometry, and then erase itself to clean up the drawing.
- **Q: The headbinders are not appearing in the correct group.**
  - A: Check the **Headbinder Type** property. If set to "Fix to the Element", they will appear inside the specific Wall's group. If set to "Loose Material", they will appear in the group names specified in the Properties palette.
- **Q: How do I change the size of the timber?**
  - A: You cannot change the size of the generated beams simply by updating the script (because it erases itself). You must either manually edit the beam properties in AutoCAD or delete the beams and re-run the `hsb_CreateHeadbinder` script with the new **H1 SolePlate** dimension.
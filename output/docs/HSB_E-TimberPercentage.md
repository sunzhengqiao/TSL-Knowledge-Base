# HSB_E-TimberPercentage.mcr

## Overview
This script calculates and visualizes the percentage of timber volume within a wall or roof element. It filters specific structural zones (profiles) to determine the solid timber ratio and displays the result as text labels in the model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Must be attached to an Element (Wall/ElementRoof). |
| Paper Space | No | Not intended for layout views. |
| Shop Drawing | No | Not intended for manufacturing views. |

## Prerequisites
- **Required Entities**: An existing Wall or Roof Element in the drawing.
- **Minimum Beam Count**: N/A (Target is an Element).
- **Required Settings**: The TSL script `HSB_E-TimberPercentageArea` must exist in your hsbCAD catalogs to display the labels.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Select `HSB_E-TimberPercentage.mcr` from the file dialog.

### Step 2: Select Element
```
Command Line: Select element(s)
Action: Click on the Wall or Roof element you wish to analyze. You can select multiple elements.
```

### Step 3: Configure Parameters (Optional)
Action: Press `Esc` to finish selection. Select the script instance (or the element) and open the **Properties Palette** (Ctrl+1).
- Adjust filters like **Profile name(s)** or **Profile depth(s)** as needed.

### Step 4: Generate Labels
Action: Right-click on the script instance and select **Reset Profiles**.
*Note: Changing properties in the palette does not automatically update the view until "Reset Profiles" is clicked.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Profile name(s)** | Text | `PLINE` | Specify the names of the structural zones (ZoneAreas) to include. If empty, the element's net outline is used. Use a semicolon (;) to separate multiple names. |
| **Area catalog** | Dropdown | First available | Selects the visual style preset (defined in the Area script) for the labels. |
| **Profile depth(s)** | Text | `-1` | Sets the timber thickness (in mm) for volume calculation. Enter `-1` to use the default/element center depth. Use semicolons to match multiple profiles. |
| **Override Name Zone 0** | Text | *Empty* | Allows you to rename the default label text if no specific profiles are found. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Reset Profiles** | Recalculates the zones and deletes old labels, regenerating them based on the current property settings. Use this after changing parameters. |
| **Delete** | Removes all percentage labels and deletes the script instance from the element. |

## Settings Files
- **Catalog Entry**: `HSB_E-TimberPercentageArea`
- **Location**: hsbCAD TSL Catalogs
- **Purpose**: This script is a dependency that handles the actual drawing of the text and visual indicators for the calculated areas.

## Tips
- **Multiple Profiles**: You can target several different timber layers at once by typing their names separated by semicolons (e.g., `Stud;TopPlate`).
- **Depths Matching**: If you specify multiple profile names, ensure the **Profile depth(s)** also match the count or order if specific depths are required, otherwise leave it as `-1`.
- **Auto-Update**: If you change the geometry of the element (e.g., stretch a wall), the labels will automatically regenerate (if a property map exists). However, changing script properties requires a manual "Reset Profiles".

## FAQ
- **Q: I changed the profile name in the properties, but the label didn't update. Why?**
  A: You must right-click the script instance and select **Reset Profiles** to apply property changes to the generated labels.
- **Q: What does the depth "-1" do?**
  A: It tells the script to ignore a manual thickness and calculate based on the existing profile data or the element's center axis.
- **Q: Can I use this on a generic beam?**
  A: No, this script is designed specifically for hsbCAD Elements (Walls or Roofs).
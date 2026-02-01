# HSB_E-ElementTable.mcr

## Overview
This script generates a dimensional schedule (element table) for timber construction elements directly in the model. It calculates and displays dimensions, surface areas, and barcodes based on the selected elements, with options to exclude specific materials or beam types (like studs) from area calculations.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Required to source elements from the project. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities**: Elements (Walls/Floors) or GenBeams must exist in the drawing.
- **Minimum Beam Count**: 0.
- **Required Scripts**: The script `HSB_G-FilterGenBeams` must be loaded in the drawing to use exclusion filters.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_E-ElementTable.mcr`

### Step 2: Configure Selection
After launching, the Properties Palette will appear. Set the **Selection mode** (`sInsertType`) to determine how the script gathers elements:
- **Select entire project**: Automatically grabs all elements.
- **Select floor level in floor level list**: Enables the **Floorgroup** dropdown to pick a specific level.
- **Select current floor level**: Uses the active working layer/group.
- **Select elements in drawing**: Prompts you to manually pick elements on screen.

### Step 3: Configure Filters (Optional)
If you need to calculate net surface areas (e.g., for sheathing), enter the beam codes or materials to exclude in the **Beam codes to exclude** or **Materials to exclude** fields.

### Step 4: Place Table
- If you selected **"Select elements in drawing"**, the command line will prompt: `Select one or more elements`. Select your objects and press Enter.
- For other modes, or after selection, the command line will prompt: `Select a position for the table`. Click in the Model Space to place the table.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Selection mode** | dropdown | 3 | Choose how to select elements: Entire Project, Floor List, Current Floor, or Manual Selection. |
| **Floorgroup** | dropdown | 0 | Select a specific floor level. Only active if "Selection mode" is set to "Select floor level in floor level list". |
| **Beam codes to exclude** | text | | Enter beam codes (e.g., "Stud;Plate") to remove from geometric/area calculations. |
| **Materials to exclude** | text | | Enter material names (e.g., "C24") to exclude from calculations. |
| **Labels to exclude** | text | | Enter labels to exclude specific components from calculations. |
| **Title** | dropdown | 0 | Choose the format for the main table header (e.g., Project Name/Number). |
| **Subtitle** | text | | Enter custom text for a secondary header line. |
| **Dimension style header** | dropdown | | Select the text style (font/height) for the table headers. |
| **Dimension style content** | dropdown | | Select the text style for the data rows. |
| **Dimension style barcodes** | dropdown | | Select the specific font style required to generate readable barcodes. |
| **Color header** | number | -1 | Set the color for the header text (-1 for ByLayer). |
| **Color content** | number | -1 | Set the color for the data text (-1 for ByLayer). |
| **Color Table** | number | -1 | Set the color for the table grid lines (-1 for ByLayer). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| **Add elements** | Prompts you to select additional elements to append to the existing table. (Only available in Manual Selection mode). |
| **Remove elements** | Prompts you to select elements currently in the table to remove them. (Only available in Manual Selection mode). |

## Settings Files
- **Dependency**: `HSB_G-FilterGenBeams.mcr`
- **Purpose**: This script is required to filter out specific beam codes or materials during the calculation process.

## Tips
- **Net Area Calculation**: To calculate the area of sheathing/boarding only, exclude the internal framing codes (like studs) in the **Beam codes to exclude** property.
- **Sorting**: Elements are automatically sorted by their Element Number in the table.
- **Updating**: Changes to filters or styles in the Properties Palette will automatically regenerate the table.

## FAQ
- **Q: Why is the "Floorgroup" dropdown greyed out?**
  A: You must change the **Selection mode** to "Select floor level in floor level list" to enable this option.
- **Q: I see an error about "HSB_G-FilterGenBeams".**
  A: Ensure the script `HSB_G-FilterGenBeams.mcr` is loaded into your drawing (using `TSLLOAD`) or clear the text in the exclusion filter fields.
- **Q: How do I add more elements to an existing table later?**
  A: Select the table, right-click, and choose **Add elements**. Note: This only works if the table was created using "Select elements in drawing" mode.
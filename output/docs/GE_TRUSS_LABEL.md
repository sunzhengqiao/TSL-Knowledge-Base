# GE_TRUSS_LABEL.mcr

## Overview
This script generates 2D symbolic labels and layout representations for TrussEntities. It creates clean construction drawings by displaying the Truss Tag/Label, a symbolic centerline, and a perimeter outline based on the Truss Definition properties.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script is intended for model layout views. |
| Paper Space | No | Cannot be inserted directly into Paper Space. |
| Shop Drawing | No | Not designed for Shop Drawing generation. |

## Prerequisites
- **Required Entities**: At least one `TrussEntity` in the drawing.
- **Configuration**: The TrussEntity must be linked to a `TrussDefinition`.
- **Data Source**: The `TrussDefinition` should contain a SubMap named `PROPERTIES` with keys for Tag, Label, Span, and Ply.

## Usage Steps

### Step 1: Launch Script
Run the command `TSLINSERT` in the AutoCAD command line and select `GE_TRUSS_LABEL.mcr` from the file browser.

### Step 2: Configure Initial Properties (Optional)
An initial properties dialog may appear (`showDialogOnce`). Adjust settings like text height or visibility if desired, or press OK to accept defaults.

### Step 3: Select Trusses
```
Command Line: Select a set of trusses
Action: Click on one or more TrussEntities in the model view and press Enter.
```
*Note: The script will process all selected trusses. If a truss already has a label from this script, the old one will be replaced.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **DimStyle** | Dropdown | *Current Style* | Selects the CAD Dimension Style to control text font and appearance. |
| **Text Height** | Number | 0 | Sets the text height. If 0, the height defined in the DimStyle is used. |
| **Display Text** | Dropdown | Label | Determines what text is shown: "Label", "Tag", "Tag - Label", or "Label - Tag". |
| **Label Display Rep** | Dropdown | *All* | Selects the Display Representation (e.g., Plan, Elevation) where the text is visible. |
| **Label Color** | Integer | -1 | Sets the color of the text (-1 = ByLayer). |
| **Display Center Line** | Dropdown | Yes | Toggles the visibility of the truss centerline axis. |
| **Center Line Display Rep** | Dropdown | *All* | Selects the Display Representation where the centerline is visible. |
| **Line LineType** | Dropdown | *Current* | Sets the Line Type (e.g., Hidden, Center) for the centerline. |
| **Line Color** | Integer | -1 | Sets the color of the centerline (-1 = ByLayer). |
| **Display Outline** | Dropdown | Yes | Toggles the visibility of the truss footprint/perimeter outline. |
| **Outline Display Rep** | Dropdown | *All* | Selects the Display Representation where the outline is visible. |
| **Outline LineType** | Dropdown | *Current* | Sets the Line Type for the outline. |
| **Outline Color** | Integer | -1 | Sets the color of the outline (-1 = ByLayer). |
| **Tag** | String | *From Map* | The Truss Tag (e.g., "T-1"). Read from Truss Definition. |
| **Label** | String | *From Map* | The Truss Label name. Read from Truss Definition. |
| **Truss Type** | String | *From Map* | The type of truss (e.g., "Fink"). Read from Truss Definition. |
| **Span** | Number | *From Map* | The length of the truss. Read from Truss Definition. |
| **Ply** | Integer | *From Map* | The number of plies (layers). Affects the number of centerlines drawn. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None Specific | No custom context menu items are defined by this script. Standard AutoCAD/TSL options apply. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script reads data directly from the `TrussDefinition` SubMap 'PROPERTIES' and does not require external XML settings files.

## Tips
- **Multi-Ply Trusses**: If the `Ply` property is greater than 1, the script will automatically draw multiple centerlines and circles to represent the individual plies.
- **Moving Labels**: You can grip-edit the label position to move the text relative to the truss without moving the truss itself.
- **Data Sync**: The script attempts to attach a Property Set named `TrussEntity` to your truss if it is missing, populating it with data from the definition.
- **Visibility**: Use the `Display Rep` properties to control which labels show in Plan view vs. 3D view (e.g., hide outlines in 3D but keep them in Plan).

## FAQ
- **Q: Why is my text blank?**
  **A:** Check if the `TrussDefinition` linked to your TrussEntity has the `PROPERTIES` SubMap populated with values for Label and Tag. If the map is missing or empty, the script has nothing to display.
- **Q: How do I change the size of just one label?**
  **A:** Select the TSL instance (label), open the Properties palette (Ctrl+1), and change the `Text Height` value. Set it to a non-zero value to override the DimStyle.
- **Q: I see multiple lines for my truss, but it's a single truss.**
  **A:** Check the `Ply` property in the Properties palette. If it is set to 2 or 3, the script draws lines for each ply. Set it to 1 to show a single line.
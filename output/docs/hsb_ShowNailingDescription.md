# hsb_ShowNailingDescription

## Overview
Generates annotation text in Paper Space that displays calculated nailing schedules (spacing and nail type) derived from engineering data attached to a wall or floor element. This script is typically used to label construction drawings with fastener requirements for sheathing or cladding.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | The script requires selecting a Viewport to identify the target Element. |
| Paper Space | Yes | The script is designed to be inserted directly onto layouts. |
| Shop Drawing | Yes | Primarily used for annotating production or layout drawings. |

## Prerequisites
- **Required Entities**: A Viewport in Paper Space that is currently displaying a valid Element (e.g., a Wall or Floor).
- **Element Data**: The Element displayed in the viewport must have engineering data (NailingInfo maps) attached to it, usually by other TSL scripts (like Wall Generators).
- **Minimum Beam Count**: The Element must exist (the script will erase itself if the viewport is invalid).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_ShowNailingDescription.mcr`

### Step 2: Select Location Point
```
Command Line: Pick a Point To Locate the Description
Action: Click anywhere in Paper Space where you want the nailing label to appear.
```

### Step 3: Select Viewport
```
Command Line: Select a viewport
Action: Click the border of the viewport that shows the element you wish to annotate.
```

### Step 4: Configure Properties
```
Dialog: Dynamic Properties Dialog
Action: Adjust settings such as the Nailing Zone, Text Height, and Prefix. Click OK to generate the text.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Nailing Zone | dropdown | 0 | Selects which nailing zone (1-10) to display. Ensure the engineer has defined data for the selected zone. |
| Dim Style | dropdown | _DimStyles | Selects the Dimension Style to control the text font and appearance. |
| Text Height | number | -1 | Sets the height of the text. Set to `-1` to use the default height defined in the selected Dim Style. |
| Offset Between Text Lines | number | U(5) | The vertical distance (in mm) between the main nailing description and the Nail Type line. |
| Show Nailing Type | dropdown | No | Set to `Yes` to display a second line of text showing the specific nail brand/size. |
| Nailing Description Prefix | text | Cladding Nailing: | The custom label that appears before the spacing values (e.g., "Sheathing Nailing: "). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add custom items to the right-click context menu. Use the Properties palette to modify settings. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script relies on data attached directly to the Element (NailingInfo maps) rather than external settings files.

## Tips
- **Data Availability**: If the label shows "N/A" or zero values, check if the Element in the viewport actually contains sheathing/sheets and if the generating TSL provided nailing data.
- **Zone Selection**: If you see "N/A" but data exists, try changing the **Nailing Zone** property (1-10). Different parts of a wall (edges vs. field) are often stored in different zones.
- **Text Standards**: For consistent office standards, leave **Text Height** set to `-1` and control the size via the **Dim Style** property.

## FAQ
- **Q: Why did the script disappear immediately after I selected the viewport?**
  **A:** The script erases itself if it cannot find a valid Element within the selected Viewport. Ensure the viewport is active and showing a wall or floor.
- **Q: How do I display the specific nail size (e.g., "3.1x75")?**
  **A:** Change the **Show Nailing Type** property to `Yes` in the Properties Palette.
- **Q: Can I move the text after inserting it?**
  **A:** Yes, select the script instance in Paper Space and use the grip point (Pt0) to drag the text to a new location.
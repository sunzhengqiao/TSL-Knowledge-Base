# hsb_ShowSheetSize.mcr

## Overview
This script displays labels in your Layout (Paper Space) to indicate the Position Number and/or dimensions of Sheets (panels/walls) visible through a selected Viewport. It is useful for quickly annotating floor plans or layout drawings with size and identification data.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script cannot be inserted in Model Space. |
| Paper Space | Yes | This is the primary workspace. The script must be inserted on a Layout tab. |
| Shop Drawing | No | This script annotates layouts; it does not generate shop drawings. |

## Prerequisites
- **Required Entities**: A Viewport containing hsbCAD Elements (Walls/Panels) with generated Sheets.
- **Minimum Beam Count**: 0.
- **Required Settings**: The Viewport must be active and contain valid timber data.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_ShowSheetSize.mcr`

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the border or inside the viewport that displays the elements you wish to annotate.
```

### Step 3: Configure Properties
After insertion, select the script instance (if visible) or simply press `Ctrl+1` to open the Properties Palette while the script is selected to configure the label display options (e.g., toggling Position Numbers or Dimensions).

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension Style | dropdown | (Current) | Selects the CAD Dimension Style (text height, font, arrows) to be used for the labels. |
| Color | number | -1 | Sets the color of the text labels. Enter a specific color index (0-255) or use -1 to use the ByLayer color. |
| Show Posnum | dropdown | No | Toggles the visibility of the Element Position Number (e.g., "W01"). Set to "Yes" to display. |
| Show Dimention | dropdown | No | Toggles the visibility of the Sheet physical dimensions (e.g., "2500x600"). Set to "Yes" to display. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are available for this script. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: This script operates entirely on internal drawing data and property settings.

## Tips
- **Combining Data**: You can set both "Show Posnum" and "Show Dimention" to "Yes" to create a comprehensive label (e.g., "W01 2500x600").
- **Dynamic Updates**: If you change the size of the panels in the model, the dimensions in the label will update automatically (usually requires a regeneration or save).
- **Text Visibility**: If you see the script insertion point but no text, check the Properties Palette to ensure at least one of the "Show" options is set to "Yes".

## FAQ
- **Q: Why don't I see any text after inserting the script?**
  - A: Ensure you have selected a viewport with valid hsbCAD Elements. Additionally, check the Properties Palette and set either "Show Posnum" or "Show Dimention" to "Yes".
- **Q: Can I change the text size without creating a new Dimension Style?**
  - A: No, the script uses the standard CAD Dimension Style settings to control text appearance. You must modify the Dimension Style in the AutoCAD Style Manager or select a different style in the script properties.
- **Q: What does the Color value -1 do?**
  - A: Setting Color to -1 makes the text take on the color of the Layer on which the script instance resides.
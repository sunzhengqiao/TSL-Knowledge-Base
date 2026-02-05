# MultiElementCOG

## Overview
This script visualizes the Center of Gravity (COG) and displays specific properties (such as weight) for timber elements. It handles both single elements and Multi-Elements (e.g., multi-layer walls), displaying individual COGs for sub-components in both Model and Paper Space.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Select elements to attach the COG marker directly to the geometry. |
| Paper Space | Yes | Select a Viewport to display COG data projected onto the layout. |
| Shop Drawing | No | This is an annotation script for general layout and modeling. |

## Prerequisites
- **Required Entities**: Element (Single or Multi), Viewport (if in Paper Space).
- **Minimum Beams**: 0 (Operates on Elements).
- **Required Settings**: The `hsbCenterOfGravity` script must be present in the system.

## Usage Steps

### Step 1: Launch Script
**Command**: `TSLINSERT` → Browse and select `MultiElementCOG.mcr`.

### Step 2: Select Elements or Viewport
The script behaves differently depending on your current CAD space:

**In Model Space:**
```
Command Line: Select elements
Action: Click on the timber elements or multi-elements you want to analyze. Press Enter to confirm.
```
*Result*: The script attaches an instance to each selected element.

**In Paper Space (Layout Tab):**
```
Command Line: Select a viewport
Action: Click on the viewport frame displaying the model you wish to annotate.
```
```
Command Line: Pick a point outside of paperspace
Action: Click a location in the layout (outside the viewport boundary) to place the annotation leader/text origin.
```

### Step 3: Configure Properties (Optional)
After insertion, select the script instance and open the **Properties Palette** to adjust text format, color, or scale.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Format | text | `@(Weight:RL1)kg` | Defines the text displayed using dynamic tokens (e.g., `@(Weight)`, `@(Number)`). |
| DimStyle | dropdown | `(Current Style)` | Selects the AutoCAD Dimension Style to control font and text appearance. |
| TextHeight | number | 3 | Sets the height of the text label (in current drawing units). |
| Color | number | 1 | Sets the AutoCAD color index for the symbol and text (e.g., 1 = Red). |
| Scale Factor | number | 1 | Multiplies the size of the COG square symbol independently of the text height. |
| Transparency | number | 0 | Sets the transparency of the filled COG symbol (0 = Solid/Opaque). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add/Remove Format | Opens a command-line menu listing available data properties (e.g., 1. Weight, 2. Number). Type the number to toggle that property in the display label, or type 0 to exit. |

## Settings Files
- **Dependency**: `hsbCenterOfGravity`
- **Purpose**: This external script is used to calculate the physical center and weight of the timber elements.

## Tips
- **Multi-Elements**: If you select a Multi-Element (e.g., a wall with multiple layers), the script automatically calculates and displays the COG for each individual sub-layer.
- **Paper Space Workflow**: Use the Paper Space mode to create clean production drawings where the data is projected from the model but the text remains editable in the layout.
- **Format Tokens**: You can combine static text with tokens. For example, entering `No: @(Number) W: @(Weight)` will display "No: 100 W: 500kg".
- **Visibility**: If the COG square obscures important details in your drawing, increase the **Transparency** value or decrease the **Scale Factor**.

## FAQ
- **Q: Why do I see multiple squares when I only selected one wall?**
  **A**: You likely selected a "Multi-Element" (e.g., a timber frame wall with cladding). The script displays the COG for every single layer (wood, cladding, insulation) separately.
- **Q: How do I change the label to show the Element Number instead of Weight?**
  **A**: Select the script, right-click and choose "Add/Remove Format". Follow the command line prompts to toggle Weight off and Number on.
- **Q: My text is too small to read in the Layout view.**
  **A**: Select the script in the layout and increase the **TextHeight** parameter in the Properties palette.
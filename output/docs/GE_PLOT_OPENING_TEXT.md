# GE_PLOT_OPENING_TEXT

## Overview
This script automatically annotates wall openings in Paper Space with text labels such as Sill Height, Head Height, Module Name, and Rough Opening (RO) dimensions. It reads the geometry from a selected viewport displaying a wall in Model Space and generates formatted text labels on the layout.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | The script is intended to be inserted and used within a Layout tab. |
| Paper Space | Yes | This is the primary environment. The script calculates coordinates from Model Space and draws text in Paper Space. |
| Shop Drawing | No | This is a general annotation tool for layouts. |

## Prerequisites
- **Required Entities**: A Layout tab containing a viewport that displays a Wall Element with Openings.
- **Minimum Beam Count**: 0 (Requires a Wall/Element, not individual beams).
- **Required Settings**: A valid Dimension Style name must be specified in the `DimStyle` property if the default does not exist in the drawing.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_PLOT_OPENING_TEXT.mcr`

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the viewport border within the Layout tab that displays the wall you wish to annotate.
```

### Step 3: Configure Properties (Optional)
After insertion, the script runs immediately. To adjust labels, select the script entity in the drawing and open the **Properties** palette (Ctrl+1). Adjust text visibility, offsets, or prefixes there.

### Step 4: Update
If the wall geometry changes, right-click the script entity and select **Recalculate** to update the text positions and values.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| DimStyle | Text | (Empty) | The dimension style to use for text appearance. |
| Display Sill Height | Dropdown | Yes | Shows or hides the Sill Height text. |
| Sill Prefix | Text | "Sill: " | Text placed before the sill height value. |
| Display Head Height | Dropdown | Yes | Shows or hides the Head Height text. |
| Head Height Prefix | Text | "Head: " | Text placed before the head height value. |
| Display Module Name | Dropdown | Yes | Shows or hides the Module Name. |
| Module Prefix | Text | (Empty) | Text placed before the module name. |
| Display RO | Dropdown | Yes | Shows or hides the Rough Opening size. |
| RO Prefix | Text | "RO: " | Text placed before the RO value. |
| Take Opening Properties from | Dropdown | Framed hole | Determines dimensions: 'Framed hole' (calculated geometry) or 'Opening size' (standard properties). |
| Offset Text | Number | 0.6 | General offset distance for the text. |
| Offset All Text-X | Number | 0.6 | Horizontal offset for the text block. |
| Offset All Text-Y | Number | 0.6 | Vertical offset for the text block. |
| Text Height | Number | 1 | The height of the text characters in Paper Space units. |
| Scale output by | Number | 1 | A multiplier factor for the text size. |
| Set To Brockport Defaults | Dropdown | Yes | If set to 'Yes', resets all properties to standard Brockport settings and reverts to 'No'. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Recalculate | Updates the text positions and values based on any changes made to the wall or openings in Model Space. |

## Settings Files
- **Filename**: None specified.
- **Location**: N/A
- **Purpose**: This script relies on internal property settings rather than external XML files.

## Tips
- **Resetting Settings**: If your text looks messy or offsets are wrong, set `Set To Brockport Defaults` to "Yes" in the properties panel and Recalculate to restore standard settings.
- **Fractional Formatting**: The script automatically formats dimensions as fractional inches (e.g., 48-1/2). It simplifies to whole numbers if the fraction is very small (less than 3/32").
- **Common Headers**: If a header spans multiple openings (e.g., a garage door header), the script is smart enough to ignore that header beam when searching for the Module Name, preventing incorrect labeling.
- **Text Clutter**: If openings are close together, the script automatically staggers (stacks) the text to prevent overlap.

## FAQ
- **Q: Why did the text not appear?**
  A: Ensure the selected viewport actually contains a valid Wall element. Also, check the Properties palette to ensure `Display Sill Height`, `Display Head Height`, etc., are set to "Yes".
- **Q: The dimensions shown don't match my rough opening sizes.**
  A: Change the property `Take Opening Properties from` from "Framed hole" to "Opening size". "Framed hole" calculates based on the actual timber geometry, while "Opening size" uses the standard opening properties.
- **Q: How do I make the text smaller?**
  A: Lower the `Text Height` value in the Properties palette or adjust the `Scale output by` factor.
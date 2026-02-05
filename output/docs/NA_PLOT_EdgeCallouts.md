# NA_PLOT_EdgeCallouts.mcr

## Overview
This script automates the annotation of Structural Insulated Panel (SIP) walls and roofs directly in Paper Space. It generates labels for edge connections (e.g., lumber splines), header sizes, and creates a customizable title block for the element within a selected viewport.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is designed for Paper Space annotations. |
| Paper Space | Yes | Requires a viewport showing the model. |
| Shop Drawing | Yes | Intended for creating production drawings. |

## Prerequisites
- **Required Entities**: A viewport containing an Element (Wall or Roof) with Sip (Structural Insulated Panel) sub-components.
- **Minimum Beams**: None (Operates on Element/Sip entities).
- **Required Settings**: The drawing must contain defined Dimension Styles (referenced as `_DimStyles`).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `NA_PLOT_EdgeCallouts.mcr`

### Step 2: Select Viewport
```
Command Line: Select a viewport
Action: Click on the border of the viewport in Paper Space that displays the wall or roof you wish to annotate.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimension Style | dropdown | (Current) | Select the CAD Dimension Style to control text font and arrow size for labels. |
| Connection Label Offset | number | 0.2 inch | The distance between the panel edge and the start of the label text. |
| Label All Edges | dropdown | Yes | Set to "Yes" to label every edge; set to "No" to label only critical connections. |
| King-Trimmer Offset | number | 0 | Adjusts label position at window/door openings to clear King and Trimmer studs. |
| Max ReportDepth | number | 6 inch | Maximum depth of a feature to generate a label. Deeper features may be ignored. |
| Title 1 Context | dropdown | Element | Source for the first title line: Element (overall wall) or Sip (specific panel). |
| Title 1 Prefix | text | Wall | Static text placed before the dynamic data in Title 1 (e.g., "Wall", "Roof"). |
| Title 1 Format | text | @(ElementNumber) | The data code displayed in Title 1 (e.g., @(ElementNumber), @(Length)). |
| Title 2 Context | dropdown | Element | Source for the second title line: Element or Sip. |
| Title 2 Prefix | text | Sip | Static text placed before the dynamic data in Title 2. |
| Title 2 Format | text | @(Style) | The data code displayed in Title 2. |
| Title Color | number | -1 | The CAD color index for the title block text (-1 = ByLayer). |
| Label Text Height | number | 0 | Height of the connection labels. Set to 0 to use the Dimension Style default. |
| Title Text Height | number | 0 | Height of the title text. Set to 0 to use the Dimension Style default. |
| Title Spacing Ratio | number | 1 | The spacing factor between Title 1 and Title 2. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Reset display data | Clears all stored positions and settings for the labels, forcing a complete redraw of all annotations. |
| Hide data | Prompts you to select text labels near the geometry to hide them from the drawing. |
| Rename data | Prompts you to select a text label and enter a new string to manually override the displayed text. |

## Settings Files
- **Reference**: `_DimStyles`
- **Location**: Current Drawing
- **Purpose**: Provides the list of available Dimension Styles to format the text and arrows used in the callouts.

## Tips
- **Reducing Clutter**: If your drawing is too busy, change **Label All Edges** to "No". This will limit labels to major connections and openings.
- **Manual Adjustments**: If an automatic label lands in a bad spot, use the **Rename data** or **Hide data** context menu options rather than exploding the script. This preserves the link to the model.
- **Formatting Titles**: Use the **Title Format** fields to pull specific data like @(ElementNumber) or @(Elevation) to automate your title blocks.

## FAQ
- **Q: My labels are overlapping the framing lumber at windows.**
  - **A:** Increase the **King-Trimmer Offset** property value. This shifts labels away from the rough opening jambs.
- **Q: How do I change the text size without changing the Dimension Style?**
  - **A:** Enter a specific value (in inches or mm) in the **Label Text Height** or **Title Text Height** properties. Setting this to 0 respects the CAD DimStyle.
- **Q: Can I label a flat roof?**
  - **A:** Yes, provided the geometry in the viewport is recognized as an Element with Sip entities. The script detects walls and roofs similarly.
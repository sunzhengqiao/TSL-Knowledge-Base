# NA_DIM_SIP_EDGE_PITCH.mcr

## Overview
This script automatically generates pitch icons (slope indicators) on the non-rectangular edges of Structural Insulated Panels (SIPs). It provides a clear visual representation of roof or connection angles where standard linear dimensions are insufficient.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be used in Model Space where the 3D Sip geometry exists. |
| Paper Space | No | This script does not function in Paper Space or Layout tabs. |
| Shop Drawing | No | While the output may appear in shop drawings, the script itself runs in the model environment. |

## Prerequisites
- **Required Entities**: At least one Structural Insulated Panel (Sip) entity in the drawing.
- **Minimum beam count**: 0.
- **Required settings**: A valid Dimension Style (e.g., 'MP Shops 1_8') must be loaded in the drawing.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `NA_DIM_SIP_EDGE_PITCH.mcr` from the file browser.

### Step 2: Select Sip Panel
```
Command Line: Select Sip Panel
Action: Click on the desired Sip Panel in the drawing.
```
The script will automatically analyze the panel geometry upon selection.

### Step 3: Configure Properties (Optional)
Before or after insertion, you can adjust the appearance of the pitch icons using the Properties Palette (Ctrl+1) while the script instance is selected.

### Step 4: Review Output
The script will place pitch icons at the midpoint of any sloped or non-rectangular edges. Rectangular edges are automatically skipped.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dim style | dropdown | MP Shops 1_8 | Determines the visual style (text height, font, arrowheads) of the pitch annotation. Select from available Dimension Styles in the drawing. |
| Display accurate icon | dropdown | Yes | Controls the size of the pitch triangle.<br>**Yes**: Draws the triangle to true geometric scale (steeper roofs = taller triangles).<br>**No**: Draws a fixed-size icon for better readability, using text overrides to show the true value. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script does not add specific items to the right-click context menu. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: This script operates independently of external XML settings files.

## Tips
- If the pitch icons appear too small or too large to read comfortably, set **Display accurate icon** to **No**. This forces the icons to a uniform size based on the dimension style's text height.
- Ensure the **Dim style** specified exists in your AutoCAD template. If the default style is missing, the script may default to a standard style.
- The script filters out edges that are perfectly rectangular (parallel to the panel's main axes). If you do not see an icon on a specific edge, it is likely a standard 90-degree cut.

## FAQ
- **Q: Why are no icons appearing on my panel?**
  A: Ensure the panel has sloped or non-rectangular edges. The script automatically skips standard rectangular edges. Also, verify that you selected a valid Sip entity and not a standard wood beam.
  
- **Q: The text on my pitch icons is too small.**
  A: Change the **Dim style** property to a style with larger text height, or set **Display accurate icon** to **No** to normalize the icon size.
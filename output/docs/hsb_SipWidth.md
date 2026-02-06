# hsb_SipWidth.mcr

## Overview
This script annotates SIP (Structural Insulated Panel) wall details directly in Paper Space layouts. It automatically retrieves the total panel width and optionally lists the internal material layers (such as OSB and Insulation thickness) based on a selected wall viewport.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | This script is intended for detailing views only. |
| Paper Space | Yes | Script must be inserted onto a Layout tab. |
| Shop Drawing | Yes | Designed for creating production drawings and detailing views. |

## Prerequisites
- A Layout (Paper Space) tab must be active.
- A **Viewport** must exist that displays an `ElementWall` with valid SIP data assigned.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SipWidth.mcr` from the list.

### Step 2: Pick Insertion Point
```
Command Line: Give insertion point:
Action: Click anywhere in the Paper Space layout where you want the SIP label to appear.
```

### Step 3: Select Viewport
```
Command Line: Select viewport:
Action: Click on the viewport frame that displays the Wall you wish to annotate.
```
*Once selected, the script will generate the text label and finish.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sDimStyle | String | _DimStyles | Selects the dimension style (controlling font, text height, and arrow style) for the annotation. |
| nColor | Integer | -1 (ByBlock) | Determines the color of the text. Set to -1 to use the ByBlock color, or enter a specific AutoCAD Color Index (0-255). |
| dOffset | Double | 100 mm | The vertical distance between the main SIP label and the individual component labels listed below it. |
| strShowSipWidth | Yes/No | Yes | Toggles the visibility of the total SIP width text (e.g., "SIP 225"). |
| strShowSipComponents | Yes/No | No | If set to "Yes", displays the breakdown of material layers (e.g., "OSB - 12", "Insulation - 200") below the main label. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Update | Recalculates the label text if the wall geometry or properties have changed. |
| Erase | Removes the script instance and the associated text from the drawing. |
| Properties | Opens the Properties Palette to modify text style, color, or visibility settings. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose:**

## Tips
- **Toggle Component Details**: By default, only the total width is shown. Use the Properties Palette (`Ctrl+1`) to change `strShowSipComponents` to "Yes" if you need to show the specific layer build-up for manufacturing.
- **Adjusting Spacing**: If the component text overlaps the main label or looks too sparse, increase the `dOffset` value to push the component lines further down.
- **Moving Labels**: You can drag the script using its insertion grip to reposition the entire annotation group without needing to re-insert it.

## FAQ
- **Q: I ran the script, but no text appeared. Why?**
- **A: Ensure the viewport you selected contains a valid `ElementWall` that has SIP properties assigned to it. If the wall is a generic timber wall without SIP data, the script will not generate text.
  
- **Q: How do I change the text height?**
- **A: You cannot change the height directly in the script properties. Instead, change the `sDimStyle` property to a different Dimension Style that uses your desired text height.

- **Q: Can I use this on multiple viewports on the same layout?**
- **A: Yes. Simply run the script again and select a different insertion point and viewport for each annotation required.
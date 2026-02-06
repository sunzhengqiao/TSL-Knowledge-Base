# hsb_OpeningInfo

## Overview
This script annotates wall elements with opening descriptions, dimensions, and optional visual indicators (such as cross-hatching or frames) directly in the 3D model space. It is useful for labeling door and window openings on walls to clearly show size, type, or material information for production or visualization.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script creates visual geometry and text in the 3D model. |
| Paper Space | No | Not designed for layout views. |
| Shop Drawing | No | This is a model space annotation tool. |

## Prerequisites
- **Required Entities**: An Element (Wall) must be selected.
- **Minimum Beam Count**: None required (operates on the Element level).
- **Required Settings**: None required, though Dimension Styles should be configured in the project for optimal text display.

## Usage Steps

### Step 1: Launch Script
Run the script using the `TSLINSERT` command or double-click `hsb_OpeningInfo.mcr` in the TSL Palette.

### Step 2: Configure Settings (Dialog)
A dialog box will appear upon insertion (unless an Execute Key is used).
- Select the **Information to Show** (Description, Header Material, Size, etc.).
- Configure visual options like **With Cross** or **With Frame**.
- Choose the **Layer** assignment (Tool, Information, or Geometry).
- Click **OK** to confirm.

### Step 3: Select Element
```
Command Line: Select element(s):
Action: Click on the Wall(s) or Element(s) where you want to display opening information.
```
The script will attach itself to the selected elements and generate the annotations automatically.

## Properties Panel Parameters
Once the script is inserted, you can modify these settings via the AutoCAD Properties Palette (Ctrl+1).

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Information to show | Dropdown | Description | Selects what content is displayed: Description only, Description + Header Material, Description + Size (W x H), or None. |
| Custom Text | String | (Empty) | Enter up to 5 lines of custom notes to appear below the opening information. |
| Assign to layer | Dropdown | T (Tool) | Sets the drawing sublayer (T=Tool, I=Information, G=Geometry) to control visibility in different views. |
| DimStyle | Dropdown | Project Default | Selects the dimension style (font, text size) used for the text annotation. |
| Text Height | Number | 0 | Overrides the text height from the DimStyle. Value is in mm. Enter 0 to use the style default. |
| Dimension opening beams | Yes/No | No | If **Yes**, dimensions are taken from the surrounding trimmer/king studs (including gaps). If **No**, dimensions are taken from the theoretical opening outline. |
| With Cross | Yes/No | No | Toggles diagonal cross-lines inside the opening to visually indicate a void. |
| With Frame | Yes/No | No | Toggles a rectangular outline (frame) around the perimeter of the opening. |
| Color Cross | Number | -1 | Sets the color for the diagonal cross-lines (-1 uses layer color). |
| Color Description | Number | -1 | Sets the color for the primary text description (-1 uses layer color). |
| Color Frame | Number | -1 | Sets the color for the rectangular frame (-1 uses layer color). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Update | Recalculates the opening geometry and text based on current Element properties or script parameter changes. |
| Erase | Removes the opening information from the selected element. |
| Properties | Opens the AutoCAD Properties Palette to edit script parameters. |

## Settings Files
- **Catalog**: `_LastInserted` (or specific Execute Key catalogs)
- **Purpose**: Stores the last used settings for the script so they are remembered for the next insertion.

## Tips
- **Clear vs. Rough Opening**: Use the **Dimension opening beams** property. Set it to **No** to get the CAD "Clear Opening" size, or **Yes** to measure between the surrounding timber (rough opening size).
- **Visibility Control**: Use the **Assign to layer** property to move annotations to the "Information" (I) layer if you want them hidden in shop floor views but visible in architectural layouts.
- **Text Scaling**: If the text appears too small or large, set **Text Height** to 0 first to check your DimStyle settings. Adjusting the DimStyle is often cleaner than hardcoding a height in the script.

## FAQ
- **Q: The dimensions shown don't match my beam sizes. Why?**
  **A**: Check the **Dimension opening beams** property. If it is set to **No**, the script measures the theoretical void. Setting it to **Yes** will calculate dimensions based on the actual beams surrounding the opening.
  
- **Q: Can I add specific notes for a specific door?**
  **A**: Yes, use the **Custom Text** property in the Properties Palette. You can type multiple lines of notes specific to that element.

- **Q: Why did the text disappear?**
  **A**: Check if the **Information to show** dropdown is set to "None". Also, verify your current layer visibility; the script might be on a frozen or turned-off layer (e.g., T-Slayer or I-Slayer).
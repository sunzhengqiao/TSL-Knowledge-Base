# hsb-E-CombinationText.mcr

## Overview
This script attaches a dynamic, multi-line text label to `hsb-E-Combination` elements (such as wall or floor panels) within the 3D model. It automatically displays specific properties—like dimensions, material codes, or labels—directly on the structure, updating automatically if the parent element changes.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script generates annotation geometry in the 3D model. |
| Paper Space | No | Not intended for layout views. |
| Shop Drawing | No | Not intended for 2D manufacturing drawings. |

## Prerequisites
- **Required Entities:** An existing `hsb-E-Combination` (TslInst) in the drawing.
- **Minimum Beam Count:** 0
- **Required Settings:** `hsbInstallationPointSettings.xml` (must be present in the hsbCAD configuration path).

## Usage Steps

### Step 1: Launch Script
Command: `TSLCONTENT` (or select the script from the hsbCAD Catalogue)
Action: Select `hsb-E-CombinationText.mcr` from the list.

### Step 2: Initial Configuration (if applicable)
```
Dialog: [Dynamic Dialog]
Action: If no execution key (catalog preset) is found, a dialog appears. 
Select the desired text style or visual settings, or click OK to accept defaults.
```

### Step 3: Select Parent Entity
```
Command Line: Select entity:
Action: Click on the desired hsb-E-Combination (wall/floor panel) you wish to label.
```

### Step 4: Confirmation
The script attaches to the selected Combination and generates the text label based on the default Format string. The text is positioned relative to the parent element's coordinate system.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Format | String | @(Text 1)\\@(Text 2)\\... | Defines the text content. Use tokens (e.g., `@(Width)`, `@(Label)`) to pull data from the parent element. Use a backslash `\` to create line breaks. |
| TextHeight | Double | U(80) | The physical height of the text characters in the model. |
| Color (nc) | Integer | ByBlock | The color of the text lines and the border. |
| FillColor (ncFill) | Integer | -1 (ByBlock) | The background color of the label box. Use `-1` for transparent/ByBlock. |
| Transparency (nt) | Integer | 70 | The opacity level of the background fill (0 = Opaque, 90 = Transparent). |
| BorderMode | Integer | 1 | Toggles the border box around the text (0 = No Border, 1 = Border). |
| DimStyle | String | _DimStyles[0] | The AutoCAD Text Style (font) used for the label. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Add/Remove Format | Opens a list of available properties from the parent element. Selecting an item adds or removes it from the Format string automatically. |

## Settings Files
- **Filename**: `hsbInstallationPointSettings.xml`
- **Location**: hsbCAD Company or Install directory
- **Purpose**: Provides default configuration values and execution keys for the script during insertion.

## Tips
- **Quick Line Breaks:** To manually add a line break in the Format property, type a backslash `\` where you want the text to wrap.
- **Troubleshooting Text:** If the label displays raw code like `@(UnknownProp)`, the parent Combination does not have that specific property, or the name is spelled incorrectly.
- **Duplicate Prevention:** The script automatically detects and purges duplicate labels on the same element. If you run the script on a labeled element again, it updates the existing label rather than creating a new one.
- **Visual Clarity:** Use the `FillColor` and `Transparency` properties to make the text readable over busy geometry.

## FAQ
- **Q: My text disappeared. How do I get it back?**
  A: Check the Properties Palette for the `Format` string. If the tokens inside evaluate to empty values (e.g., the parent element has no length), the text will not display. Try adding a static label or a different property.
- **Q: Can I move the text to a different spot on the wall?**
  A: Yes. Select the text in the model and use the standard AutoCAD **Move** command or drag the grips to reposition it relative to the parent element.
- **Q: How do I change the font?**
  A: In the Properties Palette, change the `DimStyle` parameter to any valid Text Style defined in your drawing.
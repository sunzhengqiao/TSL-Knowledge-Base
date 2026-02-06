# hsb_ShowSIPWeight.mcr

## Overview
Calculates the total weight (in Kg) of an Element's Structural Insulated Panels (SIPs) and standard beams, and places a text annotation in Paper Space.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | No | Script must be inserted in Paper Space. |
| Paper Space | Yes | Intended for layout views. |
| Shop Drawing | No | This script annotates the drawing layout itself. |

## Prerequisites
- **Required Entities**: An hsbCAD Element containing SIPs and/or Beams.
- **Minimum Beam Count**: 0 (Works with just SIPs, just beams, or both).
- **Required Settings**: The script relies on Material Names defined in the SIP Style database matching the properties in the script.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_ShowSIPWeight.mcr`

### Step 2: Pick Insertion Point
```
Command Line: Pick a Point
Action: Click in the Paper Space layout where you want the weight label to appear.
```

### Step 3: Select Source Viewport
```
Command Line: Select a viewport
Action: Click on the viewport that displays the Element you wish to calculate.
```
*Note: The script will automatically calculate the weight based on the content of the view.*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Name Material 1 | text | OSB | Exact name of the first SIP layer material (e.g., Outer Skin) as defined in the SIP Style. |
| Weight Material 1(Kg/m3) | number | 450 | Density of Material 1. |
| Name Material 2 | text | Urethane | Exact name of the second SIP layer material (e.g., Insulation Core). |
| Weight Material 2(Kg/m3) | number | 450 | Density of Material 2. |
| Name Material 3 | text | (empty) | Optional name for a third SIP layer material. |
| Weight Material 3(Kg/m3) | number | 0 | Density of Material 3. |
| Name Material 4 | text | (empty) | Optional name for a fourth SIP layer material. |
| Weight Material 4(Kg/m3) | number | 0 | Density of Material 4. |
| Name Material 5 | text | (empty) | Optional name for a fifth SIP layer material. |
| Weight Material 5(Kg/m3) | number | 0 | Density of Material 5. |
| Weight for Standard Beams (Kg/m3) | number | 450 | Density of standard timber beams (GenBeams) within the element. |
| Set Color | number | 1 | AutoCAD color index for the text label (1=Red, 7=White, etc.). |
| Dimstyle | dropdown | _DimStyles | The text style used for the annotation. |
| Text Offset | number | 0 | Vertical offset distance (mm) to shift the text from the picked point. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | No custom context menu options are defined for this script. |

## Settings Files
- No external settings files are required for this script.

## Tips
- **Material Names Matter**: The values in "Name Material X" **must** match exactly (case-insensitive) with the material names in your SIP Styles. If they don't match, that layer is treated as weightless.
- **Verify Densities**: The default density for "Urethane" (450 kg/m3) is likely incorrect for insulation foam (usually ~30-40 kg/m3). Always verify densities match your real-world materials.
- **Re-positioning**: You can select the text and drag its grip to move it around the layout after insertion.
- **Updates**: If you change the model (e.g., resize a panel), the text updates automatically when the drawing is regenerated.

## FAQ
- **Q: The text says "SIP Weight: 0 Kg". Why?**
  - **A:** Check the "Name Material" properties. If the script cannot find a material in the SIP that matches your inputs, the weight is 0. Ensure the names match your hsbCAD SIP Style definitions.
- **Q: Can I use this for walls that are not SIPs?**
  - **A:** Yes, as long as the element contains GenBeams. Set "Weight for Standard Beams" to the correct timber density, and the script will calculate the weight of the studs/plates.
- **Q: How do I change the text size?**
  - **A:** Change the **Dimstyle** property to a text style defined in your drawing with the desired height.
# hsb_ShowPosnum.mcr

## Overview
This script automatically labels timber beams and mass groups with their manufacturing position numbers in the 3D model space, ensuring visual identification and tagging for production.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Script runs and annotates entities in the 3D model. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | This is a model annotation tool, not a layout generator. |

## Prerequisites
- **Required entities**: GenBeam or MassGroup entities.
- **Minimum beam count**: 1.
- **Required settings**: None.
- **Data Requirement**: Entities must have assigned position numbers (PosNum) already generated.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_ShowPosnum.mcr` from the file dialog or run via a catalog.

### Step 2: Configure Properties (Optional)
If no execution key is set, a properties dialog may appear automatically. Alternatively, set your preferred text height, color, and offset in the Properties Palette (Ctrl+1) before proceeding to the next step.

### Step 3: Select Entities
```
Command Line: Please select entities that have position numbers
Action: Click on the beams or mass groups you wish to label, then press Enter.
```
The script will process the selection and attach a position number label to each valid entity. If the script is already attached to an entity, it will update the existing label.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimstyle | dropdown | _DimStyles | Selects the drafting style (font, arrow style) for the text. |
| Color | number | 130 | Sets the CAD color index (0-255) for the text. |
| Enter Text Height | number | 80 | Defines the physical height of the text in millimeters. |
| Offset from Beam | number | 250 | Sets the distance (mm) the label is placed away from the beam surface. |
| Offset btw Lines | number | 150 | Adjusts the horizontal alignment vector (mm) relative to the insertion point. |
| Set Rotation | number | 0 | Rotates the text label around the Z-axis in degrees. |
| Disp Rep Header | text | [Blank] | Specifies a Display Representation (e.g., 'Presentation') for visibility control. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No custom context menu options are defined for this script. |

## Settings Files
- **Filename**: None required.
- **Location**: N/A
- **Purpose**: This script relies on standard entity properties and does not require external XML settings files.

## Tips
- **Element Layers**: If a beam is part of an assembly (Element), the label is automatically attached to the Element's "Info" layer, ensuring it moves with the element.
- **Visual Clash**: Increase the "Offset from Beam" value if the text is clipping into the material geometry in the 3D view.
- **Batch Processing**: You can select multiple beams or mass groups in a single selection set to label them all at once.

## FAQ
- **Q: Why didn't the text appear on my beam?**
  **A:** Ensure the beam has a valid Position Number assigned. Also, check if a specific Display Representation is set in the script properties and ensure that view is active in AutoCAD.
- **Q: How do I change the font of the position number?**
  **A:** Select the dimension style you wish to use in the `Dimstyle` property dropdown. Ensure the desired text style is configured in your CAD standard.
- **Q: Can I rotate the text to face a specific direction?**
  **A:** Yes, use the `Set Rotation` property. A value of 0 aligns it to the default beam axis; adjust degrees to rotate as needed.
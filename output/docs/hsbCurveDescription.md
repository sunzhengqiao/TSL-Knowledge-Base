# hsbCurveDescription.mcr

## Overview
This script automates the labeling of manufacturing presses (jigs) and generates a detailed lamella schedule table for curved timber beams. It provides a visual breakdown of the beam's layer structure (quantities, quality, thickness) and numbers the assigned production presses directly in the model.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script inserts the schedule table and labels into the 3D model. |
| Paper Space | No | Not supported in layout views. |
| Shop Drawing | No | This is a model-space annotation tool, not a generative drawing layout script. |

## Prerequisites
- **Required Entities**: A `CurvedDescription` entity must exist in the model.
- **Minimum Beam Count**: N/A (Operates on the curved description entity, not the beam directly).
- **Required Settings**: None specific, though Dimension Styles must exist in the drawing to populate the drop-down list.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsbCurveDescription.mcr`

### Step 2: Configure Dimension Style
```
Dialog: Show Dynamic Dialog
Action: Select the desired Dimension Style from the list to define the font and text characteristics for the schedule and labels.
```

### Step 3: Select Entity
```
Command Line: Select curved description
Action: Click on the CurvedDescription entity associated with your curved beam. You can select multiple descriptions if needed.
```

### Step 4: Define Table Location
- **If ONE entity was selected**:
  ```
  Command Line: [Point Prompt]
  Action: Click in the model to specify the insertion point for the Lamella Schedule Table.
  ```
- **If MULTIPLE entities were selected**:
  ```
  Action: The script automatically places the table at the coordinate system origin of each selected entity. No manual point picking is required.
  ```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Dimstyle | Dropdown | (First Available) | Sets the drafting text style (font, etc.) for all generated text and tables. |
| Text Height | Number | U(40) | Overrides the text height specifically for the Lamella Schedule Table. |
| Text Height (Press Label) | Number | U(40) | Overrides the text height for the numerical labels attached to the presses. |
| Color | Number | 1 | Sets the color (AutoCAD Color Index) for the schedule table lines and text. |
| Color (Press) | Number | 252 | Sets the color for standard press labels. Set to `-1` to use the press entity's native color. |
| Color (Reference Press) | Number | 4 | Sets the color for the Reference Press label (the press closest to the beam origin). Set to `-1` to use the native color. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Number Presses | Renumbers all assigned presses sequentially (1, 2, 3...) based on their position along the beam. |

## Settings Files
- **Filename**: None
- **Location**: N/A
- **Purpose**: This script uses internal logic and current drawing standards; no external XML settings file is required.

## Tips
- **Moving the Table**: Select the script instance and drag the blue grip point (`_Pt0`) to move the schedule table to a clearer location.
- **Batch Processing**: Select multiple curved descriptions at once during insertion to quickly generate schedules for an entire project without manually placing each table.
- **Color Management**: If you want the press labels to match the 3D press parts exactly, set both "Color (Press)" and "Color (Reference Press)" to `-1`.

## FAQ
- **Q: My text looks too small.**
  - **A**: Increase the `Text Height` or `Text Height (Press Label)` values in the Properties Palette.
- **Q: The press numbers are out of order.**
  - **A**: Right-click the script instance and select "Number Presses" to force a recalculation based on current positions.
- **Q: Can I change the font?**
  - **A**: Yes, change the `Dimstyle` property to select a different text style defined in your AutoCAD drawing.
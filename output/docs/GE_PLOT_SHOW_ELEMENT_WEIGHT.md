# GE_PLOT_SHOW_ELEMENT_WEIGHT

## Overview
This script calculates the total weight of a timber wall element (including beams and sheathing) based on your inventory defaults. It displays a weight tag in either Model Space or Paper Space (Viewports) and attaches the weight data to the element for export. Panels exceeding a defined weight limit are automatically highlighted in red.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Attaches to the element; follows the element in 3D. |
| Paper Space | Yes | Places tags in 2D viewports; does not attach to the element. |
| Shop Drawing | No | Used for tagging and logistics planning, not generating fabrication drawings. |

## Prerequisites
- **Required Entities**: Wall Element.
- **Minimum Beam Count**: 0 (Calculates weight for both beams and sheets/sheathing).
- **Required Settings**:
  - `hsbFramingDefaults.Inventory.dll` must be configured.
  - **Lumber Items**: Must have `Grade`, `Width`, `Height`, and `WEIGHTPERWEIGHTLENGTH` defined.
  - **Sheathing Items**: Must have `Material`, `Thickness`, and `WEIGHTPERWEIGHTAREA` defined.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `GE_PLOT_SHOW_ELEMENT_WEIGHT.mcr`

### Step 2: Select Mode
A dialog will appear upon insertion.
- **Action**: Choose the operating mode.
  - **Model**: Places the tag on the physical wall element in the model.
  - **Viewport**: Places the tag in a 2D layout view.

### Step 3: Execute (Based on Mode)

**If Model Mode is selected:**
```
Command Line: Select elements:
Action: Click on the wall element(s) you wish to tag and press Enter.
Result: The script attaches to the elements, calculates the weight, and draws the tag.
```

**If Viewport Mode is selected:**
```
Command Line: Specify insertion point:
Action: Click in the layout where you want the weight text to appear.
Command Line: Select viewport:
Action: Click on the viewport border that shows the wall element.
Result: The script identifies the element in that view and places the text.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| sMode | Dropdown | Model | Sets whether the tag lives in **Model** (3D) or **Viewport** (2D). |
| sDimStyle | String | (Current) | The AutoCAD Dimension Style used for the text (controls font and size). |
| dMaxWeight | Number | 230 (kg) / 500 (lbs) | The weight limit. If the element is heavier, the text turns **Red**. |
| sShowPrefix | Enum | Yes | Adds the word "Weight:" before the number (e.g., "Weight: 500kg"). |
| sEraseAfterInsertion | Enum | No | **Model Only**. If Yes, deletes the script instance after running once to keep the file size small. |
| dOffset | Number | 50 (mm) / 2 (in) | **Model Only**. The distance between the wall arrow and the text label. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| Report issues | Re-prints warning messages to the command line (e.g., beams with missing grades or missing weight data in the Defaults Editor). |

## Settings Files
- **Filename**: `hsbFramingDefaults.Inventory.dll` (accessed via Defaults Editor)
- **Location**: Defined in your hsbCAD configuration.
- **Purpose**: Provides material density data. Ensure Lumber items have `WEIGHTPERWEIGHTLENGTH` and Sheathing items have `WEIGHTPERWEIGHTAREA` populated for specific grades/materials.

## Tips
- **Troubleshooting 0 Weight**: If the tag shows "Weight: 0", use the **Report issues** right-click option. You likely have beams without a Grade assigned or materials missing weight definitions in the Defaults Editor.
- **Transport Planning**: Use the `dMaxWeight` property to highlight heavy panels (Red) automatically, helping to identify if a wall needs to be split for transport.
- **Clean Model**: In **Model Mode**, set `sEraseAfterInsertion` to **Yes**. The tag will remain visible, but the script instance is removed, preventing the script from recalculating unnecessarily and slowing down the model.

## FAQ
- **Q: Why is my text Red?**
  - A: The calculated weight of the element exceeds the `dMaxWeight` value set in the properties. Increase the limit or verify the element weight.
- **Q: Can I move the text tag manually?**
  - A: Yes. You can use standard AutoCAD grips or the Move command to reposition the text. Note that in Model Mode, updating the script properties may reset the position to the calculated offset.
- **Q: What units does it use?**
  - A: The script automatically adapts to your drawing units (Metric or Imperial), displaying kg or lbs respectively.
# HSB_W-ProfiledHeader.mcr

## Overview
This utility allows you to batch modify the cross-section profiles and material properties of header beams located above wall openings. It is useful for replacing standard rectangular headers with specific profiled sections (e.g., glulams) and updating material grades for multiple openings at once.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D model elements. |
| Paper Space | No | Not designed for layout views. |
| Shop Drawing | No | Not designed for 2D detailing views. |

## Prerequisites
- **Required Entities**: Wall openings (`OpeningSF`) must exist in the model.
- **Parent Elements**: The selected openings must belong to a Wall (`Element`) that contains existing Header beams.
- **Minimum Beam Count**: Existing header beams must be present above the openings to be modified.

## Usage Steps

### Step 1: Launch Script
1.  Type `TSLINSERT` in the command line.
2.  Browse to and select `HSB_W-ProfiledHeader.mcr`.

### Step 2: Configure Properties
1.  Upon insertion, a dialog or the Properties Palette will appear displaying the script parameters.
2.  **Extrusion profile name**: Select the desired cross-section shape (e.g., Rectangular, Round, or custom profiles) from the dropdown list.
3.  **Material**: Enter the material name (e.g., C24, GL24h) to apply. *Leave this blank to keep the beam's current material.*
4.  **Copy profile name to**: Choose whether to save the selected profile name into the beam's "Information" field for reporting.
5.  Press **Enter** or click **OK** to confirm settings.

### Step 3: Select Openings
```
Command Line: Select one or more openings
Action: Click on individual wall openings or drag a window to select multiple openings in the model.
```

### Step 4: Completion
The script will process the selected openings, identify the associated header beams, and apply the new profile and material settings. The script instance will automatically delete itself from the drawing once finished.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Extrusion profile name** | Dropdown | Rectangular | Select the specific cross-sectional shape to apply to the header beams. |
| **Material** | Text | (Empty) | The timber grade or species to assign. If left empty, the existing material is preserved. |
| **Copy profile name to** | Dropdown | Do not copy | Select "Information" to automatically write the profile name into the beam's Information field. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script runs immediately upon insertion and does not remain in the drawing to offer context menu options. |

## Settings Files
- **None**: This script does not rely on external settings or XML files for configuration.

## Tips
- **Batch Processing**: You can select multiple wall openings in a single step to update all headers in a wall or floor plan efficiently.
- **Material Preservation**: If you only want to change the shape (profile) of the headers but keep the current material, ensure the **Material** field is left empty.
- **Verification**: Since the script deletes itself automatically, use the AutoCAD `UNDO` command immediately after execution if the results are not as expected.

## FAQ
- **Q: I ran the script, but it disappeared and didn't seem to do anything.**
  - **A**: Ensure you selected valid `OpeningSF` entities that actually have Header beams associated with them. If the opening has no header above it, the script will find nothing to modify.
- **Q: Can I use this to edit beams other than headers?**
  - **A**: No, this script specifically searches for and modifies only the beams identified as `_kHeader` type within the parent wall element.
- **Q: How do I change the headers back to the original shape?**
  - **A**: Run the script again, select the original profile (e.g., Rectangular) and the original dimensions, and select the same openings. Alternatively, use the standard AutoCAD `UNDO` command if the change was recent.
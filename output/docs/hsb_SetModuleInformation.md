# hsb_SetModuleInformation.mcr

## Overview
This utility script automatically assigns "Module" names to sheathing panels (Sheets) based on the modules assigned to the structural framing (Beams) within selected Wall Elements. It ensures that cladding and structural components share consistent module data for organization, numbering, and export filtering.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D Wall Elements containing beams and sheets. |
| Paper Space | No | This tool does not function in layout views. |
| Shop Drawing | No | This is a model organization tool, not a drawing generation script. |

## Prerequisites
- **Required Entities:** Structural Frame Wall Elements (`ElementWallSF`) that contain both Beams (structure) and Sheets (sheathing/cladding).
- **Module Data:** The structural Beams within the walls must already have a "Module" property assigned. If the beams have no module name, the script has nothing to transfer to the sheets.
- **Model Space:** You must be in the Model Space to select and process the elements.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse to the script location and select `hsb_SetModuleInformation.mcr`.

### Step 2: Select Wall Elements
```
Command Line: Select a set of elements
Action: Click on the Wall Elements you wish to update. You can select multiple walls at once. Press Enter to confirm your selection.
```

### Step 3: Automatic Processing
Action: The script will automatically calculate the geometric extents of each module defined by the beams and apply those names to any overlapping sheets. The script instance will automatically delete itself from the model once the process is complete.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| N/A | N/A | N/A | This script is a transient utility and does not create a persistent entity with editable properties. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| N/A | This script removes itself from the model after execution; no context menu is available. |

## Settings Files
- **Filename:** None
- **Location:** N/A
- **Purpose:** This script does not rely on external settings files.

## Tips
- **Preparation:** Verify your wall beams (studs, plates, etc.) have the correct "Module" names in the Properties Palette before running this script.
- **Verification:** Since the script erases itself immediately, check the "Module" property of a few Sheets in the wall to confirm the update was successful.
- **Complex Walls:** The script works by geometrically checking where sheets fall relative to the beam modules. Ensure your wall geometry is clean for the best results.

## FAQ
- **Q: I ran the script, but the Sheets still have no Module name. Why?**
  **A:** Check the Beams in the wall. If the Beams do not have a "Module" name assigned, the script cannot detect which module the sheets belong to.
- **Q: Why did the script disappear from the model?**
  **A:** This is a "utility" script designed to perform a task and then clean up after itself. It does not need to remain in the drawing.
- **Q: Can I use this on roof elements?**
  **A:** The script is designed for `ElementWallSF` (Structural Frame Walls). While it might technically process other element types if they contain beams and sheets, it is intended for vertical wall applications.
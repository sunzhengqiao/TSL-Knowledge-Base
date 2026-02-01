# hsb_ConvertBeamToJoistProfile.mcr

## Overview
This script standardizes the cross-sectional profile of specific beams within selected elements. It automatically updates the width and height of filtered beams to match the profile of the element's center joist.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script operates on 3D Elements and Beams in the model. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities:** Elements containing Beams.
- **Minimum Beam Count:** 1
- **Required Settings:** None

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse the file list and select `hsb_ConvertBeamToJoistProfile.mcr`.

### Step 2: Select Elements
```
Command Line: Select a set of elements
Action: Click on the Elements (or Zones) in the model that contain the beams you wish to update. Press Enter to confirm selection.
```

### Step 3: Configure Filter (Optional)
Action: Before or after selecting elements, open the **Properties Palette** (Ctrl+1). Enter the specific Beam Codes you wish to target in the *Convert Beams with Code* field.

### Step 4: Execution
Action: Once the elements are selected, the script will automatically identify the center joist's profile and apply it to all matching beams within those elements.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Convert Beams with Code | Text | "" | Enter the Beam Codes (e.g., 'Rafter', 'Purlin') to identify which beams should be updated. Separate multiple codes with a semicolon ';'. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| None | No custom right-click menu options are available for this script. |

## Settings Files
- **Filename**: None required.

## Tips
- **Target Profile:** Ensure that the "Center Joist" of the element already has the correct profile before running the script, as this is the source shape used for the conversion.
- **Beam Codes:** If the `Convert Beams with Code` field is left empty, the script may not update any beams depending on your project setup. Always verify the Beam Codes in your model match the text entered in the properties.
- **Zone Selection:** You can select an entire Zone (if supported by your project structure), and the script will attempt to convert all applicable beams within that Zone.

## FAQ
- **Q: Why didn't my beams change size?**
  **A:** Check the `Convert Beams with Code` property. Ensure the Beam Codes assigned to your beams in the model exactly match the text you entered (remember to separate them with `;`).
- **Q: Which profile is applied to the beams?**
  **A:** The script reads the cross-section from the first "Center Joist" found in the selected Element. Ensure this beam has the desired dimensions.
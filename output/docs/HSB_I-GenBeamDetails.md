# HSB_I-GenBeamDetails.mcr

## Overview
This script generates a detailed text report displaying geometric dimensions, material attributes, naming properties, and a list of attached TSLs for selected structural elements (Beams, Sheets, or SIPs). It acts as a quick auditing tool to review element properties without opening multiple property palettes.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in Model Space. |
| Paper Space | No | Not supported. |
| Shop Drawing | No | Not supported. |

## Prerequisites
- **Required entities**: General Beam (GenBeam), Sheet, or Structural Insulated Panel (SIP).
- **Minimum beam count**: 1 (supports multiple selection).
- **Required settings**: None.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `HSB_I-GenBeamDetails.mcr`

### Step 2: Select Elements
```
Command Line: Select GenBeam(s)
Action: Click on the desired beam, sheet, or SIP in the model. You can select multiple elements.
```
**Note**: Press Enter to confirm your selection.

### Step 3: View Report
```
Action: A notice window will appear displaying the detailed report for the selected elements.
```
**Note**: Review the information and close the notice window. The script will automatically remove itself from the drawing once finished.

## Properties Panel Parameters

This script has no editable parameters in the Properties Palette.

## Right-Click Menu Options

This script does not add custom options to the right-click menu.

## Settings Files
No external settings files are required for this script.

## Tips
- **Batch Auditing**: You can select multiple elements at once during the prompt. The script will generate a separate report for each element found in the selection set.
- **Troubleshooting**: Use this script to quickly verify which TSLs (scripts) are attached to a specific element if it is not behaving as expected.
- **Clean Workflow**: The script is designed to "self-destruct" after running. You do not need to delete the script instance manually; it cleans itself up automatically.

## FAQ
- **Q: Can I run this on Walls?**
  - A: Yes, provided the walls are defined as GenBeams, Sheets, or SIPs within the hsbCAD environment.
- **Q: What happens if I select an element that is not a Beam or Sheet?**
  - A: The script will report an error and skip that specific entity. Ensure you select valid structural timber elements.
- **Q: Where does the text report appear?**
  - A: The report appears in a standard hsbCAD ShowNotice (pop-up dialog) on your screen.
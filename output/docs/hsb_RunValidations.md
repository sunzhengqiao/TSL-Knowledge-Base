# hsb_RunValidations.mcr

## Overview
This script launches the hsbCAD Validation Inspector tool to check selected construction elements (walls, floors, roofs) against company-specific design rules and standards. It generates a detailed report of errors and clashes to help ensure model integrity before manufacturing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script is designed for 3D model verification. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Not used within single-element shop drawings. |

## Prerequisites
- **Required Entities**: Elements (Walls, Floors, or Roofs).
- **Minimum Beam Count**: None (entire Elements are selected).
- **Required Settings**: The external hsbValidation DLLs must be installed in the hsbCAD Utilities folder:
  - `...Utilities\hsbValidation\hsbValidationTSL.dll`
  - `...Utilities.Acad\hsbValidation\hsbValidationInspectorAcad.dll`

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_RunValidations.mcr`

### Step 2: Select Test Group
```
Dialog: Properties
Action: Use the "Test Group" dropdown to select the set of validation rules (e.g., General, Material, Machining) you wish to run. Click OK.
```

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the Elements (Walls, Floors, Roofs) in your 3D model that you want to check. Press Enter to confirm selection.
```
*(The script will then launch the Validation Inspector window and automatically remove itself from the drawing.)*

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Test Group | Dropdown | First item available | Selects the specific validation rule set or configuration group to run against the selected elements. Options are retrieved from your company's hsbValidation configuration. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| None | This script executes immediately upon insertion and erases itself from the drawing. There are no context menu options available after execution. |

## Settings Files
- **DLL Dependencies**: `hsbValidationTSL.dll`, `hsbValidationInspectorAcad.dll`
- **Location**: `_kPathHsbInstall\Utilities\hsbValidation\` and `_kPathHsbInstall\Utilities.Acad\hsbValidation\`
- **Purpose**: These external files contain the logic for the validation rules and the interface for the Inspector window. The specific rule sets are usually managed by your CAD Manager via external configuration files referenced by these DLLs.

## Tips
- The script is a "one-time command" tool; it will disappear from your drawing immediately after launching the inspector.
- You can select multiple Elements at once using a window selection during the command line prompt.
- If the "Test Group" dropdown is empty, contact your CAD Manager, as the validation configuration files may be missing or misconfigured.

## FAQ
- **Q: Where do I see the validation results?**
  A: A standalone "Validation Inspector" window will open displaying a list of errors, warnings, and info messages based on the checks performed.
- **Q: Can I re-run the script on the same elements?**
  A: Yes, simply insert the script again (`TSLINSERT`), select your desired Test Group, and pick the elements again.
- **Q: Why did the script block vanish from the model?**
  A: The script is designed to run once and then delete itself (`eraseInstance`) to avoid cluttering the drawing. It does not affect your geometry.
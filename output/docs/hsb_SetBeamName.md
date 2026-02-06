# hsb_SetBeamName

## Overview
This script automates the standardization of beam properties (Names, Materials, Grades, and Colors) within timber wall or floor elements. It is designed to batch-process generated elements to ensure consistency for production lists, labeling, and visual quality control.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script searches for and processes Timber Elements in the current model. |
| Paper Space | No | This script does not operate on 2D drawings or layouts. |
| Shop Drawing | No | This is a 3D model processing script. |

## Prerequisites
- **Required Entities**: Timber Elements (Walls/Floors) must exist in the Model Space.
- **Minimum Beam Count**: 0 (The script will simply skip empty elements).
- **Required Settings**: None (Uses internal properties or script defaults).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SetBeamName.mcr` from the file browser.

### Step 2: Configure Properties
Before clicking to place the script, open the **AutoCAD Properties Palette (Ctrl+1)**.
- Set the desired **Naming Conventions** (e.g., "STUD", "TOP PLATE").
- Configure **Color** and **Material** settings.
- Adjust **Filters** if specific beams should be excluded from changes.

### Step 3: Execute Script
```
Command Line: TSLINSERT
Action: Click anywhere in the Model Space to insert the script instance.
```
The script will immediately scan all elements in the model, apply the configured properties, and then automatically delete itself.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Set Default Color** | dropdown | No | Applies a standard color to all beams for visual checking. |
| **Set Module Beam with Default Color** | dropdown | No | If "Yes", overwrites the color of beams inside imported Modules (sub-elements). |
| **Set Information Field** | dropdown | No | If "Yes", populates the beam's 'Information' field with its Name if it is currently empty. |
| **Set subLabel with Group Name** | dropdown | No | If "Yes", sets the beam's 'SubLabel' to the parent Element's Group Name. |
| **Append Wall Type to subLabel** | dropdown | No | If "Yes", appends the Wall Type to the SubLabel (e.g., "ExtWall"). |
| **Use detail beam properties (if any)** | dropdown | No | If "Yes", preserves specific beam names defined in Details rather than overwriting them. |
| **Exclude Color on Beams with Code** | text | X; | List of beam codes (separated by `;`) to exclude from color changes. |
| **Default Color** | number | 7 | The AutoCAD Color Index (ACI) number to apply if coloring is enabled. |
| **Jack Over Opening** | text | LINTOL PACKERS | Sets the name for Jack/Rafter beams located above openings. |
| **Jack Under Opening** | text | SILL STUDS | Sets the name for Jack/Rafter beams located below openings. |
| **Cripple Stud** | text | CRIPPLE | Sets the name for Cripple Studs. |
| **Transom** | text | TRANSOM | Sets the name for Transom beams. |
| **King Stud** | text | STUD | Sets the name for King Studs. |
| **Sill** | text | SILL | Sets the name for Sill plates. |
| **Angled TopPlate Left** | text | TOP PLATE | Sets the name for left-angled top plates. |
| **Angled TopPlate Right** | text | TOP PLATE | Sets the name for right-angled top plates. |
| **TopPlate** | text | TOP PLATE | Sets the name for standard Top Plates. |

## Right-Click Menu Options
This script executes automatically upon insertion and erases itself immediately. There are no persistent right-click menu options associated with it.

## Settings Files
- **Filename**: None required.
- **Location**: N/A.
- **Purpose**: All settings are managed directly via the AutoCAD Properties Palette during insertion.

## Tips
- **Visual QC**: Enable "Set Default Color" and choose a bright color (e.g., Red) to quickly verify that all beams in a complex wall have been processed by the script.
- **Preserving Manual Names**: If you have manually renamed specific beams in your details and want to keep them, set **Use detail beam properties (if any)** to "Yes".
- **Exclusions**: Use the **Exclude Color on Beams with Code** field to ensure that hardware or special non-timber items (defined by specific codes) are not recolored by the batch process.

## FAQ
- **Q: Why did the script disappear immediately after I inserted it?**
  **A:** This is normal behavior. The script is a "run-once" processor. It scans the model, updates the beams, and then performs an automatic cleanup (`eraseInstance`) to avoid cluttering your drawing.
- **Q: How do I change the Material or Grade?**
  **A:** The script uses internal defaults (typically 'CLS' and 'C16') if these fields are empty. To change these defaults, you must edit the script source code or the specific element defaults before running this script, as these specific parameters are not exposed in the Properties Panel in this version.
- **Q: The script didn't change the name of a specific beam. Why?**
  **A:** Check if the beam has a specific name defined in its Detail properties. If **Use detail beam properties (if any)** is set to "Yes", the script will respect the existing name.
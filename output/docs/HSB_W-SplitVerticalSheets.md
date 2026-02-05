# HSB_W-SplitVerticalSheets.mcr

## Overview
This script optimizes wall or roof cladding sheets by squaring off their ends and cutting them into standardized lengths suitable for transport or manufacturing. It processes selected Elements and filters sheets based on specific criteria before modifying their geometry.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Must be run in 3D Model Space. |
| Paper Space | No | Not applicable for 2D layouts. |
| Shop Drawing | No | Designed for 3D model processing. |

## Prerequisites
- **Required Entities**: Elements containing Sheet entities (GenBeams).
- **Dependencies**: The script `HSB_G-FilterGenBeams.mcr` must be loaded in the drawing to allow filtering.
- **Context**: Works best on Elements where sheets run parallel to the Element X-axis.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT`
Action: Browse and select `HSB_W-SplitVerticalSheets.mcr`.

### Step 2: Configure Properties
Dialog: Properties
Action: Set the filtering criteria (Zone, Material, etc.) and optimizing parameters (Optimized Length, Gap) in the Properties Palette or the initial dialog.
- If `sOptimizeLength` is set to "Yes", ensure `dOptimizedLength` matches your stock material size.

### Step 3: Select Elements
```
Command Line: Select a set of elements
Action: Click on the Elements in the model that contain the sheets you wish to process. Press Enter to confirm selection.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| **Filtering** | | | |
| Operator | Dropdown | All | Determines if "All" filter conditions must be met or just "Any". |
| Filter sheets in zone | Dropdown | 0 | Select a specific zone number (1-10) to process only sheets in that zone. |
| Filter sheets with beamcode | Text | (empty) | Enter a beam code to only process sheets matching this code. |
| Filter sheets with label | Text | (empty) | Enter a label to only process sheets with this specific label. |
| Filter sheets with material | Text | (empty) | Enter a material name to only process sheets made of this material. |
| Filter sheets with hsbID | Text | (empty) | Enter a specific hsbID to target a single sheet instance. |
| **Optimizing** | | | |
| Make ends squared | Dropdown | Yes | If "Yes", trims the ends of the sheets to be perfectly square (90°) relative to the element axis. |
| Optimize length | Dropdown | Yes | If "Yes", splits long sheets into segments of the target "Optimized length". |
| Optimized length | Number | 10000 | The target length (mm) for the resulting sheet segments. |
| Gap | Number | 0 | The saw kerf width (mm) or spacing to subtract between cut pieces. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | No specific context menu options are defined for this script. |

## Settings Files
- **Filename**: None specified
- **Location**: N/A
- **Purpose**: This script relies on dependencies (`HSB_G-FilterGenBeams`) rather than specific external XML settings files.

## Tips
- **Saw Kerf**: If you are cutting sheets on a CNC or saw, set the **Gap** parameter to the width of your saw blade (e.g., 4mm or 5mm) to ensure the cut pieces fit perfectly within the raw material length.
- **Clean Ends**: Use the **Make ends squared** option when walls have non-90° corners or irregular geometry to create clean, rectangular sheets for fabrication.
- **Filtering**: Use the **Operator** "Any" with a Material filter if you want to catch all sheets of a certain material regardless of their Zone or Label.

## FAQ
- **Q: Why did the script report an error about filtering?**
  A: Ensure that the script `HSB_G-FilterGenBeams.mcr` is loaded into your drawing. This script is required to process the filtering logic.
- **Q: Can I split sheets horizontally (height-wise)?**
  A: No, this script is designed to split "Vertical" sheets, meaning it cuts them along their length (usually the wall length) into shorter, standardized lengths.
- **Q: The script disappeared after I selected elements. Did it fail?**
  A: No, this is normal behavior. The script creates "satellite" instances on the elements to perform the work and then erases the master instance. Check your sheets to see if they were modified.
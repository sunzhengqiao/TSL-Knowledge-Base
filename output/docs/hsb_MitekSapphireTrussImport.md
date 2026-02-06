# hsb_MitekSapphireTrussImport

## Overview
Imports structural timber truss data from Mitek Sapphire software into the hsbCAD model via IFC, organizing elements into the Project Manager.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Geometry is generated here. |
| Paper Space | No | Not intended for layout or detailing. |
| Shop Drawing | No | Not a shop drawing script. |

## Prerequisites
- **Required Entities**: None. This is an import tool.
- **Minimum Beam Count**: 0.
- **Required Settings**:
  - `hsbSteicoIO.dll` must be located in the `Utilities\hsbCloudStorage\` folder of your hsbCAD installation.
  - Access to valid Mitek IFC export data.

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_MitekSapphireTrussImport.mcr`

### Step 2: Configure Properties
```
Command Line: Properties Palette displays automatically
Action: Set the destination folders and import filters.
```
The script will immediately prompt you with the Properties Palette. Configure your import settings here.

### Step 3: Execute Import
```
Command Line: None
Action: Close the Properties Palette or click in the drawing area.
```
The script will call the external import function, generate the geometry, and then remove itself from the model.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Truss Group Name | Text | Trusses\Ground_Floor | The destination folder path in the Project Manager where the Truss Assemblies will be created. |
| Beam Group Name | Text | Beams\Ground_Floor | The destination folder path in the Project Manager where individual timber members (chords/webs) will be stored. |
| Truss Name Filter | Text | [Empty] | A specific text string to filter which trusses to import. Leave empty to import all trusses from the source file. |

## Right-Click Menu Options
| Menu Item | Description |
|-----------|-------------|
| None | This script executes once and deletes itself; it does not remain in the model for right-click interactions. |

## Settings Files
- **Filename**: `hsbSteicoIO.dll`
- **Location**: `%hsbInstallPath%\Utilities\hsbCloudStorage\`
- **Purpose**: Provides the `ImportMitekIFC` function required to parse and convert Mitek Sapphire data into hsbCAD entities.

## Tips
- Use backslashes (`\`) when typing folder paths in the Group Name properties (e.g., `Roof\Trusses`).
- If the script runs but creates no geometry, check your **Truss Name Filter**. You may have filtered out the specific trusses you are looking for.
- Since the script deletes itself after running, ensure your properties are correct before closing the Properties Palette. To run again, simply re-insert the script.

## FAQ
- **Q: I ran the script, but I can't find it to edit the properties again.**
  - A: This script is designed to "self-destruct" using `eraseInstance()` immediately after importing. To change settings, delete the imported beams/trusses and insert the script fresh.
- **Q: How do I import trusses to a different floor?**
  - A: Before running the script, change the **Truss Group Name** and **Beam Group Name** in the Properties Palette to reflect the desired floor (e.g., change `Ground_Floor` to `First_Floor`).
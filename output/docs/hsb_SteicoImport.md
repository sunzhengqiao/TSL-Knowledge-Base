# hsb_SteicoImport.mcr

## Overview
Imports structural floor layouts designed in Steico software into the hsbCAD 3D model. It automatically generates timber elements (I-Joists, beams, noggins, etc.) and places them into specified project catalog groups, then removes itself from the drawing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | Generates 3D structural elements. |
| Paper Space | No | Not applicable. |
| Shop Drawing | No | Not applicable. |

## Prerequisites
- **Required Settings**: `hsbSteicoIO.dll` (usually located in `hsbCAD\Utilities\hsbCloudStorage`).
- **External Data**: Valid Steico CAD data accessible to the import function.
- **Minimum Entities**: None (this script creates new entities).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `hsb_SteicoImport.mcr`

### Step 2: Configure Group Names
Upon insertion, the configuration dialog will appear automatically.
```
Action: Review the "Group Name" fields in the dialog.
Action: Modify the default catalog paths (e.g., change "Ground_Floor" to "First_Floor") to match your current project structure.
Action: Click OK to start the import process.
```

### Step 3: Generation and Completion
```
Action: The script will communicate with the Steico IO engine to import data.
Result: 3D entities (I-Joists, Beams, Noggins, etc.) are generated in Model Space and sorted into the specified groups.
Result: The script instance is automatically deleted from the drawing.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| IJoist Group Name | Text | I-Joists\Ground_Floor | Destination catalog folder for imported I-Joists. |
| Member Group Name | Text | Member\Ground_Floor | Destination catalog folder for imported structural Members. |
| Beam Group Name | Text | Beams\Ground_Floor | Destination catalog folder for imported Beams. |
| Noggin Group Name | Text | Noggins\Ground_Floor | Destination catalog folder for imported Noggins. |
| Blocking Group Name | Text | Blocking\Ground_Floor | Destination catalog folder for imported Blocking. |
| Sacrificial Joists Group Name | Text | Sacrificial Joists\Ground_Floor | Destination catalog folder for imported Sacrificial Joists. |
| End Device Group Name | Text | End Device\Ground_Floor | Destination catalog folder for imported hardware/devices. |
| Rimboard Group Name | Text | Rimboard\Ground_Floor | Destination catalog folder for imported Rimboard elements. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| (None) | The script deletes itself immediately after generating the elements, leaving no instance to right-click. |

## Settings Files
- **Filename**: `hsbSteicoIO.dll`
- **Location**: `_kPathHsbInstall\Utilities\hsbCloudStorage\`
- **Purpose**: Provides the `ImportCadModel` function required to interpret Steico CAD data and generate the 3D geometry within hsbCAD.

## Tips
- **Folder Setup**: Ensure the target catalog folders (e.g., "Structure\First_Floor") exist or are valid paths within your Project Manager before running the script to ensure elements are organized correctly.
- **Multiple Floors**: If importing designs for multiple floors, run the script repeatedly for each floor, updating the "Group Name" properties (e.g., changing "Ground_Floor" to "First_Floor") during each insertion.
- **Script Removal**: Do not be alarmed if the script icon disappears after execution; this is intended behavior. The resulting timber beams and elements will remain in the model.

## FAQ
- Q: The script disappeared after I ran it. Is that normal?
- A: Yes. This script functions as a one-time import tool. It generates the 3D model and then deletes itself to keep the drawing clean.
- Q: How do I import the design for the first floor instead of the ground floor?
- A: When the configuration dialog opens during insertion, simply edit the text in the Group Name fields (e.g., change "Ground_Floor" to "First_Floor") before clicking OK.
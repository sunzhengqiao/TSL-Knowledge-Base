# TrussImport.mcr

## Overview
Imports engineered truss geometry and structural data from an external source into the hsbCAD model, automatically organizing the generated components (beams, planes, and assemblies) into specified project groups.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script generates 3D geometry and entities within the active model. |
| Paper Space | No | |
| Shop Drawing | No | |

## Prerequisites
- **Required Entities:** None (This script creates new entities).
- **Minimum Beam Count:** 0.
- **Required Settings:** 
  - The external DLL file `Utilities\hsbCloudStorage\hsbTrussIO.dll` must be present in your hsbCAD installation.
  - Valid truss data must be available from the connected external engineering source (e.g., hsbCloud).

## Usage Steps

### Step 1: Launch Script
Command: `TSLINSERT` → Select `TrussImport.mcr`

### Step 2: Configure Grouping
Before the script processes the import, you can define where the elements will be placed in your project structure.
```
Action: Select the script instance in the model (if inserted at 0,0,0) or check Properties immediately after insertion.
Input: Update the "Group Name" parameters in the Properties Palette to match your desired project folder structure (e.g., "Structure\Roof\Level1").
```

### Step 3: Execute Import
```
Action: Once properties are set, the script communicates with the external DLL to generate the trusses.
Note: If the import does not start automatically, verify the connection to the external data source.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Truss Group Name | text | Trusses\Ground_Floor | The destination folder path in the project browser where the main Truss assemblies will be placed. |
| Beam Group Name | text | Beams\Ground_Floor | The destination folder path where the individual timber elements (chords and webs) will be placed. |
| Roof Plane Group Name | text | RoofPlanes\Ground_Floor | The destination folder path for Roof Plane entities generated from the truss geometry. |
| Ceiling Plane Group Name | text | CeilingPlanes\Ground_Floor | The destination folder path for Ceiling Plane entities generated from the bottom chord geometry. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | No specific context menu options are defined for this script. Configuration is handled via the Properties Palette. |

## Settings Files
- **Filename**: `hsbTrussIO.dll`
- **Location**: `Utilities\hsbCloudStorage\`
- **Purpose**: This external library handles the logic to interpret structural data and generate the specific geometry, beams, and planes within the model.

## Tips
- **Project Organization:** Use backslashes `\` when typing group paths to define subfolders (e.g., `ProjectName\Level2\Trusses`).
- **Batch Imports:** If importing multiple floors or sections, change the "Group Name" properties (e.g., from "Ground_Floor" to "First_Floor") and insert the script again to keep your model tree organized.
- **Troubleshooting:** If the script inserts but produces no geometry, check that the `hsbTrussIO.dll` is not blocked by firewall or antivirus software, as it needs to communicate with external data sources.

## FAQ
- **Q: Where do I select the specific truss file to import?**
  - A: This script relies on a pre-configured connection or active session handled by the `hsbTrussIO.dll`. You typically select the job or data within the external engineering tool or cloud interface before running this script.
- **Q: Can I modify the truss shape after importing?**
  - A: Yes, once the beams and planes are generated in the model, they become standard hsbCAD entities that can be edited or detailed further.
- **Q: What happens if I enter a Group Name that doesn't exist?**
  - A: The script (or the underlying system) will typically attempt to create the group structure automatically based on the path provided.
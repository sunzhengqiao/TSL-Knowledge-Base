# hsb_CHHImport.mcr

## Overview
Imports structural timber data (floors and beams) from a CHH IFC file into the hsbCAD model, automatically organizing the imported elements into specified model groups and then removing itself from the drawing.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | The script generates 3D geometry (GenBeams and Elements) directly in the model. |
| Paper Space | No | This script does not create 2D views or annotations. |
| Shop Drawing | No | This script is not used for detailing or creating manufacturing drawings. |

## Prerequisites
- **Required entities**: None (The script creates new entities).
- **Minimum beam count**: 0.
- **Required settings files**:
  - `hsbSteicoIO.dll` must be located in `hsbInstall\Utilities\hsbCloudStorage`.

## Usage Steps

### Step 1: Launch Script
```
Command Line: TSLINSERT
Action: Browse and select hsb_CHHImport.mcr, then click Open.
```

### Step 2: Configure Group Names
```
Action: Use the Properties Palette (OPM) to set the destination paths for your imported data.
Details: By default, the script suggests "Floors\Ground_Floor" for floor elements and "Beams\Ground_Floor" for beams. Adjust these paths to match your project's Model Tree structure.
```

### Step 3: Select CHH File
```
Action: A file selection dialog (from the external hsbSteicoIO tool) will appear automatically.
Details: Navigate to and select the source CHH IFC file you wish to import.
```

### Step 4: Complete Import
```
Action: The script processes the file and generates the geometry.
Result: The imported floor elements and beams appear in the Model Tree under the groups specified in Step 2. The script instance is automatically deleted from the drawing.
```

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Floor Element Group Name | text | `Floors\Ground_Floor` | The destination folder path in the Model Tree where imported floor panels or slabs (plate elements) will be stored. |
| Beam Group Name | text | `Beams\Ground_Floor` | The destination folder path in the Model Tree where imported structural members (joists, beams) will be stored. |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| None | This script is transient and deletes itself immediately after running; it does not remain in the model to offer context menu options. |

## Settings Files
- **Filename**: `hsbSteicoIO.dll`
- **Location**: `hsbInstall\Utilities\hsbCloudStorage`
- **Purpose**: Provides the external functionality to parse the CHH IFC file format and map the data for hsbCAD.

## Tips
- **Script Behavior**: This script is designed as a "one-shot" wizard. Once the import is complete, the script object is erased. To re-import or change settings, you must insert the script again.
- **Folder Preparation**: Ensure the Group Names specified in the Properties Panel exist in your Model Tree, or be prepared to create them manually if the automatic creation fails (depending on your hsbCAD configuration).
- **Headless Mode**: If executed via a specific preset or command key (_kExecuteKey), the script may run without showing the property dialog, using the last known or catalog default values.

## FAQ
- **Q: Why does the script disappear after I run it?**
  **A:** The script is designed to be a transient import tool. Once it calls the external DLL and generates the geometry, it executes `eraseInstance()` to clean up the drawing.
- **Q: What happens if the file selection dialog does not appear?**
  **A:** This usually means `hsbSteicoIO.dll` is missing or located in the wrong folder. Verify that it exists in `hsbInstall\Utilities\hsbCloudStorage`.
- **Q: Can I import into an existing group?**
  **A:** Yes. Simply type the exact path of the existing group (e.g., `Project\Level 1\Walls`) into the corresponding Group Name property before running the import.
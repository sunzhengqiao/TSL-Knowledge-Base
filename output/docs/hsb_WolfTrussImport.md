# hsb_WolfTrussImport.mcr

## Overview
This script imports roof truss geometry and data from an external Wolf (IFC) source directly into your hsbCAD model. It automatically organizes the imported trusses and their individual timber components into specified project groups.

## Usage Environment
| Space | Supported | Notes |
|-------|-----------|-------|
| Model Space | Yes | This script must be run in Model Space to generate geometry. |
| Paper Space | No | Not supported for layout views. |
| Shop Drawing | No | This is a modeling tool, not a detailing script. |

## Prerequisites
- **Required Settings**: The file `hsbSteicoIO.dll` must be present in your hsbCAD installation directory (`Utilities\hsbCloudStorage`).
- **Project Structure**: It is recommended (though not strictly enforced) to have the target Group Names (e.g., "Trusses") created in your project tree beforehand to ensure organization.

## Usage Steps

### Step 1: Launch Script
1. Type `TSLINSERT` in the AutoCAD command line.
2. Select `hsb_WolfTrussImport.mcr` from the file dialog.
3. Click in the Model Space to insert the script instance (location does not affect the import, but insertion is required to activate).

### Step 2: Configure Properties
Immediately after insertion, the script is active. Before the geometry generates, configure the import settings in the **Properties Palette** (usually on the right side of the screen).

| Parameter | Action |
|-----------|--------|
| **Truss Group Name** | Enter the group path where the main truss assemblies should be stored (e.g., `1st Floor\Roof\Trusses`). |
| **Beam Group Name** | Enter the group path for individual beams/chords (e.g., `1st Floor\Roof\Timber`). |
| **Truss Name Filter** | (Optional) Enter a text string to filter specific trusses from the source file. Leave blank to import all trusses. |

### Step 3: Execute Import
1. Once properties are set, the script will attempt to execute the import logic automatically.
2. If a file dialog or external prompt appears (from the Steico IO plugin), select the appropriate Wolf/IFC source file.
3. The script will generate the geometry and then **automatically delete itself** from the drawing.

## Properties Panel Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Truss Group Name | Text | `Trusses\Ground_Floor` | Determines the destination group in the project tree for the imported truss assemblies. |
| Beam Group Name | Text | `Beams\Ground_Floor` | Determines the destination group for the individual timber members (chords/webs) if they are imported as separate entities. |
| Truss Name Filter | Text | ` (Empty)` | allows you to import only specific trusses. Enter a name or partial name to filter the list (e.g., "Attic" to import only attic trusses). |

## Right-Click Menu Options

| Menu Item | Description |
|-----------|-------------|
| *None* | This script does not use persistent right-click menu options, as the script instance deletes itself immediately after generating the trusses. |

## Settings Files
- **Filename**: `hsbSteicoIO.dll`
- **Location**: `[hsbCAD Install Path]\Utilities\hsbCloudStorage`
- **Purpose**: This library contains the `ImportWolfIFC` function required to read and interpret the external Wolf truss data.

## Tips
- **Verify Paths**: Ensure the `Truss Group Name` and `Beam Group Name` match your existing Project Tree structure. If the groups do not exist, the script may fail to place the elements visibly.
- **Use Filters**: If importing a large file, use the `Truss Name Filter` to bring in only a specific section of the roof first to check alignment and positioning before importing the full set.
- **Script Disappears**: Do not be alarmed when the script insertion point vanishes. This is intended behavior; the trusses remain as native hsbCAD elements.

## FAQ
- **Q: The script disappeared, but I don't see any trusses.**
  - A: Check your Project Tree (Groups). The trusses may have been created inside a folder that is currently hidden or collapsed. Verify the paths in the Properties Palette were correct.
- **Q: Can I modify the trusses after import?**
  - A: Yes. Once the script finishes, the trusses are standard native elements in the drawing. You can edit them manually or using other hsbCAD tools.
- **Q: I got an error about a missing DLL.**
  - A: Ensure your hsbCAD installation is up-to-date and that the `hsbCloudStorage` module is correctly installed in your Utilities folder.